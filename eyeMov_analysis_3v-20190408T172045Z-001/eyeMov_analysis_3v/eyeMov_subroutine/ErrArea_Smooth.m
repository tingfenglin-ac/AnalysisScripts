function ErrArea_Smooth(X,Y,ERR,LineColor)

err=fill([X;flipud(X)],[Y-ERR;flipud(Y+ERR)],LineColor,'linestyle','none');
% set(gco,'linestyle','none')
% Choose a number between 0 (invisible) and 1 (opaque) for facealpha.  
set(err,'facealpha',.2,'marker','none')
set(get(get(err,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');

end