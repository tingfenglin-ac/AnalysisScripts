
function [MergeDATA,GOF]=MergeDynamics
currentFolder = pwd;
[FolderName,FolderPath] = uigetfile([currentFolder(1),':\TURN TABLE\library'],'*.mat');
load([FolderPath,FolderName]);


for d=1:length(library.data(:,1))
    load([currentFolder(1),library.data{d,3}(2:end),library.data{d,2}]);
    MergeDATA(d)=data;
end

[MergeDATA]=GetMergeVel(MergeDATA);
%getting velocity by derivetive

[MergeDATA,GOF]=VelPlot(MergeDATA);
%mean of the velocity distribution; shaded area is std



end

function [MergeDATA]=GetMergeVel(MergeDATA)
lr='lr';
for j=1:2
    for d=1:length(MergeDATA);
        eye_raw=MergeDATA(d).([lr(j),'eye_raw']);
        MergeDATA(d).([lr(j),'vel'])=derivate(eye_raw,1/40);
    end
end
end

function [MergeDATA,GOF]=VelPlot(MergeDATA);

lr='lr';
for j=1:2;
    
    xscale=[0 45];
    yscale=[-5 12];
    %
    figure(j);
    fig=gcf;
    fig.Position=[0,0, 1000, 400];
    [protocol,protocol_name,ProtoCat]=ProtocolLibrary(4);
    protocol=[protocol(1:end-1);protocol(2:end)];
    
    %stimulus velocity
    StimVelPro(4);
    ylim(yscale);
    set(gca,'LineWidth',1.5,'YColor','r');
    hold on
    
yyaxis left
%     plot(protocol(1:end),[0 0 10 10 0 0],'r');
%     hold on
    %v=velocity s=datasize
    Merge_time=[];
    MergeMidVel=[];
    for d=1:length(MergeDATA);
        
        
        VEL=MergeDATA(d).([lr(j),'vel']);
        TIME=MergeDATA(d).(['time_',lr(j)]);
        IDX=MergeDATA(d).(['SaccExtremeIdx',upper(lr(j))]);
        [MidVel]=FirstSecVel(TIME,VEL,IDX);
        [BinMeanVel,time]=BinVel(TIME,MidVel,IDX(1:end-1,2),10);
        
        
        if length(MergeMidVel)~=0 & length(MergeMidVel)<length(BinMeanVel)
            MergeMidVel(end+1:length(BinMeanVel),:)=nan;
        end
        if  length(MergeMidVel)>length(BinMeanVel)
            BinMeanVel(end+1:length(MergeMidVel),:)=nan;
        end
        MergeMidVel=[MergeMidVel BinMeanVel];
        
        
        
    end
    time=time(1):time(2)-time(1):time(1)+(time(2)-time(1))*(length(BinMeanVel)-1);
    Vel=nanmean(MergeMidVel,2);
    VelStd=nanstd(MergeMidVel,0,2);
    errorbar(time(~isnan(Vel))'/60,Vel(~isnan(Vel)),VelStd(~isnan(Vel)),'ko');
    %     errorbar(time(~isnan(BinMeanVel))',nanmean(BinMeanVel(~isnan(BinMeanVel)),2),nanstd(BinMeanVel(~isnan(BinMeanVel)),0,2),'o');
    fitstart=5;
    fitend=25;
    TraceStart=5;
    [GOF.(['OKN',upper(lr(j))]),GOF.(['OKNgof',upper(lr(j))])]=Fit2Exp(Vel(~isnan(Vel)),time(~isnan(Vel))',1:length(Vel(~isnan(Vel))),fitstart,fitend,TraceStart);
    hold on
    plot(fitstart:0.1:fitend,GOF.(['OKN',upper(lr(j))])(60*(fitstart:0.1:fitend)),...
        'k-',...
        'LineWidth',2);
    
    fitstart=27;
    fitend=45;
    TraceStart=25;
    [GOF.(['OKAN',upper(lr(j))]),GOF.(['OKANgof',upper(lr(j))])]=Fit1Exp(Vel(~isnan(Vel)),time(~isnan(Vel))',1:length(Vel(~isnan(Vel))),fitstart,fitend,TraceStart);
    plot(fitstart:0.1:fitend,GOF.(['OKAN',upper(lr(j))])(60*(fitstart:0.1:fitend)),...
        'k-',...
        'LineWidth',2);
    
    
    PlotProtocol(1,4,11,1);
    
    xlim(xscale);
    ylim(yscale);
    set(gca,'fontsize',20)
    plot(xlim,[0 0],'k:')
    ylabel({'Eye velocity (deg/min)'},'FontSize',22);
    xlabel({'Time (min)'},'FontSize',22);     
    set(gcf,'Color',[1 1 1]);
    set(gca,'LineWidth',1.5,'YColor','k');
    box off
    
    %scalebar
    set(gca,'xtick',[]);
    set(gca,'xcolor',[1 1 1])
    Barwidth=10; %how long the scale bar should be reciprocol of whole xaxis
    xBAR=0.05;%label position from left
    yBAR=0.05;%label position from top
    ScaleBar(xlim,ylim,Barwidth,xBAR,yBAR);

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


