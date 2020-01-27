function sbx2tif_shef_hanseledits(varargin)

% sbx2tif_shef
% Generates tif file from sbx files of any size
% Concatenates and scales multiple sbx files into one large tiff
% Can split multiplane images into a separate files during conversion
% All files in working directory

%%Filenames of the sbx files (minus the ".sbx").  Each line will produce 1 long tif
%%Array containing the output filenames

%% Options for selecting files (Tuan&Silas edits) 
% 1. If you have just a few files and you need to concatenate some files: 
% refer to: sbx2tif_shef


% 2. IF you have multiple files and do not need to concatenate:
[F D] = uigetfile('.sbx', 'Select sbx files', 'Multiselect', 'on');

filenum=0;
if iscell(F)
    for celln=1:length(F)
        CurFileDir = [D F{celln}];
        sbx_filenames{filenum+1} = CurFileDir;
        filenum = filenum +1;
    end
else
    CurFileDir = [D F];
    sbx_filenames{filenum+1} = CurFileDir;
    filenum = filenum +1;
end

check_if_sbx = cellfun(@(x) ~isempty(regexp(x,'.sbx$', 'once')), sbx_filenames, 'uni', 1);
if ~all(check_if_sbx)
    error('At least one of the selected files did have not .SBX suffix');
end
sbx_prefix = regexprep(sbx_filenames, '.sbx', ''); 
num_files = length(sbx_prefix);
Files(num_files) = struct('sbx','');
for i = 1:num_files
    Files(i).sbx = {sbx_prefix{i}};
end

default_array = {};
for i = 1:num_files
%     sheffield lab usually puts yes for deadbands, but if you put no then
%     the conversion will also auto-crop the files. Tuan and Silas found no
%     issues with the auto-crop, so the default value is set to 'n'
    default_array = horzcat(default_array,regexprep(sbx_filenames(i), '.sbx', '_OUT'),'1,30,n');
end

prompts_out{1} = cellfun(@(x) ['Output of "', x '" is'], sbx_prefix, 'uni', 0);
prompts_out{2} = cellfun(@(x) ['Parameters for "', x '" are'], sbx_prefix, 'uni', 0);

prompt_array = {};
for i = 1:length(prompts_out{1})
    prompt_array = horzcat(prompt_array,prompts_out{1}(i),prompts_out{2}(i));
end

% Instructions on parameters
fprintf(['There must only be three parameters (# of planes, scale window, and if you zeroed the deadbands)\n' ... 
     '+ Parameters must be separated by COMMAS without spaces, must include (in order):\n' ...
     '\t1) a NUMBER representing the number of planes\n' ...
     '\t2) a NUMBER representing the scale window\n'...
     '\t3) a LETTER (y,Y,n or N) indicating if you zeroed the deadbands\n' ...
     '+ Parameters must be in the proper order (#planes,scale window, deadBands)\n' ...
     '+ The DEFAULT parameters are "1,30,n" \n'])

% Show prompt
show_only = 7; 
cur_show = 1; 
while (cur_show <= 2*num_files)
    to_show = cur_show: min(cur_show+2*show_only-1,2*num_files);
    prompt_answers(to_show) = inputdlg(prompt_array(to_show),...
        'Edit output names',[1,50],default_array(to_show));
    cur_show = to_show(end)+1;
end

Outputs = prompt_answers(1:2:end);
Parameters = prompt_answers(2:2:end);

if num_files ~= length(unique(Outputs)) 
    error('There are duplicates of output names');
end
if num_files*2 ~= length(unique([Outputs,sbx_prefix])) 
    error('There are duplicates of OUTPUT names and SBX input names');
end

%% Set Video Parameters

warning('off','all');
nsplits = zeros(1,size(Files,2));
scaleWindow = zeros(1,size(Files,2));
deadBands = cell(1,size(Files,2));
error_message = "ERROR ENTERING PARAMETERS";
error_message = error_message + newline + "There must only be three parameters (# of planes, scale window, and if you zeroed the deadbands)";
error_message = error_message + newline + "Parameters must be separated by commas without spaces";
error_message = error_message + newline + "Parameters must include 1) a number representing the number of planes, 2) a number representing the scale window, and 3) a letter (eg y,Y,n,N) indicating if you zeroed the deadbands";
error_message = error_message + newline + "Parameters must be in the proper order (#planes,scale window, deadBands)";
error_message = error_message + newline + "The default parameters are '1,30,n' representing 1 plane, 30 scale window, and yes the deadBands were zeroed";

for i = 1:size(Files,2)
    parameter_split = strsplit(Parameters{i}, ',');
    error_patterns = [";",":",".","-"," ","/","\"];
    if contains(Parameters{i}, error_patterns) || length(parameter_split) ~= 3
        error(error_message);
    end
    nsplits(1,i) = str2num(parameter_split{1});
    scaleWindow(1,i) = str2num(parameter_split{2});
    if isempty(nsplits(1,i)) || isempty(scaleWindow(1,i))
        error(error_message);
    end
    deadBands{i} = parameter_split{3};
    if ~strcmpi(deadBands{i},'y') && ~strcmpi(deadBands{i},'n')
        error('deadband answer not recognized (must be Y,y,N,n)');
    end
end

%% Convert each sbx
for F = 1:size(Files,2)
    T = struct('names', cell(1, nsplits(1,F)));
    M = struct('names', cell(1, nsplits(1,F)));
    
    disp(['Beginning Tiff ' Outputs{F} '...']);
    skipF = false; 
    for f = 1:size(Files(F).sbx,2)
        fname = Files(F).sbx{f};
        z = sbxread(fname,1,1);
        global info;
        
        %Tuan and Silas edits, allows tiff conversion to continue without
        %processing sbx files that were aborted during recording
        if info.abort_bit == 1
            skipF = true; 
            fprintf('Skipping File %s as it was aborted during recording \n', fname);
            break;
        end
        %end of Tuan and Silas Edit
        
        if(nargin>2)
            N = min(varargin{1},info.max_idx);
        else
            N = info.max_idx;
        end
        
        NFrames = N+1;
        
        %% Single plane conversion
        if nsplits (1,F) == 1       % convertion for files containing only 1 plane
            Tiffname = [fname '_' num2str(f) '.tif'];
            if info.scanmode == 1
                if isequal(deadBands{F},'Y') || isequal(deadBands{F},'y')
                    TS.data.sbx = zeros(info.sz(1),info.sz(2),NFrames,'uint16');
                else
                    TS.data.sbx = zeros(info.sz(1),info.sz(2)-140,NFrames,'uint16');
                end
            else
                if isequal(deadBands{F},'Y') || isequal(deadBands{F},'y')
                    TS.data.sbx = zeros(info.sz(1),info.sz(2)-91,NFrames,'uint16');
                else
                    TS.data.sbx = zeros(info.sz(1),info.sz(2)-161,NFrames,'uint16');
                end
            end
            T.names{f} = Tiffname;
            M.names{f} = [fname '.mat'];
            for k = 1:N+1
                if k == 1                   %replace first frame with second
                    q = sbxread(fname,k,1,2);
                else
                    q = sbxread(fname,k-1,1);
                end
                q = permute(q,[2,3,1]);
                if f == 1 && k ==1 && info.scanmode == 1    %Make reference file for Tiff tags.  Needed for some files to have correct parameters in the final tiff.  Why?  I dont know and fucking sick of trying to figure it out...and this works.
                    if isequal(deadBands{F},'Y') || isequal(deadBands{F},'y')
                        write_tiff_fast([Outputs{F} '_Ref.tif'],q)
                    else
                        write_tiff_fast([Outputs{F} '_Ref.tif'],q(:,71:end-70))
                    end
                elseif f == 1 && k ==1 && info.scanmode == 0
                    if isequal(deadBands{F},'Y') || isequal(deadBands{F},'y')
                        write_tiff_fast([Outputs{F} '_Ref.tif'],q(:,92:end))
                    else
                        write_tiff_fast([Outputs{F} '_Ref.tif'],q(:,92:end-70))
                    end
                end
                if info.scanmode == 1       % Determine which deadbands exists
                    if isequal(deadBands{F},'Y') || isequal(deadBands{F},'y')
                        TS.data.sbx(:,:,k) = q;
                    else
                        TS.data.sbx(:,:,k) = q(:,71:end-70);
                    end
                else
                    if isequal(deadBands{F},'Y') || isequal(deadBands{F},'y')
                        TS.data.sbx(:,:,k) = q(:,92:end);       % If deadband exists, remove first 91 columns containing the deadband
                    else
                        TS.data.sbx(:,:,k) = q(:,92:end-70);
                    end
                end
            end
            saveastiff_big(TS.data.sbx,Tiffname);
            %write_tiff_fast(Tiffname,TS.data.sbx);
            %% Multiplane Conversion
        else
            split=nsplits(1,F);
            frms = (linspace(1,N+1,N+1))-1;
            for s = 1:split
                Tiffname = [fname '_' num2str(s) '_' num2str(f) '.tif'];
                CurFrms = frms(s:split:end);
                if info.scanmode == 1
                    if isequal(deadBands{F},'Y') || isequal(deadBands{F},'y')
                        TS.data.sbx = zeros(info.sz(1),info.sz(2),ceil(NFrames/split),'uint16');
                    else
                        TS.data.sbx = zeros(info.sz(1),info.sz(2)-140,ceil(NFrames/split),'uint16');
                    end
                else
                    if isequal(deadBands{F},'Y') || isequal(deadBands{F},'y')
                        TS.data.sbx = zeros(info.sz(1),info.sz(2)-91,ceil(NFrames/split),'uint16');
                    else
                        TS.data.sbx = zeros(info.sz(1),info.sz(2)-161,ceil(NFrames/split),'uint16');
                    end
                end
                T(s).names{f} = Tiffname;
                M(s).names{f} = [Tiffname(1:end-4) '.mat'];
                info.config.frames = numel(CurFrms);
                info.plane = s;
                save(M(s).names{f},'info')
                for fr = 1:numel(CurFrms)
                    if CurFrms(fr) == 0         %replace first frame with second frame of that plane
                        q = sbxread(fname,CurFrms(fr+1),1);
                    else
                        q = sbxread(fname,CurFrms(fr),1);
                    end
                    q = permute(q,[2,3,1]);
                    if f == 1 && CurFrms(fr) ==0 && info.scanmode == 1    %Make reference file for Tiff tags.  Needed for some files to have correct parameters in the final tiff.  Why?  I dont know and fucking sick of trying to figure it out...and this works.
                        if isequal(deadBands{F},'Y') || isequal(deadBands{F},'y')
                            write_tiff_fast([Outputs{F} '_Ref.tif'],q)
                        else
                            write_tiff_fast([Outputs{F} '_Ref.tif'],q(:,71:end-70))
                        end
                    elseif f == 1 && CurFrms(fr) ==0 && info.scanmode == 0
                        if isequal(deadBands{F},'Y') || isequal(deadBands{F},'y')
                            write_tiff_fast([Outputs{F} '_Ref.tif'],q(:,92:end))
                        else
                            write_tiff_fast([Outputs{F} '_Ref.tif'],q(:,92:end-70))
                        end
                    end
                    if info.scanmode == 1       % Determine which deadbands exists
                        if isequal(deadBands{F},'Y') || isequal(deadBands{F},'y')
                            TS.data.sbx(:,:,fr) = q;
                        else
                            TS.data.sbx(:,:,fr) = q(:,71:end-70);
                        end
                    else
                        if isequal(deadBands{F},'Y') || isequal(deadBands{F},'y')
                            TS.data.sbx(:,:,fr) = q(:,92:end);       % If deadband exists, remove first 91 columns containing the deadband
                        else
                            TS.data.sbx(:,:,fr) = q(:,92:end-70);
                        end
                    end
                end
                saveastiff_big(TS.data.sbx,Tiffname);    %Buggy
                %write_tiff_fast(Tiffname,TS.data.sbx);
            end
        end
        
        
        %% notification of conversion
        disp(['...sbx file ' num2str(f) ' for ' Outputs{F} ' has been converted'])
        
        
    end
    %% concatenate and scale
    
    if skipF 
        continue;
    end
    % Tuan&Silas changed `nsplits` -> `nsplits(1,F)`
    if nsplits(1,F) == 1
        disp(['...Concatenating and Scaling ' Outputs{F}])
        concatenate_and_scale_shef...
            (T.names,...
            M.names,...
            [Outputs{F} '_Ref.tif'],...
            'output_file',[Outputs{F} '.tif'],...
            'scale_window',scaleWindow(1,F));
    else
        for c = 1:nsplits(1,F)
            disp(['...Concatenating and Scaling ' Outputs{F}, ' split ' num2str(c)])
            concatenate_and_scale_shef...
                (T(c).names,...
                M(c).names,...
                [Outputs{F} '_Ref.tif'],...
                'output_file',[Outputs{F} '_Plane_' num2str(c) '.tif'],...
                'scale_window',scaleWindow(1,F));
        end
    end
    
    %% remove converted files and reference file so only concatenated one remains
    disp('...Deleting Converted Files')
    % Tuan&Silas changed `nsplits` -> `nsplits(1,F)`
    delete([Outputs{F} '_Ref.tif']);
    for ds = 1:nsplits(1,F)
        for d = 1:size(T(ds).names,2)
            delete(T(ds).names{d})
        end
    end
    %% notification of completion
    disp([Outputs{F} ' is Complete!'])
end


end