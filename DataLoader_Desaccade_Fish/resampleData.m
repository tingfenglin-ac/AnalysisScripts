function [tnew,datanew]=resampleData(t,data,fc)

%%%crea oggetto timeseries dei dati iniziali
tSer=timeseries(data,t);

%%%%crea nuovo vettore tempo con nuova fc
tnew=t(1):1/fc:t(end);

%%ricampionamento
tSer1=resample(tSer,tnew);%%nuova timeseries

%%%riporto dati nei vettori
tnew=tSer1.Time;
datanew=tSer1.Data;