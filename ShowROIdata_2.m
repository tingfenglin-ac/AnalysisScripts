addpath('C:\Users\lab\Desktop\scripts\subroutine');

%% configure
paw_move=0; %%if the paw movement will be included in the figure choose 1, or choose others  
vel_ana=0; %if the motion activity will be included in the figure choose 1, or choose others  
blink_ana=0; %if the eye blink will be included in the figure choose 1, or choose others  
Air_puff=0; %if the air puff will be included in the figure choose 1, or choose others  
CrossCor=0; %if the cross correlation among signals will be analyzed choose 1
StackOrOverlap=1; %if the signals will be placed in staks choose 1; if the signals will be placed overlapped choose 2
PlotMean=1; %if plot the mean of data
plotArea=1; %if plot the mean with shaded area as sdv

%n = ROI number I would like to analyze
n=[1:10];


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
    FN
    %% get time variables from file
    %                     load(['D:\2pdata\Ting\GCaMP 20190820\820','\820_000_001','_ball.mat']);% load time dataset
    if isfile([FP{1},FN{1}(1:11),'_ball.mat'])
        load([FP{1},FN{1}(1:11),'_ball.mat']);
        balltime=time;
    elseif isfile([FP{1},FN{1}(1:11),'_eye.mat'])
        load([FP{1},FN{1}(1:11),'_eye.mat']);
    end
    
    % if its's concatenated data, FramePerFile is the frame number of each
    % recording
    load([FP{1},FN{1}(1:11),'.mat']);
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
    
    
for nfile=1:size(signal,3)
    %background correction
    BC_signal=cat(3,BC_signal,FBackCorr(signal(:,:,nfile),FrameRate));
    
    %ploting signal
    if StackOrOverlap==1
        increvalue=1;
        incre=increvalue.*(size(signal,2):-1:1);
    else
        incre=zeros(size(signal,2));
    end
    for i=1:size(signal,2)
        plot(time,BC_signal(:,i,nfile)+incre(i),'color',LC(nfile,:));
        hold on
        
        %% calculate spiking rate
        [pk,loc] = findpeaks(BC_signal(:,i,nfile));
        locs{i}=time(loc(zscore(pk)>3));
        pks{i}=pk(zscore(pk)>3);
        plot(locs{i},pks{i}+incre(i),'ro');
    end 
end

    if PlotMean==1
        for i=1:size(signal,2)
            plot(time,mean(BC_signal(:,i,:),3)+incre(i),'color',linecolor,'linewidth',1.5);
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
         plot(time,mean(BC_signal(:,i,:),3)+incre(i),'color',linecolor,'linewidth',1.5);
         hold on
         signalStd=nanstd(BC_signal(:,i,:),0,3);
         ErrArea_Smooth(time,mean(BC_signal(:,i,:),3)+incre(i),signalStd,...
             meancolor);
     end
end
    

%% velocity analysis
if vel_ana==1
    VEL=[];
    for nfile=1:size(signal,3)
        %unit of velocity is pixel
        %1 alphabet is around 75 pixel which is around 30 mm
        load([FP{nfile},FN{nfile}(1:11),'_velocity.mat']);
        velocity = medfilt1(velocity,15,'omitnan','truncate'); %median filtering
        % change the unit
        velocity=velocity./(30.*75./30);
        
        VEL=cat(2,VEL,velocity);
    end
    
    figure(kn);
    plot(balltime(1:length(VEL)),VEL,'color',[0.5 0.5 0.5]);
    plot(balltime(1:length(VEL)),mean(VEL,2),'color',[0 0 0],'linewidth',1.5);
    
    if plotArea
        figure(mn);
        velocityStd=nanstd(VEL,0,2);
        ErrArea_Smooth(time(1:length(signal)),mean(VEL,2),velocityStd,...
            [0 0 0]); hold on
        plot(balltime(1:length(VEL)),mean(VEL,2),'color',[0 0 0],'linewidth',1.5);
    end
    
end

%% eye blink
if blink_ana==1;
    [blink]=EyeBlinkEstimation;
blink=smooth(blink(1:600),15,'lowess');
normalb=blink/max(blink);
hold on
figure(k);
area(time(1:length(normalb)),1-normalb,...
    'FaceColor',[0.5 0.5 0.5],...
    'EdgeColor','none',...
    'FaceAlpha',0.3);
stim='Eye blink';
end

%% Air puff
if Air_puff==1;
    
    [Stim_signal]=ShowEvent; % if show stimulus
    % for concatenated data
    Stim_signal=repmat(Stim_signal,round(size(signal,1)/size(Stim_signal,1)),1);
    
    figure(kn)
    area(time,Stim_signal*100,...
        'FaceColor',[0 0 0.5],...
        'EdgeColor','none',...
        'FaceAlpha',0.7);stim='Air puff';
    if plotArea
        figure(mn)
        area(time,Stim_signal*100,...
            'FaceColor',[0 0 0.5],...
            'EdgeColor','none',...
            'FaceAlpha',0.7);stim='Air puff';
    end
end

%% figure
%single data
figure(kn)
xlabel('Time (s)');
set(gcf,'color',[1,1,1]);
if StackOrOverlap==1
    ylim([-1 (size(signal,2)+1)*increvalue]);
    yticks(fliplr(incre));
    yticklabels(cellfun(@num2str,mat2cell(fliplr(n),1,ones(1,length(n))),'uni',0));
    ylabel('ROI')
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
        yticks(fliplr(incre));
        yticklabels(cellfun(@num2str,mat2cell(fliplr(n),1,ones(1,length(n))),'uni',0));
        ylabel('ROI')
    else
        ylim([0 8]);
    end
    
    
    %     xlim([0 30*8])
    % title({['Cell ' num2str(n) ' (n=' num2str(size(all_signal,2)) ')']},'FontSize',14);
    %     title({['(n=' num2str(filesize) ')']},'FontSize',14);
    
end

% legend([Label,'speed']);

%% cross correlation
if CrossCor==1
CrossCorr_Ting(velocity,Tablenames,n);
end

%% histogram
% figure
% histogram(all_pks,[0:0.02:1],'FaceColor',linecolor,'EdgeColor',meancolor);
% xlim([0,1]);
% xlabel('dF/F0');
% ylabel('#peaks');


% figure
% histogram(repmat(all_pks_pre(:,1),filesize_lp*filesize_ep,1),[0:0.02:1],'Normalization','probability');
% hold on
% histogram(repmat(all_pks_ep(:,1),filesize_pre*filesize_lp,1),[0:0.02:1],'Normalization','probability');
% histogram(repmat(all_pks_lp(:,1),filesize_pre*filesize_ep,1),[0:0.02:1],'Normalization','probability');
% xlim([0,1]);
% xlabel('dF/F0');
% ylabel('Probability');
% legend('Pre','Early-post','Late-post');
