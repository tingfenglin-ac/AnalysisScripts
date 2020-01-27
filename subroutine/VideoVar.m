% get file name
currentFolder = pwd
[FolderName,FolderPath] = uigetfile(currentFolder, 'Multiselect', 'on');
if iscell(FolderName)
    filezize=size(FolderName,2);
else
    filezize=1;
end
for fnumber=1:filezize    
    if iscell(FolderName)
        FN=FolderName{fnumber};
    else
        FN=FolderName;
    end
        load([FolderPath,FN(1:end-4),'_ball.mat']);
        
        variance=var(double(data),0,4);
        figure
        imagesc(variance);
        caxis([0 1000]);
end