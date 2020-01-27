data=ans;

%position
figure
plot(data.time_l,data.leye_raw,'k');
hold on
plot(data.time_r,data.reye_raw,'b');
plot(data.time_r,data.bodyP_r,'r');
plot([0:0.01:360],-cos([0:0.001:36]*2*pi),'k');

%position
figure
subplot(3,1,1)
plot([0:0.01:10],-20*cos([0:0.001:1]*2*pi)+40,'r','LineWidth',2);
hold on;
for i=1:36
    plot(data.time_l(min(find(data.time_l>(i-1)*10)):max(find(data.time_l<=i*10)))-(i-1)*10,data.leye_raw(min(find(data.time_l>(i-1)*10)):max(find(data.time_l<=i*10))));
end
title('l eye');

subplot(3,1,2)
plot([0:0.01:10],20*cos([0:0.001:1]*2*pi)+50,'r','LineWidth',2);
hold on;
for i=1:36
    plot(data.time_r(min(find(data.time_r>(i-1)*10)):max(find(data.time_r<=i*10)))-(i-1)*10,data.reye_raw(min(find(data.time_r>(i-1)*10)):max(find(data.time_r<=i*10))));
end
title('r eye');

subplot(3,1,3)
for i=1:36
    plot(data.time_l(min(find(data.time_l>(i-1)*10)):max(find(data.time_l<=i*10)))-(i-1)*10,data.bodyP_l(min(find(data.time_l>(i-1)*10)):max(find(data.time_l<=i*10))));
    hold on
end
title('body');



%velocity
data.leye_v=derivate(data.leye_raw,1/40);
data.reye_v=derivate(data.reye_raw,1/40);
data.body_v=derivate(data.bodyP_l,1/40);
figure
subplot(3,1,1)
plot([0:0.01:10],20*sin([0:0.001:1]*2*pi),'r','LineWidth',2);
hold on;
for i=1:36
    plot(data.time_l(min(find(data.time_l>(i-1)*10)):max(find(data.time_l<=i*10)))-(i-1)*10,data.leye_v(min(find(data.time_l>(i-1)*10)):max(find(data.time_l<=i*10))));
end
title('l eye');

subplot(3,1,2)
plot([0:0.01:10],-20*sin([0:0.001:1]*2*pi),'r','LineWidth',2);
hold on;
for i=1:36
    plot(data.time_r(min(find(data.time_r>(i-1)*10)):max(find(data.time_r<=i*10)))-(i-1)*10,data.reye_v(min(find(data.time_r>(i-1)*10)):max(find(data.time_r<=i*10))));
end
title('r eye');

subplot(3,1,3)
for i=1:36
    plot(data.time_l(min(find(data.time_l>(i-1)*10)):max(find(data.time_l<=i*10)))-(i-1)*10,data.body_v(min(find(data.time_l>(i-1)*10)):max(find(data.time_l<=i*10))));
    hold on
end
title('body');