%CaDistribution_v4 20191218
%plot spike freq
clear
addpath(genpath('C:\Users\lab\Desktop\scripts'));

%% configure
paw_move=0; %%if the paw movement will be included in the figure choose 1, or choose others  
vel_ana=0; %if the motion activity will be included in the figure choose 1, or choose others  
blink_ana=0; %if the eye blink will be included in the figure choose 1, or choose others  
Air_puff=1; %if the air puff will be included in the figure choose 1, or choose others  
CrossCor=0; %if the cross correlation among signals will be analyzed choose 1
StackOrOverlap=1; %if the signals will be placd in stacks choose 1; if the signals will be placed overlapped choose 2
PlotMean=1; %if plot the mean of data
plotArea=1; %if plot the mean with shaded area as sdv
CategorizeResponsive=1; %if plot responsive and non-responsive trace separately
increvalue=0.5;

%n = ROI number I would like to analyze
% if different ROI are from the same cell and want to merge ROIs to one
% ROI, then put them in the same ROIgroup

n=[1:16];
ROIgroup={[1:10] [11:16]};  
ROIlabel={'Cell 1' 'Cell 2'}

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
%     figure;
%     kn=get(gcf,'Number');

    defautPosition=get(gcf,'Position');
%     set(gcf,'position',[1 1 defautPosition(3) 840]);
    BC_signal=[];
    
    % raw traces color
    LC=copper(size(signal,3));%gradient color
%     LC=winter(size(signal,2));%gradient color
%     LC=[1 140/255 0].*ones(size(signal,2),3);%orange
%     LC=[0 1 1].*ones(size(signal,2),3);%orange
    
    co = return_colorbrewer('Dark2');
            set(groot,'defaultAxesColorOrder',co)
            
            
if CategorizeResponsive
            preSpikeTime=cell(size(n));
            preSpikeAmp=cell(size(n));
            SpikeGroup=cell(size(n));
            SponSpikeAmp=cell(size(n));
            SponSpikeTime=cell(size(n));
            SponSpikelocs=cell(size(n));
            Prepikenum=cell(size(n));
            Postpikenum=cell(size(n));
            [Stim_signal]=ShowEvent; % if show stimulus          
            StimInitial=time(min(find(Stim_signal)));

end
    for nfile=1:size(signal,3)
        %background correction
        BC_signal=cat(3,BC_signal,FBackCorr(signal(:,:,nfile),FrameRate));  
        
        %% find peaks and categorize traces to responsive or non-responsive
        if CategorizeResponsive
        window=5;
        thr=0.09;
        for trace=n
            smoothBC_signal=smooth(BC_signal(:,trace,end),window);
        [pks{trace},locs{trace}]=findpeaks(smoothBC_signal, 'MinPeakProminence', thr, 'MinPeakDistance', window);
        preSpikeTime{trace}=[preSpikeTime{trace} time(max(locs{trace}(time(locs{trace})<StimInitial)))];%time of the last spike before stimulus
        preSpikeAmp{trace}=[preSpikeAmp{trace} pks{trace}(max(find(time(locs{trace})<StimInitial)))];%amplitude of the last spike before stimulus
        SpikeGroup{trace}=logical([SpikeGroup{trace} sum(time(locs{trace})>StimInitial &time(locs{trace})<StimInitial+0.5)]);%responsive trial or not
        SponSpikeAmp{trace}=[SponSpikeAmp{trace};pks{trace}(find(time(locs{trace})>1 & time(locs{trace})<StimInitial))];%amplitude of the spikes before stimulus
        SponSpikelocs{trace}=[SponSpikelocs{trace} locs{trace}(time(locs{trace})<StimInitial)];%index of the pre stimulus spike
        Prepikenum{trace}=[Prepikenum{trace} length(locs{trace}(time(locs{trace})<StimInitial))];%index of the pre stimulus spike
        Postpikenum{trace}=[Postpikenum{trace} length(locs{trace}(time(locs{trace})>StimInitial))];%index of the pre stimulus spike


        

        
        
        
        %1st column: time of the spikes before stimulus; 2nd column: responsive trial or not
        SponSpikeTime{trace}=[SponSpikeTime{trace};...
            time(locs{trace}(time(locs{trace})>1 & time(locs{trace})<StimInitial)),...
            SpikeGroup{trace}(end).*ones(size(time(locs{trace}(time(locs{trace})>1 & time(locs{trace})<StimInitial))))];
        end
        end


        %% ploting signal
        if StackOrOverlap==1
            
            incre=increvalue.*(size(signal,2):-1:1); %plot the signal from top to down
        else
            incre=zeros(size(signal,2));
        end
%         for i=1:size(signal,2)
%             
% %             
% %             plot(time,BC_signal(:,i,nfile)+incre(i),'linewidth',2);
% % %             ,'color',LC(nfile,:)
% %             hold on
%         end
    end
    

    
    
%     
%     if PlotMean==1
%         for i=1:size(signal,2)
%             plot(time,mean(BC_signal(:,i,:),3)+incre(i),'color',linecolor,'linewidth',1.5);
%             hold on
%         end
%     end
    
    
    %% plotting responsive and non responsive traces

        %% plot individual traces
        %matrix for stimulus 
        Stim_signal=repmat(Stim_signal,round(size(signal,1)/size(Stim_signal,1)),1);
        for file=1:nfile
            figure
            Tn=get(gcf,'Number');
            
            
            for trace=n
            %plot responsive trace
            if SpikeGroup{trace}(file)
                figure(Tn)
                plot(time,permute(BC_signal(:,trace,file)+incre(trace),[1,3,2]),'b');
                title(FN{file}(1:11),'Interpreter','none');
                hold on
                area(time,Stim_signal*1000,...
                    'FaceColor',[1 0.5 0.5],...
                    'EdgeColor','none',...
                    'FaceAlpha',0.5);stim='Air puff';
                        ylim([increvalue-0.1 (size(signal,2)+1)*increvalue]);

                %plot heatmap
                
                heatmap_idx=locs{trace}(time(locs{trace})>StimInitial &time(locs{trace})<StimInitial+0.5);
                [BCim,im]=getim(FP{1},[FN{1}(1:11),'_OUT_MotCor.tif'],FrameRate); %get image file as matrix
                
                
                for pic=1:length(SponSpikelocs{trace})
                                     
                    heatmap_idx=SponSpikelocs{trace}(pic)-2:SponSpikelocs{trace}(pic)+8;
                    
                    figure(Tn)
                    plot(time(heatmap_idx),BC_signal(heatmap_idx,trace,file)+incre(trace),'k');
                text(time(SponSpikelocs{trace}(pic)),BC_signal(SponSpikelocs{trace}(pic),trace,file)+incre(trace)+0.05,num2str(pic))
                    
                    
                    figure
                    subplot(2,1,1)
                    imagesc(mean(im(:,:,heatmap_idx),3));
                    title(['Cell ' num2str(trace) '; Spike ' num2str(pic) ])
                    colorbar
                    axis image;
                    subplot(2,1,2)
                    imagesc(mean(BCim(:,:,heatmap_idx),3));
                    colorbar
                    axis image;
                    Fcaxis=[0 10]
                    caxis(Fcaxis);
                end


            end
            
                        hold on
            %plot non-responsive trace
            if ~SpikeGroup{trace}(file)
              figure(Tn)
                plot(time,permute(BC_signal(:,trace,file)+incre(trace),[1,3,2]),'g');
                hold on
                area(time,Stim_signal*1000,...
                    'FaceColor',[1 0.5 0.5],...
                    'EdgeColor','none',...
                    'FaceAlpha',0.5);stim='Air puff';
                        ylim([increvalue-0.1 (size(signal,2)+1)*increvalue]);

            end
        end
        
        %plot heatmap
%                 Fcaxis=[0 10];
%                 [BCim,im]=getim(FP{file},[FN{file}(1:11),'_OUT_MotCor.tif'],FrameRate); %get image file as matrix
%                 StimInitial_idx=min(find(Stim_signal));
%                 figure
%                 
%                 subplot(2,1,1)
%                 imagesc(mean(im(:,:,StimInitial_idx:StimInitial_idx+10),3));
%                 title(FN{file}(1:11),'Interpreter','none');
%                 colorbar;
%                 axis image;
%                 subplot(2,1,2)
%                 imagesc(mean(BCim(:,:,StimInitial_idx:StimInitial_idx+10),3));
%                 colorbar;
%                 axis image;
%                 caxis(Fcaxis);
                
                
%                 figure
%                 for Frame=1:32
%                 subplot(11,3,Frame)
%                 imagesc(mean(BCim(:,:,StimInitial_idx-2+Frame),3));
%                 axis image;                
%                 caxis(Fcaxis);
%                 end
% colorbar

        
        set(gcf,'color',[1 1 1])
        set(gca,'FontSize',10)
        
        end
              
%         %% plot mean and shaded area
%         figure
%         for trace=n
%             plot(time,mean(BC_signal(:,trace,SpikeGroup{trace}),3)+incre(trace),'color',linecolor,'linewidth',1.5);
%             hold on
%             signalStd=nanstd(BC_signal(:,trace,SpikeGroup{trace}),0,3);
%             ErrArea_Smooth(time,mean(BC_signal(:,trace,SpikeGroup{trace}),3)+incre(trace),signalStd,...
%                 meancolor);
%         end
%                 xlim([10 20])
%         ylim([increvalue-0.1 (size(signal,2)+1)*increvalue]);
%         
%         set(gcf,'color',[1 1 1])
%         set(gca,'FontSize',10)
%         %% plot last spike time before response
%         figure
%         hold on
%         splitrange=0.3;
%          for trace=n
%          
%             
%              % box
%              rectangle('Position',[0.9+(trace-3./2).*splitrange,...
%                  prctile(preSpikeTime{trace}(SpikeGroup{trace}),25),...
%                  0.2,...
%                  prctile(preSpikeTime{trace}(SpikeGroup{trace}),75)-prctile(preSpikeTime{trace}(SpikeGroup{trace}),25)],...
%                  'FaceColor',[0.95 .95 .95]);
%              
%              %draw lines
%              plot([0.9 1.1]+(trace-3./2).*splitrange,repmat([prctile(preSpikeTime{trace}(SpikeGroup{trace}),25),...
%                  prctile(preSpikeTime{trace}(SpikeGroup{trace}),50),...
%                  prctile(preSpikeTime{trace}(SpikeGroup{trace}),75)],2,1)',...
%                  'LineWidth',1.5,...
%                  'color',[0.3 0.3 0.3]);
%              
%              if sum(~SpikeGroup{trace})>0
%              % box
%              rectangle('Position',[-0.1+(trace-3./2).*splitrange,...
%                  prctile(preSpikeTime{trace}(~SpikeGroup{trace}),25),...
%                  0.2,...
%                  prctile(preSpikeTime{trace}(~SpikeGroup{trace}),75)-prctile(preSpikeTime{trace}(~SpikeGroup{trace}),25)],...
%                  'FaceColor',[0.95 .95 .95]);
%              
%              %draw lines
%              plot([-0.1 0.1]+(trace-3./2).*splitrange,repmat([prctile(preSpikeTime{trace}(~SpikeGroup{trace}),25),...
%                  prctile(preSpikeTime{trace}(~SpikeGroup{trace}),50),...
%                  prctile(preSpikeTime{trace}(~SpikeGroup{trace}),75)],2,1)',...
%                  'LineWidth',1.5,...
%                  'color',[0.3 0.3 0.3]);
%              end
%              
%              %     boxplot(spiketime_BC_signal,group_spiketime);
%              scatter(SpikeGroup{trace}+(trace-3./2).*splitrange,preSpikeTime{trace},'o',...
%                  'jitter','on','jitteramount',0.05,...
%                  'SizeData',60,...
%                  'LineWidth',1.5,...
%                  'MarkerEdgeColor',co(trace,:));
%              
%              
%              
%          end
%          
%          plot([-1 2],[15 15],'k:')
% %          legend(ROIlabel,'Air puff');
%          ylabel('Time (s)')
%          xticks([0 1])
%          xticklabels({'Non-responsive','Responsive'});
%          xlim([-0.5 1.5])
%          set(gcf,'color',[1 1 1])
%          
         %% plot all spike time before response
%         figure
%         hold on
%         splitrange=0.3;
%          for trace=n
%          
%             
%              % box
%              rectangle('Position',[0.9+(trace-3./2).*splitrange,...
%                  prctile(SponSpikeTime{trace}(logical(SponSpikeTime{trace}(:,2)),1),25),...
%                  0.2,...
%                  prctile(SponSpikeTime{trace}(logical(SponSpikeTime{trace}(:,2)),1),75)-prctile(SponSpikeTime{trace}(logical(SponSpikeTime{trace}(:,2)),1),25)],...
%                  'FaceColor',[0.95 .95 .95]);
%              
%              %draw lines
%              plot([0.9 1.1]+(trace-3./2).*splitrange,repmat([prctile(SponSpikeTime{trace}(logical(SponSpikeTime{trace}(:,2)),1),25),...
%                  prctile(SponSpikeTime{trace}(logical(SponSpikeTime{trace}(:,2)),1),50),...
%                  prctile(SponSpikeTime{trace}(logical(SponSpikeTime{trace}(:,2)),1),75)],2,1)',...
%                  'LineWidth',1.5,...
%                  'color',[0.3 0.3 0.3]);
%              
%              % box
%              rectangle('Position',[-0.1+(trace-3./2).*splitrange,...
%                  prctile(SponSpikeTime{trace}(~logical(SponSpikeTime{trace}(:,2)),1),25),...
%                  0.2,...
%                  prctile(SponSpikeTime{trace}(~logical(SponSpikeTime{trace}(:,2)),1),75)-prctile(SponSpikeTime{trace}(~logical(SponSpikeTime{trace}(:,2)),1),25)],...
%                  'FaceColor',[0.95 .95 .95]);
%              
%              %draw lines
%              plot([-0.1 0.1]+(trace-3./2).*splitrange,repmat([prctile(SponSpikeTime{trace}(~logical(SponSpikeTime{trace}(:,2)),1),25),...
%                  prctile(SponSpikeTime{trace}(~logical(SponSpikeTime{trace}(:,2)),1),50),...
%                  prctile(SponSpikeTime{trace}(~logical(SponSpikeTime{trace}(:,2)),1),75)],2,1)',...
%                  'LineWidth',1.5,...
%                  'color',[0.3 0.3 0.3]);
%              
%              %     boxplot(spiketime_BC_signal,group_spiketime);
%              scatter(SponSpikeTime{trace}(:,2)+(trace-3./2).*splitrange,SponSpikeTime{trace}(:,1),'o',...
%                  'jitter','on','jitteramount',0.05,...
%                  'SizeData',60,...
%                  'LineWidth',1.5,...
%                  'MarkerEdgeColor',co(trace,:));
%              
%              
%              
%          end
%          
%          plot([-1 2],[15 15],'k:')
% %          legend(ROIlabel,'Air puff');
%          ylabel('Time (s)')
%          xticks([0 1])
%          xticklabels({'Non-responsive','Responsive'});
%          xlim([-0.5 1.5])
%          set(gcf,'color',[1 1 1])
         %% plot spike time-amplitude relationship before response
%          figure
%          for trace=n
%              plot(preSpikeTime{trace}(SpikeGroup{trace}),preSpikeAmp{trace}(SpikeGroup{trace}),'o',...
%                  'MarkerSize',10,...
%                  'LineWidth',3);
%              hold on
%              plot(preSpikeTime{trace}(~SpikeGroup{trace}),preSpikeAmp{trace}(~SpikeGroup{trace}),'o',...
%                  'MarkerSize',10,...
%                  'LineWidth',3);
%          end
%          leg=[ROIlabel;ROIlabel];
%          legend(leg(:),'box','off')
%          set(gcf,'color',[1 1 1])
%     end
%     
%     
%     
%     
%     
%     
%     %% plot probality of response
%     
%     
%     
%     linecolor=[71, 97, 157;...
%         209, 55, 107;...
%         255, 164, 57;...
%         57, 195, 177]./255;
%     meancolor=[166, 181, 215;...
%         237, 179, 199;...
%         255, 234, 210;...
%         173, 231, 224]./255;
% 
% 
% 
% ResponseRatio=cellfun(@(x) sum(x==1)./length(x),SpikeGroup)';
% figure
% hold on
% for trace=n
%     bar(trace,ResponseRatio(trace));
% end
% set(gcf,'color',[1 1 1])
%     ylim([0 1])
%     
%     
%     
%     %%
%     SponSpikeAmp_late.nfile=nfile;
%     SponSpikeAmp_late.SponSpikeAmp=SponSpikeAmp;
    