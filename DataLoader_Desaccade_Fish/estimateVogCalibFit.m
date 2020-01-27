function  [coeff]=estimateVogCalibFit(calibpoint,calibvalue,type)


idx=sum(isnan(calibvalue),2)>0;
fitobjectH=fit(calibvalue(~idx,:),calibpoint(~idx,1),type);

fitobjectV=fit(calibvalue(~idx,:),calibpoint(~idx,2),type);

coeff={fitobjectH,fitobjectV};

end