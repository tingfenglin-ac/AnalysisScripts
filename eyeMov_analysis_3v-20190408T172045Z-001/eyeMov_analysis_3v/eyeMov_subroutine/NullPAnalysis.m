function [MergeDATA,GOF]=FigMergeDynamics_normal
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

[MergeDATA,GOF]=null_position(MergeDATA,ProtNumber);
end

function [MergeDATA,GOF]=null_position(MergeDATA,ProtNumber);

[protocol,protocol_name,ProtoCat]=ProtocolLibrary(ProtNumber);
OKNduration=protocol(3)-protocol(2);
protocol=[protocol(1:end-1);protocol(2:end)];
[fitstart,fitend,TraceStart]=OKANfitTIME(OKNduration);
lr='lr';
FONT=22;

%in case monocular
if length(MergeDATA(1).SaccExtremeIdxL)==100;
    lr_repeat=2;
elseif length(MergeDATA(1).SaccExtremeIdxR)==100;
    lr_repeat=1;
else
    lr_repeat=1:2;
end

for j=lr_repeat;
    figure
    Merge_time=[];
    MergeMidVel=[];
    allPrePose=[];
    allPostPose=[];
    allPreVel=[];
    allPostVel=[];
    
    for d=1:length(MergeDATA);
        VEL=MergeDATA(d).([lr(j),'vel']);
        Position=MergeDATA(d).([lr(j),'eye_raw']);
        TIME=MergeDATA(d).(['time_',lr(j)]);
        IDX=MergeDATA(d).(['SaccExtremeIdx',upper(lr(j))]);
        
        [MidVel,IntIDX]=FirstSecVel(TIME,VEL,IDX);
        [MidPos]=MidPosition(Position,IntIDX);
        PreIDX=(1:sum(TIME(IntIDX(:,1))/60<5))';
        PostIDX=(sum(TIME(IntIDX(:,1))/60<25)+1:sum(TIME(IntIDX(:,1))/60<30))';
        
        plot(MidPos(PreIDX),MidVel(PreIDX),'ko')
        hold on
        plot(MidPos(PostIDX),MidVel(PostIDX),'ro')
        
        allPrePose=[allPrePose;MidPos(PreIDX)];
        allPostPose=[allPostPose;MidPos(PostIDX)];
        allPreVel=[allPreVel;MidVel(PreIDX)];
        allPostVel=[allPostVel;MidVel(PostIDX)];
    end
    
    %linear fit pre
    coeffs = polyfit(allPrePose, allPreVel, 1);
    % Get fitted values
    fittedX = linspace(-30, 30, 200);
    fittedY = polyval(coeffs, fittedX);
    % Plot the fitted line
    hold on;
    plot(fittedX, fittedY, 'k-', 'LineWidth', 1.5);
    
    %linear fit post
    coeffs = polyfit(allPostPose, allPostVel, 1);
    % Get fitted values
    fittedX = linspace(-30, 30, 200);
    fittedY = polyval(coeffs, fittedX);
    % Plot the fitted line
    hold on;
    plot(fittedX, fittedY, 'r-', 'LineWidth', 1.5);
    
    
    
    
    %legend
    symbol={'ko' 'ro'};
    str={'Prestim' 'Poststim'};
    symbolloca=[11 9;11 7];
    txtloca=[13 9;13 7];
    Tinglegend(symbol,str,symbolloca,txtloca,FONT);
    
    xlabel({'Eye position (deg)'},'FontSize',FONT)
    ylabel({'SPV (deg/sec)'},'FontSize',FONT);
    xlim([-30 30])
    ylim([-10 10])
    set(gca,'FontSize',FONT)
    set(gcf,'Color',[1 1 1]);
    
    
    if 0
        PoseVelTTest(allPrePose,allPostPose,allPreVel,allPostVel)
    end
end
end

function PoseVelTTest(allPrePose,allPostPose,allPreVel,allPostVel)
figure('position',[0,0,600,300])
subplot(1,2,1)
data=[mean(allPrePose) mean(allPostPose)];
bar([1 2],data)
hold on
stdpre=std(allPrePose);
stdppost=std(allPostPose);
er = errorbar([1 2],data,...
    data+[stdpre stdppost],...
    data-[stdpre stdppost]);
er.Color = [0 0 0];
er.LineStyle = 'none';
[h,p] = ttest2(allPrePose,allPostPose);
title(num2str(p));
ylim([-30 30]);

subplot(1,2,2)
data=[mean(allPreVel) mean(allPostVel)];
bar([1 2],data)
hold on
stdpre=std(allPreVel);
stdppost=std(allPostVel);
er = errorbar([1 2],data,...
    data+[stdpre stdppost],...
    data-[stdpre stdppost]);
er.Color = [0 0 0];
er.LineStyle = 'none';
[h,p] = ttest2(allPreVel,allPostVel)
title(num2str(p));


% only comparethe position and velocity moved within top helf position
figure('position',[0,0,600,300])
subplot(1,2,1)
data=[mean(allPrePose(allPrePose>median(allPrePose))) mean(allPostPose(allPostPose>median(allPrePose)))];
bar([1 2],data)
hold on
stdpre=std(allPrePose(allPrePose>median(allPrePose)));
stdppost=std(allPostPose(allPostPose>median(allPrePose)));
er = errorbar([1 2],data,...
    data+[stdpre stdppost],...
    data-[stdpre stdppost]);
er.Color = [0 0 0];
er.LineStyle = 'none';
[h,p] = ttest2(allPrePose(allPrePose>median(allPrePose)),allPostPose(allPostPose>median(allPrePose)))
title(num2str(p));
ylim([-30 30]);

subplot(1,2,2)
data=[mean(allPreVel(allPrePose>median(allPrePose))) mean(allPostVel(allPostPose>median(allPrePose)))];
bar([1 2],data)
hold on
stdpre=std(allPreVel(allPrePose>median(allPrePose)));
stdppost=std(allPostVel(allPostPose>median(allPrePose)));
er = errorbar([1 2],data,...
    data+[stdpre stdppost],...
    data-[stdpre stdppost]);
er.Color = [0 0 0];
er.LineStyle = 'none';
[h,p] = ttest2(allPreVel(allPrePose>median(allPrePose)),allPostVel(allPostPose>median(allPrePose)))
title(num2str(p));
end