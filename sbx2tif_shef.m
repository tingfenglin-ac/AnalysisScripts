function sbx2tif_shef(varargin)

% sbx2tif_shef
% Generates tif file from sbx files of any size
% Concatenates and scales multiple sbx files into one large tiff
% Can split multiplane images into a separate files during conversion
% All files in working directory

%%Filenames of the sbx files (minus the ".sbx").  Each line will produce 1 long tif

% 1. If you have just a few files and you need to concatenate some files: 
% 1.a. Do as many "Files(i).sbx" as desired. 
%      Put multiple files within the curly braces as desired for 
%      concatenation of those SBX files. 
% 1.b. Don't put ".sbx" inside 
% 1.c. For defining "Outputs", the number of elements must match with the
%      number of files. 
%      The output names must be DIFFERENT from original SBX names
%      (from original Sheffield) 
% Example: 
%
%         Files(1).sbx={'221_000_000'};
%         Files(2).sbx={'221_000_001', '221_000_002', '221_000_003'};
%         Files(3).sbx={'221_000_004'};
%         Outputs = { '221_StimControl',...
%                     '221_StimConditioned',...
%                     '221_PostStim'};
 

Files(1).sbx={'221_000_000'};
Files(2).sbx={'221_000_001'};
Files(3).sbx={'221_000_002'};
% Files(4).sbx={'213_000_003'};
% Files(5).sbx={'213_000_004'};
% Files(6).sbx={'213_000_005'};
% Files(7).sbx={'213_000_006'};
% Files(8).sbx={'213_000_007'};
%etc

%%Array containing the output filenames
Outputs = {'221_test0','221_test1','221_test2'};% f1','cre2-3_n1-1','cre2-3_n1-2'}; % this must be different from original sbx names

% 2. IF you have multiple files and do not need to concatenate:
% refer to: sbx2tif_shef_hanseledits
%% How many planes did you use for the above images..
% each line should corrospond with one line above

warning('off','all');
nsplits = zeros(1,size(Files,2));
scaleWindow = zeros(1,size(Files,2));
deadBands = cell(1,size(Files,2));
for i = 1:size(Files,2)
    nsplits(1,i) = input(['How many plains did you image for tiff "' Outputs{i} '" >> ']);
    scaleWindow(1,i) = input(['What scale window would you like to use for tiff "' Outputs{i} '" >> ']);
    deadBands{i} = input(['Did you zero the deadbands for tiff "' Outputs{i} '" (Y/N) >> '],'s');
    if ~isequal(deadBands{i},'Y') && ~isequal(deadBands{i},'y') && ~isequal(deadBands{i},'N') && ~isequal(deadBands{i},'n')
        error('deadband answer not recognized (must be Y,y,N,n)');
    end
end

%% Convert each sbx
for F = 1:size(Files,2)
    T = struct('names', cell(1, nsplits(1,F)));
    M = struct('names', cell(1, nsplits(1,F)));
    
    disp(['Beginning Tiff ' Outputs{F} '...']);
    for f = 1:size(Files(F).sbx,2)
        fname = Files(F).sbx{f};
        z = sbxread(fname,1,1);
        global info;
        
        if(nargin>2)
            N = min(varargin{1},info.max_idx);
        else
            N = info.max_idx;
        end
        
        NFrames = N+1;
        
        %% Single plane conversion
        if nsplits (1,F) == 1       % convertion for files containing only 1 plain
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
                info.plain = s;
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
    
    if nsplits == 1
        disp(['...Concatenating and Scaling ' Outputs{F}])
        concatenate_and_scale_shef...
            (T.names,...
            M.names,...
            [Outputs{F} '_Ref.tif'],...
            'output_file',[Outputs{F} '.tif'],...
            'scale_window',scaleWindow(1,F));
    else
        for c = 1:nsplits
            disp(['...Concatenating and Scaling ' Outputs{F}, ' split ' num2str(c)])
            concatenate_and_scale_shef...
                (T(c).names,...
                M(c).names,...
                [Outputs{F} '_Ref.tif'],...
                'output_file',[Outputs{F} '_Plain_' num2str(c) '.tif'],...
                'scale_window',scaleWindow(1,F));
        end
    end
    
    %% remove converted files and reference file so only concatenated one remains
    disp('...Deleting Converted Files')
    delete([Outputs{F} '_Ref.tif']);
    for ds = 1:nsplits
        for d = 1:size(T(ds).names,2)
            delete(T(ds).names{d})
        end
    end
    %% notification of completion
    disp([Outputs{F} ' is Complete!'])
end


end