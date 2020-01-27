function [value,datasize]=sorting(time,time_min,time_max,data,rise);

% time_temp,data_temp,number,value,datasize

time_temp=time(time>=time_min & time<=time_max);
data_temp=data(time>=time_min & time<=time_max);

number=ceil(max(data_temp)/rise)+ceil(abs(min(data_temp)/rise));
n1=0+floor(min(data_temp)/rise)*rise;
value=n1-0.5*rise+(1:number)'*rise;

sort(data_temp);
datasize=[];
for i=1:number;
datasize=[datasize; 100*length(data_temp(data_temp>((i-1)*rise+n1) & data_temp<=i*rise+n1))/length(data_temp)];
end


end