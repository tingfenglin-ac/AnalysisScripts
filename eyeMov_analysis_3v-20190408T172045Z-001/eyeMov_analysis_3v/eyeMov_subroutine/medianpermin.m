

function [output]=medianpermin(time,value);
time=time/60;
bin=0.5%median of every half minute
for k=1:floor(max(time))/bin;
    tempvalue=[];
for i=1:length(value);
    if ceil((time(i,1))/0.5)==k;
        tempvalue=[tempvalue value(i,1)];
    end
end
output(k,1)=k*bin-bin/2;%output time
output(k,2)=median(tempvalue);%output median
end
end