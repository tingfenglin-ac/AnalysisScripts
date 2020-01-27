%20190223   analyze null position by ploting SPV versus eye position
%           of every single data point.           
%20190224   calculate the coefficient of each trace

function [MergeDATA,GOF]=NullPAnalysis_wholedatapoint_trace
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
%     figure
    Merge_time=[];
    MergeMidVel=[];
    allPrePose=[];
    allPostPose=[];
    allVSMPose=[];
    allPreVel=[];
    allPostVel=[];
    allVSMVel=[];
    GOF.([lr(j),'PreCoeffs'])=[];
    GOF.([lr(j),'PostCoeffs'])=[];
    
    for d=1:length(MergeDATA);
        VEL=MergeDATA(d).([lr(j),'vel']);
        Position=MergeDATA(d).([lr(j),'eye_raw']);
        TIME=MergeDATA(d).(['time_',lr(j)]);
        idx=MergeDATA(d).(['SaccExtremeIdx',upper(lr(j))]);
        idx=[idx(1:end-1,2) idx(2:end,1)];
        IDX=[];
        for i=1:length(idx(:,1))
            IDX=[IDX;(idx(i,1):idx(i,2))'];
        end
        
        
        
        PreIDX=IDX((TIME(IDX)/60)<5)';
        PostIDX=IDX((TIME(IDX)/60)>25 & (TIME(IDX)/60)<30)';
        VSMIDX=IDX((TIME(IDX)/60)>25 & (TIME(IDX)/60)<27)';
        
%         scatter(TIME(PreIDX)/60,Position(PreIDX),'k');
%         hold on
%         scatter(TIME(PostIDX)/60,Position(PostIDX),'r');
%         scatter(TIME(VSMIDX)/60,Position(VSMIDX),'g');
        
        PrePose=Position(PreIDX);
        PostPose=Position(PostIDX);
        VSMPose=Position(VSMIDX);
        PreVel=VEL(PreIDX);
        PostVel=VEL(PostIDX);
        VSMVel=VEL(VSMIDX);
        
        %filter out velocit>10 deg/sec
        %filter criteria
        PreCriteria=10>PreVel & PreVel>-10 & 50>PrePose & PrePose>-50;
        PostCriteria=10>PostVel & PostVel>-10 & 50>PostPose & PostPose>-50;
        PrePose=PrePose(PreCriteria);
        PostPose=PostPose(PostCriteria);
        PreVel=PreVel(PreCriteria);
        PostVel=PostVel(PostCriteria);
        
        figure
        plot(PrePose,PreVel,'ko','MarkerSize',0.05)
        hold on
        plot(PostPose,PostVel,'ro','MarkerSize',0.05)
        
        
        %linear fit pre
        [coeffs,S] = polyfit(PrePose, PreVel, 1);
        GOF.([lr(j),'PreCoeffs'])=[GOF.([lr(j),'PreCoeffs']);coeffs];
        % Get fitted values
        [fittedY,delta] = polyval(coeffs, PrePose, S);
        % Plot the fitted line
        hold on;
        plot(PrePose, fittedY, 'k-', 'LineWidth', 1.5);
        %     plot(PrePose,fittedY+2*delta,'k:',PrePose,fittedY-2*delta,'k:', 'LineWidth', 1.5)
        
        %linear fit post
        [coeffs,S] = polyfit(PostPose, PostVel, 1);
        GOF.([lr(j),'PostCoeffs'])=[GOF.([lr(j),'PostCoeffs']);coeffs];
        % Get fitted values
        [fittedY,delta] = polyval(coeffs, PostPose, S);
        % Plot the fitted line
        hold on;
        plot(PostPose, fittedY, 'r-', 'LineWidth', 1.5);
        %     plot(PostPose,fittedY+2*delta,'r:',PostPose,fittedY-2*delta,'r:', 'LineWidth', 1.5)
    end
    
    GOF.([lr(j),'Xintercept']) =[-GOF.([lr(j),'PreCoeffs'])(:,2)./GOF.([lr(j),'PreCoeffs'])(:,1),...
        -GOF.([lr(j),'PostCoeffs'])(:,2)./GOF.([lr(j),'PostCoeffs'])(:,1)]
    [h,GOF.([lr(j),'XinterP'])] = ttest(GOF.([lr(j),'Xintercept'])(:,1),GOF.([lr(j),'Xintercept'])(:,2))
    
    GOF.([lr(j),'Yintercept']) =[GOF.([lr(j),'PreCoeffs'])(:,2),GOF.([lr(j),'PostCoeffs'])(:,2)]
    [h,GOF.([lr(j),'YinterP'])] = ttest(-GOF.([lr(j),'Yintercept'])(:,1),GOF.([lr(j),'Yintercept'])(:,2))
    
    xlabel({'Eye position (deg)'},'FontSize',FONT)
    ylabel({'SPV (deg/sec)'},'FontSize',FONT);
    xlim([-30 30])
    ylim([-10 10])
    set(gca,'FontSize',FONT)
    set(gcf,'Color',[1 1 1]);
    
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