[init_time,chair_acc]=find_chair_accel(Data(i).chair_vel(:,3),60);
[end_time,chair_acc]=find_chair_accel(Data(i).chair_vel(:,3),60);
end_time=round(end_time);
if length(Data(i).reye_vel)-end_time>30000
t3=(end_time+30000)/1000;
t2=end_time/1000;
t1=init_time/1000;
else
t3=(length(Data(i).reye_vel)-200)/1000;
t2=end_time/1000;
t1=init_time/1000;
end
time1=t1:0.001:t2-20;
time2=t2:0.001:t3;
vel_des = JL_desaccader(Data(i).reye_vel(:,2),-200:2:200,2);
close all
figure
[R, res] = JL_fit_exp(time1, vel_des(t1*1000:(t2-20)*1000), t1,t2-20,[NaN 10 10 0 0],1);
figure
[R2, res] = JL_fit_exp(time2, vel_des(t2*1000:t3*1000), t2,t3,[NaN 10 10 0 0],1);
