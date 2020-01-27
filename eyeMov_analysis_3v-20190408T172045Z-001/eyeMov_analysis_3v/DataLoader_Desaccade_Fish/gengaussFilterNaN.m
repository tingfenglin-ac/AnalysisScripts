function [data] = gengaussFilterNaN(data,cutoff)

a=1;
b = gengauss(cutoff);
b= b/sum(b);

dataCell=cell(1,size(data,2));
for j=1:size(data,2)
    if sum(~isnan(data(:,j)))==0
        dataCell(j)={data(:,j)};
        continue
    end
    [temp]=splitSignal(data(:,j));
    [a1,b1]=deal(cell(size(temp)));
    a1(:)={a}; b1(:)={b}; %inizializzo celle
    temp=cellfun(@filterFunCell,temp,a1,b1,'UniformOutput', false);
    
    dataCell(j)={vertcat(temp{:})};
  
end

if size(dataCell,2)~=1
    data=catpad(2,dataCell{:});
else
    data=dataCell{:};
end

end


function x=filterFunCell(x,a,b)
nfact = 3*(length(b)-1);

if length(x) > nfact
    x=filtfilt(b,a,x);
end

end


function [signals]=splitSignal(x)
%Divisione del segnale tra dati e NaN
%input= vettore dati
%output= indici del primo e dell'ultimo NaN dei segmenti d
dimX=size(x);
if dimX(1)<dimX(2)
    x=x';
    dimX=size(x);
end

%controllo x se primo e ultimo valore sono dei nan
if isnan(x(1))
    x(1)=x(2);
end
if isnan(x(end))
    x(end)=x(end-1);
end

%controllo Nan singoli dove c'è il meno due
idxSingle=find(diff(diff(isnan([0;x;0])))==-2);
x(idxSingle)=(x(idxSingle-1)+x(idxSingle+1))/2;
%x([1 end])=[];

%controllo Nan doppi dove c'è il meno due
idxDouble=find(abs(diff(isnan([0;x;0])))==1);
idxNanD=find(diff(idxDouble)==2);
idxDouble=[idxDouble(idxNanD),idxDouble(idxNanD)+1]';
idxDouble=idxDouble(:);
x(idxDouble)=interp1(x,idxDouble,'spline');


%trovo i NaN shiftando i vettori avanti e indietro di 1t
xtemp=(isnan([x;0;0])&isnan([0;x;0])&isnan([0;0;x]));
idx=find(xor(isnan(x),xtemp(2:end-1)));

%idxStart=idx(1:2:end);
%idxEnd=idx(2:2:end);

idxStart=sort([1;idx(1:2:end);idx(2:2:end)+1]);
idxEnd=sort([idx(1:2:end)-1;idx(2:2:end);dimX(1)]);

d=idxEnd-idxStart<=0;
idxStart(d)=[];
idxEnd(d)=[];

for j=1:size(idxEnd)
    ind1=idxStart(j);
    ind2=idxEnd(j);
    
    signals(j,1)={x(idxStart(j):idxEnd(j))};
end


end