function [hCal,vCal]=evalVogCalibGB(hEyeMov,vEyeMov,coeff)
%alpha=coeffright(13,1);
alpha=coeff(1,3);
hEyeMov=hEyeMov.*cosd(alpha)+vEyeMov.*sind(alpha);
vEyeMov=-hEyeMov.*sind(alpha)+vEyeMov.*cosd(alpha);
hCal=eval2dPoly(hEyeMov,vEyeMov, coeff(:,1));
vCal=eval2dPoly(hEyeMov,vEyeMov, coeff(:,2));
end
%DO ployval for the three horiz and three vertical calib_line fit a line on the three  to optain the best extimate for each point, use
% the raw coordinate of each of the calib line and the raw coordinate of the actual point
%