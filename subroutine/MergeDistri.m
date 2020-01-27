
function LoadingFile
[FolderName,FolderPath] = uigetfile('H:\TURN TABLE\library','*.mat');
load([FolderPath,FolderName]);

LR='LR';
IndexPro=2;%protocol library
for i=1:2 %faster stimulation direction or seeing eye
    index=find(strcmp(LR(i),library.data(:,4)));
    for d=1:length(index)
        load([library.data{index(d),3},library.data{index(d),2}]);
        MergeDATA.([LR(i)])(d)=data;
    end
    
    [MergeDATA]=GetMergeVel(MergeDATA,LR(i));
    %getting velocity by derivetive
    
    MeanDistri(MergeDATA,LR(i),IndexPro); 
    %mean of the velocity distribution; shaded area is std
    
    StatMid(MergeDATA,LR(i),IndexPro); 
    %median of velocity distribution
    
%     MidPAN(MergeDATA,LR(i),0);
    %median of the velocity of every single slow phase
    
    
    % MidDistri
    % MeanPAN
    
end
end

function [MergeDATA]=GetMergeVel(MergeDATA,LR)
lr='lr';
for j=1:2
    for d=1:length(MergeDATA.([LR]));
        eye_raw=MergeDATA.([LR])(d).([lr(j),'eye_raw']);
        MergeDATA.([LR])(d).([lr(j),'vel'])=derivate(eye_raw,1/40);
    end
end
end

function MeanDistri(MergeDATA,LR,IndexPro);
[protocol,protocol_name]=ProtocolLibrary(IndexPro);
lr='lr';
for j=1:2;
    FigHandle = figure('Position', [0,0, 2000, 300]);
    for i=2:length(protocol);
        
        %v=velocity s=datasize
        for d=1:length(MergeDATA.([LR]));
            VEL=MergeDATA.([LR])(d).([lr(j),'vel']);
            TIME=MergeDATA.([LR])(d).(['time_',lr(j)]);
            [VelBin,Datasize(:,d)]=sorting(TIME/60,protocol(i-1),protocol(i),VEL,1);
        end
        DATAmean=mean(Datasize,2);
        DATAerr=std(Datasize,0,2);
        
        [vp,sp,vn,sn]=SortPN(VelBin,DATAmean);
        [ERRvp,ERRsp,ERRvn,ERRsn]=SortPN(VelBin,DATAerr);
        
        %plot
        xscale=[0 20];
        yscale=[0 40];
        subplot(1,length(protocol)-1,i-1)
        
        StairArea(vp,sp,'b','CCW',ERRsp)
        hold on
        StairArea(vn,sn,'r','CW',ERRsn)
        
        
        xlim(xscale);
        ylim(yscale);
        set(gca,'XTick',[min(xlim):(max(xlim)-min(xlim))/4:max(xlim)]);
        title(protocol_name(i-1),'FontSize',16);
    end
    set(gcf,'Color',[1 1 1]);
    
end
end

function StatMid(MergeDATA,LR,IndexPro)
lr='lr';
cut_point=50;
[protocol,protocol_name]=ProtocolLibrary(IndexPro);
for j=1:2
    figure('Position', [0,0, 2000, 300]);
    for i=2:length(protocol);
        for d=1:length(MergeDATA.([LR]));
            
            VEL=MergeDATA.([LR])(d).([lr(j),'vel']);
            TIME=MergeDATA.([LR])(d).(['time_',lr(j)]);
            [Pmean,Nmean,Pquant,Nquant]=quant_mean(TIME/60,protocol(i-1),protocol(i),VEL,cut_point);
            Pmid.([lr(j)])(i-1,d)=Pquant;
            Nmid.([lr(j)])(i-1,d)=abs(Nquant);
            
            p=i-1;
            subplot(1,length(protocol)-1,i-1)
            plot([p*2-1 p*2],[Pquant abs(Nquant)],'k-o')
            hold on
            plot(p*2-1,Pquant,'bo')
            plot(p*2,abs(Nquant),'ro')
            xlim([[p*2-1.5 p*2+0.5]]);
            
            if strcmp(protocol_name(p),'Dark')
                set(gca,'Color',[.9 .9 .9])
                ylim([0 2])
            else
                ylim([0 15])
            end
        end
        set(gca,'xtick',[1.5:2:11.5],'xticklabel',protocol_name);
    end
    set(gcf,'Color',[1 1 1]);
end
end

function MidPAN(MergeDATA,LR,IndexPro);
[protocol,protocol_name]=ProtocolLibrary(IndexPro);
lr='lr';
for j=1:2;
    figure
    mergepMidbinVel=[];
    mergenMidbinVel=[];
    for d=1:length(MergeDATA.([LR]));
        VEL=MergeDATA.([LR])(d).([lr(j),'vel']);
        TIME=MergeDATA.([LR])(d).(['time_',lr(j)]);
        IDX=MergeDATA.([LR])(d).(['SaccExtremeIdx',upper(lr(j))]);
        [dIDX,lIDXodd,lIDXeven]=PANidx(VEL,TIME,IDX,0);
        
        [dMidVel]=MidVel(VEL,dIDX);
        [MidVelodd]=MidVel(VEL,lIDXodd);
        [MidVeleven]=MidVel(VEL,lIDXeven);
        [pMidVel,pMidIdx,nMidVel,nMidIdx]=PANpnSort(dMidVel,dIDX,MidVelodd,lIDXodd,MidVeleven,lIDXeven);
        
        [pbinVel,pbinIdx,pMidbinVel,pMidinterval]=PANbinSort(TIME,pMidVel,pMidIdx,0);
        [nbinVel,nbinIdx,nMidbinVel,nMidinterval]=PANbinSort(TIME,nMidVel,nMidIdx,0);
        
        mergepMidbinVel=[ mergepMidbinVel pMidbinVel'];
        mergenMidbinVel=[ mergenMidbinVel nMidbinVel'];
        MergeDATA.([LR])(d).([lr(j),'nMidbinVel'])=nMidbinVel';
%         for p=1:length(pbinIdx)
%             plot(TIME(pbinIdx{p}),pbinVel{p},'bo','MarkerSize',2);
%             hold on
%             plot(TIME(nbinIdx{p}),nbinVel{p},'ro','MarkerSize',2);
%         end
        
    end
%     plot(pMidinterval,nanmedian(mergepMidbinVel,2),'bo','MarkerSize',6);
%     hold on
%     plot(pMidinterval,nanmedian(mergenMidbinVel,2),'ro','MarkerSize',6);
    errorbar(pMidinterval,nanmean(mergepMidbinVel,2),std(mergepMidbinVel,0,2),'bo','MarkerSize',6);
    hold on
    errorbar(pMidinterval,nanmean(mergenMidbinVel,2),std(mergepMidbinVel,0,2),'ro','MarkerSize',6);
end

end

