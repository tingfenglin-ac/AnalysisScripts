

function [output]=medianpermin(time,value);
for k=1:floor(max(time))/0.5;
    tempvalue=[];
for i=1:length(value);
    if ceil((time(i,1))/0.5)==k;
        tempvalue=[tempvalue value(i,1)];
    end
end
output(k,1)=median(tempvalue);
end
end