function [crop_points, maxshift_x, maxshift_y, arealims] = get_motcorr_points( data, runs, numframes )
%GET_MOTCORR_POINTS Summary of this function goes here
%   Detailed explanation goes here
% keyboard
if ~exist('runs','var'), runs = [1 1 1]; end
if ~exist('numframes','var'), numframes=[]; end

crop_points = [];
maxshift_x = [];
maxshift_y = [];
arealims = [];

zoom = 1.5;

mnwind = 5;

if ischar(data)||iscellstr(data)
    filepath = data;
    [~,numframes] = load_tiffs_fast(data,'start_ind',1,'end_ind',1);
    [data,numframes] = load_tiffs_fast(data,'start_ind',1,'end_ind',min(5000,sum(numframes)),'frame_skip',2,'nframes',numframes);
else
    filepath = [];
    numframes = size(data,3);
end
data = double(data);
data(data==0) = NaN;
mn = nanmean(data,3);

if ~isequal(class(data),'double'), data = double(data); end

if runs(1)
    fig=figure;
    set(fig, 'Position', get(0,'Screensize')); % Maximize figure.
    
    sd = std(data,[],3);
    imagesc(mn);axis equal;colormap hot;colorbar;
    set(gca,'CLim',[quantile(mn(mn>0),0.01) max(mn(:))]);
    title('Select crop region. Suggested crop region labeled.')
    
    xx = (1:size(mn,2))-size(mn,2)/2;
    yy = (1:size(mn,1))-size(mn,1)/2;
    [yy,xx] = meshgrid(xx,yy);
    temp = conv2((mn./sd).*normpdf(sqrt(xx.^2+yy.^2),0,sqrt(numel(mn))/3),ones(150),'same');
    [yy,xx] = ind2sub(size(mn),find(temp==max(temp(:)),1));
    if numel(xx)>1
        yy = yy(1);xx=xx(1);
    elseif numel(xx)==0
        yy=size(mn,2)/2;
        xx = size(mn,2)/2;
    end
    
    hold on;
    plot(xx+[-75 75 75 -75 -75],yy+[75 75 -75 -75 75],'w--');
    hold off;
    
    crop_points = round(ginput(2))';
    crop_points = [min(crop_points(1,:)) min(crop_points(2,:)) max(crop_points(1,:)) max(crop_points(2,:))];
    close(fig);pause(0.01);
    
end

if runs(2)
    fig=figure;
    set(fig, 'Position', get(0,'Screensize')); % Maximize figure.
    maxshift_x = zeros(20,2);
    maxshift_y = zeros(20,2);
    j = 2*mnwind;
    if ~isnumeric(data)
        h = imagesc(mean(load_tiffs_fast(filepath,'start_ind',j-mnwind,'end_ind',j+mnwind,'nframes',numframes),3));
    else
        h = imagesc(mean(data(:,:,max(j-mnwind,1):min(j+mnwind,size(data,3))),3));
    end
    
    for i=1:20
        j = ceil(rand()*(sum(numframes)-2*mnwind-1))+mnwind;
        if ~isempty(filepath)
            temp = load_tiffs_fast(filepath,'start_ind',j-mnwind,'end_ind',j+mnwind,'nframes',numframes);
            %             imagesc(mean(load_tiffs_fast(filepath,'start_ind',j-mnwind,'end_ind',j+mnwind,'nframes',numframes),3));
        else
            %             imagesc(mean(data(:,:,j-mnwind:j+mnwind),3));
            temp = data(:,:,j-mnwind:j+mnwind);
        end
        
        temp(temp==0) = nan;
        temp = nanmean(temp,3);
        
        set(h,'CData',temp);
        try
            set(gca,'CLim',[quantile(temp(temp>0),0.01) max(temp(:))]);
        catch err; end
        title(sprintf('Select feature through randomly selected frames: %i of 20',i));
        set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
        colormap(hot);
        %         caxis(minmax(mn(:)'));
        axis equal;
        maxshift_x(i,:) = ginput(1);
    end
    maxshift_y = ceil(std(maxshift_x(:,2))*5);
    maxshift_x = ceil(std(maxshift_x(:,1))*5);
    close(fig);pause(0.01);
end

if runs(3)
    fig=figure;
    set(fig, 'Position', get(0,'Screensize')); % Maximize figure.
    imagesc(mn);
    xlim(size(data,2)/2+[-1 1]*size(data,2)/zoom/2);
    ylim(size(data,1)/2+[-1 1]*size(data,1)/zoom/2);
    axis equal;colormap jet;colorbar;title('Select smallest visible cell.')
    caxis([min(mn(:)) quantile(mn(:),0.9999)]);
    set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
    smallcell = sum(sum(roipoly));
    title('Select largest visible cell.')
    largecell = sum(sum(roipoly));
    arealims = [smallcell*0.75 largecell*1.25];
    close(fig);pause(0.01);
end
end

