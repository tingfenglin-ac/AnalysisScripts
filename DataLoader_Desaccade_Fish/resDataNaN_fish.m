function [tnew,datanew]=resDataNaN_fish(t,data,fc2)
%%% [tnew,datanew]=resDataNaN(t,data,fc)
% resample at new sampling frequency, data
% this function handles NaN values
%%%%% INPUT
%	t: orginal time vector (i.e. time stamp)
%	data: matrix containing signals, each COLUMN represents one signals
% 	fc1: original sampling frequency
% 	fc2: new sampling frequency chosen
%%%%% OUTPUT
%	tnew: new time vector resampled
%	datanew; new signals matrix resaple
%
% Author: FR,PG          Date: 12/2014             Review: 2.1v
% 1v: resample only a vector
% 1.2v: handle matrix
% 2v: handle NaN
%2016 FR
%
%Dependeces:
%1.resample function, from Signal Processing Toolbox, is used
%2.catpad function, from Utils, is used

if size(t,1)~=length(t) %vettore colonna
    t=t';
    data=data';
end

%[data] = butterFilterNaN( data,fc1,floor(fc2/2),'low',2);


dataNaN=isnan(data);

%%%crea oggetto timeseries dei dati iniziali
tSer=timeseries([data,dataNaN],t);

%%%%crea nuovo vettore tempo con nuova fc
tnew=t(1):1/fc2:t(end);

%%ricampionamento
tSer1=tSer.resample(tnew);%%nuova timeseries

%%%riporto dati nei vettori
tnew=tSer1.Time;
datanew=tSer1.Data;
dimData=size(datanew);
dataNaN=datanew(:,(dimData(2)/2+1):dimData(2));
datanew=datanew(:,1:dimData(2)/2);
datanew(logical(dataNaN))=NaN;

