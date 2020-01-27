function [value,datasize,vp,sp,vn,sn]=sorting(time,time_min,time_max,data,rise);

% time_temp,data_temp,number,value,datasize
data=data(time>=time_min & time<=time_max);

value=[(-300:300)'];

datasize(1:300,1)=(histcounts(data(data<0),-300.5:-0.5));
datasize(301)=sum(data>=-0.5 & data<=0.5);
datasize(302:601,1)=flip(histcounts(-data(data>0),-300.5:-0.5));

datasize=100*datasize/sum(datasize);

[vp,sp,vn,sn]=SortPN(value,datasize);
end

