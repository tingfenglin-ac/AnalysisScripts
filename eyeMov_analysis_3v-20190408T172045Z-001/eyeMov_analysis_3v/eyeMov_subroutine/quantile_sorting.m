function [mid]=quantile_sorting(datasize,percent)
half=sum(datasize)*percent/100
ABaccum=abs(cumsum(datasize)-half);
mid=find(ABaccum==min(ABaccum));