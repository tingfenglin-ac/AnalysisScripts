function [slop]=slop_v(time,raw,Idx,fit_l);
% fit_l=how many second after the start of slow phase would like to fit


for i=1:length(Idx(:,1))-1
y=raw(Idx(i,2):(Idx(i+1,1)));
x=time(Idx(i,2):(Idx(i+1,1)));
if max(x)-min(x)>fit_l

    x=x(find(x-min(x)<=1));
    y=y(find(x-min(x)<=1));
end
XX = [ones(length(x),1) x];
b = XX\y;
slop(i,1)=b(2);
reg_time(i,1)={x};
reg_line(i,1)={XX*b};
end