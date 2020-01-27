function Vslop(i,i_length,fish,tit,xscale,yscale,grating_frq,xBAR,yBAR,ylebel,Nproto,scaleBAR)

Barwidth=5 %Barwidth=2*scalebar 

[fileName,pathName] = uigetfile('*.mat');
load([pathName,fileName]);

[choice]=L_R_analysis();
LR='lr';
l_r=LR(choice);




fit_lenght=40;
for v=1:length(data.(['SaccExtremeIdx',upper(l_r)]))-1
    Idx=data.(['SaccExtremeIdx',upper(l_r)])(v,2):(data.(['SaccExtremeIdx',upper(l_r)])(v+1,1));
    y=data.([l_r,'eye_raw'])(Idx);
    x=data.(['time_',l_r])(Idx);
    if length(x)>fit_lenght
        x=x(1:fit_lenght,1);
        y=y(1:fit_lenght,1);
    end
    X = [ones(length(x),1) x];
    b = X\y
    slop(v,1)=b(2);
    reg_time(v,1)={x};
    reg_line(v,1)={X*b};
end

t=data.(['time_',l_r])/60;
scatter(t(data.(['SaccExtremeIdx',upper(l_r)])(1:end-1,2)),slop,10,[0.5 0.5 0.5],'fill');
[Vmedian]=medianpermin(data.(['time_',l_r])(data.(['SaccExtremeIdx',upper(l_r)])(1:end-1,2)),slop);
hold on
scatter(Vmedian(:,1),Vmedian(:,2),...
    'MarkerEdgeColor',[0.5 0.5 0.5],...
    'MarkerFaceColor',[1 1 1],...
    'LineWidth',1.5)
plot([t(1) t(end)],[0 0],'k');
[largest]=findLARGEST(slop,3);%find the largest n numbers
%plot([5 15],[mean(largest) mean(largest)],'Color',[0.5 0.5 0.5],'LineStyle','- -');

xlim(xscale);
ylim(yscale);

hold on

if any(Nproto(:) == i);
%if protocol is WT protocol fish =0, if protocol is bel protocol fish= any
%number
if fish==0;
    protocol=[0 5 25 30 50 60];
    protocol_name={'Dark' 'OKR' 'Dark' 'OKR' 'Dark'};
end
if fish==1;
    protocol=[0 5 25 30 50 60 80 85 105 115];
    protocol_name={'Dark' 'OKR' 'Dark' 'OKR' 'Dark' 'OKR' 'Dark' 'OKR' 'Dark'};
end
if fish==2;
    protocol=[0 5 15 25];
    protocol_name={'Dark' 'OKR' 'Dark'};
end
if fish==3;
    protocol=[0 5 25 45];
    protocol_name={'Dark' 'OKR' 'Dark'};
end


width_grating=0;
plot([t(1) t(end)],[ylebel+width_grating ylebel+width_grating],'k',...
    'LineWidth',8);
t_grating=t(1):1/grating_frq:t(end);
scatter(t_grating,ylebel*ones(1,length(t_grating)),'w','filled','s');
% plot([t(1) t(end)],[ylebel-width_grating ylebel-width_grating],'k');
    
for k=2:length(protocol)
if mod(k,2)==0;
    plot([protocol(k-1) protocol(k)],[ylebel ylebel],'k',...
        'LineWidth',7);
% else
%     grating_frq=8; %how many grating per minute
%     t_grating=protocol(i-1):1/grating_frq:protocol(i);
%     scatter(t_grating,ylebel*ones(1,length(t_grating)),'w','filled','s');
end
end
% text_high=ylebel+6;
% text(stext_x,text_high,stext);
% text(dtext_x,text_high,dtext);
end

ylabel({'Eye velocity';'(deg/min)'},'FontSize',12);
delY=max(ylim)-min(ylim);
set(gca, 'YTick',min(ylim):delY/5:max(ylim));
if any(scaleBAR(:) == i)
% xlabel('Time (sec)','FontSize',12);
delX=max(xlim)-min(xlim);
Bar=[min(xlim)+delX/Barwidth min(xlim)+2*delX/Barwidth];
delBAR=max(Bar)-min(Bar);
plot(Bar,min(ylim)*ones(2,1),'k');
bar_label=sprintf('%d min', delBAR);
text(min(Bar)+xBAR*delBAR,min(ylim)-yBAR*delY,bar_label,'FontSize',12);
end

% if i~=i_length;
 set(gca,'xtick',[]);
 set(gca,'xcolor',[1 1 1])
% end

title(tit,'fontsize',16,'fontweight','bold')
set(get(gca,'title'),'Position',[min(xlim)-0.5 30 1.00011])
box off