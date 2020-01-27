%range means you will get the median velocity of first ? second 
%Idx(:,1)=begining of slow phase
%Idx(:,2)=end of slow phase

function [output]=velocity(raw,time,Idx,range);
dydt = derivate(raw,1/40);
output=[];
if size(Idx)==0
    output=[];
else
for i=1:length(Idx(:,1))
velocity=dydt(Idx(i,1):max(find(time<=time(Idx(i,1))+range)));
output=[output;median(velocity)];
end
end