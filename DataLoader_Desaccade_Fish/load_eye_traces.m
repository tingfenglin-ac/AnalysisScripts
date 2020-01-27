function R = load_eye_traces(filename,gainfile,t1,t2)
% filename is the filename of the data file
% gainfile is the calibration file 

if(nargin < 3), t1 = [] ; end
if(nargin < 4), t2 = [] ; end

figure(1)
[time,Chair,Wheel] = load_data(filename,gainfile,1) ;

[t1,chair_acc]=find_chair_accel(gradient((Chair(:,1)+Chair(:,3))',1/1000),90);
[t2,chair_acc]=find_chair_accel(gradient((Chair(:,1)+Chair(:,3))',1/1000),90);
t1=round(t1);t2=round(t2);
% Take an interval from -2 s to + 60 s after motion onset
 I = -2000:90000 ;
 c2 = gradient((Chair(:,1)+Chair(:,3))',1/1000) ;
 c2(abs(c2) > 500) = NaN ;
 c2 = interp1(time(not(isnan(c2))),c2(not(isnan(c2))),time,'nearest') ;
 [b,a] = butter(2,5/1000) ;
 c2 = filter(b,a,c2) ;
% 
% if(isempty(t1))
%     t1 = find(abs(c2(2:end)) > 20 & abs(c2(1:end-1)) <= 20,1,'first') ;
% end
% if(isempty(t2))
%     t2 = find(abs(c2(2:end)) < 20 & abs(c2(1:end-1)) >= 20,1,'first') ;
% end
if(isempty(t1)), error('Could not find t1 !'); end
if(isempty(t2)), error('Could not find t2 !'); end

R(1).addr = addr ;
R(1).t0 = t1 ;
R(1).omega = round(eNaN(@median,c2(t1 + [5000:30000]),2)) ;
R(1).time = I(2:10:end)/1000;
% if (0 < min(I)+t1)
%    R(1).Vel = JL_Resample(Vel(t1 + I,1),10) ;
% else
%    R(1).Vel = Vel(1:t1+max(I),1) ; 
%    R(1).Vel = [ones(length(I)-length(R(1).Vel)-1,1)*NaN; R(1).Vel ] ;
%    R(1).Vel = JL_Resample(R(1).Vel,10) ;
% end
if (0 < min(I)+t1)
   R(1).Wheel = JL_Resample(Wheel(t1 + I,1),10) ;
else
   R(1).Wheel = Wheel(1:t1+max(I),1) ; 
   R(1).Wheel = [ones(length(I)-length(R(1).Wheel)-1,1)*NaN; R(1).Wheel ] ;
   R(1).Wheel = JL_Resample(R(1).Wheel,10) ;
end


R(1).type = 1 ; % Rotatory
R(1).fix = 0 ;

if (t2-t1) < max(I)
%    R(1).Vel(round((t2-t1)/10):end) = NaN ; 
   R(1).Wheel(round((t2-t1)/10):end) = NaN ; 
end

R(2).addr = addr ;
R(2).t0 = t2 ;
R(2).omega = round(eNaN(@median,c2(t1 + [5000:30000]),2)) ;
R(2).time = I(2:10:end)/1000;
% if (length(Vel) > max(I)+t2)
%    R(2).Vel = JL_Resample(Vel(t2 + I,1),10) ;
% else
%    R(2).Vel = Vel(t2+min(I):end,1) ; 
%    R(2).Vel = [R(2).Vel ; ones(length(I)-length(R(2).Vel)-1,1)*NaN] ;
%    R(2).Vel = JL_Resample(R(2).Vel,10) ;
% end
if (length(Wheel) > max(I)+t2)
   R(2).Wheel = JL_Resample(Wheel(t2 + I,1),10) ;
else
   R(2).Wheel = Wheel(t2+min(I):end,1) ; 
   R(2).Wheel = [R(2).Wheel ; ones(length(I)-length(R(2).Wheel)-1,1)*NaN] ;
   R(2).Wheel = JL_Resample(R(2).Wheel,10) ;
end

R(2).type = 2 ;
R(2).fix = 0 ;
figure(2)
% subplot(211)
% plot(R(1).time, [R.Vel])
% subplot(212)
plot(R(1).time, [R.Wheel])
