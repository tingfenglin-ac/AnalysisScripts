% close all
clear
[fileName,pathName] = uigetfile('*.mat');
load([pathName,fileName]);

[choice]=L_R_analysis();




% left eye occlusion=1; right eye occlusion=2
% if choice==1
%     data.leye_raw=-data.leye_raw;
% end

%legend
directP='CCW';
directN='CW';
cut_point=50;
%mean_cutpoint=1



for k=choice;
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

[protocol,protocol_name]=ProtocolLibrary(2);

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
yscale=[0 40];
FigHandle = figure('Position', [0,0, 2000, 400]);

for i=2:length(protocol);

%v=velocity s=datasize
subplot(1,length(protocol)-1,i-1)
[v,s,vp,sp,vn,sn]=sorting(time/60,protocol(i-1),protocol(i),deriv,1);


plot(vp,sp,'b','LineWidth',3);
hold on
plot(vn,sn,'r','LineWidth',3);








%medium

if exist('cut_point')
    [Pmean,Nmean,Pquant,Nquant]=quant_mean(time/60,protocol(i-1),protocol(i),deriv,cut_point);
    line([Pquant Pquant],yscale,'Color','blue','LineWidth',1.1,'LineStyle',':');
    % text(Pquant,max(yscale)-0.25*diff(yscale),cut_point,'Color','blue');
    % my_str=sprintf('%.0f - %.0f',vp(midp)-0.5,vp(midp)+0.5);
    % text(vp(midp),max(yscale)-0.05*diff(yscale),my_str,'Color','blue');
    
    Nquant=abs(Nquant);
    line([Nquant Nquant],yscale,'Color','red','LineWidth',1,'LineStyle',':');
    % text(Nquant,max(yscale)-0.35*diff(yscale),cut_point,'Color','red');
    % my_str=sprintf('%.0f - %.0f',vn(midn)-0.5,vn(midn)+0.5);
    % text(vn(midn),max(yscale)-0.15*diff(yscale),my_str,'Color','red');
end

if exist('mean_cutpoint')
    [Pmean,Nmean]=quant_mean(time/60,protocol(i-1),protocol(i),deriv);
    line([Pmean Pmean],yscale,'Color','blue','LineWidth',1.1,'LineStyle',':');
    
    Nmean=abs(Nmean);
    line([Nmean Nmean],yscale,'Color','red','LineWidth',1,'LineStyle',':');
end

if exist('distri')==0
distri.Lmid=[];
distri.Rmid=[];
distri.Lpercen=[];
distri.Rpercen=[];
distri.Ldatasize=[];
distri.Rdatasize=[];
distri.mid_of_bin=[];
end
if k==1;
    distri.Lmid(i-1,:)=[Pmean Nmean];
    distri.Lpercen(i-1,:)=[sum(sp) sum(sn)];
    distri.Ldatasize(:,i-1)=s;
    distri.mid_of_bin=v;
end
if k==2;
    distri.Rmid(i-1,:)=[Pmean Nmean];
    distri.Rpercen(i-1,:)=[sum(sp) sum(sn)];
    distri.Rdatasize(:,i-1)=s;
    distri.mid_of_bin=v;
end




delta=sp-sn;
pdelta=delta;
pdelta(delta<0)=0;
ndelta=delta;
ndelta(delta>0)=0;
% plot(midn,pdelta,'b:','LineWidth',3);%delta
% plot(vn,abs(ndelta),'r:','LineWidth',3);%delta


if k==1;
    lv=v;
    ls=s;
    
else
    rv=v;
    rs=s;
end
          




ylabel('Data number ratio (%)','FontSize',16);
xlabel('Velocity (deg/sec)','FontSize',16);





xlim(xscale);
ylim(yscale);
set(gca,'XTick',[min(xlim):(max(xlim)-min(xlim))/4:max(xlim)]);
%ratio and legend
p=round(100*sum(s(v>0))/sum(s));
n=round(100*sum(s(v<0))/sum(s));
my_str=sprintf('(%d:%d)',n,p);
%legend(directP,directN,['delta (' directP ')'],['delta (' directN ')']);
legend(directP,directN);
title(protocol_name(i-1),'FontSize',16);
% text(max(xlim)-(max(ylim)-min(ylim))/6,(max(ylim)-min(ylim))/2+min(ylim),my_str);
end
set(gcf,'Color',[1 1 1]);

L_R='LR';
print(gcf,[pathName,fileName(1:end-9),'_distri',L_R(k)],'-dtiff','-r300'); 
end

%to make the overlap distribution figure overlapfig=1
overlapfig=0
if overlapfig
    
FIGover=figure(3)
set(FIGover,'Position', [0,0, 2000, 400]);
rsp=[];
lsp=[];
rsn=[];
lsn=[];

for i=2:length(protocol); 
    figure(3)
    
    for k=choice;
        if k==1;
            deriv=derivate(data.leye_raw,1/40);
            time=data.time_l;
            [v,s]=sorting(time/60,protocol(i-1),protocol(i),deriv,1);
            lv=v';
            ls=s';
            
            lvp=lv(lv>0);
            lsp=ls(lv>0);
            lvn=flip(abs(lv(lv<0)));
            lsn=flip(ls(lv<0));
            lsp(end+1:numel(lsn))=0;
            lsn(end+1:numel(lsp))=0;
            lvp=(lvp(1):lvp(2)-lvp(1):lvp(1)+(lvp(2)-lvp(1))*(length(lsp)-1))';
            lvn=(lvn(1):lvn(2)-lvn(1):lvn(1)+(lvn(2)-lvn(1))*(length(lsn)-1))';
        end
        if k==2;
            deriv=derivate(data.reye_raw,1/40);
            time=data.time_r;
            [v,s]=sorting(time/60,protocol(i-1),protocol(i),deriv,1);
            rv=v';
            rs=s';
            
            rvp=rv(rv>0);
            rsp=rs(rv>0);
            rvn=flip(abs(rv(rv<0)));
            rsn=flip(rs(rv<0));
            rsp(end+1:numel(rsn))=0;
            rsn(end+1:numel(rsp))=0;
            rvp=(rvp(1):rvp(2)-rvp(1):rvp(1)+(rvp(2)-rvp(1))*(length(rsp)-1))';
            rvn=(rvn(1):rvn(2)-rvn(1):rvn(1)+(rvn(2)-rvn(1))*(length(rsn)-1))';
        end
    end

    subplot(1,length(protocol)-1,i-1);
    
    rsp(end+1:numel(lsp))=0;
    lsp(end+1:numel(rsp))=0;
    tsp=(lsp+rsp)/2;
    if length(choice)==1;
        tsp=(lsp+rsp);
    end
    rsn(end+1:numel(lsn))=0;
    lsn(end+1:numel(rsn))=0;
    tsn=(lsn+rsn)/2;
    if length(choice)==1;
        tsn=(lsn+rsn);
    end
    
    tv=(0.5:1:0.5+length(tsn)-1)';
    
    

    plot(tv,tsp,'b','LineWidth',3);
    hold on
    plot(tv,tsn,'r','LineWidth',3);
    
%     if exist('cut_point')
%     [tmidp]=quantile_sorting(tsp,50);
%     [tmidn]=quantile_sorting(tsn,50);
%     
%     line([tv(tmidp) tv(tmidp)],yscale,'Color','blue','LineWidth',1.1,'LineStyle',':');
%     text(tv(tmidp),max(yscale)-0.25*diff(yscale),cut_point,'Color','blue');
% %     my_str=sprintf('%.0f - %.0f',tv(tmidp)-0.5,tv(tmidp)+0.5);
% %     text(tv(tmidp),max(yscale)-0.05*diff(yscale),my_str,'Color','blue');
%     
%     line([tv(tmidn) tv(tmidn)],yscale,'Color','red','LineWidth',1,'LineStyle',':');
%     text(tv(tmidn),max(yscale)-0.35*diff(yscale),cut_point,'Color','red');
% %     my_str=sprintf('%.0f - %.0f',tv(tmidn)-0.5,tv(tmidn)+0.5);
% %     text(tv(tmidn),max(yscale)-0.15*diff(yscale),my_str,'Color','red');
%     end    

    delta=tsp-tsn;
    pdelta=delta;
    pdelta(delta<0)=0;
    ndelta=delta;
    ndelta(delta>0)=0;
    %     plot(tv,pdelta,'b:','LineWidth',3);%delta
    %     plot(tv,abs(ndelta),'r:','LineWidth',3);%delta
    
    ylabel('Data number ratio (%)','FontSize',16);
    xlabel('Velocity (deg/sec)','FontSize',16);
    
    xlim(xscale);
    ylim(yscale);
    set(gca,'XTick',[min(xlim):(max(xlim)-min(xlim))/4:max(xlim)]);
    %ratio and legend
    p=round(100*sum(s(v>0))/sum(s));
    n=round(100*sum(s(v<0))/sum(s));
    my_str=sprintf('(%d:%d)',n,p);
%     legend(directP,directN,['delta (' directP ')'],['delta (' directN ')']);
    legend(directP,directN);
    title(protocol_name(i-1),'FontSize',16);
    % text(max(xlim)-(max(ylim)-min(ylim))/6,(max(ylim)-min(ylim))/2+min(ylim),my_str);
    set(gcf,'Color',[1 1 1]);

figure(4) %compare dark
if i-1==1
plot(tv,tsp,'b','LineWidth',3);
hold on
plot(tv,tsn,'r','LineWidth',3);
hold on
end
if i-1==3
    hold on
    plot(tv,tsp,'b--','LineWidth',3);
    hold on
    plot(tv,tsn,'r--','LineWidth',3);
end
if i-1==5
    hold on
    plot(tv,tsp,'b:','LineWidth',3);
    hold on
    plot(tv,tsn,'r:','LineWidth',3);
end
ylabel('Data number ratio (%)','FontSize',16);
xlabel('Velocity (deg/sec)','FontSize',16);

xlim(xscale);
%ylim(yscale);
set(gca,'XTick',[min(xlim):(max(xlim)-min(xlim))/4:max(xlim)]);
%ratio and legend
p=round(100*sum(s(v>0))/sum(s));
n=round(100*sum(s(v<0))/sum(s));
my_str=sprintf('(%d:%d)',n,p);
legend([directP ' (pre-stim)'],[directN ' (pre-stim)'],[directP ' (post-1^{st}stim)'],[directN ' (post-1^{st}stim)'],[directP ' (post-2^{nd}stim)'],[directN ' (post-2^{nd}stim)']);
title('Fish-1','FontSize',16);
end
set(gcf,'Color',[1 1 1]);
end

save([pathName,fileName(1:end-9),'_distri.mat'],'distri');

simuPAN;
clc
clear