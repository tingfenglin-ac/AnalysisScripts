%data=ans;

figure
subplot(2,1,1)
plot(data.time_l/60,derivate(data.leye_raw,1/40),'k');

hold on 
ylebel=180;
plot([0 5],[ylebel ylebel],'k');
plot([5 25],[ylebel ylebel],'k:');
plot([25 30],[ylebel ylebel],'k');
plot([30 50],[ylebel ylebel],'k:');
plot([50 60],[ylebel ylebel],'k');
% plot([60 80],[ylebel ylebel],'k:');
% plot([80 85],[ylebel ylebel],'k');
% plot([85 105],[ylebel ylebel],'k:');
% plot([105 115],[ylebel ylebel],'k');

subplot(2,1,2)
plot(data.time_l/60,data.leye_raw,'k');

figure
subplot(2,1,1)
plot(data.time_r/60,derivate(data.reye_raw,1/40),'k');

hold on 
ylebel=180;
plot([0 5],[ylebel ylebel],'k');
plot([5 25],[ylebel ylebel],'k:');
plot([25 30],[ylebel ylebel],'k');
plot([30 50],[ylebel ylebel],'k:');
plot([50 60],[ylebel ylebel],'k');
% plot([60 80],[ylebel ylebel],'k:');
% plot([80 85],[ylebel ylebel],'k');
% plot([85 105],[ylebel ylebel],'k:');
% plot([105 115],[ylebel ylebel],'k');

subplot(2,1,2)
plot(data.time_r/60,data.reye_raw,'k');

