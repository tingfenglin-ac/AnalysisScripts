function [idx,chair_acc]=find_chair_accel(chair_vel,speed)
% bgindex=500;
[val,id]=max(abs(chair_vel));
sign_chair=-sign(chair_vel(id));
if sign_chair>0
indices=find(chair_vel<-100);
chair_vel(indices)=speed; % Delete the step in position at the end of each 360° rotations
else
indices=find(chair_vel>100);
chair_vel(indices)=-speed; % Delete the step in position at the end of each 360° rotations
end   

chair_vel=remezfilt(chair_vel,0.5,3,1000);
figure;
plot(chair_vel)
set(gcf,'CurrentCharacter','c')
title('Zoom to the initial or the last part of the stimulus, than hit a button to end zooming and start the selection')
zoom on
while ~waitforbuttonpress
end
zoom off
title ('Click on the stimulus initial/final point (at the begining/end of acceleration phase)')
[idx,nothing]=ginput(1);
idx=round(idx);
chair_acc=sign_chair*90;


% acc = diff(chair_vel*1000);
% acc=acc(500:end-500);
% idx=find(acc>0.9*max(acc))+2*bgindex;
% if idx(end)-idx(1)>1000
%     idx=round((idx(end)-idx(1))/2)-500+idx(1):1:round((idx(end)-idx(1))/2)+500+idx(1);
% end

% med=median(chair_vel(round((idx(end)-idx(1))/2)-round((idx(end)-idx(1))/10):round((idx(end)-idx(1))/2)+round((idx(end)-idx(1))/10)));
% idx=find(chair_vel>med);