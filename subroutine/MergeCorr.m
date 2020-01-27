function [rho,pval]=MergeCorr(MergeDATA_SPV,MergeDATA_SF,j);

bin=10;
bin=bin/60;
[protocol,protocol_name,ProtoCat]=ProtocolLibrary(4);

[matSPV]=GetFromMerge(MergeDATA_SPV,'BinMeanVel',j);
[matSF]=GetFromMerge(MergeDATA_SF,'DiffFreq',j);

time=bin/2:bin:bin/2+bin*(length(matSPV(:,1))-1);

PreIdx=1:(protocol(2)-protocol(1))/bin;
StimIdx=PreIdx(end)+1:PreIdx(end)+(protocol(3)-protocol(2))/bin;
PostIdx=StimIdx(end)+1:StimIdx(end)+(protocol(4)-protocol(3))/bin;

if strcmp(j,'l')
    br='b';
else
    br='r';
end

plot(nanmean(matSF(PreIdx,:),2),nanmean(matSPV(PreIdx,:),2),'o',...
    'MarkerEdgeColor',br,...
    'MarkerSize',8);
hold on
plot(nanmean(matSF(StimIdx,:),2),nanmean(matSPV(StimIdx,:),2),'s',...
    'MarkerEdgeColor',br,...
    'MarkerSize',8);
plot(nanmean(matSF(PostIdx,:),2),nanmean(matSPV(PostIdx,:),2),'d',...
    'MarkerEdgeColor',br,...
    'MarkerSize',8);

[rho.total,pval.total] = corr(nanmean(matSF(1:PostIdx(end),:),2),nanmean(matSPV(1:PostIdx(end),:),2));
[rho.pre,pval.pre] = corr(nanmean(matSF(PreIdx,:),2),nanmean(matSPV(PreIdx,:),2));
[rho.stim,pval.stim] = corr(nanmean(matSF(StimIdx,:),2),nanmean(matSPV(StimIdx,:),2));
[rho.post,pval.post] = corr(nanmean(matSF(PostIdx,:),2),nanmean(matSPV(PostIdx,:),2));
end

function [matDATA]=GetFromMerge(MergeDATA,DataCat,j)
matDATA=[];
for d=1:length(MergeDATA);
    Array=MergeDATA(d).([j,DataCat]);  
    [matDATA]=MergeMat(matDATA,Array);
end
end