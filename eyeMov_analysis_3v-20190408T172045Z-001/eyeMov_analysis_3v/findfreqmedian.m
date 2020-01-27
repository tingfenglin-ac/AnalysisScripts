function [output]=findfreqmedian(time,time_of_otherdirection,value);
endtime=max([time;time_of_otherdirection]);
for k=1:floor(endtime/0.5);
    temp=[];
for i=1:length(time);
    if ceil(time(i,1)/0.5)==k;
        temp=[temp value(i,1)];
    end
end
output.median(k,1)=median(temp);
output.time(k,1)=(k-0.5)/2;
end

output.median(isnan(output.median(:,1)),:)=0;
end


