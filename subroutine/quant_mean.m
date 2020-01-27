function [Pmean,Nmean,Pquant,Nquant]=quant_mean(time,time_min,time_max,data,quant_percent);

time_temp=time(time>=time_min & time<=time_max);
data_temp=data(time>=time_min & time<=time_max);

Pdata=data_temp(data_temp>0);
Ndata=data_temp(data_temp<0);


Pmean=nanmean(Pdata);
Nmean=nanmean(Ndata);

Pquant=[];
Nquant=[];
if exist('quant_percent')
Pquant=quantile(Pdata,quant_percent/100);
Nquant=quantile(Ndata,quant_percent/100);
end


end