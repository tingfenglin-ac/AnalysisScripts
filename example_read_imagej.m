[sROI] = ReadImageJROI('924_000_054_OUT ROI set2.zip');
%%
coords = cellfun(@(x) [x.mnCoordinates;x.mnCoordinates(1,:)], sROI, 'uni', 0); 
imsize = [635, 512]; 
masks = cellfun(@(x) poly2mask(x(:,1), x(:,2), imsize(2), imsize(1)), coords, 'uni', 0);

%%
figure;
for i = 1:length(masks) 
    subplot(4,3,i);
    imagesc(masks{i}); 
    daspect([1,1,1]);
end
linkaxes(findall(gcf,'type','axes'), 'xy'); 

% xlim([0,imsize(2)]); ylim([0,imsize(1)]); 