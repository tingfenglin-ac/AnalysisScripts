[fileName,pathName] = uigetfile('*.mat');
load([pathName,fileName]);
[GOF]=VelPlot(data);

function [GOF]=VelPlot(data);

lr='lr';
for j=1:2;
    
    Merge_time=[];
    MergeMidVel=[];
    FigHandle = figure('Position', [0,0, 1000, 600]);
    %v=velocity s=datasize
  
        
        
        VEL=derivate(data.([lr(j),'eye_raw']),1/40);
        TIME=data.(['time_',lr(j)]);
        IDX=data.(['SaccExtremeIdx',upper(lr(j))]);
        [MidVel]=FirstSecVel(TIME,VEL,IDX);
        [BinMeanVel,time]=BinVel(TIME,MidVel,IDX(1:end-1,2),10);

        
        if length(MergeMidVel)~=0 & length(MergeMidVel)<length(BinMeanVel)
            MergeMidVel(end+1:length(BinMeanVel),:)=nan;
        end
        if  length(MergeMidVel)>length(BinMeanVel)
            BinMeanVel(end+1:length(MergeMidVel),:)=nan;
        end
        MergeMidVel=[MergeMidVel BinMeanVel];
 
        
        

    time=time(1):time(2)-time(1):time(1)+(time(2)-time(1))*(length(BinMeanVel)-1);
    Vel=nanmean(MergeMidVel,2);
    VelStd=nanstd(MergeMidVel,0,2);
    errorbar(time(~isnan(Vel))'/60,Vel(~isnan(Vel)),VelStd(~isnan(Vel)),'o');
%     errorbar(time(~isnan(BinMeanVel))',nanmean(BinMeanVel(~isnan(BinMeanVel)),2),nanstd(BinMeanVel(~isnan(BinMeanVel)),0,2),'o');

    [GOF.(['f',upper(lr(j))]),GOF.(['gof',upper(lr(j))])]=Fit2Exp(Vel(~isnan(Vel)),time(~isnan(Vel))',1:length(Vel(~isnan(Vel))),5,25);
    hold on
    plot(5:0.1:25,GOF.(['f',upper(lr(j))])(60*(5:0.1:25)));
    set(gcf,'Color',[1 1 1]);
    %         xlim(xscale);
    %         ylim(yscale);
    %         set(gca,'XTick',[min(xlim):(max(xlim)-min(xlim))/4:max(xlim)]);
    %         title(protocol_name(i-1),'FontSize',16);
end



end

function [MidVel,IntIDX]=FirstSecVel(TIME,VEL,IDX)
VelInt=2;%the interval of slow phase to be calsulated
figure 
plot(TIME,VEL,'k');
hold on
for i=1:length(IDX)-1
    if TIME(IDX(i+1,1))-TIME(IDX(i,2))>VelInt
        SphEnd=sum(TIME<TIME(IDX(i,2))+VelInt);
        IntIDX(i,:)=[IDX(i,2) SphEnd];
        MidVel(i,:)=nanmedian(VEL(IntIDX(i,1):IntIDX(i,2)));
        plot(TIME(IntIDX(i,1):IntIDX(i,2)),VEL(IntIDX(i,1):IntIDX(i,2)),'r');
    else
        IntIDX(i,:)=[IDX(i,2) IDX(i+1,1)];
        MidVel(i,:)=nanmedian(VEL(IntIDX(i,1):IntIDX(i,2)));
        plot(TIME(IntIDX(i,1):IntIDX(i,2)),VEL(IntIDX(i,1):IntIDX(i,2)),'r');
    end
end  
end

function [f,gof]=Fit2Exp(VEL,TIME,IDX,fitstart,fitend)
% fit_idx=find(TIME(IDX(1:end-1,2))>fitstart*60 & TIME(IDX(1:end-1,2))<fitend*60);
% fit_time=TIME(IDX(fit_idx,2));
% [MidVel]=FirstSecVel(TIME,VEL,IDX);
% fit_value=MidVel(fit_idx);

fit_idx=find(TIME(IDX)>fitstart*60 & TIME(IDX)<fitend*60);
fit_time=TIME(IDX(fit_idx));
fit_value=VEL(fit_idx);


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
