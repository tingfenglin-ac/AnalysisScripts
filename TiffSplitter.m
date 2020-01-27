%% config
addpath('C:\Users\lab\Desktop\scripts');
addpath('C:\Users\lab\Desktop\scripts\subroutine');

%% input
[FolderName,FolderPath] = uigetfile('*.tif','Select combined tiff file');

%% output

        Filename_3='_OUT_MotCor.tif';
answer = questdlg('select method to set output file name', ...
    'Output file name', ...
    'Select files of pre-concatenated data','Enter a vector of numbers','Select files of pre-concatenated data');
% Handle response
switch answer
    case 'Select files of pre-concatenated data'
        [FN,~] = uigetfile('*OUT.tif','Multiselect', 'on');
        Filename_1=FN{1}(1:8);
        Filename_2=cellfun(@(x) str2double(x(9:11)),FN);
        
    case 'Enter a vector of numbers'
        Filename_1='011_005_';
        prompt = 'Enter a vector of numbers:';
        Filename_2 = input(prompt);
end




%% read image
Filename =[FolderPath,FolderName];
T = Tiff(Filename);
j = T.getTag('ImageDescription');
k=strfind(j,'images=')+7;
nframes=str2double(j((1:find(j(k:end)==newline,1))+k-1));
datanumber=length(Filename_2);
FrameNumber=nframes/datanumber

%% splitdata
parfor fileN=1:datanumber
    data=load_tiffs_fast(Filename,'start_ind',(fileN-1)*FrameNumber+1,'end_ind',fileN*FrameNumber);
    
%     data=CombData(:,:,(fileN-1)*FrameNumber+1:fileN*FrameNumber);
    
% Don't use imwrite, saveastiff and saveastiff_big. Non of them
% work!!-Ting
write_tiff_fast([Filename_1,sprintf('%03d',Filename_2(fileN)),Filename_3],data,'end_ind',FrameNumber,'calcmult',8);
end

