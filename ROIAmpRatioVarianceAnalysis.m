clear
addpath(genpath('C:\Users\lab\Desktop\scripts'));


%% configure
paw_move=0; %%if the paw movement will be included in the figure choose 1, or choose others  
vel_ana=0; %if the motion activity will be included in the figure choose 1, or choose others  
blink_ana=0; %if the eye blink will be included in the figure choose 1, or choose others  
Air_puff=0; %if the air puff will be included in the figure choose 1, or choose others  
CrossCor=0; %if the cross correlation among signals will be analyzed choose 1
StackOrOverlap=1; %if the signals will be placed in stacks choose 1; if the signals will be placed overlapped choose 2
PlotMean=0; %if plot the mean of data
plotArea=1; %if plot the mean with shaded area as sdv


%n = ROI number I would like to analyze
n=[1:19];

% if different ROI are from the same cell and want to merge ROIs to one
% signal
ROIgroup={[1,2],1,2};    %21  22    23    24    25    26    27    28    29    30    31    32    33    34    35    36    37};
ROIlabel=['global 1' cellfun(@num2str,num2cell([1,2]),'uni',0)];
% ROIgroup={};
% ROIlabel=[cellfun(@num2str,mat2cell([3,2,6,9,10],1,ones(1,length(ROIgroup)-3)),'uni',0)]
increvalue=2;

%set color
linecolor=[0.5 0 0];
meancolor=[1 0 0];

% linecolor=[0 0 0.5];
% meancolor=[0 0 1];

%% load ROI analysis data
all_velocity=[];
all_pks=[];
signal=[];

f=1;

filesize=0;
FN=cell(0);
FP=cell(0);

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

    FN
    

if length(ROIgroup)
    %% read ROI size
    [ROIName,ROIPath] = uigetfile('*set.zip');
    [sROI] = ReadImageJROI([ROIPath,ROIName]);
    coords = cellfun(@(x) [x.mnCoordinates;x.mnCoordinates(1,:)], sROI, 'uni', 0);
    masks = cellfun(@(x) poly2mask(x(:,1), x(:,2), max(x(:)), max(x(:))), coords, 'uni', 0);
    weight=cell2mat(cellfun(@(x) sum(x(:)),masks, 'uni', 0));
    
    %% converge
    for group=1:length(ROIgroup)
    activ(:,group,:)=sum(weight(ROIgroup{group}).*signal(:,ROIgroup{group},:),2)./sum(weight(ROIgroup{group}),2);
    end
    signal=activ;
    n=1:length(ROIgroup);
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
        time=(time(1):time(930)/(930*2):time(end))';
    end
    
    % if its's concatenated data, FramePerFile is the frame number of each
    % recording
    load([FP{1},FN{1}(1:11),'.mat']);
    FramePerFile=info.config.frames;
    
    
    % ratio of camera sampling rate and 2P sampling rate
    step=round(size(time,1)./FramePerFile);
    %time of the 2P signal
    time=time(1:step:step.*FramePerFile);
    FrameRate=mean(1./diff(time));
    
    
    % for concatenated data
%     timestep=time;
%     for ext_time=1:round(size(signal,1)/size(time,1))-1
%         time=[time;time(end)+timestep];
%     end   

    %% analyze ROI
    figure;
    kn=get(gcf,'Number');
    defautPosition=get(gcf,'Position');
    set(gcf,'position',[1 1 defautPosition(3) 840]);
    BC_signal=[];
    
    % raw traces color
    LC=copper(size(signal,3));%gradient color
%     LC=winter(size(signal,2));%gradient color
%     LC=[1 140/255 0].*ones(size(signal,2),3);%orange
%     LC=[0 1 1].*ones(size(signal,2),3);%orange
    
    co = colormap([0.031372549019608,0.250980392156863,0.505882352941176;...
                0.031372549019608,0.407843137254902,0.674509803921569;...
                0.168627450980392,0.549019607843137,0.745098039215686;...
                0.305882352941177,0.701960784313725,0.827450980392157;...
                0.482352941176471,0.800000000000000,0.768627450980392;...
                0.658823529411765,0.866666666666667,0.709803921568628;...
                0.800000000000000,0.921568627450980,0.772549019607843;...
                0.878431372549020,0.952941176470588,0.858823529411765]);
            set(groot,'defaultAxesColorOrder',co);
            
    for nfile=1:size(signal,3)
        %background correction
        BC_signal=cat(3,BC_signal,FBackCorr(signal(:,:,nfile),FrameRate));  
        
        
        
        %ploting signal
        if StackOrOverlap==1
            
            incre=increvalue.*(size(signal,2):-1:1); %plot the signal from top to down
        else
            incre=zeros(size(signal,2));
        end
        for i=1:size(signal,2)
            
            
            plot(time,BC_signal(:,i,nfile)+incre(i),'linewidth',2);
%             ,'color',LC(nfile,:)
            hold on
        end
    end
    % find peaks
    %                     [pks,locs] = findpeaks(signal,time(1:length(signal)));
    %                     all_pks.(['roi',num2str(n(i))])=[all_pks.(['roi',num2str(n(i))]);[pks,locs]];

    % get mean
    % plot mean
    if PlotMean==1
        for i=1:size(signal,2)
            plot(time,mean(BC_signal(:,i,:),3)+incre(i),'color',linecolor,'linewidth',1.5);
            hold on
        end
    end
    
    
%%
thr=0.1;
window=5;

concatBC_signal=[];
concattime=0;
for nfile=1:size(BC_signal,3)
concatBC_signal=[concatBC_signal;BC_signal(:,:,nfile)];
concattime=[concattime;concattime(end)+time];
end
concattime(1)=[];

%get rid of extrem number
thr_ext=0.6;
keepn=find(concatBC_signal(:,1)<thr_ext);
losen=find(concatBC_signal(:,1)>thr_ext);
time_temp=concattime(keepn);
BC_signal_temp=concatBC_signal(keepn,:);
for t=1:3
intersignal(:,t)=interp1(keepn,BC_signal_temp(:,t),1:length(concattime))';
end
concatBC_signal=intersignal;

[~,locs]=findpeaks(smooth(concatBC_signal(:,1),window), 'MinPeakProminence', thr, 'MinPeakDistance', window);

d_points = floor(window/2); 
IDX = arrayfun(@(x) (x-d_points):(x+d_points), locs, 'uni', 0); 

peaks_rois = cellfun(@(x) mean(concatBC_signal(x,:), 1),IDX, 'uni', 0);
peaks_rois = cell2mat(peaks_rois);

dev_factor = 2; 
slopes=peaks_rois(:,3)./peaks_rois(:,2);
mslope=median(slopes);

DisToSlope=point_to_line_distance(peaks_rois(:,[2 3]),[0 0],[1 mslope]);
DisToSlope(slopes<mslope,:)=-DisToSlope(slopes<mslope,:);
med_dist = median(DisToSlope);
std_dist = mad(DisToSlope,1);
sep_lines = med_dist + [-1,1]*dev_factor*std_dist; 

offset=sep_lines*sqrt(1+(mslope)^2); 

lrIDX = find(DisToSlope<sep_lines(1));
hrIDX = find(DisToSlope>sep_lines(2));
mrIDX = find(DisToSlope>=sep_lines(1) & DisToSlope <= sep_lines(2));

%%
binnum=30;
binedge=-0.4:0.8/binnum:0.4;
%%
figure; 
subplot(121); hold on; 
histogram(DisToSlope,binedge);
arrayfun(@(x) plot([1,1]*x, [0,3], '--k'), sep_lines);
xlabel('Amplitude ratio distance from expected ratio')
xlim([-0.3,0.3])

subplot(122); hold on 
scatter(peaks_rois(:,2),peaks_rois(:,3),100,'m.')
scatter(peaks_rois(lrIDX,2),peaks_rois(lrIDX,3),300,'b.')
scatter(peaks_rois(hrIDX,2),peaks_rois(hrIDX,3),300,'r.')
% fplot(@(x) mslope.*x,'k')
plot([0,max(peaks_rois(:))],mslope.*[0,max(peaks_rois(:))], '-k')
plot([0,max(peaks_rois(:))],mslope.*[0,max(peaks_rois(:))]+offset(1),'--k')
plot([0,max(peaks_rois(:))],mslope.*[0,max(peaks_rois(:))]+offset(2),'--k')
xlabel(['ROI ' ROIlabel{2}])
ylabel(['ROI ' ROIlabel{3}])
xlim([0,max(peaks_rois(:,2))])
ylim([0,max(peaks_rois(:,3))])
set(gcf,'color',[1 1 1])

%% 
figure; 
subplot(121); hold on; 
histogram(DisToSlope,binedge);
[~,~,locs]=histcounts(DisToSlope,binnum);
[~,~,locs_sig]=histcounts(DisToSlope,[-inf,sep_lines(1),sep_lines(2),inf]);
arrayfun(@(x) plot([1,1]*x, [0,3], '--k'), sep_lines);
xlabel('Amplitude ratio distance from expected ratio')
co=jet(binnum);
Width=[10 6 10];

locs(locs==0)=1;
locs_sig(locs_sig==0)=1;

for p=1:length(peaks_rois)
subplot(122); hold on 
plot(peaks_rois(p,2),peaks_rois(p,3),'o','MarkerFaceColor',co(locs(p),:),'Markersize',Width(locs_sig(p)))
% ,'MarkerSize' ,Width(locs_sig))
% fplot(@(x) mslope.*x,'k')
plot([0,max(peaks_rois(:))],mslope.*[0,max(peaks_rois(:))], '-k')
plot([0,max(peaks_rois(:))],mslope.*[0,max(peaks_rois(:))]+offset(1),'--k')
plot([0,max(peaks_rois(:))],mslope.*[0,max(peaks_rois(:))]+offset(2),'--k')
xlabel(['ROI ' ROIlabel{2}])
ylabel(['ROI ' ROIlabel{3}])
xlim([0,max(peaks_rois(:,2))])
ylim([0,max(peaks_rois(:,3))])
end

set(gcf,'color',[1 1 1])
%%
figure; hold on;

for n=1:3
    plot(concattime,concatBC_signal(:,n)+(n-1)*increvalue,'k');
    for p=1:length(peaks_rois)
    plot(concattime(IDX{p}),concatBC_signal(IDX{p},n)+(n-1)*increvalue,'color',co(locs(p),:),'linewidth',4);
    end
end

set(gcf,'color',[1 1 1])
%%
figure; hold on;

for n=1:3
    plot(concattime,concatBC_signal(:,n)+(n-1)*increvalue,'k');
    cellfun(@(x) plot(concattime(x),concatBC_signal(x,n)+(n-1)*increvalue,'r','linewidth',4),IDX(hrIDX),'uni',0);
    cellfun(@(x) plot(concattime(x),concatBC_signal(x,n)+(n-1)*increvalue,'b','linewidth',4),IDX(lrIDX),'uni',0);
    cellfun(@(x) plot(concattime(x),concatBC_signal(x,n)+(n-1)*increvalue,'m','linewidth',4),IDX(mrIDX),'uni',0);
end

set(gcf,'color',[1 1 1]);
plot(repmat(concattime(losen)',2,1),repmat([0 7]',1,length(losen)),'k--');
% plot([45 45],[0 7],'k--');
% plot([75 75],[0 7],'k--');
% plot([105 105],[0 7],'k--');

plot([30 30],[0 7],'k-');
plot([60 60],[0 7],'k-');
% plot([90 90],[0 7],'k-');

% 
% figure
% scatter(peaks_rois(:,2),peaks_rois(:,3),'k')
% hold on
%slopes of peaks

% hrpeaks=peaks_rois(slopes>mslope,:);
% lrpeaks=peaks_rois(slopes<mslope,:);
% hrIDX=IDX(slopes>mslope);
% lrIDX=IDX(slopes<mslope);
% Mean_reg_distance=mean(DisToSlope);
% Std_reg_distance=std(DisToSlope);
% reg_distance_min=(Mean_reg_distance-2*Std_reg_distance)
% reg_distance_max=(Mean_reg_distance+2*Std_reg_distance)

% scatter(peaks_rois(:,2),peaks_rois(:,3),'k')
% scatter(hrpeaks(:,2),hrpeaks(:,3),'r')
% scatter(lrpeaks(:,2),lrpeaks(:,3),'g')
% plot([0,1],mslope.*[0,1])

% offset=sep_lines*sqrt(1+(mslope)^2);
% plot([0,1],mslope.*[0,1]+offset(1),'--k')
% plot([0,1],mslope.*[0,1]+offset(2),'--k')
% 
% figure
% plot(concattime,concatBC_signal(:,1),'k');
% hold on
% cellfun(@(x) plot(concattime(x),concatBC_signal(x,1),'r'),hrIDX,'uni',0);
% cellfun(@(x) plot(concattime(x),concatBC_signal(x,1),'g'),lrIDX,'uni',0);

% hridx=peaks_rois()
% 
% 
% 
% cellfun(@(x) plot(time(x(hrpeaks,)),BC_signal),)
% 
% 
% figure
% plot(time,BC_signal(:,1))
% hold on
% scatter(time(IDX),BC_signal(IDX,1))
% 
% 
% pkeak()
% 
% %%
% % thrsignal=BC_signal(BC_signal(:,1)>thr,:);
% % thrtime=time(BC_signal(:,1)>thr,:);
% 
% % figure
% % plot(time,BC_signal(:,3))
% % % findpeaks(BC_signal(:,1))
% % hold on
% % plot(time,medfilt1(BC_signal(:,3),5), 'r')
% % plot(time,smooth(BC_signal(:,3),5), 'g')
% % plot(time,smoothdata(BC_signal(:,3),'gaussian', 5), 'm')
% 
% % findpeaks(medfilt1(BC_signal(:,1),5))
% %%
% 
% 
% 
% 
% scatter(thrtime(begIDX),thrsignal(begIDX,1),'r')
% 
%     figure
%     scatter(BC_signal(IDX,2,:),BC_signal(IDX,3,:))
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     
%     %% plot area
% if plotArea
%     figure;
%     mn=get(gcf,'Number');
%     defautPosition=get(gcf,'Position');
%     set(gcf,'position',[1 1 defautPosition(3) 840]);
%      for i=1:size(signal,2)
%          plot(time(1:end),mean(BC_signal(1:end,i,:),3)+incre(i),'color',linecolor,'linewidth',1.5);
%          hold on
%          signalStd=nanstd(BC_signal(1:end,i,:),0,3);
%          ErrArea_Smooth(time(1:end),mean(BC_signal(1:end,i,:),3)+incre(i),signalStd,...
%              meancolor);
%      end
% end
%     
% %% velocity analysis
% if vel_ana==1
%     VEL=[];
%     for nfile=1:size(signal,3)
%         %unit of velocity is pixel
%         %1 alphabet is around 75 pixel which is around 30 mm
%         load([FP{nfile},FN{nfile}(1:11),'_velocity.mat']);
%         velocity = medfilt1(velocity,15,'omitnan','truncate'); %median filtering
%         % change the unit
%         velocity=velocity./(75./10);
%         
%         VEL=cat(2,VEL,velocity);
%     end
%     
%     if round(length(time)/size(VEL,1))==1
%         VEL=VEL(1:length(time),:);
%     else
%         disp('check if there is bug');
%     end
%     
%     figure(kn);
%     plot(time,VEL,'color',[0.5 0.5 0.5]);
%     plot(time,mean(VEL,2),'color',[0 0 0],'linewidth',1.5);
%     
%     if plotArea
%         figure(mn);
%         velocityStd=nanstd(VEL,0,2);
%         ErrArea_Smooth(time,mean(VEL,2),velocityStd,...
%             [0 0 0]); hold on
%         plot(time,mean(VEL,2),'color',[0 0 0],'linewidth',1.5);
%     end
%     
% end
% 
% %% eye blink
% if blink_ana==1;
%     [blink]=EyeBlinkEstimation;
% blink=smooth(blink(1:600),15,'lowess');
% normalb=blink/max(blink);
% hold on
% figure(k);
% area(time(1:length(normalb)),1-normalb,...
%     'FaceColor',[0.5 0.5 0.5],...
%     'EdgeColor','none',...
%     'FaceAlpha',0.3);
% stim='Eye blink';
% end
% 
% %% Air puff
% if Air_puff==1;
%     
%     [Stim_signal]=ShowEvent; % if show stimulus
%     % for concatenated data
%     Stim_signal=repmat(Stim_signal,round(size(signal,1)/size(Stim_signal,1)),1);
%     
%     
%     figure(kn)
%     area(time,Stim_signal*1000,...
%         'FaceColor',[1 0.5 0.5],...
%         'EdgeColor','none',...
%         'FaceAlpha',0.5);stim='Air puff';
%     if plotArea
%         figure(mn)
%         area(time,Stim_signal*1000,...
%             'FaceColor',[1 0.5 0.5],...
%             'EdgeColor','none',...
%             'FaceAlpha',0.5);stim='Air puff';
%     end
% end
% 
% %% figure
% %single data
% figure(kn)
% xlabel('Time (s)');
% set(gcf,'color',[1,1,1]);
% if StackOrOverlap==1
%     ylim([-1 (size(signal,2)+1)*increvalue]);
%     yticks(fliplr(incre));
% 
% %     yticklabels(cellfun(@num2str,ROIgroup(fliplr(n)),'uni',0));
% yticklabels(fliplr(ROIlabel));
%     ylabel('ROI')
% else
%     ylim([0 8]);
% end
% set(gca,'FontSize',20)
% %%
% 
% % yticks([1:size(all_signal,2)+2])
% % xlim([0 30*8])
% % legend({'Distal dendrite 1','Distal dendrite 2', 'Proximal dendrite','Air puff'},'FontSize',14);
% 
% %shadow
% if plotArea
%     figure(mn)
%     xlabel('Time (s)');
%     set(gcf,'color',[1,1,1]);
%     if StackOrOverlap==1
%         ylim([-1 (size(signal,2)+1)*increvalue]);
%         yticks(fliplr(incre));
% %         yticklabels(cellfun(@num2str,ROIgroup(fliplr(n)),'uni',0));
% yticklabels(fliplr(ROIlabel));
% 
%         ylabel('ROI')
%     else
%         ylim([0 8]);
%     end
%     
%     
%     %     xlim([0 30*8])
%     % title({['Cell ' num2str(n) ' (n=' num2str(size(all_signal,2)) ')']},'FontSize',14);
%     %     title({['(n=' num2str(filesize) ')']},'FontSize',14);
%     
% end
% 
% % legend([Label,'speed']);
% 
% %% cross correlation
% if CrossCor==1
% CrossCorr_Ting(velocity,Tablenames,n);
% end
% 
% %% histogram
% % figure
% % histogram(all_pks,[0:0.02:1],'FaceColor',linecolor,'EdgeColor',meancolor);
% % xlim([0,1]);
% % xlabel('dF/F0');
% % ylabel('#peaks');
% 
% 
% % figure
% % histogram(repmat(all_pks_pre(:,1),filesize_lp*filesize_ep,1),[0:0.02:1],'Normalization','probability');
% % hold on
% % histogram(repmat(all_pks_ep(:,1),filesize_pre*filesize_lp,1),[0:0.02:1],'Normalization','probability');
% % histogram(repmat(all_pks_lp(:,1),filesize_pre*filesize_ep,1),[0:0.02:1],'Normalization','probability');
% % xlim([0,1]);
% % xlabel('dF/F0');
% % ylabel('Probability');
% % legend('Pre','Early-post','Late-post');
% %% plot heatmap
% figure
% %plot Ca signal
% % subplot(3,1,[1 2])
% imagesc(mean(BC_signal,3)','XData',time)
% % caxis([0 0.3]);
% get(gca,'ylim')
% hold on
% % area(time,Stim_signal*100,...
% %     'FaceColor',[1 0.5 0.5],...
% %     'EdgeColor','none',...
% %     'FaceAlpha',0.7);stim='Air puff';%plot stimulation
% set(gcf,'color',[1 1 1]);
% ylabel('ROI')
% yticks(1:length(n));
% yticklabels(ROIlabel);
% 
% % plot velocity
% % subplot(3,1,3)
% % ErrArea_Smooth(time,mean(VEL,2),velocityStd,...
% %     [0 0 0]); hold on
% % plot(time,mean(VEL,2),'color',[0 0 0],'linewidth',1.5);
% % area(time,Stim_signal*100,...
% %     'FaceColor',[1 0 0],...
% %     'EdgeColor','none',...
% %     'FaceAlpha',0.7);stim='Air puff';%plot stimulation
% % ylim([0 1.5])
% % xlim([0 time(end)])
% % ylabel('Locomotion speed')
% % xlabel('Time (sec)');