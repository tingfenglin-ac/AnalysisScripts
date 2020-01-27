%% read ROI size
[ROIName,ROIPath] = uigetfile('*set.zip');
[sROI] = ReadImageJROI([ROIPath,ROIName]);
coords = cellfun(@(x) [x.mnCoordinates;x.mnCoordinates(1,:)], sROI, 'uni', 0);
masks = cellfun(@(x) poly2mask(x(:,1), x(:,2), max(x(:)), max(x(:))), coords, 'uni', 0);

%% color code
co = permute([0.031372549019608,0.250980392156863,0.505882352941176;...
    0.031372549019608,0.407843137254902,0.674509803921569;...
    0.168627450980392,0.549019607843137,0.745098039215686;...
    0.305882352941177,0.701960784313725,0.827450980392157;...
    0.482352941176471,0.800000000000000,0.768627450980392;...
    0.658823529411765,0.866666666666667,0.709803921568628;...
    0.800000000000000,0.921568627450980,0.772549019607843;...
    0.878431372549020,0.952941176470588,0.858823529411765],[1,3,2]);

%% merge masks
base=double(repmat(masks{end},1,1,3));
roi=[3,2,6,19,9,10,11];
index=num2cell(1:length(roi));

[X,Y]=cellfun(@(x) find(x==1),masks,'uni',0);
MaskCoord=cellfun(@(x,y) [x y],X,Y,'uni',0);
MaskCoord=MaskCoord(roi);
% testbase=cellfun(@(x,y) base(x(:,1),x(:,2),:)*0+co(y+1,1,:),MaskCoord,index,'uni',0);

for n=1:length(roi)
    for i=1:length(MaskCoord{n})
        base(MaskCoord{n}(i,1),MaskCoord{n}(i,2),:)=co(n,:,:);
    end
end
imshow(base)