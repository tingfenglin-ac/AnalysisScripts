clear
addpath('C:\Users\lab\Desktop\scripts\subroutine');

%% configure
    colorlist=[1 0.5 0.5;0.5 0.5 1];
    colororder=2;


StackOrOverlap=1; %if the signals will be placed in staks choose 1; if the signals will be placed overlapped choose 2
PlotMean=0; %if plot the mean of data
plotArea=0; %if plot the mean with shaded area as sdv

%n = ROI number I would like to analyze
n=[19 43];

% if different ROI are from the same cell and want to merge ROIs to one
% signal
% ROIgroup={[1:2] [3:4] [5:8] [9] [10] [11] [12:22] [23:27] [28] 29 30 31 32 33 34:37};
ROIgroup={};



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
    [FileName,FolderPath] = uigetfile({'*analysis.mat'},'Select an ROI file', 'Multiselect', 'on');
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
    

if length(ROIgroup)
    %% read ROI size
    [sROI] = ReadImageJROI('010_015_004-043_OUT_MotCor ROI set.zip');
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
                        load(['D:\2pdata\Ting\GCaMP 20190815\815','\815_000_001','_ball.mat']);% load time dataset
%     if isfile([FP{1},FN{1}(1:11),'_ball.mat'])
%         load([FP{1},FN{1}(1:11),'_ball.mat']);
%         balltime=time;
%     elseif isfile([FP{1},FN{1}(1:11),'_eye.mat'])
%         load([FP{1},FN{1}(1:11),'_eye.mat']);
%     end
    
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
            increvalue=0.5;
            incre=increvalue.*(size(signal,2):-1:1);
        else
            incre=zeros(size(signal,2));
        end
        for i=1:size(signal,2)
            plot(time,BC_signal(:,i,nfile)+incre(i),'color',LC(nfile,:));
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
    
    %% deconvolution
    [c, s, options] = deconvolveCa(medfilt1(BC_signal(:),10),2,'optimize_b',true,'method','thresholded',...
                    'optimize_pars',true,'maxIter',20,'window',200);

    Fc=reshape(c(:),size(BC_signal));
    Fs=reshape(s(:),size(BC_signal));
    
     %% check deconvolution
%     for test=1:size(signal,2) 
%     figure
%     m=test;
%     n=9;
%     plot(BC_signal(:,m,n));
%     hold on
%     plot(Fc(:,m,n));
%     plot(Fs(:,m,n));
%     end
%% aling spike
th=0.4;
PreWind=ceil(5.*FrameRate);
PostWind=ceil(15.*FrameRate);
Dend=[];
Soma=[];
for nfile=1:size(signal,3)
    [pks locs]=findpeaks(Fc(:,1,nfile));
    locs=locs(pks>th);
    pks=pks(pks>th);
    for Sn=1:length(pks)
        if locs>PreWind & (locs+PostWind)<FramePerFile
            Dend=cat(2,Dend,BC_signal(locs(Sn)+(-PreWind:PostWind),1,nfile));
            Soma=cat(2,Soma,BC_signal(locs(Sn)+(-PreWind:PostWind),2,nfile));
        end
    end
end
t=(1:size(Dend,1))'/FrameRate;
DenStd=std(Dend,0,2);
SomStd=std(Soma,0,2);

figure
% ErrArea_Smooth(t,mean(Dend,2)+0.2,DenStd,...
%              [1 0.5 0.5]);
% hold on
for incre=1:size(Dend,2)
plot(t,Dend(:,incre)+incre,'color',[0.5 0 0])
hold on
% ErrArea_Smooth(t,mean(Soma,2),SomStd,...
%              [0.5 0.5 1]);
plot(t,Soma(:,incre)+incre,'color',[0 0 0.5])
end

     %% fourier transformation

     
     
     T = 1/FrameRate;             % Sampling period
     L = size(BC_signal,1);             % Length of signal
     Pall=[];
     Ptotal=[];
     f = FrameRate*(0:(L/2))/L;
     figure
     for nfile=1:size(signal,3)
         Pfile=[];
         for ntrace=1:size(signal,2)
             Y = fft(BC_signal,ntrace,nfile);
             % Compute the two-sided spectrum P2. Then compute the single-sided spectrum P1 based on P2 and the even-valued signal length L.
             
             P2 = abs(Y/L);
             P1 = P2(1:L/2+1);
             P1(2:end-1) = 2*P1(2:end-1);
             hold on
             Pfile=cat(2,Pfile,P1');
             
%              plot(f,P1,'color',colorlist(colororder,:))
             %              Pall=cat(2,Pall,P1)
             %              Ptotal=Ptotal+P1;
         end
         Pall=cat(3,Pall,Pfile);
     end
    
  plot(f,mean(mean(Pall,2),3)','color',[0.5 0 0])



    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    set(gcf,'color',[1 1 1])
   
%     legend('Awake','Anaesthesia');
    
    %% histogram amplitude (probability)

    
    
    figure
    hold on
    [pks,locs] = findpeaks(Fc(:));
    histogram(pks,'BinWidth',0.01,...
            'BinWidth',0.01,...
            'EdgeColor','none',...
            'FaceColor',colorlist(colororder,:),...
            'FaceAlpha',0.5,...
            'Normalization','probability')
    xlabel('Amplitude of deconvoluted Fd/F0')
    ylabel('Probability')
    set(gcf,'color',[1 1 1])
    xlim([0 0.8]);
    legend('Awake','Anaesthesia');
    %% histogram amplitude (absolute number)
        figure
    hold on
    [pks,locs] = findpeaks(Fc(:));
    histogram(pks,'BinWidth',0.01,...
            'BinWidth',0.01,...
            'EdgeColor','none',...
            'FaceColor',colorlist(colororder,:),...
            'FaceAlpha',0.5)
    xlabel('Amplitude of deconvoluted Fd/F0')
    ylabel('Spike count')
    set(gcf,'color',[1 1 1])
    xlim([0 0.8]);
    legend('Awake','Anaesthesia');
    %% interval histogram (probability)
    for th=1:2
        thresh=[0.1.*th];
        figure(10+th)
        hold on
        for i=1:length(thresh)
            interval=[];
            for nfile=1:size(signal,3)
                for ntrace=1:size(signal,2)
                    [pks,locs] = findpeaks(Fc(:,ntrace,nfile));
                    interval=cat(1,interval,diff(locs(pks>thresh(i))));
                end
            end
            
            histogram(interval/FrameRate,...
                'BinWidth',0.5,...
                'EdgeColor','none',...
                'FaceColor',[0.5 0.5 1],...
                'FaceAlpha',0.5,...
                'Normalization','probability')
            
            hold on
        end
        xlabel('Interspike interval (s)')
        ylabel('Probability')
        legend('Awake','Anaesthesia');
    end
    %% interval histogram (absolute number)
    for th=1:2
        thresh=[0.1.*th];
        figure(10+th)
        hold on
        for i=1:length(thresh)
            interval=[];
            for nfile=1:size(signal,3)
                for ntrace=1:size(signal,2)
                    [pks,locs] = findpeaks(Fc(:,ntrace,nfile));
                    interval=cat(1,interval,diff(locs(pks>thresh(i))));
                end
            end
            
            histogram(interval/FrameRate,...
                'BinWidth',0.5,...
                'EdgeColor','none',...
                'FaceColor',[0.5 0.5 1],...
                'FaceAlpha',0.5)
            
            hold on
        end
        xlabel('Interspike interval (s)')
        ylabel('Count')
        legend('Awake','Anaesthesia');
    end