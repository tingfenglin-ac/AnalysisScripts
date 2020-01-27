
function [MergeDATA]=LoadingFile
[FolderName,FolderPath] = uigetfile('H:\TURN TABLE\library','*.mat');
load([FolderPath,FolderName]);


for d=1:length(library.data(:,1))
    load([library.data{d,3},library.data{d,2}]);
    MergeDATA(d)=data;
end

[MergeDATA]=GetMergeVel(MergeDATA);
%getting velocity by derivetive

[MergeDATA]=VelPlot(MergeDATA);
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

function [MergeDATA]=VelPlot(MergeDATA);

lr='lr';
for j=1:2;
    
    Merge_time=[];
    MergeMidVel=[];
    FigHandle = figure('Position', [0,0, 1000, 600]);
    %v=velocity s=datasize
    for d=1:length(MergeDATA);
        
        
        VEL=MergeDATA(d).([lr(j),'vel']);
        TIME=MergeDATA(d).(['time_',lr(j)]);
        IDX=MergeDATA(d).(['SaccExtremeIdx',upper(lr(j))]);
        [MidVel]=FirstSecVel(TIME,VEL,IDX);
        [BinMeanVel,time]=BinVel(TIME,MidVel,IDX(1:end-1,2),10);
        
        %         Merge_time=[Merge_time;TIME(IDX(1:end-1,2))/60];
        %         MergeMidVel=[MergeMidVel;MidVel];
        %         plot(TIME(IDX(1:end-1,2))/60,MidVel,'o');
        plot(time(~isnan(BinMeanVel)),BinMeanVel(~isnan(BinMeanVel)),'o');
        
        hold on
        
    end
%     [f,MergeDATA(d).(['gof',upper(lr(j))])]=Fit2Exp(VEL,TIME,IDX,5,25);
    
%     plot(5:0.1:25,f(60*(5:0.1:25)));
    set(gcf,'Color',[1 1 1]);
    %         xlim(xscale);
    %         ylim(yscale);
    %         set(gca,'XTick',[min(xlim):(max(xlim)-min(xlim))/4:max(xlim)]);
    %         title(protocol_name(i-1),'FontSize',16);
end



end
function [MidVel,IntIDX]=FirstSecVel(TIME,VEL,IDX)
VelInt=1;%the interval of slow phase to be calsulated
for i=1:length(IDX)-1
    if TIME(IDX(i,2))-TIME(IDX(i+1,1))>VelInt
        SphEnd=sum(TIME<TIME(IDX(i,2))+VelInt);
        IntIDX(i,:)=[IDX(i,2) SphEnd];
        MidVel(i,:)=nanmedian(VEL(IntIDX(i,1):IntIDX(i,2)));
    else
        IntIDX(i,:)=[IDX(i,2) IDX(i+1,1)];
        MidVel(i,:)=nanmedian(VEL(IntIDX(i,1):IntIDX(i,2)));
    end
end  
end

function [f,gof]=Fit2Exp(VEL,TIME,IDX,fitstart,fitend)
fit_idx=find(TIME(IDX(1:end-1,2))>fitstart*60 & TIME(IDX(1:end-1,2))<fitend*60);
fit_time=TIME(IDX(fit_idx,2));
[MidVel]=FirstSecVel(TIME,VEL,IDX);
fit_value=MidVel(fit_idx);


initTC1=60;
initTC2=300;

fo= fitoptions('Method','NonlinearLeastSquares',...
               'Lower',[0,0,0,0,quantile(fit_value,0.1)],'Upper',[Inf,Inf,inf,100,quantile(fit_value,0.9)],...
               'MaxFunEvals',100000,'TolFun',10^-12,...
           'StartPoint',[(max(fit_value)-quantile(fit_value,0.5))/2,initTC1,(max(fit_value)-quantile(fit_value,0.5))/2,initTC2,quantile(fit_value,0.5)]);
           
ft=fittype('a*exp(-x/b) + c*exp(-x/d)+e');

[f,gof]=fit(fit_time(:),fit_value(:),ft,fo);%,'StartPoint',[5, 4, 8, 4, 0] );

% output.rsquare=[output.rsquare gof.rsquare];
% parameters=coeffvalues(f);
end
