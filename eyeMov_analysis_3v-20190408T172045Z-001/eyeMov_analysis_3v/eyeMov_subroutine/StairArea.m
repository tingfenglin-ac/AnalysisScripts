function StairArea(X,Y,LineColor,label,ERR)
interval=X(2)-X(1);
X=X-0.5*interval;

if exist('ERR')
ErrArea(X,Y,ERR,LineColor);
end
hold on
Pstair=stairs(X,Y,LineColor,'LineWidth',1.5,'DisplayName',label);
legend('-DynamicLegend');

end

function ErrArea(X,Y,ERR,LineColor)
[X]=AdjustRowColumn(X);
[Y]=AdjustRowColumn(Y);
[ERR]=AdjustRowColumn(ERR);

X=[X;X];
X=X([2:end end])'
Y=([Y;Y]);
Y=Y(1:end)';
ERR=([ERR;ERR]);
ERR=ERR(1:end)';

err=fill([X;flipud(X)],[Y-ERR;flipud(Y+ERR)],LineColor,'linestyle','none');

% Choose a number between 0 (invisible) and 1 (opaque) for facealpha.  
set(err,'facealpha',.2)
set(get(get(err,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
end

function [Vect]=AdjustRowColumn(Vect)
if find(size(Vect)==max(size(Vect)))==1;
    Vect=Vect';
end
end