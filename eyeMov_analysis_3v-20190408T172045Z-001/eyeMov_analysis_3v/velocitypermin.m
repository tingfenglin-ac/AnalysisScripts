function [output]=findmedian(time,index,value);
for k=1:floor(time(index(end,1)));
    temp=[];
for i=1:length(index);
    if ceil(time(index(i,1)))==k;
        temp=[temp value(i,1)];
    end
end
output(k,1)=median(temp);
end
end