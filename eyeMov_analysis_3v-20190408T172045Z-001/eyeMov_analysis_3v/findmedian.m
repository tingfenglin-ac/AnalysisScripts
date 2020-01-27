function [output]=findmedian(time,value);
for k=1:floor(time(end,1)/0.5);
    temp=[];
for i=1:length(time);
    if ceil(time(i,1)/0.5)==k;
        temp=[temp value(i,1)];
    end
end
output.median(k,1)=median(temp);
output.time(k,1)=(k-0.5)/2;
end

% output.time(isnan(output.median(:,1)),:)=[];
% output.median(isnan(output.median(:,1)),:)=[];
end


