%adaptation and amplitude estimated by median
function [output]=adap_amp_withnan(medata,okantime);

output.okramp=nanmean(medata.median(11:12,:));
output.okrdrop=output.okramp-nanmean(medata.median([(okantime*2-3):okantime*2],:));
output.okanamp=nanmean(medata.median([okantime*2+3 okantime*2+4],:));

output.normaladapt=output.okrdrop/output.okramp;
output.normalokanamp=-output.okanamp/output.okramp;
    

end