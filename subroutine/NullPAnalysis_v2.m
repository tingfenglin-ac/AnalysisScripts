% 20190301  null position analysis of first second of each slow phase, the 
%           regression line was predicted by fitlm


function [MergeDATA,GOF]=NullPAnalysis_v2
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
Width=1.5;

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
        
        plot(MidPos(PreIDX),MidVel(PreIDX),'ko','LineWidth',Width,...
            'MarkerSize',2);
        hold on
        plot(MidPos(PostIDX),MidVel(PostIDX),'o',...
            'MarkerEdgeColor',[0.5 0.5 0.5],...
            'LineWidth',Width,...
            'MarkerSize',2)
        
        allPrePose=[allPrePose;MidPos(PreIDX)];
        allPostPose=[allPostPose;MidPos(PostIDX)];
        allPreVel=[allPreVel;MidVel(PreIDX)];
        allPostVel=[allPostVel;MidVel(PostIDX)];
    end
    
    %linear fit pre
    mdl = fitlm(allPrePose,allPreVel);
    beta = mdl.Coefficients.Estimate;
    GOF.xintercept.([lr(j)])=-beta(1)/beta(2);
    GOF.premdl.([lr(j)])=mdl;
    Xnew = linspace(min(allPrePose), max(allPrePose), 1000)';
    [ypred,yci] = predict(mdl, Xnew,'Alpha',0.05);
    
    % Plot the fitted line
    hold on;
    plot(Xnew, ypred, 'k-','LineWidth',Width);
    plot(Xnew, yci, '--k','LineWidth',Width)
    
    [ypred,yci] = predict(mdl, allPrePose);
    Detrend_allPreVel=allPreVel-ypred;
    [ypred,yci] = predict(mdl, allPostPose);
    Detrend_allPostVel=allPostVel-ypred;
    
    %linear fit post

    % Get fitted values
    mdl = fitlm(allPostPose,allPostVel);
    beta = mdl.Coefficients.Estimate;
    GOF.xintercept.([lr(j)])=[GOF.xintercept.([lr(j)]) -beta(1)/beta(2)];
    GOF.postmdl.([lr(j)])=mdl;
    Xnew = linspace(min(allPostPose), max(allPostPose), 1000)';
    [ypred,yci] = predict(mdl,Xnew,'Alpha',0.05);

    % Plot the fitted line
    hold on;
    plot(Xnew, ypred, '-','LineWidth',Width,...
        'Color',[0.5,0.5,0.5]);
    plot(Xnew, yci, '--k','LineWidth',Width,...
        'Color',[0.5,0.5,0.5])
    
    
    %legend
    symbol={'o' 'o';'0 0 0' '0.5 0.5 0.5'};
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
    
    %plot detrend
    figure
    bar([1],[mean(Detrend_allPreVel)],...
        'FaceColor',[1 1 1],...
        'EdgeColor',[0 0 0],...
        'LineWidth',Width);
    hold on
    bar([2],[mean(Detrend_allPostVel)],...
        'FaceColor',[1 1 1],...
        'EdgeColor',[0.5 0.5 0.5],...
        'LineWidth',Width);
    plot(0.2*rand(length(Detrend_allPreVel),1)+0.9,Detrend_allPreVel, 'ko','MarkerSize',2);
    plot(0.2*rand(length(Detrend_allPostVel),1)+1.9,Detrend_allPostVel, 'o','MarkerSize',2,...
        'MarkerEdgeColor',[0.5 0.5 0.5]);
    [h,GOF.detranSPV_p.([lr(j)])] = ttest2(Detrend_allPreVel,Detrend_allPostVel);
    GOF.meanDSPV.([lr(j)])=[mean(Detrend_allPreVel) mean(Detrend_allPostVel)];
    GOF.stdDSPV.([lr(j)])=[std(Detrend_allPreVel) std(Detrend_allPostVel)];

    if h
        plot([1 2],[7 7],'k','LineWidth',Width);
        plot([1.5],[7.5],'k*','MarkerSize',10)
    end
    xlim([0.5 2.5])
    ylim([-8 8])
    xticks([1 2])
    xticklabels({'Prestim','Poststim'})
    ylabel({'Detrended SPV (deg/sec)'},'FontSize',FONT);
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