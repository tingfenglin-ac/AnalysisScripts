function TiffConcatenator
%% config
addpath('C:\Users\lab\Desktop\scripts');
addpath('C:\Users\lab\Desktop\scripts\subroutine');

%% read image
FolderPath=1;
FN=cell(0);
while FolderPath~=0
    [Filename,FolderPath] = uigetfile('*.tif','Select tiff files to concatenate', 'Multiselect', 'on');
    if iscell(Filename)||Filename~=0
        for fileN=1:size(Filename,2)
            FN =cat(1,FN,[FolderPath,Filename{fileN}]);
        end
    end
end
% disp('...will concatenate the following images');
% disp(cat(2,cellstr(num2str((1:length(FN))')),FN));
[Filename,FolderPath] = uiputfile('*.tif','Save concatenated file',[FN{1},'...']);
%% splitdata
CombData=[];
for fileN=1:length(FN)
    %get the frame number
    T = Tiff(FN{fileN});
    j = T.getTag('ImageDescription');
    k=strfind(j,'images=')+7;
    nframes=str2double(j((1:find(j(k:end)==newline,1))+k-1));
    %load tiff file to matrix
    CombData=cat(3,CombData,load_tiffs_fast(FN{fileN},'nframes',nframes));  
end
% Don't use imwrite, saveastiff and saveastiff_big. Non of them
% work!!-Ting
write_tiff_fast([FolderPath,Filename],CombData,'end_ind',size(CombData,3),'calcmult',8);

