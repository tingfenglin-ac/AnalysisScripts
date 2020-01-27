function  [coeff]=estimateVogCalibFR(calibpoint,calibvalue)


% calibpoint(isnan(calibvalue(:,1)),:)=[];
% calibvalue(isnan(calibvalue(:,1)),:)=[];
% coeff = fitgeotrans(calibpoint,calibvalue,'polynomial',2);

alpha=0;
ind=(not(isnan(calibvalue(:,1))) & not(isnan(calibvalue(:,2))));
coeffH = fit2dPolySVD( calibvalue(ind,1), calibvalue(ind,2), calibpoint(ind,1), 3);
coeffV = fit2dPolySVD( calibvalue(ind,1), calibvalue(ind,2), calibpoint(ind,2), 3);

coeff=[coeffH,coeffV,[alpha; zeros(length(coeffV)-1,1)]];
end