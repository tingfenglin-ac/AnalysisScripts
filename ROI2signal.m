%% read ROI
[ROIName,ROIPath] = uigetfile('*set.zip');
[sROI] = ReadImageJROI([ROIPath,ROIName]);
coords = cellfun(@(x) [x.mnCoordinates;x.mnCoordinates(1,:)], sROI, 'uni', 0);

%% load image
FN=cell(0);
FP=cell(0);
[FileName,FolderPath] = uigetfile('*MotCor.tif','Select image', 'Multiselect', 'on');

if iscell(FileName)
    for fnumber=1:length(FileName)
        FN=cat(1,FN,FileName{fnumber});
    end
else
    FN=cat(1,FN,FileName);
end
FP=cat(1,FP,FolderPath);


%% get the frame number
T = Tiff([FP{1},FN{1}]);
j = T.getTag('ImageDescription');
k=strfind(j,'images=')+7;
nframes=str2double(j((1:find(j(k:end)==newline,1))+k-1));

inf=imfinfo([FP{1},FN{1}]);
imsize = [inf.Width inf.Height];
masks = cellfun(@(x) poly2mask(x(:,1), x(:,2), imsize(2), imsize(1)), coords, 'uni', 0);


%% load image
for fileN=1:length(FN)
    %load tiff file to matrix
    im=load_tiffs_fast([FP{1},FN{fileN}],'nframes',nframes);
    
    d_im = double(im);
    activs = cellfun(@(x) squeeze(sum(sum(d_im.*x,1),2))/sum(x(:)), masks, 'uni', 0);
    activs = horzcat(activs{:});
    save([FP{1},FN{fileN}(1:end-4),' ROI analysis.mat'],'activs');
end
%%
% figure;
% for i = 1:length(masks)
%     subplot(4,3,i);
%     imagesc(masks{i});
%     daspect([1,1,1]);
% end
% linkaxes(findall(gcf,'type','axes'), 'xy');

% xlim([0,imsize(2)]); ylim([0,imsize(1)]);