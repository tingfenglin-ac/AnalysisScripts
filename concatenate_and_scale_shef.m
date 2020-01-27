function [scale] = concatenate_and_scale_shef(filepaths,data_files,tiff_field,varargin)
% CONCATENATE_AND_SCALE Concatenates and scales calcium imaging data
%
% INPUT
%   filepaths - A cell array of the paths to the each file.
%   data_files - A cell array of paths to sheffield data .mat files
%   tiff_field - A single frame Tiff file to be used to transfer the Tiff parameters
% OPTIONAL PARAMETERS
%   scale_joins (true) - Scales around the joins between file so that the
%       median of the means intensity across the [scale_window] frames on
%       either side of the join are equal
%   scale_overall (true) - Removes the baseline shift by equilibrating the
%       8th percentile of the mean intensities within each window
%   output_file ('out.tiff') - The output file for the join
%   fill_dynamic_range (false) - Scales and shifts to occupy 80% of the
%       available dynamic range
%   nsplits (1) - The number of ways to split the matrix (alternates
%       frames)
%   crop ([0 0 0 0]) - The number of pixels from the top, bottom, left and
%       right of the matrix to crop off.
%
% RETURNS
%   scale - The relative scale used in each frame
%
% Updated 11 April 2016 by Dr. Jason R. Climer (jason.r.climer@gmail.com)
% keyboard
% Parse inputs
nsplits = [];

ip = inputParser;
ip.addParameter('scale_joins',true);
ip.addParameter('scale_overall',true);
ip.addParameter('scale_window',[]);
ip.addParameter('join_scale_window',[]);
ip.addParameter('output_file','out.tif');
ip.addParameter('max_range',false);
ip.addParameter('nsplits',1);
ip.addParameter('verbosity',false);
ip.addParameter('crop',[0 0 0 0]);


if exist('filepaths','var')
    if ~iscell(filepaths)
        filepaths = {filepaths};
        if ismember(filepaths,ip.Parameters)
            varargin = [filepaths varargin]; 
            clear filepaths;
        end
    end
end



ip.parse(varargin{:});
for j=fields(ip.Results)'
    eval([j{1} '=ip.Results.' j{1} ';']);
end

if ~iscell(filepaths), filepaths = {filepaths}; end

% Get parameters from the first file
T = Tiff(filepaths{1});
width = T.getTag('ImageWidth');
height = T.getTag('ImageLength');
close(T);

if size(crop,1)==1&&nsplits>1
   crop = repmat(crop,[nsplits 1]); 
end

% for im = 1:numel(filepaths)
%     a = uigetfile('*.mat',['Choose the .mat file for tiff number' num2str(im)]);
%     data_files{im} = a;
% end

% Calculate the number of frames 
 [~,nframes] = load_tiffs_fast_shef(filepaths,'start_ind',1,'end_ind',1,'data_files',data_files); 


if isempty(scale_window)
   tiff_player_shef(filepaths,'data_files',data_files);
   scale_window = input('What is the scale window? (much longer than tansients) >>');
end

if isempty(join_scale_window)
   join_scale_window = scale_window; 
end

% nframes = [];
% for fp = 1:numel(filepaths)
%     
% imagedatfile = uigetfile('*.mat',['Select .mat file for image' num2str(fp)]);
% load(imagedatfile)
% 
% nframes(fp) = info.config.frames;

% Allocate power measurements
mean_pow = NaN(sum(nframes),1);
min_pow = mean_pow;
max_pow = mean_pow;

% Calculate the buffer size
maxbuff = memory;
maxbuff = 2^(nextpow2(maxbuff.MaxPossibleArrayBytes/2/8/width/height)-1);

% Go through each frame in buffers
for i=1:ceil(sum(nframes)/maxbuff)    
   % Load the data  
   buffer =  load_tiffs_fast_shef(filepaths,'start_ind',(i-1)*maxbuff+1,'end_ind',min(i*maxbuff,sum(nframes)),'display','none','data_files',data_files);
   
   % Calculate the mean, minimum and maximum power in each of these frames
   mean_pow((i-1)*maxbuff+1:min(i*maxbuff,sum(nframes)))=mean(mean(buffer,1),2);   
   min_pow((i-1)*maxbuff+1:min(i*maxbuff,sum(nframes)))=min(min(buffer,[],1),[],2);
   max_pow((i-1)*maxbuff+1:min(i*maxbuff,sum(nframes)))=max(max(buffer,[],1),[],2);
   
   clear buffer;
end
%%
scale = ones(size(mean_pow));

% Scale the joins between frames
if scale_joins
for i=2:numel(nframes)% Go through each joint
    for k=1:nsplits
        % First, find the last frames in the (i-1) video in each channel
        last_k = mod(sum(nframes(1:i-1))-1,nsplits)+1;
        last_in = mod(last_k-k,nsplits);
        
        before = sum(nframes(1:i-1))-last_in-(0:join_scale_window-1)*nsplits;
        before = before(before>0);
        
        after = sum(nframes(1:i-1))-last_in+(1:join_scale_window)*nsplits;        
        after = after(after<sum(nframes(1:i)));
        
        scale(sum(nframes(1:i-1))-last_in+nsplits:nsplits:sum(nframes(1:i))) = ...
            median(scale(before).*mean_pow(before))./median(scale(after).*mean_pow(after));
    end
end
end
%%
% mean_pow = reshape(mean_pow,[nsplits numel(mean_pow)/nsplits])';
% min_pow = reshape(min_pow,[nsplits numel(min_pow)/nsplits])';
% max_pow = reshape(max_pow,[nsplits numel(max_pow)/nsplits])';
% scale = reshape(scale,[nsplits numel(max_pow)/nsplits])';

%%
if scale_overall% Scale using a moving window
    last_k = mod(sum(nframes)-1,nsplits)+1;
    for k=1:nsplits
%       last_in = mod(last_k-k,nsplits);
      in = (k:nsplits:sum(nframes))';
      per8 = zeros(size(in));
%        return %% dont know why this is here.  comment out so script works -Joe
      parfor i=1:numel(per8)
          in2 = max(in(i)-nsplits*(scale_window-1),k):nsplits:min(in(i)+nsplits*(scale_window-1),sum(nframes));
          per8(i) = quantile(scale(in2).*mean_pow(in2),0.08);          
      end
      scale(in) = scale(in)./per8;
      scale(in) = scale(in)/median(scale(in));
    end
end


% Maximize the dynamic range
% if max_range
%     offsets = -min(scale.*min_pow);
%     scale = scale*diag(2^16./((max(scale.*max_pow)-offsets)));
% else
%    offsets = zeros(1,nsplits); 
% end
% offsets = repmat(offsets,sum(nframes)/nsplits,1);
offsets = zeros(size(scale));

% Write the output file(s)
if ischar(output_file)% output_file is a string
    if nsplits>1% Format for each of the channels
        output_file = arrayfun(@(i)sprintf('%s_%i.tif',output_file(1:end-4),i),1:nsplits,'UniformOutput',false);
    else
        output_file = {output_file};
    end
end
scale = bsxfun(@rdivide,scale,median(scale));
disp('Writing Current File(s)')
for i=1:nsplits% For each channel
    
    write_tiff_fast(output_file{i},...
        @(i1,i2)...
        split_and_crop(...
        ...Begin function
        bsxfun(@plus,...Begin offsets
        bsxfun(@times,double(...Begin scale
        load_tiffs_fast_shef(...% Load the frame
            filepaths...
            ,'start_ind',(i1-1)*nsplits+i...
            ,'end_ind',(i2-1)*nsplits+i...
            ,'data_files',data_files...
                ,'display','none'...
        ,'nframes',nframes...
        ,'frame_skip',nsplits))...
        ,permute(scale(((i1-1)*nsplits+i):nsplits:((i2-1)*nsplits+i)),[3 2 1]))...
        ,permute(offsets(((i1-1)*nsplits+i):nsplits:((i2-1)*nsplits+i)),[3 2 1])...
        )...
        ,'crop',crop(i,:))...
        ,'start_ind',1,'end_ind',(sum(nframes)-mod(mod(sum(nframes)-1,nsplits)+1-i,nsplits)-i)/nsplits+1, 'tiff_fields',tiff_field);

    
%    write_tiff_fast(output_file{i},...
%        @(i1,i2)...
%        split_and_crop(...
%     bsxfun(@plus,bsxfun(@times,double(load_tiffs_fast_shef(...
%        filepaths,...
%        'start_ind',(i1-1)*nsplits+i,'end_ind',(i2-1)*nsplits+i ...
%         ,'display','none'...
%         ,'nframes',nframes...
%         ,'frame_skip',nsplits...
%         )),permute(scale(i-(mod(i1-1,nsplits)+1)+i1:nsplits:i2),[3 2 1])),permute(offsets(i-(mod(i1-1,nsplits)+1)+i1:nsplits:i2),[3 2 1]))...
%     ,'crop',crop(i,:)),'end_ind',sum(nframes)/nsplits,'mode','imageJ_raw');
   save([output_file{i}(1:end-4) '_bookmarks.mat'],'nframes');
end
%%
% i2 = i2*2;
% clear data;
% data = split_and_crop(...
%     bsxfun(@plus,bsxfun(@times,double(load_tiffs_fast_shef(...
%        filepaths,...
%        'start_ind',(i1-1)*nsplits+i,'end_ind',(i2-1)*nsplits+i ...
%         ,'display','none'...
%         ,'nframes',nframes...
%         ,'frame_skip',nsplits...
%         )),permute(scale(i1:i2,i),[3 2 1])),permute(offsets(i1:i2,i),[3 2 1]))...
%     ,'crop',crop(i,:));
%%
end
