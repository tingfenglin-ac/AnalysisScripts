clear
[fileName,pathName] = uigetfile('*.mat');
load([pathName,fileName]);

[choice]=L_R_analysis();
lr='lr'
for i=choice
    
data.([lr(i),'vel'])=derivate(data.([lr(i),'eye_raw']),1/40);
[dIDX,lIDXodd,lIDXeven]=PANidx(data.([lr(i),'vel']),data.(['time_',lr(i)]),data.(['SaccExtremeIdx',upper(lr(i))]),0);
[dMidVel]=MidVel(data.([lr(i),'vel']),dIDX);
[MidVelodd]=MidVel(data.([lr(i),'vel']),lIDXodd);
[MidVeleven]=MidVel(data.([lr(i),'vel']),lIDXeven);
[pMidVel,pMidIdx,nMidVel,nMidIdx]=PANpnSort(dMidVel,dIDX,MidVelodd,lIDXodd,MidVeleven,lIDXeven);

[pbinVel,pbinIdx,pMidbinVel,pMidinterval]=PANbinSort(data.(['time_',lr(i)]),pMidVel,pMidIdx,0);
[nbinVel,nbinIdx,nMidbinVel,nMidinterval]=PANbinSort(data.(['time_',lr(i)]),nMidVel,nMidIdx,0);



figure
% plot(data.(['time_',lr(i)]),data.([lr(i),'vel']),'k');
% hold on

for k=1:length(pbinIdx)
plot(data.(['time_',lr(i)])(pbinIdx{k,1}),pbinVel{k},'bo','MarkerSize',2);
hold on
plot(data.(['time_',lr(i)])(nbinIdx{k,1}),nbinVel{k},'ro','MarkerSize',2);
end
plot(pMidinterval,pMidbinVel,'bo','MarkerSize',10);
plot(nMidinterval,nMidbinVel,'ro','MarkerSize',10);

end