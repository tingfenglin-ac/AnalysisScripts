%% load data
addpath 'C:\Users\lab\Desktop\scripts\subroutine'

[FolderName,FolderPath] = uigetfile('Select data', 'Multiselect', 'on');

if iscell(FolderName)
    filezize=size(FolderName,2);
else
    filezize=1;
end

    load([FolderPath,FolderName(1:11),'\suite2p\plane0\Fall.mat']);%load stat
    F=readNPY([FolderPath,FolderName(1:11),'\suite2p\plane0\F.npy']);% load fluorescence
    idxcell = readNPY([FolderPath,FolderName(1:11),'\suite2p\plane0\iscell.npy']);% load cell index
    imsize=size(imread([FolderPath,FolderName(1:11),'_OUT.tif']));

    
    %%
    %find dimension of image
    xmax = max(cellfun(@(x) max(x.xpix),stat));
    ymax = max(cellfun(@(x) max(x.ypix),stat));
    
    xext=(xmax-imsize(2))/2;%extension of ROI detected image of suite2p
    xext=(abs(xext)+xext)/2;%if no extension it become zero
    yext=(ymax-imsize(1))/2;%extension of ROI detected image of suite2p
    yext=(abs(yext)+yext)/2;%if no extension it become zero
    
    % ploting 
%     cmap=permute(colormap(hsv),[1 3 2]);
    cmap=permute(0,[1 3 2]);
    colorlist=[];
    
    IDXcell=find(idxcell(:,1))';
    
for n=IDXcell
    im=ones([imsize 1])*255;
    xpix=stat{1,n}.xpix-xext;
    ypix=stat{1,n}.ypix-yext;
    lam=stat{1,n}.lam;
    
colornumber=ceil(rand(1)*(size(cmap,1)-1))+1;
colorlist=[colorlist colornumber];
    for k=1:length(xpix)
        im(ypix(k)+1,xpix(k)+1,:)=1*cmap(colornumber,:,:);
%         lam(k)*
    end
    
    %xy coordinates text file
%     fileID = fopen([FolderPath,FolderName(1:11),'\suite2p\plane0\ROI-cell ',num2str(n),'.txt'],'w');
% fprintf(fileID,'%3d %3d\n',[xpix;ypix]);
% fclose(fileID);

%ROI mask file
imwrite(im,[FolderPath,FolderName(1:11),'\suite2p\plane0\mask-cell ',num2str(n),'.png'])
end
% figure
% imshow(im)