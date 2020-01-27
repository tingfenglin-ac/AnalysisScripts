data=ans;
data.Velocity.SaccExtremeIdx=data.SaccExtremeIdxL;
data.Velocity.eye_raw=data.leye_raw;
data.Velocity.time=data.time_l;


data.Velocity.dydt = diff(data.Velocity.eye_raw(:))./diff(data.Velocity.time(:));


data.Velocity.SaccExtremeIdx(isnan(data.Velocity.SaccExtremeIdx(:,1)),:)=[];
data.Velocity.velocity=[];
for i=1:length(data.Velocity.SaccExtremeIdx)-1
velocity=(data.Velocity.dydt(data.Velocity.SaccExtremeIdx(i,2):data.Velocity.SaccExtremeIdx(i,2)+ceil((data.Velocity.SaccExtremeIdx(i+1,1)-data.Velocity.SaccExtremeIdx(i,2))/10),1)');
data.Velocity.velocity=[data.Velocity.velocity;median(velocity)];
end

data.Velocity.velocity_time=data.Velocity.time(data.Velocity.SaccExtremeIdx(1:end-1,1))/60;
data.Velocity.velocity_lowess=malowess(data.Velocity.time(data.Velocity.SaccExtremeIdx(1:end-1,1))/60,data.Velocity.velocity(:));

scatter(data.Velocity.velocity_time,data.Velocity.velocity,'B');
hold on
plot(data.Velocity.velocity_time,data.Velocity.velocity_lowess,'R');
hold on
plot(0:0.1:data.Velocity.velocity_time(end,1),0,'k');

%median of every min
for k=1:floor((data.Velocity.time(data.Velocity.SaccExtremeIdx(end,2)))/60);
    velocity=[];
for i=1:length(data.Velocity.SaccExtremeIdx)-1;
    if ceil((data.Velocity.time(data.Velocity.SaccExtremeIdx(i,2)))/60)==k;
        velocity=[velocity data.Velocity.velocity(i,1)];
    end
end
data.Velocity.velocity_everymin(k,1)=median(velocity);
end