% plot spike frequency (20191218)
clear
addpath('C:\Users\lab\Desktop\scripts\subroutine');

%% configure
paw_move=0; %%if the paw movement will be included in the figure choose 1, or choose others  
vel_ana=0; %if the motion activity will be included in the figure choose 1, or choose others  
blink_ana=0; %if the eye blink will be included in the figure choose 1, or choose others  
Air_puff=1; %if the air puff will be included in the figure choose 1, or choose others  
CrossCor=0; %if the cross correlation among signals will be analyzed choose 1
StackOrOverlap=1; %if the signals will be placd in stacks choose 1; if the signals will be placed overlapped choose 2
PlotMean=1; %if plot the mean of data
plotArea=1; %if plot the mean with shaded area as sdv


%n = ROI number I would like to analyze
% if different ROI are from the same cell and want to merge ROIs to one
% ROI, then put them in the same ROIgroup

n=[1:17];
ROIgroup={1:17};
% ROIlabel={'cell 1' 'cell 2' 'cell 2'};

increvalue=0.5;

% set color
% % linecolor=[0.505882352941176,0.250980392156863,0.031372549019608];
% % meancolor=linecolor*1.5;
% % 
% linecolor=[0.5 0 0.25];
% meancolor=[1 0 0.5];
% 
% linecolor=[0.1 0.2 0.1];
% meancolor=[0.1 0.3 0.1];
% % 
% linecolor=[0.1 0.2 0.5];
% meancolor=[0.1 0.3 1];




linecolor=[71, 97, 157;...
    209, 55, 107;...
    255, 164, 57;...
    57, 195, 177]./255;
meancolor=[166, 181, 215;...
    237, 179, 199;...
    255, 234, 210;...
    173, 231, 224]./255;



InductCon=2; %before induction protocal (tetanization)=1; after induction protocal (tetanization)=2
linecolor=linecolor(InductCon,:);
meancolor=meancolor(InductCon,:);



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
%   kn=1
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
    
    co = return_colorbrewer('Dark2');
            set(groot,'defaultAxesColorOrder',co)
            
            

            preSpikeTime=[];
            preSpikeAmp=[];
            SpikeGroup=[];
            Prespikenum=cell(size(n));
            Postspikenum=cell(size(n));
            [Stim_signal]=ShowEvent; % if show stimulus          
            StimInitial=time(min(find(Stim_signal)));
            
            figure; hold on;
    for nfile=1:size(signal,3)
        %background correction
        BC_signal=cat(3,BC_signal,FBackCorr(signal(:,:,nfile),FrameRate));  
        
        
        window=5;
        thr=0.09;
        for trace=n
            smoothBC_signal=smooth(BC_signal(:,trace,end),window);
            [pks{trace},locs{trace}]=findpeaks(smoothBC_signal, 'MinPeakProminence', thr, 'MinPeakDistance', window);
            Prespikenum{trace}=[Prespikenum{trace} length(locs{trace}(time(locs{trace})>2 & time(locs{trace})<StimInitial))];%index of the pre stimulus spike
            Postspikenum{trace}=[Postspikenum{trace} length(locs{trace}(time(locs{trace})>StimInitial+2))];%index of the pre stimulus spike
            plot(time(locs{trace}(1:end-1)),diff(time(locs{trace}))+trace*10,'o-')
        end
        
        %% ploting signal
        if StackOrOverlap==1
            
            incre=increvalue.*(size(signal,2):-1:1); %plot the signal from top to down
        else
            incre=zeros(size(signal,2));
        end
        for i=1:size(signal,2)
            
            
%             plot(time,BC_signal(:,i,nfile)+incre(i),'linewidth',2);
%             ,'color',LC(nfile,:)
            hold on
        end
    end
    

    
    
    
    if PlotMean==1
        for i=1:size(signal,2)
%             plot(time,mean(BC_signal(:,i,:),3)+incre(i),'color',linecolor,'linewidth',1.5);
            hold on
        end
    end
    
    

%%  plot freq
figure
boxplot([Prespikenum{1}' Postspikenum{1}' Prespikenum{2}' Postspikenum{2}'])


hold on
for trace=n
%     boxplot((trace+0.2).*ones(size(Prespikenum{trace})),Prespikenum{trace});
%     boxplot(trace+0.5.*ones(size(Postspikenum{trace})),Postspikenum{trace});
for nfile=1:size(signal,3)
plot(trace.*2-2+[1 2],[Prespikenum{trace}(nfile),Postspikenum{trace}(nfile)],'k-o');
end
end
% %% plot area
% if plotArea
%     mn=2;
%      figure(mn);
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
%         ylim([0 (size(signal,2)+1)*increvalue]);
%         yticks(fliplr(incre));
% %         yticklabels(cellfun(@num2str,ROIgroup(fliplr(n)),'uni',0));
% yticklabels(fliplr(ROIlabel));
% 
%         ylabel('ROI')
%     else
%         ylim([0 8]);
%     end
%     xlim([10 20])
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
% set(gca,'FontSize',16)
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