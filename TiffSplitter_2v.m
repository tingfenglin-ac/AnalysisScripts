%% config
addpath('C:\Users\lab\Desktop\scripts');
addpath('C:\Users\lab\Desktop\scripts\subroutine');

Filename_1='917_000_048_';
Filename_2=001:101;
Filename_3='_OUT.tif';

% how many plain will be motor corrected together
Plainchunk=6;

%% read image
[FolderName,FolderPath] = uigetfile('*.tif','Select combined tiff file');
Filename =[FolderPath,FolderName];
T = Tiff(Filename);
j = T.getTag('ImageDescription');
k=strfind(j,'images=')+7;
nframes=str2double(j((1:find(j(k:end)==newline,1))+k-1));
CombData=load_tiffs_fast(Filename,'nframes',nframes);
datanumber=length(Filename_2);
FrameNumber=nframes/datanumber;

%% splitdata
for fileN=1:datanumber-Plainchunk+1
    data=CombData(:,:,(fileN-1)*FrameNumber+1:(fileN+Plainchunk-1)*FrameNumber);
    
% Don't use imwrite, saveastiff and saveastiff_big. Non of them
% work!!-Ting
write_tiff_fast([Filename_1,sprintf('%03d',Filename_2(fileN)),Filename_3],data,'end_ind',FrameNumber*Plainchunk,'calcmult',8);
end

