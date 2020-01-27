function [xshifts,yshifts] = motion_correct_shef(filepath,outfile,varargin)
%MOTION_CORRECT Correct motion by aligning to a referance frame
% Align frames to a referance frame using the center of mass of the
% cross-correlation (Pearson normalized) above a threshold
%
% INPUT:
%   filepath - The filepath to the source file (the file to be corrected)
%   outfile - The filepath for the destination of the corrected file
%
% OPTIONAL PARAMETERS (RECOMMENDED TO BE SET ARE INDICATED WITH *)
%   motcorr_crop_points* ([]) - The portion of the video (pixels) to
%       be aligned - larger regions are slower, but will yield more
%       consistent results. If not provided, will query user with the
%       still_frame. If 'full', will use the whole video.
%   maxshift_x* ([]) - The maximum shift in the x direction (pixels)
%   maxshift_y* ([]) - The maximum shift in the y direction (pixels)
%       If either of these are not provided, it will ask by randomly
%       jumping between 20 frames, asking for the user to click on the same
%       feature in all 20.
%   numframes ([]) - The number of frames in the file. If left empty,
%       calculates from the file
%   still_frame ([]) - The index of the frame to be aligned to. If left
%       empty, the algorithm chooses the frame that has the smallest mean
%       change in intenstity between pixels to the next frame. Still frame
%       can also be 'mean', in which case it uses the mean for the whole
%       video.
%   interplevel (4) - How many times to interpolate the autocorrelogram to
%       reduce edge effects
%   correlation_threshold (0.8) - The threshold for the cross-correlation
%       to contribute to the center of mass
%   min_samples (75) - The smallest number of samples that must be
%       considered to contribute to the center of mass. If not at least
%       this many are above correlation_threshold, the highest min_samples
%       in correlation are used to calculate the center of mass
%   check_corr_drops (true) - If true, looks for frames where the
%       correlation to the mean is at least 2 standard deviantions (p=0.05)
%       below the mean or the shift is 2.8 standard deviations (p=0.01)
%       from the center and interpolates between the values surrounding the
%       gap
%   XSHIFTS ([]) - Uses this value if not empty
%   YSHIFTS ([]) - Uses this value if not empty
%
% RETURNS:
%   XSHIFTS - The offsets in the x direction
%   YSHIFTS - The offsets in the y direction
%
% Updated 4-13-2017 by Dr. Jason R. Climer (jason.r.climer@gmail.com)
warning('off','all');
% Declare variables (static workspace)

motcorr_crop_points=[];
maxshift_x=[];
maxshift_y=[];
numframes=[];
still_frame=[];
interplevel=[];
correlation_threshold=[];
min_samples=[];
yshifts = [];
xshifts = [];
cropresult = [];
check_corr_drops = [];

% Parse inputs
ip = inputParser;
ip.addParamValue('motcorr_crop_points',[]);
ip.addParamValue('maxshift_x',[]);
ip.addParamValue('maxshift_y',[]);
ip.addParamValue('numframes',[]);
ip.addParamValue('yshifts',[]);
ip.addParamValue('xshifts',[]);
ip.addParamValue('still_frame',[]);
ip.addParamValue('interplevel',4);
ip.addParamValue('correlation_threshold',0.8);
ip.addParamValue('min_samples',75);
ip.addParamValue('cropresult',true);
ip.addParamValue('check_corr_drops',true);



if exist('filepath','var')&&ismember(filepath,ip.Parameters)
    varargin = [{filepath} varargin];
    clear filepath;
end
if ~exist('filepath','var')
    [filepath,j] = uigetfile('*.tif');
    filepath = [j filepath];
end

if exist('outfile','var')&&ismember(outfile,ip.Parameters)
    varargin = [{outfile} varargin];
    clear outfile;
end
ip.parse(varargin{:});
for j=fields(ip.Results)'
    eval([j{1} '=ip.Results.' j{1} ';']);
end

if ~ischar(filepath)
    data = filepath;
    filepath = [];
    numframes = size(data,3);
else
    % Look up numberd of frames if necessary
    if isempty(numframes)
        [data,numframes]=load_tiffs_fast(filepath,'end_ind',1);
    else
        data = load_tiffs_fast(filepath,'end_ind',1,'nframes',numframes);
    end
end

% Look up sizes
width = size(data,2);
height = size(data,1);

if isempty(motcorr_crop_points)
    [motcorr_crop_points] = get_motcorr_points(filepath,[1 0 0],numframes);
elseif isequal(motcorr_crop_points,'full')
    motcorr_crop_points = [0 0 width+1 height+1];
end

if isempty(maxshift_x)||isempty(maxshift_y)
    temp = cell(2,1);
    [~,temp{:}] = get_motcorr_points(filepath,[0 1 0],numframes);
    if isempty(maxshift_x)
        maxshift_x = temp{1};
    end
    if isempty(maxshift_y)
        maxshift_y = temp{2};
    end
end

if isempty(yshifts)||isempty(xshifts)% If the shift hasn't been provided
    if isempty(still_frame)% Still frame hasn't been provided
%         % Set up buffer
%         maxbuff = memory;
%         maxbuff = min(...
%             2^(nextpow2(maxbuff.MaxPossibleArrayBytes/8/width/height)-3)...
%             ,round(numframes/4));
        meandiffs = zeros(round(numframes)-1,1);
        
%         for i=1:ceil((numel(meandiffs)+1))% Go through each chunk
%             if ~isempty(filepath)
                meandiffs(1:end)=...
                    mean(mean(abs(diff(load_tiffs_fast(filepath,'nframes',numframes),[],3))));% Find the mean change in intensity between frames
%             else
%                 meandiffs((i-1)*maxbuff+1:min(i*maxbuff,numel(meandiffs)))=...
%                     mean(mean(abs(diff(data((i-1)*maxbuff+floor(numframes*3/8):min(i*maxbuff+floor(numframes*3/8),floor(numframes*3/8)+numel(meandiffs)))))));
%             end
%         end
        wind = input('How many frames would you like to average? >>');
        [~,s]=min(movsum(meandiffs,wind,'Endpoints','discard'));
        still_image = mean_image(filepath, 'start_ind', s, 'end_ind', s+wind-1);
%         [~,still_frame] = min(meandiffs);
%         still_frame = still_frame+floor(numframes*3/8);
    end
    
    if isequal(still_frame,'mean')
        MeanS = input('What is the first frame you want to average? >>');
        MeanE = input('What is the last frame you want to average? >>');
        still_image = mean_image(filepath, 'start_ind', MeanS, 'end_ind', MeanE);
    elseif isa(still_frame,'double')
        still_image = still_frame;
    elseif isscalar(still_frame)
        if ~isempty(filepath)
            still_image = double(load_tiffs_fast(filepath,'start_ind',still_frame,'end_ind',still_frame,'nframes',numframes));
        else
            still_image = double(data(:,:,still_frame));
        end
    elseif isa(still_frame,'uint16')
        error('unit16 not supported for motion correction reference frame, bro');
    end
    
    still_image = still_image(max(motcorr_crop_points(2),1):min(motcorr_crop_points(4),height),max(motcorr_crop_points(1),1):min(motcorr_crop_points(3),width));
    still_image = still_image-mean(still_image(:));
    
    maxshift_x = min(maxshift_x,size(still_image,2)-1);
    maxshift_y = min(maxshift_y,size(still_image,1)-1);
    
    X = -size(still_image,2)+1:size(still_image,2)-1;
    Y = -size(still_image,1)+1:size(still_image,1)-1;
    
    xin = -maxshift_x:maxshift_x;
    yin = -maxshift_y:maxshift_y;
    
    xint = -maxshift_x:1/interplevel:maxshift_x;
    yint = -maxshift_y:1/interplevel:maxshift_y;
    
    [yyin,xxin] = meshgrid(xin,yin);
    [yyint,xxint] = meshgrid(yint,xint);
    
    interplevel = 4;
    vect = @(x)x(:);
    
    n = xcorr2(ones(size(still_image)),ones(size(rot90(conj(still_image),2))));
    %     n = conv2(ones(size(still_image)),ones(size(rot90(conj(still_image)))));
    
    maxbuff = memory;
    maxbuff = min(...
        2^(nextpow2(maxbuff.MaxPossibleArrayBytes/8/4/width/height)-2)...
        ,numframes);
    %     end
    
    h = ver;
    
    workers = [];
    if ismember('Parallel Computing Toolbox',{h.Name})
        workers = gcp; % If no pool, do not create new one.
    end
    if isempty(workers)
        workers = 1;
    else
        workers = workers.NumWorkers;
    end
    
    XSHIFTS = cell(workers,1);
    YSHIFTS = cell(workers,1);
    yshifts = [];
    xshifts = [];
    
    % B = fft2(padarray(still_image,2),ceil([(numel(y)-size(still_image,1))/2 (numel(x)-size(still_image,2))/2]),0));
    
    for i=1:ceil(numframes/maxbuff)% For each chunk
        slice_size = ceil((min(i*maxbuff,numframes)-(i-1)*maxbuff)/workers);
        parfor SLICE = 1:workers
            disp(sprintf('%s    Chunk: %i, SLICE: %i',datestr(now),i,SLICE));
            dataw = load_tiffs_fast(filepath,'start_ind',(i-1)*maxbuff+(SLICE-1)*slice_size+1,'end_ind',min([(i-1)*maxbuff+SLICE*slice_size i*maxbuff numframes]),'nframes',numframes);
            dataw = double(dataw(max(motcorr_crop_points(2),1):min(motcorr_crop_points(4),height),max(motcorr_crop_points(1),1):min(motcorr_crop_points(3),width),:));
            
            XSHIFTS{SLICE} = NaN(size(dataw,3),1);
            YSHIFTS{SLICE} = XSHIFTS{SLICE};
            
            for m=1:numel(XSHIFTS{SLICE})
                %                 disp(m+slice_size*(SLICE-1)+(i-1)*maxbuff)
                % Do cross correlation (Person's correlation normalized) using fft
                % method (>100X as fast)
                corrmat = conv_fft2(dataw(:,:,m)-mean(mean(dataw(:,:,m))),rot90(conj(still_image),2))./n/std(vect(dataw(:,:,m)))/std(vect(still_image));% Takes 18.033 s for 4000 calls, and I think we can make this faster
                corrmat = interp2(yyin,xxin,corrmat(ismember(Y,yin),ismember(X,xin)),yyint,xxint);
                corrmat(isnan(corrmat))=0;
                
                % Find the correlation threshold that allows us to have at least
                % min_samples above, no higher than correlation_threshold
                correlation_threshold_temp=correlation_threshold;
                if sum(sum(corrmat>correlation_threshold))<min_samples
                    correlation_threshold_temp=quantile(corrmat(:),1-min_samples/numel(corrmat));
                end
                
                % Mask by the threshold
                corrmat = corrmat.*(corrmat>correlation_threshold_temp);
                
                % Find the shifts
                YSHIFTS{SLICE}(m) = real(sum(sum(corrmat).*yint)/sum(corrmat(:)));
                XSHIFTS{SLICE}(m) = real(sum(sum(corrmat,2).*xint(:))/sum(corrmat(:)));
                
                if isnan(YSHIFTS{SLICE}(m))
                    YSHIFTS{SLICE}(m)=0;
                end
                
                if isnan(XSHIFTS{SLICE}(m))
                    XSHIFTS{SLICE}(m)=0;
                end
            end
        end
        
        yshifts = [yshifts;cat(1,XSHIFTS{:})];
        xshifts = [xshifts;cat(1,YSHIFTS{:})];
    end
end

%% Interpolate and write back out
y = 1:height;
x = 1:width;
[xx,yy] = meshgrid(x,y);

yshifts = yshifts(:)-median(yshifts);
xshifts = xshifts(:)-median(xshifts);

Y = -ceil(max([yshifts;0])):height-floor(min([yshifts;0]));
X = -ceil(max([xshifts;0])):width-floor(min([xshifts;0]));
[XX,YY] = meshgrid(X,Y);
% This code is for debugging: plots the whole results
% figure;
% j = 1;
% dataw = double(load_tiffs_fast(filepath,'start_ind',j,'end_ind',j,'nframes',numframes));
% % corrmat = zeros(sum(numframes),1);
% i = imagesc(X,Y,XX);axis equal;%xlim([0 width]);ylim([0 height]);
% set(gca,'CLim',minmax(dataw(:)'))
% for j=1:10:sum(numframes)
%     j
% %     dataw = double(load_tiffs_fast(filepath,'start_ind',j,'end_ind',j,'nframes',numframes));
%     set(i,'CData',shift(j,j))
% %     corrmat(j) = sum(sum(interp2(xx-xshifts(j),yy-yshifts(j),dataw,XX,YY,'linear*',0)~=0));
%     drawnow;
% end
%%

    function out = shift(i1,i2,dataw)
        if ~exist('dataw','var')&&~isempty(filepath)
            dataw=double(load_tiffs_fast(filepath,'start_ind',i1,'end_ind',i2,'nframes',numframes));
        else
            dataw = data(:,:,i1:i2);
        end
        out = zeros([size(YY) size(dataw,3)]);
        for k=1:i2-i1+1
            out(:,:,k) = interp2(xx-xshifts(k+i1-1),yy-yshifts(k+i1-1),dataw(:,:,k),XX,YY,'linear',0);
        end
        if cropresult
            out = out(Y>-min(yshifts)&Y<height-max(yshifts),X>-min(xshifts)&X<width-max(xshifts),:);
        end
        clear dataw;
    end

if exist('outfile','var')
    write_tiff_fast(outfile,@shift,'end_ind',numframes,'calcmult',8);
    save([outfile(1:end-4) '_shifts.mat'],'yshifts','xshifts');
end

end

