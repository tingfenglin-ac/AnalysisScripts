
for k=1:2;
    if k==1;
        deriv=derivate(data.leye_raw,1/40);
        time=data.time_l;
    end
    if k==2;
        deriv=derivate(data.reye_raw,1/40);
        time=data.time_r;
    end
            

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




xscale=[0 20];
yscale=[0 2];
FigHandle = figure('Position', [0,0, 2000, 500]);

protocol=[0 5 25 30 50 60];
protocol_name={'dark' 'OKR' 'Dark' 'OKR' 'Dark'}
for i=2:length(protocol);
    
[v,s]=sorting(time/60,protocol(i-1),protocol(i),deriv,1);
subplot(1,length(protocol)-1,i-1)

vp=v(v>0);
sp=s(v>0);
vn=abs(v(v<0));
sn=s(v<0);
plot(vp,sp,'b');
hold on
plot(vn,sn,'r');

ylabel('Data number ratio (%)','FontSize',16);
xlabel('velocity (deg/sec)','FontSize',16);

xlim(xscale);
%ylim(yscale);
set(gca,'XTick',[min(xlim):(max(xlim)-min(xlim))/4:max(xlim)]);
%ratio and legend
p=round(100*sum(s(v>0))/sum(s));
n=round(100*sum(s(v<0))/sum(s));
my_str=sprintf('(%d:%d)',n,p);
title(protocol_name(i-1));
% text(max(xlim)-(max(ylim)-min(ylim))/6,(max(ylim)-min(ylim))/2+min(ylim),my_str);
end





set(gcf,'Color',[1 1 1]);
end
