function [output]=fit2exp(output,time,value,start_time,end_time,okanstart_time,okanend_time)
%Analysis at first time, it should be uncommend 
if isempty(output)
    
    output.rsquare=[];
    output.a=[];
    output.b=[];
    output.c=[];
    output.d=[];
    output.e=[];
    output.fit_time=[];
    output.fit_value=[];
    output.fit_okr_exp1st=[];
    output.fit_okr_exp2nd=[];
    output.okr_adapt1st=[];
    output.okr_adapt2nd=[];
    
    
    
    output.okanrsquare=[];
    output.f=[];
    output.g=[];
    output.h=[];
    output.m=[];
    output.n=[];
    output.fit_time_okan=[];
    output.fit_value_okan=[];
    output.okanamp=[];
end


fit_time=[];
fit_value=[];
for i=1:length(time)
if time(i,1)>start_time && time(i,1)<end_time;
    fit_time=[fit_time time(i,1)];
    fit_value=[fit_value value(i,1)];
end
end
fit_time=fit_time-fit_time(1);
initTC1=1;
initTC2=10;

fo= fitoptions('Method','NonlinearLeastSquares',...
               'Lower',[0,0,0,0,quantile(fit_value,0.1)],'Upper',[Inf,Inf,inf,100,quantile(fit_value,0.9)],...
               'MaxFunEvals',100000,'TolFun',10^-12,...
           'StartPoint',[(max(fit_value)-quantile(fit_value,0.5))/2,initTC1,(max(fit_value)-quantile(fit_value,0.5))/2,initTC2,quantile(fit_value,0.5)]);
           
ft=fittype('a*exp(-x/b) + c*exp(-x/d)+e');

[f,gof]=fit(fit_time(:),fit_value(:),ft,fo);%,'StartPoint',[5, 4, 8, 4, 0] );

output.rsquare=[output.rsquare gof.rsquare];
parameters=coeffvalues(f);

%a b c d e


if parameters(1,2)>parameters(1,4);
    parameters(1,[3,4,1,2,5])=parameters(1,1:5);
end
    

output.a=[output.a parameters(1,1)];
output.b=[output.b parameters(1,2)];

output.c=[output.c parameters(1,3)];
output.d=[output.d parameters(1,4)];

output.e=[output.e parameters(1,5)];

    


output.fit_time{1,length(output.fit_time)+1}=(start_time:0.0041:end_time)';
tFit=start_time:0.0041:end_time;
output.fit_value{1,length(output.fit_value)+1}=f(tFit-tFit(1));

fit_okr_exp1st=((parameters(1,1))*exp(-(tFit-tFit(1))/parameters(1,2))+parameters(1,5))';
fit_okr_exp2nd=((parameters(1,3))*exp(-(tFit-tFit(1))/parameters(1,4))+parameters(1,5))';
output.fit_okr_exp1st{1,length(output.fit_okr_exp1st)+1}=fit_okr_exp1st;
output.fit_okr_exp2nd{1,length(output.fit_okr_exp2nd)+1}=fit_okr_exp2nd;

OKR_hight=parameters(1,1)+parameters(1,3)+parameters(1,5);
okr_adapt1st=(fit_okr_exp1st(1)-fit_okr_exp1st(end))/(OKR_hight);
output.okr_adapt1st=[output.okr_adapt1st okr_adapt1st];
okr_adapt2nd=(fit_okr_exp2nd(1)-fit_okr_exp2nd(end))/(OKR_hight);
output.okr_adapt2nd=[output.okr_adapt2nd okr_adapt2nd];




%OKAN exp
%Analysis at first time, it should be uncommend 


fit_time=[];
fit_value=[];
for i=1:length(time);
%     && time(i,1)<okanend_time
if time(i,1)>okanstart_time ;
    fit_time=[fit_time time(i,1)];
    fit_value=[fit_value value(i,1)];
end
end
fit_time=fit_time-fit_time(1)+0.5;

initTC1=1;
initTC2=10;

fo= fitoptions('Method','NonlinearLeastSquares',...
               'Lower',[0,0,0,0,quantile(fit_value,0.1)],'Upper',[Inf,100,inf,100,quantile(fit_value,0.9)],...
               'MaxFunEvals',100000,'TolFun',10^-12,...
           'StartPoint',[(max(fit_value)-quantile(fit_value,0.5))/2,initTC1,(max(fit_value)-quantile(fit_value,0.5))/2,initTC2,0]);
           
ft=fittype('-f*exp(-x/g)-h*exp(-x/m)+n');


[fokan,gof]=fit(fit_time(:),fit_value(:),ft,fo);%,'StartPoint',[5, 4, 8, 4, 0] );

output.okanrsquare=[output.okanrsquare gof.rsquare];
parameters=coeffvalues(fokan);

%a b c d e
output.f=[output.f parameters(1,1)];
output.g=[output.g parameters(1,2)];
output.h=[output.h parameters(1,3)];
output.m=[output.m parameters(1,4)];
output.n=[output.n parameters(1,5)];

tFit_okan=okanstart_time-0.5:0.0041:okanend_time;
output.fit_time_okan{1,length(output.fit_time_okan)+1}=tFit_okan';
output.fit_value_okan{1,length(output.fit_value_okan)+1}=fokan(tFit_okan-tFit_okan(1));
output.okanamp=[output.okanamp parameters(1,1)/(OKR_hight)];











plot(tFit',f(tFit-tFit(1))',tFit',fit_okr_exp1st,tFit',fit_okr_exp2nd,time,value,'ro',tFit_okan',fokan(tFit_okan-tFit_okan(1))');
legend('okrfit','expab','exp2cd','raw','okanfit');

end


