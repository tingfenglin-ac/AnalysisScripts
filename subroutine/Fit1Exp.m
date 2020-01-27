function [f,gof]=Fit1Exp(VEL,TIME,IDX,fitstart,fitend,TraceStart)
% fit_idx=find(TIME(IDX(1:end-1,2))>fitstart*60 & TIME(IDX(1:end-1,2))<fitend*60);
% fit_time=TIME(IDX(fit_idx,2));
% [MidVel]=FirstSecVel(TIME,VEL,IDX);
% fit_value=MidVel(fit_idx);

fit_idx=find(TIME(IDX)>fitstart*60 & TIME(IDX)<fitend*60);
fit_time=TIME(IDX(fit_idx));
fit_value=VEL(fit_idx);


initTC1=60;
initTC2=300;
stimulusV=10;

if nanmean(fit_value(1:end/2))>nanmean(fit_value(end/2:end))
    fo= fitoptions('Method','NonlinearLeastSquares',...
        'Lower',[0,0,quantile(fit_value,0.1)],'Upper',[stimulusV,Inf,quantile(fit_value,0.9)],...
        'MaxFunEvals',100000,'TolFun',10^-12,...
        'StartPoint',[(max(fit_value)-quantile(fit_value,0.5))/2,initTC1,quantile(fit_value,0.5)]);
    
    ft=fittype(['a*exp(-(x-' num2str(TraceStart*60) ')/b)+c']);
else
    fo= fitoptions('Method','NonlinearLeastSquares',...
        'Lower',[-stimulusV,0],'Upper',[0,Inf],...
        'MaxFunEvals',100000,'TolFun',10^-12,...
        'StartPoint',[(min(fit_value)-quantile(fit_value,0.5))/2,initTC1]);
    
    ft=fittype(['a*exp(-(x-' num2str(TraceStart*60) ')/b)']);
end

[f,gof]=fit(fit_time(:),fit_value(:),ft,fo);%,'StartPoint',[5, 4, 8, 4, 0] );

% output.rsquare=[output.rsquare gof.rsquare];
% parameters=coeffvalues(f);
end