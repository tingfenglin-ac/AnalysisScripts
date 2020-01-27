function raw_trace(i,i_length,ProtNumber,tit,xscale,yscale,grating_frq,xBAR,yBAR,Yposition,Nproto,scaleBAR,Barwidth,Format)

LINEWIDTH=Format.LINEWIDTH;%axis
TraceWDTH=Format.TraceWDTH;%trace
FONT=Format.FONT;
TICK=Format.TICK;
SaccadDirct=Format.SaccadDirct;

%10v sqaure symmetry
[fileName,pathName] = uigetfile('*.mat');
load([pathName,fileName]);

[choice]=L_R_analysis();
LR='lr';
l_r=LR(choice);

% stimulus velocity
if 0
StimVelPro(ProtNumber);
set(gco,'LineWidth',TraceWDTH);
ylim(yscale);
set(gca,'YTick',min(ylim):15:max(ylim),...
    'YColor','r',...
    'LineWidth',LINEWIDTH,...
    'FontSize',FONT,...
    'YTick',TICK);
hold on
yyaxis left
end


plot(data.(['time_',l_r])/60,data.([l_r,'eye_raw']),'k','LineWidth',TraceWDTH);
xlim(xscale);
ylim(yscale);
hold on


if any(Nproto(:) == i);
%if protocol is WT protocol fish =0, if protocol is bel protocol fish= any
%number
PlotProtocol(grating_frq,ProtNumber,Yposition,0);
end

ylabel({'Eye position (deg)'},'FontSize',12);
set(gca, 'YTick',TICK,...
    'YColor','k',...
    'FontSize',FONT);

% Scale bar
 set(gca,'xtick',[],...
 'xcolor',[1 1 1],...
 'LineWidth',LINEWIDTH); 
if any(scaleBAR(:) == i);
ScaleBar(xlim,ylim,Barwidth,xBAR,yBAR,FONT);
set(gco,'LineWidth',LINEWIDTH);
end

% label saccade direction
if SaccadDirct
[PosIdx,NegIdx]=SaccDir(data,l_r);
TIME=data.(['time_',l_r])/60;
eye_raw=data.([l_r,'eye_raw']);
Ps=scatter(TIME(PosIdx),eye_raw(PosIdx),40,'ro','LineWidth',1.5);
hold on
Ns=scatter(TIME(NegIdx),eye_raw(NegIdx),40,'go','LineWidth',1.5);
legend([Ps Ns],{'Positive-directed peaks','Negative-directed peaks'},'FontSize',FONT);
legend('boxoff');
end

% Label e.g. A, B, C
if 1
SubplotLabel(tit,FONT)
end
box off