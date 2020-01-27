function [BinMeanVel,time]=BinVel(TIME,VEL,IDX,bin);
lowBound=0:bin:bin*floor(TIME(end)/bin);
highBound=0+bin:bin:bin*ceil(TIME(end)/bin);
lowBoundmat=repmat(lowBound,length(IDX),1);
highBoundmat=repmat(highBound,length(IDX),1);
TIME=TIME(IDX);
TIMEmat=repmat(TIME,1,length(lowBound));
VELmat=repmat(VEL,1,length(lowBound));

VELmat(TIMEmat<lowBoundmat)=nan;
VELmat(TIMEmat>highBoundmat)=nan;

BinMeanVel=nanmean(VELmat)';
time=lowBound'+0.5*bin;
end