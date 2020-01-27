
%% configure
StackOrOverlap=1; %1=stack; 2=overlap
extend=[0.1 0.5]; %plot 'extend' second before and after the rising phase
heatmap_ext=0.4; %plot heatmap 'extend' second after the rising phase
n=[5]; %n = ROI number I would like to analyze
Fcaxis=[0, 3*10^4];
dFcaxis=[0,10];

%% load ROI analysis data
all_velocity=[];
all_pks=[];
signal=[];

f=1;
filesize=0;
FN=cell(0);
FP=cell(0);

f=1;
FolderPath=1;
filesize=0;
FN=cell(0);
FP=cell(0);
while FolderPath~=0
    [FileName,FolderPath] = uigetfile({'*.csv;*analysis.mat'},'Select an ROI file', 'Multiselect', 'on');
    if iscell(FileName)
        NewAddFile=size(FileName,2);
    elseif FileName~=0
        NewAddFile=1;
    else
        NewAddFile=0;
    end
    filesize=filesize+NewAddFile;
    
    for fnumber=1:NewAddFile
        if iscell(FileName)
            FN=cat(1,FN,FileName{fnumber});
        else
            FN=cat(1,FN,FileName);
        end
        FP=cat(1,FP,FolderPath);
        if strfind(FN{end},'csv')
            Import_data=importdata([FP{end},FN{end}]);
            signal=cat(3,signal,Import_data.data(:,3+(n-1)*2));
        else
            Import_data=load([FP{end},FN{end}]);
            signal=cat(3,signal,Import_data.activs(:,n));
        end
    end
end

%% get time variables from file
%                     load(['D:\2pdata\Ting\GCaMP 20190820\820','\820_000_001','_ball.mat']);% load time dataset
if isfile([FP{1},FN{1}(1:11),'_ball.mat'])
    load([FP{1},FN{1}(1:11),'_ball.mat']);
    balltime=time;
elseif isfile([FP{1},FN{1}(1:11),'_eye.mat'])
    load([FP{1},FN{1}(1:11),'_eye.mat']);
else
    load('D:\2pdata\Ting\time variables\011_006_002_eye')
end

% if its's concatenated data, FramePerFile is the frame number of each
% recording
load([FP{end},FN{end}(1:9),'00.mat']);

% ratio of camera sampling rate and 2P sampling rate
step=round(size(time,1)./size(signal,1));
%time of the 2P signal
time=time(1:step:step.*size(signal,1));
FrameRate=mean(1./(time(2:end)-time(1:end-1)));

% for concatenated data
timestep=time;
for ext_time=1:round(size(signal,1)/size(time,1))-1
    time=[time;time(end)+timestep];
end
                    
%% align Ca signal
[BCsignal]=FBackCorr(signal,FrameRate);

% select spike
figure
plot(1:length(signal),signal);
title('choose begining of a spike');
zoom on;
pause() % you can zoom with your mouse and when your image is okay, you press any key
zoom off; % to escape the zoom mode

rect = ginput(1);
rect=floor(rect);
close

% get index for ploting
InterFrameInterval=nanmean(diff(time,1)); %inter-sample interval
ExtendIndex=round(extend./InterFrameInterval);
heatmap_ext_idx=round(heatmap_ext/InterFrameInterval);

if rect(1)-ExtendIndex(1)>0 && rect(1)+ExtendIndex(2)<length(signal)
    idx=(rect(1)-ExtendIndex(1):rect(1)+ExtendIndex(2))'; %idx of ca signal
    heatmap_idx=rect(1):rect(1)+heatmap_ext_idx; %idx of ca signal which would generate heatmap
end
%% ploting Ca trace
figure
%ploting F
set(gcf,'Position',[680 100 600 200],'color',[1 1 1]);
subplot(1,3,1);

area(time(heatmap_idx)-time(rect(1)),3*max(signal)*ones(1,length(heatmap_idx))',...
    'EdgeColor','none',...
    'FaceColor',[1 0.5 0.5],...
    'Facealpha',0.5);
hold on
plot(time-time(rect(1)),BCsignal,'color',[0.5 0.5 1]);
ylim([-0.5 1])
xlim([-extend(1) extend(end)]);
xlabel('Time (s)')
ylabel('dF/F0');

%% load ROI
ROI=dlmread([FP{1},FN{1}(1:8),'057-062_OUT_MotCor ROI ',num2str(n),' XY.txt']);
dim=[min(ROI(:,2))-1,max(ROI(:,2))+1,min(ROI(:,1))-1,max(ROI(:,1))+1];%position of heatmap [min(y) max(y) min(x) max(x)]
bw = uint16(poly2mask([ROI(:,1);ROI(1,1)]-dim(3),[ROI(:,2);ROI(1,2)]-dim(1),dim(2)-dim(1)+1,dim(4)-dim(3)+1));

%% plotting F
[BCim,im]=getim(FP{1},[FN{1}(1:11),'_OUT_MotCor.tif'],FrameRate); %get image file as matrix
subplot(1,3,2);
imagesc(mean(im(dim(1):dim(2),dim(3):dim(4),heatmap_idx).*bw,3));
colorbar
title('F')
axis image;
caxis(Fcaxis);
hold on

%draw ROI
plot([ROI(:,1);ROI(1,1)]-dim(3),[ROI(:,2);ROI(1,2)]-dim(1),'r');
set(gca, 'XTick', [],'YTick', []);

%% ploting dF/F0 image
subplot(1,3,3);
imagesc(mean(BCim(dim(1):dim(2),dim(3):dim(4),heatmap_idx).*bw,3));
colorbar
title('dF/F0')
axis image;
caxis(dFcaxis);
hold on
%draw ROI
plot([ROI(:,1);ROI(1,1)]-dim(3),[ROI(:,2);ROI(1,2)]-dim(1),'k');

set(gca, 'XTick', [],'YTick', []);


%% plotting time series dF/F0-1
figure
% set(gcf,'Position',[680 200 1200 200],'color',[1 1 1]);
smooth_size = 5; 
for tf=1:length(heatmap_idx)+1
    
    subplot(3,5,tf);
    imgdat = uint16(BCim(dim(1):dim(2),dim(3):dim(4),min(heatmap_idx)-2+tf)); 
    filtimg = conv2(imgdat, 1/(smooth_size^2)*ones(smooth_size), 'same'); 
    imagesc(filtimg);
    
%     colorbar
    title([num2str(time(min(heatmap_idx)-2+tf)-time(rect(1)),'%.2f'),' s'])
    axis image;
    caxis(dFcaxis);
    hold on
    %draw ROI
    plot([ROI(:,1);ROI(1,1)]-dim(3),[ROI(:,2);ROI(1,2)]-dim(1),'r');
    set(gca, 'XTick', [],'YTick', []);
end

