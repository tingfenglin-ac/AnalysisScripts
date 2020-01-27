

function [MergeDATA,GOF]=FigMergeDynamics
currentFolder = pwd;
addpath([currentFolder(1) ':\UZH data backup\eyeMov_analysis_3v\eyeMov_subroutine']);

currentFolder = pwd;
[FolderName,FolderPath] = uigetfile([currentFolder(1),':\UZH data backup\library'],'*.mat');
load([FolderPath,FolderName]);
[ProtNumber]=GetProtNumber(FolderName);


for d=1:length(library.data(:,1))
    load([currentFolder(1:19),library.data{d,3}(end-8:end),library.data{d,2}]);
    MergeDATA(d)=data;
end



[MergeDATA]=GetMergeVel(MergeDATA);
%getting velocity by derivetive



[MergeDATA,GOF]=VelPlot(MergeDATA,ProtNumber);
%mean of the velocity distribution; shaded area is std



end

function [MergeDATA,GOF]=VelPlot(MergeDATA,ProtNumber);

[protocol,protocol_name,ProtoCat]=ProtocolLibrary(ProtNumber);
OKNduration=protocol(3)-protocol(2);
protocol=[protocol(1:end-1);protocol(2:end)];
[fitstart,fitend,TraceStart]=OKANfitTIME(OKNduration);

lr='lr';
% LineColor='br';
TestColor=[0.3010, 0.7450, 0.9330;0.5 0 0];
% 
% LineColor='b';
    LineColor=[get(gca,'colororder');1 1 0;0 1 0];
    LineColor=LineColor(find([65 55 45 25 22 21 20 15 13]==protocol(end)),:);


[VorF]=VELorFREQ % making velocity plot
if VorF
    yscale=[-7 11];
else
    yscale=[-0.3 0.5];
end
% yscale=[-4 1];

% xscale=[0 protocol(end)];
xscale=[0 65];
% xscale=[24.5 32]

FONT=14;
bin=10;%time bin of frequncy and velocity


[MergeDATA,time]=GetMergeFreq(MergeDATA,bin);
%getting frequency

%in case monocular
if length(MergeDATA(1).SaccExtremeIdxL)==100;
    lr_repeat=2;
elseif length(MergeDATA(1).SaccExtremeIdxR)==100;
    lr_repeat=1;
else
    lr_repeat=1:2;
end

for j=lr_repeat;
    
    % figure(j)
    hold on 
    subplot(2,2,j)
    %  subplot(1,2,1)
    
    %stimulus velocity
%     if VorF
if 0
    StimVelLabel=1;
    StimVelPro(ProtNumber,StimVelLabel);
    ylim(yscale);
    set(gca,'LineWidth',FONT,'YColor',[0.5 0.5 0.5]);
    hold on
    yyaxis left
end
    
    
    Merge_time=[];
    MergeMidVel=[];
    for d=1:length(MergeDATA);
        VEL=MergeDATA(d).([lr(j),'vel']);
        TIME=MergeDATA(d).(['time_',lr(j)]);
        IDX=MergeDATA(d).(['SaccExtremeIdx',upper(lr(j))]);
        [MidVel]=FirstSecVel(TIME,VEL,IDX);
        
        if VorF
            [BinMeanVel,time]=BinVel(TIME,MidVel,IDX(1:end-1,2),bin);
            MergeDATA(d).([lr(j),'BinMeanVel'])=BinMeanVel;
            MergeDATA(d).([lr(j),'OKANpeak'])=min(BinMeanVel(time<=fitend*60 & time>TraceStart*60));
            
        else
            PosFreq=MergeDATA(d).([lr(j),'PosFreq']);
            NegFreq=MergeDATA(d).([lr(j),'NegFreq']);
            BinMeanVel=MergeDATA(d).([lr(j),'DiffFreq']);
            time=bin/2:bin:bin/2+bin*(length(BinMeanVel(:,1))-1);
            MergeDATA(d).([lr(j),'OKANpeak'])=min(BinMeanVel(time<=fitend*60 & time>TraceStart*60));
        end
        
        [MergeMidVel]=MergeMat(MergeMidVel,BinMeanVel);
    end
    
    time=bin/2:bin:bin/2+bin*(length(MergeMidVel(:,1))-1);
    Vel=nanmean(MergeMidVel,2);
    VelStd=nanstd(MergeMidVel,0,2);
    
    %remove redundant data
    time=time(time<fitend*60);
    Vel=Vel(time<fitend*60);
    
    %collect velocity and frequency for McGill to validate
    if VorF
    if j==1
        GOF.ltime=time;
        GOF.lVel=Vel;
    else
        GOF.rtime=time;
        GOF.rVel=Vel;
    end
    else
    if j==1
        GOF.ltime=time;
        GOF.lFre=Vel;
    else
        GOF.rtime=time;
        GOF.rFre=Vel;
    end
    end
%     'Color',LineColor(j),...
      plot(time(~isnan(Vel))'/60,Vel(~isnan(Vel)),'-',...
        'LineWidth',3,...
        'MarkerSize',10,...
        'Color',LineColor);
    if j==1
%         legend('Left eye');
%         legend boxoff;
    end
    if j==2
%         legend('Right eye');
%         legend boxoff;
    end
    hold on
    %draw the peak of the velocity plot
    switch j
        case 1
            [GOF.PeakVelL]=DrewPeakVel(OKNduration,time,Vel,0);
        case 2
            [GOF.PeakVelR]=DrewPeakVel(OKNduration,time,Vel,0);
    end
    
    if length(MergeDATA)>1
        %error bar (filled area)

        ErrArea_Smooth(time(~isnan(Vel))'/60,Vel(~isnan(Vel)),VelStd(~isnan(Vel)),...
            LineColor);
        
        FitColor=TestColor(j,:);
        % FitColor='k';
        
        %OKN fitting
        fitstart=5;
        TraceStart=5;
        [fitend]=OKNfitTIME(OKNduration);
        [GOF.(['OKN',upper(lr(j))]),GOF.(['OKNgof',upper(lr(j))])]=Fit2Exp(Vel(~isnan(Vel)),time(~isnan(Vel))',1:length(Vel(~isnan(Vel))),fitstart,fitend,TraceStart);
        hold on
        if 0 %show fitting curve
            plot(fitstart:0.1:fitend,GOF.(['OKN',upper(lr(j))])(60*(fitstart:0.1:fitend)),...
                '-',...
                'LineWidth',4,...
                'Color',FitColor);
        end
        
        %bootstraping
        %     if 1
        %     for b=1:1000
        %         [f,gof]=Fit2Exp(Vel(~isnan(Vel)),time(~isnan(Vel))',1:length(Vel(~isnan(Vel))),fitstart,fitend,TraceStart);
        %         GOF.boot.(['OKN',upper(lr(j))])(b,:)=coeffvalues(f);
        %         GOF.boot.(['OKNgof',upper(lr(j))])(b)=gof;
        %     end
        %     end
        
        %OKAN fitting
        [fitstart,fitend,TraceStart]=OKANfitTIME(OKNduration);
        %     fitstart=TraceStart
        [GOF.(['OKAN',upper(lr(j))]),GOF.(['OKANgof',upper(lr(j))])]=Fit1Exp(Vel(~isnan(Vel)),time(~isnan(Vel))',1:length(Vel(~isnan(Vel))),fitstart,fitend,TraceStart);
        if 0 %show fitting curve
            plot(fitstart:0.1:fitend,GOF.(['OKAN',upper(lr(j))])(60*(fitstart:0.1:fitend)),...
                '-',...
                'Color',FitColor,...
                'LineWidth',4);
            %           'Color',LineColor(j),...
        end
    else
        GOF=[];
    end
    
    xlim(xscale);
    ylim(yscale);
    set(gca,'fontsize',FONT)
    %     plot(xlim,[0 0],'k:')
    if VorF
        ylabel({'Eye velocity (deg/sec)'},'FontSize',FONT);
    else
        ylabel({'\DeltaQPF (beats/sec)'},'FontSize',FONT);
    end
    xlabel({'Time (min)'},'FontSize',FONT);
    set(gcf,'Color',[1 1 1]);
    set(gca,'LineWidth',1.5,'YColor','k');
    box off
    
    %scalebar
    set(gca,'xtick',[]);
    set(gca,'xcolor',[1 1 1])
    Barwidth=10; %how long the scale bar should be reciprocol of whole xaxis
    %     xBAR=0.05;%label position from left
    % xBAR=0.01;%figure 6
    xBAR=0.03;%figure 3
    if VorF
        yBAR=0.05;%label position from top
    else
        yBAR=0.05
    end
    ScaleBar(xlim,ylim,Barwidth,xBAR,yBAR,FONT);
    %         set(gca,'XTick',[min(xlim):(max(xlim)-min(xlim))/4:max(xlim)]);
    %         title(protocol_name(i-1),'FontSize',16);
end



end

function [MidVel,IntIDX]=FirstSecVel(TIME,VEL,IDX)
VelInt=2;%the interval of slow phase to be calsulated
% figure
% plot(TIME,VEL,'k');
% hold on
for i=1:length(IDX)-1
    if TIME(IDX(i+1,1))-TIME(IDX(i,2))>VelInt
        SphEnd=sum(TIME<TIME(IDX(i,2))+VelInt);
        IntIDX(i,:)=[IDX(i,2) SphEnd];
        
        nNANvel=VEL(IntIDX(i,1):IntIDX(i,2));
        MidVel(i,:)=median(nNANvel(~isnan(nNANvel)));
        %         plot(TIME(IntIDX(i,1):IntIDX(i,2)),VEL(IntIDX(i,1):IntIDX(i,2)),'r');
    else
        IntIDX(i,:)=[IDX(i,2) IDX(i+1,1)];
        
        nNANvel=VEL(IntIDX(i,1):IntIDX(i,2));
        MidVel(i,:)=median(nNANvel(~isnan(nNANvel)));
        %         plot(TIME(IntIDX(i,1):IntIDX(i,2)),VEL(IntIDX(i,1):IntIDX(i,2)),'r');
    end
end
end

function [VorF]=VELorFREQ
answer = questdlg('Velocity or frequency', ...
    'Velocity or frequency', ...
    'Velocity','Frequency','Velocity');
% Handle response
switch answer
    
    case 'Velocity'
        VorF=1
        
    case 'Frequency'
        VorF=0
end
end

function [fitend]=OKNfitTIME(OKNduration)
fitend=5+OKNduration;
end

