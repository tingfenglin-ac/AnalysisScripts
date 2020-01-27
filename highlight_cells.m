function highlight_cells(varargin)

%% highlight_cells

% allows user to highlight the cells of their choosing from the data
% structure which is the output of cellsort2

%INPUT: array containing the indices of the cells you wish to highlight.
%multiple sets of indices seperated by a comma will be displayed in
%different colors.  these can be from the same data file or different ones
%(as long as teh dimentions match)
%
%ONE COLOR EXAMPLE:  highlight_cells([1 2 3 8 23 30 39 41:62])
%
%TWO COLOR EXAMPLE: highlight_cells([1 2 3 8 23 30 39 41:62],[1:6 9 20 31])

IDs=varargin;
layers = size(IDs,2);
numFiles = input('Are you using one a single data file?  Y/N >> ','s');
segmentMatrix = [];

if isempty(IDs)
    error('You must include the Cell IDs as input variables, dummy');
end

if numFiles == 'Y' || numFiles == 'y'
    [filename, loc] = uigetfile('*.mat','Choose the cellsort data file');% Select Tif to be cell sorted
    load([loc filename],'data');
    selectSegs = zeros(size(data.icaSegments,1),size(data.icaSegments,2),layers);
    means = zeros(size(data.icaSegments,1),size(data.icaSegments,2),layers);
    for n = 1:layers
        selectSegs(:,:,n) = sum(data.icaSegments(:,:,IDs{n}),3);
        means(:,:,n) = data.mean;
        if n == 1
            segmentMatrix = data.icaSegments(:,:,IDs{n});
        else
           segmentMatrix = cat(3, segmentMatrix, data.icaSegments(:,:,IDs{n}));
        end
    end
else
    for n = 1:layers
        [filename, loc] = uigetfile('*.mat',['Cell Set ' num2str(n) ': Choose the cellsort data file']);% Select Tif to be cell sorted
        load([loc filename],'data');
        if n == 1
            selectSegs = zeros(size(data.icaSegments,1),size(data.icaSegments,2),layers);
            means = zeros(size(data.icaSegments,1),size(data.icaSegments,2),layers);
        end
        selectSegs(:,:,n) = sum(data.icaSegments(:,:,IDs{n}),3);
        means(:,:,n) = data.mean;
        if n == 1
            segmentMatrix = data.icaSegments(:,:,IDs{n});
        else
           segmentMatrix = cat(3, segmentMatrix, data.icaSegments(:,:,IDs{n}));
        end
    end
end

for s = 1:layers
    
end

allSegs = sum(selectSegs,3);
meanImg = mean(means,3);
low = min(min(meanImg));
high = max(max(meanImg));
colors = [0 1 0
    1 0 0
    0 0 1
    1 0 1
    0 1 1
    1 1 0
    1 1 1
    0 0.5 0
    0.5 0 0
    0 0 0.5
    0.5 0 0.5
    0 0.5 0.5
    0.5 0.5 0
    0.5 0.5 0.5];

OverlayFig = figure;

hold on

ax1 = axes('Parent',OverlayFig);
ax2 = axes('Parent',OverlayFig);

set(ax1,'Visible','off');
set(ax2,'Visible','off');

I = imshow(allSegs,'Parent',ax2);
set(I,'AlphaData',.3);
imshow(meanImg,[low high],'Parent',ax1);

segInd = 0;

for nums = 1:numel(IDs)
    numCells = size(IDs{nums},2);
    ind = find(segmentMatrix(:,:,(segInd+1):(segInd+numCells))); % finds the index of all parts of all segments
    [iy, ix, iz] = ind2sub(size(segmentMatrix(:,:,(segInd+1):(segInd+numCells))), ind); % converts ind so that indices represent all 3 dimentions
    x = zeros(1,numCells);
    y= zeros(1,numCells);
    for z = 1:numCells % determine the center of each segment (so number stamp can be displayed on figure)
        zInd = find(iz==z);
        y(z)=mean(iy(zInd));
        if z<10
            x(z)=mean(ix(zInd)-2);
        elseif z<100 && z>=10
            x(z)=mean(ix(zInd)-4);
        elseif z>=100
            x(z)=mean(ix(zInd)-6);
        end
    end
    txt = cellstr(string(IDs{nums}))'; %creates cell array with number stamps 1 through number of cells (for display)
    text(x,y,txt, 'Color',colors(nums,:),'FontSize',8) %apply number stamp to the center of each segment
    segInd = segInd+numCells;
end
