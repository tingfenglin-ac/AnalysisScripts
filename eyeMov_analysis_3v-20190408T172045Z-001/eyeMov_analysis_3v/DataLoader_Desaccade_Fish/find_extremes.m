function [startidx,endidx]=find_extremes(chair_vel,speed,smpf,qst, acc)
if nargin<5
    acc=90;
end
if nargin<4
    qst=0;
end


%qst: flag to have question.. unesuful if you the check again this point on
%the trace of the eye

%Determine constant velocity period of the chair andgive the index of start
%and stop of the chair
%note: input the vel as the derivative of a low pass filtered position
chair_vel=firfilt(chair_vel,.5,5,smpf);
chair_vel=abs(chair_vel);
indices=find(chair_vel>100);
chair_vel(indices)=speed; % Delete the step in position at the end of each 360° rotations

idx=find(chair_vel>speed/2);
med=median(chair_vel(round((idx(end)-idx(1))/2)-round((idx(end)-idx(1))/10):round((idx(end)-idx(1))/2)+round((idx(end)-idx(1))/10)));
idx=find(chair_vel>med);
idx=round(idx);

    
    startidx=idx(1);
    endidx=idx(end)+smpf*1.1*(speed/acc); %time to completely brake +10% for delay, infintite jerk approx.. 10% is good for 90 deg/s^2

    if qst==1
    out=0;
 while out==0 
    figure(1000)  
    plot(chair_vel)
    hold on
    plot(startidx,chair_vel(startidx),'r*')
    answer=questdlg('Is the right onset point?','Select chiar mov onset','Yes','No','No');
    if strcmp(answer,'Yes')
        out=1;
    else 
        zoom on
        while ~waitforbuttonpress
            pause(0.1)
        end
        temp=round(ginput(1));
        startidx=round(temp(1));
    end
    close 1000
end

out=0;
    
    endidx=idx(end);
 while out==0
    figure(1000)
    plot(chair_vel)
    hold on
    plot(endidx,chair_vel(endidx),'r*')
    answer=questdlg('Is the right stop point?','Select chiar mov stop','Yes','No','No');    
    if strcmp(answer,'Yes')
        out=1;
    else 
        while ~waitforbuttonpress
            pause(0.1)
        end
        temp=round(ginput(1));
        endidx=round(temp(1));
    end
    close 1000
 end
end



