function  [coeff]=estimateVogCalibGB(calibpoint,calibvalue)

%ind=[1 7; 2 6; 3 5; 8 10; 11 13];
%ind_pair=[1 7; 2 6; 3 5; [1 7; 2 6; 3 5;]+7; [1 7; 2 6; 3 5;]+14];
   
L=length(calibpoint)/3;
ind_pair=[];
for ij=1:L
    ind_pair=[ind_pair; ij ij+L; ij ij+2*L; ij+L ij+2*L];
end
kk=0;
for i=1:length(ind_pair)
    if not(isnan(calibvalue(ind_pair(i,1)))) &&  not(isnan(calibvalue(ind_pair(i,2))))
        kk=kk+1;
        %I add a minus because the rot was wrong, check and try other ways.
        alpha(kk)=-atand((calibvalue(ind_pair(i,1),1)-calibvalue(ind_pair(i,2),1))/(calibvalue(ind_pair(i,1),2)-calibvalue(ind_pair(i,2),2)));
    end
end

alpha=median(alpha);


calibvalue(:,1)=calibvalue(:,1).*cosd(alpha)+calibvalue(:,2).*sind(alpha);
calibvalue(:,2)=-calibvalue(:,1).*sind(alpha)+calibvalue(:,2).*cosd(alpha);


ind=(not(isnan(calibvalue(:,1))) & not(isnan(calibvalue(:,2))));
coeffH = fit2dPolySVD( calibvalue(ind,1), calibvalue(ind,2), calibpoint(ind,1), 4);
coeffV = fit2dPolySVD( calibvalue(ind,1), calibvalue(ind,2), calibpoint(ind,2), 4);

coeff=[coeffH coeffV [alpha;  zeros(length(coeffV)-1,1)]];
end