function [tnew,datanew]=resampleDataFR_noNaN(t,data,fc)


%%%%crea nuovo vettore tempo con nuova fc
tnew=t(1):1/fc:t(end);

datanew=nan(size(tnew));
[~,Iref] = histc(tnew,t);

for k=1:length(t)
    if Iref(k)>0
       datanew(Iref(k),:) = data(k,:);
    end
end

end