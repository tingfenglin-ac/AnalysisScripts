addpath('C:\Users\lab\Desktop\scripts\subroutine');

%% configure
paw_move=0; %%if the paw movement will be included in the figure choose 1, or choose others  
vel_ana=0; %if the motion activity will be included in the figure choose 1, or choose others  
blink_ana=0; %if the eye blink will be included in the figure choose 1, or choose others  
Air_puff=1; %if the air puff will be included in the figure choose 1, or choose others  
CrossCor=0; %if the cross correlation among signals will be analyzed choose 1
StackOrOverlap=1; %if the signals will be placed in staks choose 1; if the signals will be placed overlapped choose 2
PlotMean=1; %if plot the mean of data
plotArea=1; %if plot the mean with shaded area as sdv

%n = ROI number I would like to analyze
n=[1:33];

%set color
linecolor=[0.5 0 0];
meancolor=[1 0 0];

% linecolor=[0 0 0.5];
% meancolor=[0 0 1];

%% read aligned velocity data
[FileName,FolderPath] = uigetfile('*speed.mat','Select aligned speed data');
load([FolderPath,FileName])

%% read Ca activity and treadmill data
signal=[];
all_velocity=[];
alignidx=[];
for fnumber=1:length(SelectedFile)
    % read Ca activity
    Import_data=load([FolderPath,SelectedFile{fnumber}(1:12),'OUT_MotCor ROI analysis.mat']);
    signal=cat(3,signal,Import_data.activs(:,n));
    
    % algn Ca activity
    if fnumber==1
    alignsignal=nan(2.*size(signal,1)-1,size(signal,2),length(SelectedFile));
    end   
    alignidx(:,fnumber)=size(signal,1)-median(IDX(:,fnumber))+1:size(signal,1)-median(IDX(:,fnumber))+size(signal,1);
    alignsignal(alignidx(:,fnumber),:,fnumber)=Import_data.activs(:,n);
    
    % read treadmill data
    load([FolderPath,SelectedFile{fnumber}]);
    velocity = medfilt1(velocity,30,'omitnan','truncate'); %median filtering
    % change the unit
    velocity=velocity./(75./10);
    
    all_velocity=cat(2,all_velocity,velocity(1:size(signal,1)));
    
     % algn treadmill data
    if fnumber==1
    alignvelocity=nan(2.*size(signal,1)-1,length(SelectedFile));
    end   
    alignvelocity(alignidx(:,fnumber),fnumber)=velocity(1:size(signal,1));
end
    
%% get time variables from file
    %                     load(['D:\2pdata\Ting\GCaMP 20190820\820','\820_000_001','_ball.mat']);% load time dataset
    if isfile([FolderPath,SelectedFile{1}(1:11),'_ball.mat'])
        load([FolderPath,SelectedFile{1}(1:11),'_ball.mat']);
        balltime=time;
    elseif isfile([FolderPath,SelectedFile{1}(1:11),'_eye.mat'])
        load([FolderPath,SelectedFile{1}(1:11),'_eye.mat']);
    end
    
    % if its's concatenated data, FramePerFile is the frame number of each
    % recording
    load([FolderPath,SelectedFile{1}(1:11),'.mat']);
    FramePerFile=info.config.frames;
    
    
    % ratio of camera sampling rate and 2P sampling rate
    step=round(size(time,1)./FramePerFile);
    %time of the 2P signal
    time=time(1:step:step.*FramePerFile);
    FrameRate=mean(1./(time(2:end)-time(1:end-1)));
    
    % for concatenated data
    timestep=time;
    for ext_time=1:round(size(signal,1)/size(time,1))-1
        time=[time;time(end)+timestep];
    end   
    
    % time for aligned data
    aligntime=[-flipud(time(2:end));time];
    
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
    
    % define the increment of stacked traces
    if StackOrOverlap==1
        increvalue=0.5;
        incre=increvalue.*(size(signal,2):-1:1);
    else
        incre=zeros(size(signal,2));
    end
    
    % ploting raw traces
    for nfile=1:size(signal,3)
        % algn backgound correctted Ca activity
        if nfile==1
            alignBCsignal=nan(2.*size(signal,1)-1,size(signal,2),length(SelectedFile));
        end
        alignBCsignal(alignidx(:,nfile),:,nfile)=FBackCorr(signal(:,:,nfile),FrameRate);
        
        %ploting signal
        for i=1:size(signal,2)
            plot(aligntime,alignBCsignal(:,i,nfile)+incre(i),'color',LC(nfile,:));
            hold on
        end
    end
    
 

    % plot mean of raw traces
    if PlotMean==1
        for i=1:size(signal,2)
            plot(aligntime,mean(alignBCsignal(:,i,:),3)+incre(i),'color',linecolor,'linewidth',1.5);
            hold on
        end
    end
  
%% plot area
if plotArea
    figure;
    mn=get(gcf,'Number');
    defautPosition=get(gcf,'Position');
    set(gcf,'position',[1 1 defautPosition(3) 840]);
     for i=1:size(signal,2)
         plot(aligntime,mean(alignBCsignal(:,i,:),3)+incre(i),'color',linecolor,'linewidth',1.5);
         hold on
         signalStd=std(alignBCsignal(:,i,:),0,3);
         ErrArea_Smooth(aligntime,mean(alignBCsignal(:,i,:),3)+incre(i),signalStd,...
             meancolor);
     end
end

%% plot velocity
% plot mean of raw traces
figure(kn)
plot(aligntime,alignvelocity,'color',[0.5 0.5 0.5]);
plot(aligntime,nanmean(alignvelocity,2),'color',[0 0 0],'linewidth',1.5);
if plotArea
    figure(mn)
    velocityStd=nanstd(alignvelocity,0,2);
    ErrArea_Smooth(aligntime,nanmean(alignvelocity,2),velocityStd,...
        [0 0 0]); hold on
    plot(aligntime,nanmean(alignvelocity,2),'color',[0 0 0],'linewidth',1.5);
end

%% figure
%single data
figure(kn)
xlabel('Time (s)');
set(gcf,'color',[1,1,1]);
if StackOrOverlap==1
    ylim([-1 (size(signal,2)+1)*increvalue]);
    yticks([0 fliplr(incre)]);
    yticklabels(['Speed',cellfun(@num2str,mat2cell(fliplr(n),1,ones(1,length(n))),'uni',0)]);
    ylabel('ROI')
    xlim([-5 5])
else
    ylim([0 8]);
end
% yticks([1:size(all_signal,2)+2])
% xlim([0 30*8])
% legend({'Distal dendrite 1','Distal dendrite 2', 'Proximal dendrite','Air puff'},'FontSize',14);

%shadow
if plotArea
    figure(mn)
    xlabel('Time (s)');
    set(gcf,'color',[1,1,1]);
    if StackOrOverlap==1
        ylim([-1 (size(signal,2)+1)*increvalue]);
        yticks([0 fliplr(incre)]);
        yticklabels(['Speed',cellfun(@num2str,mat2cell(fliplr(n),1,ones(1,length(n))),'uni',0)]);
        ylabel('ROI')
        xlim([-5 5])
    else
        ylim([0 8]);
    end
    
    
    %     xlim([0 30*8])
    % title({['Cell ' num2str(n) ' (n=' num2str(size(all_signal,2)) ')']},'FontSize',14);
    %     title({['(n=' num2str(filesize) ')']},'FontSize',14);
    
end


%% plot heatmap
figure
subplot(3,1,[1 2])
imagesc(mean(alignBCsignal,3)','XData',aligntime)
xlim([-5 5]);
caxis([0 0.5]);
get(gca,'ylim')
hold on
% plot([0 0],get(gca,'ylim'),'color',[1 0.5 0.5]);
set(gcf,'color',[1 1 1]);

ylabel('ROI')

subplot(3,1,3)
ErrArea_Smooth(aligntime,nanmean(alignvelocity,2),velocityStd,...
    [0 0 0]); hold on
plot(aligntime,nanmean(alignvelocity,2),'color',[0 0 0],'linewidth',1.5);
xlim([-5 5]);
ylim([0 1.5])
ylabel('Locomotion speed')
xlabel('Time (sec)');
    