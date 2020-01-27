deriv=derivate(data.reye_raw,1/40);
dydt = diff(data.reye_raw(:))./diff(data.time_l(:));

light_t1=5;
dark_t1=25;
light_t2=30;
dark_t2=50;
rec_end=60;

%for stationary grating data
solidline_t1=0:light_t1;
solidline1=ones(1,length(solidline_t1))*30;
dashline_t1=light_t1:dark_t1;
dashline1=ones(1,length(dashline_t1))*30;

solidline_t2=dark_t1:light_t2;
solidline2=ones(1,length(solidline_t2))*30;
dashline_t2=light_t2:dark_t2;
dashline2=ones(1,length(dashline_t2))*30;

solidline_t3=dark_t2:rec_end;
solidline3=ones(1,length(solidline_t3))*30;


figure
for i=1:12
    [v,s]=sorting(data.time_r/60,(i-1)*5,i*5,deriv,1);
    subplot(6,2,i)
    color=[0 0 0;0.5 0.5 0.5;0.5 0.5 0.5;0.5 0.5 0.5;0.5 0.5 0.5;0 0 0;0.5 0.5 0.5;0.5 0.5 0.5;0.5 0.5 0.5;0.5 0.5 0.5;0 0 0;0 0 0];
    area(v,s,'FaceColor',color(i,:));
    xlim([-30 30]);
    %ylim([0 4000]);
    set(gca,'XTick',[min(xlim):(max(xlim)-min(xlim))/4:max(xlim)]);
    
    %ratio and legend
    p=round(100*sum(s(v>0))/sum(s));
    n=round(100*sum(s(v<0))/sum(s));
    pn_ratio(i,1)=p;
    pn_ratio(i,2)=n;
    my_str=sprintf('(%d:%d)',n,p);
    text(20,(max(ylim)-min(ylim))/2+min(ylim),my_str);
end
set(gcf,'Color',[1 1 1]);

%position
figure
plot(data.time_r/60,data.reye_raw,'k');
hold on
plot(solidline_t1,solidline1,'k-');
plot(dashline_t1,dashline1,'k:');
plot(solidline_t2,solidline2,'k-');
plot(dashline_t2,dashline2,'k:');
plot(solidline_t3,solidline3,'k-');

ylim([-30 35]);
set(gcf,'Color',[1 1 1]);

%velocity
figure
plot(data.time_r/60,deriv,'k');
hold on
plot(solidline_t1,solidline1,'k-');
plot(dashline_t1,dashline1,'k:');
plot(solidline_t2,solidline2,'k-');
plot(dashline_t2,dashline2,'k:');
plot(solidline_t3,solidline3,'k-');


set(gcf,'Color',[1 1 1]);
