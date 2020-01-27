function ScaleBar(xlim,ylim,Barwidth,xBAR,yBAR,FONT)
delX=max(xlim)-min(xlim);
delY=max(ylim)-min(ylim);

Bar=[min(xlim)+delX/10 min(xlim)+delX/10+Barwidth];

bar_label=sprintf([num2str(Barwidth) ' min']);
text(min(Bar)+xBAR*delX,min(ylim)-yBAR*delY,bar_label,'FontSize',FONT);
plot(Bar,min(ylim)*ones(2,1),'k-');
end