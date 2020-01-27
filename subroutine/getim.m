%% get image as matrix
function [BCim,im]=getim(FolderPath,FolderName,FrameRate)
clear data3d
data=[];

Filename =[FolderPath,FolderName];

T = Tiff(Filename);
j = T.getTag('ImageDescription');
k=strfind(j,'images=')+7;
nframes=str2double(j((1:find(j(k:end)==newline,1))+k-1));


im=load_tiffs_fast(Filename,'nframes',nframes);
% BCim=im;
[BCim]=FBackCorr(im,FrameRate);

end