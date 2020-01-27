function SubplotLabel(tit,FONT)
title(tit,'fontsize',FONT,'fontweight','bold')
P = get(gca,'Position');
DX=max(xlim)-min(xlim);
DY=max(ylim)-min(ylim);
set(get(gca,'title'),'Position',[min(xlim)-0.05*DX/P(3) max(ylim)+0.01*DY/P(4) 1.00011]);
end