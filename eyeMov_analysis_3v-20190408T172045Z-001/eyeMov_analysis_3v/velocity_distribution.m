
for k=1:2;
    if k==1;
        deriv=derivate(data.leye_raw,1/40);
        time=data.time_l;
    end
    if k==2;
        deriv=derivate(data.reye_raw,1/40);
        time=data.time_r;
    end
            

%if protocol is WT protocol fish =0, if protocol is bel protocol fish= any
%number

fish=0;

if fish==0
    protocol=[0 5 25 30 50 60];
    protocol_name={'Dark' 'OKR' 'Dark' 'OKR' 'Dark'}
else
    protocol=[0 5 25 30 50 60 80 85 105 115];
    protocol_name={'Dark' 'OKR' 'Dark' 'OKR' 'Dark' 'OKR' 'Dark' 'OKR' 'Dark'}
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




xscale=[0 30];
yscale=[0 2];
FigHandle = figure('Position', [0,0, 2000, 500]);

for i=2:length(protocol);
    
[v,s]=sorting(time/60,protocol(i-1),protocol(i),deriv,1);
subplot(1,length(protocol)-1,i-1)

vp=v(v>0);
sp=s(v>0);
vn=flipud(abs(v(v<0)));
sn=flipud(s(v<0));
sp(end+1:numel(sn))=0;
sn(end+1:numel(sp))=0;
vp=(vp(1):vp(2)-vp(1):vp(1)+(vp(2)-vp(1))*(length(sp)-1))';
vn=(vn(1):vn(2)-vn(1):vn(1)+(vn(2)-vn(1))*(length(sn)-1))';

plot(vp,sp,'b');
hold on
plot(vn,sn,'r');
delta=sp-sn;
pdelta=delta;
pdelta(delta<0)=0;
ndelta=delta;
ndelta(delta>0)=0;
plot(vp,pdelta,'b:');
plot(vn,abs(ndelta),'r:');

if k==1;
    lv=v
    ls=s
    
else
    rv=v
    rs=s
end
          




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

FigHandle = figure('Position', [0,0, 2000, 500]);
for i=2:length(protocol);  
    for k=1:2;
        if k==1;
            deriv=derivate(data.leye_raw,1/40);
            time=data.time_l;
            [v,s]=sorting(time/60,protocol(i-1),protocol(i),deriv,1);
            lv=v;
            ls=s;
        end
        if k==2;
            deriv=derivate(data.reye_raw,1/40);
            time=data.time_r;
            [v,s]=sorting(time/60,protocol(i-1),protocol(i),deriv,1);
            rv=v;
            rs=s;
        end
    end

    subplot(1,length(protocol)-1,i-1);
    
    lvp=lv(lv>0);
    lsp=ls(lv>0);
    lvn=flipud(abs(lv(lv<0)));
    lsn=flipud(ls(lv<0));
    lsp(end+1:numel(lsn))=0;
    lsn(end+1:numel(lsp))=0;
    lvp=(lvp(1):lvp(2)-lvp(1):lvp(1)+(lvp(2)-lvp(1))*(length(lsp)-1))';
    lvn=(lvn(1):lvn(2)-lvn(1):lvn(1)+(lvn(2)-lvn(1))*(length(lsn)-1))';
    
    rvp=rv(rv>0);
    rsp=rs(rv>0);
    rvn=flipud(abs(rv(rv<0)));
    rsn=flipud(rs(rv<0));
    rsp(end+1:numel(rsn))=0;
    rsn(end+1:numel(rsp))=0;
    rvp=(rvp(1):rvp(2)-rvp(1):rvp(1)+(rvp(2)-rvp(1))*(length(rsp)-1))';
    rvn=(rvn(1):rvn(2)-rvn(1):rvn(1)+(rvn(2)-rvn(1))*(length(rsn)-1))';
    
    rsp(end+1:numel(lsp))=0;
    lsp(end+1:numel(rsp))=0;
    tsp=(lsp+rsp)/2;
    rsn(end+1:numel(lsn))=0;
    lsn(end+1:numel(rsn))=0;
    tsn=(lsn+rsn)/2;
    
    tv=(0.5:1:0.5+length(tsn)-1)';
    
    plot(tv,tsp,'b');
    hold on
    plot(tv,tsn,'r');
    delta=tsp-tsn;
    pdelta=delta;
    pdelta(delta<0)=0;
    ndelta=delta;
    ndelta(delta>0)=0;
    plot(tv,pdelta,'b:');
    plot(tv,abs(ndelta),'r:');
    
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