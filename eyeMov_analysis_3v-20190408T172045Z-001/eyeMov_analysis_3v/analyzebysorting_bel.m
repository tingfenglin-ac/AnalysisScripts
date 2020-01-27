% data=ans
%for stationary grating data
for k=1:2;
    if k==1;
        deriv=derivate(data.leye_raw,1/40);
    end
    if k==2;
        deriv=derivate(data.reye_raw,1/40);
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

%dark_1
xscale=[-20 20];
figure
i=1;
[v,s]=sorting(data.time_r/60,(i-1)*5,i*5,deriv,1);
subplot(9,1,1)
area(v,s,'FaceColor','k');
xlim(xscale);
set(gca,'XTick',[min(xlim):(max(xlim)-min(xlim))/4:max(xlim)]);
%ratio and legend
p=round(100*sum(s(v>0))/sum(s));
n=round(100*sum(s(v<0))/sum(s));
my_str=sprintf('(%d:%d)',n,p);
text(max(xlim)-(max(ylim)-min(ylim))/6,(max(ylim)-min(ylim))/2+min(ylim),my_str);




%stationary_1
for i=1:4;
    n=i+1;
[v,s]=sorting(data.time_r/60,(n-1)*5,n*5,deriv,1);
subplot(9,1,2)
hold on
color=[0 0 0;0.2 0.2 0.2;0.4 0.4 0.4;0.6 0.6 0.6];
plot(v,s,'Color',color(i,:));
xlim(xscale);
set(gca,'XTick',[min(xlim):(max(xlim)-min(xlim))/4:max(xlim)]);
%ratio and legend
p=round(100*sum(s(v>0))/sum(s));
n=round(100*sum(s(v<0))/sum(s));
my_str=sprintf('(%d:%d)',n,p);
text(max(xlim)-(max(ylim)-min(ylim))/6,(5-i)*(max(ylim)-min(ylim))/4+min(ylim),my_str);
end


%dark_2
i=6;
[v,s]=sorting(data.time_r/60,(i-1)*5,i*5,deriv,1);
subplot(9,1,3)
area(v,s,'FaceColor','k');
xlim(xscale);
set(gca,'XTick',[min(xlim):(max(xlim)-min(xlim))/4:max(xlim)]);
%ratio and legend
p=round(100*sum(s(v>0))/sum(s));
n=round(100*sum(s(v<0))/sum(s));
my_str=sprintf('(%d:%d)',n,p);
text(max(xlim)-(max(ylim)-min(ylim))/6,(max(ylim)-min(ylim))/2+min(ylim),my_str);


%stationary_2
for i=1:4;
    n=i+6;
[v,s]=sorting(data.time_r/60,(n-1)*5,n*5,deriv,1);
subplot(9,1,4)
hold on
color=[0 0 0;0.2 0.2 0.2;0.4 0.4 0.4;0.6 0.6 0.6];
plot(v,s,'Color',color(i,:));
xlim(xscale);
set(gca,'XTick',[min(xlim):(max(xlim)-min(xlim))/4:max(xlim)]);
%ratio and legend
p=round(100*sum(s(v>0))/sum(s));
n=round(100*sum(s(v<0))/sum(s));
my_str=sprintf('(%d:%d)',n,p);
text(max(xlim)-(max(ylim)-min(ylim))/6,(5-i)*(max(ylim)-min(ylim))/4+min(ylim),my_str);
end


%dark_3
i=11;
[v,s]=sorting(data.time_r/60,(i-1)*5,i*5,deriv,1);
subplot(9,1,5)
area(v,s,'FaceColor','k');
xlim(xscale);
set(gca,'XTick',[min(xlim):(max(xlim)-min(xlim))/4:max(xlim)]);
%ratio and legend
p=round(100*sum(s(v>0))/sum(s));
n=round(100*sum(s(v<0))/sum(s));
my_str=sprintf('(%d:%d)',n,p);
text(max(xlim)-(max(ylim)-min(ylim))/6,(max(ylim)-min(ylim))/2+min(ylim),my_str);


%stationary_3
for i=1:4;
    n=i+12;
[v,s]=sorting(data.time_r/60,(n-1)*5,n*5,deriv,1);
subplot(9,1,6)
hold on
color=[0 0 0;0.2 0.2 0.2;0.4 0.4 0.4;0.6 0.6 0.6];
plot(v,s,'Color',color(i,:));
xlim(xscale);
set(gca,'XTick',[min(xlim):(max(xlim)-min(xlim))/4:max(xlim)]);
%ratio and legend
p=round(100*sum(s(v>0))/sum(s));
n=round(100*sum(s(v<0))/sum(s));
my_str=sprintf('(%d:%d)',n,p);
text(max(xlim)-(max(ylim)-min(ylim))/6,(5-i)*(max(ylim)-min(ylim))/4+min(ylim),my_str);
end


%dark_4
i=17;
[v,s]=sorting(data.time_r/60,(i-1)*5,i*5,deriv,1);
subplot(9,1,7)
area(v,s,'FaceColor','k');
xlim(xscale);
set(gca,'XTick',[min(xlim):(max(xlim)-min(xlim))/4:max(xlim)]);
%ratio and legend
p=round(100*sum(s(v>0))/sum(s));
n=round(100*sum(s(v<0))/sum(s));
my_str=sprintf('(%d:%d)',n,p);
text(max(xlim)-(max(ylim)-min(ylim))/6,(max(ylim)-min(ylim))/2+min(ylim),my_str);

%stationary_4
for i=1:4;
    n=i+17;
[v,s]=sorting(data.time_r/60,(n-1)*5,n*5,deriv,1);
subplot(9,1,8)
hold on
color=[0 0 0;0.2 0.2 0.2;0.4 0.4 0.4;0.6 0.6 0.6];
plot(v,s,'Color',color(i,:));
xlim(xscale);
set(gca,'XTick',[min(xlim):(max(xlim)-min(xlim))/4:max(xlim)]);
%ratio and legend
p=round(100*sum(s(v>0))/sum(s));
n=round(100*sum(s(v<0))/sum(s));
my_str=sprintf('(%d:%d)',n,p);
text(max(xlim)-(max(ylim)-min(ylim))/6,(5-i)*(max(ylim)-min(ylim))/4+min(ylim),my_str);
end


%dark_5
i=22;
[v,s]=sorting(data.time_r/60,(i-1)*5,i*5,deriv,1);
subplot(9,1,9)
area(v,s,'FaceColor','k');
xlim(xscale);
set(gca,'XTick',[min(xlim):(max(xlim)-min(xlim))/4:max(xlim)]);
%ratio and legend
p=round(100*sum(s(v>0))/sum(s));
n=round(100*sum(s(v<0))/sum(s));
my_str=sprintf('(%d:%d)',n,p);
text(max(xlim)-(max(ylim)-min(ylim))/6,(max(ylim)-min(ylim))/2+min(ylim),my_str);


set(gcf,'Color',[1 1 1]);
end
