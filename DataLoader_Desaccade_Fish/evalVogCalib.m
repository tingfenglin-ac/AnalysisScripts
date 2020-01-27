function [out]=evalVogCalib(in,coeff)
% in = [vEyeMov, hEyeMov];
% out= [vCal, hCal];

%alpha=coeffright(13,1);
if iscell(coeff)
    
    hCal=feval(coeff{1},in(:,[2,1]));
    vCal=feval(coeff{2},in(:,[2,1]));
else
    
    vEyeMov= in(:,1); hEyeMov=in(:,2);
    
    alpha=coeff(1,3);
    hEyeMov=hEyeMov.*cosd(alpha)+vEyeMov.*sind(alpha);
    vEyeMov=-hEyeMov.*sind(alpha)+vEyeMov.*cosd(alpha);
    hCal=eval2dPoly(hEyeMov,vEyeMov, coeff(:,1));
    vCal=eval2dPoly(hEyeMov,vEyeMov, coeff(:,2));
  
end

  out=[vCal,hCal];
%DO ployval for the three horiz and three vertical calib_line fit a line on the three  to optain the best extimate for each point, use
% the raw coordinate of each of the calib line and the raw coordinate of the actual point
%