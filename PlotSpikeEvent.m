f=1;
filesize=0;
FN=cell(0);
FP=cell(0);
SpikeAmpCell=[];
SpikeTimeCell=[];
StimTimeCell=[];
while f
    [FileName,FolderPath] = uigetfile({'*Spike.mat'},'Select SpikeData files', 'Multiselect', 'on');
    
    if FolderPath==0;f=0;end
    
    if iscell(FileName)
        NewAddFile=size(FileName,2);
    elseif FileName~=0
        NewAddFile=1;
    else
        NewAddFile=0;
    end
    
    if NewAddFile~=0;
        for fnumber=1:NewAddFile
            if iscell(FileName)
                FN=cat(1,FN,FileName{fnumber});
            else
                FN=cat(1,FN,FileName);
            end
            FP=cat(1,FP,FolderPath);
        end
        
        Import_data=cellfun(@(x,y) importdata([x,y]),FP(filesize+1:filesize+NewAddFile),FN(filesize+1:filesize+NewAddFile));
        filesize=filesize+NewAddFile;
        
        SpikeAmp=vertcat(Import_data.SponSpikeAmp);
        SpikeAmp=arrayfun(@(x) vertcat(SpikeAmp{:,x}),1:size(SpikeAmp,2),'uni',0);
        SpikeAmpCell=horzcat(SpikeAmpCell,SpikeAmp);
        
        SpikeTime=vertcat(Import_data.SponSpikeTime);
        SpikeTime=arrayfun(@(x) vertcat(SpikeTime{:,x}),1:size(SpikeTime,2),'uni',0);
        SpikeTimeCell=horzcat(SpikeTimeCell,SpikeTime);
        
        StimTime=mean(vertcat(Import_data.StimTime));
        StimTimeCell=horzcat(StimTimeCell,cellfun(@(x) StimTime.*ones(size(x)),SpikeAmp,'uni',0));
    end
end


%% color
linecolorPalette=[71, 97, 157;...
    209, 55, 107;...
    255, 164, 57;...
    57, 195, 177]./255;
meancolorPalette=[166, 181, 215;...
    237, 179, 199;...
    255, 234, 210;...
    173, 231, 224]./255;

InductCon=3; %before induction protocal (tetanization)=1; after induction protocal (tetanization)=2
linecolor=linecolorPalette(InductCon,:);
meancolor=meancolorPalette(InductCon,:);
%%
% figure
hold on
histdata=SpikeTimeCell';
histstimtime=StimTimeCell';

histdata=vertcat(histdata{:});
histstimtime=vertcat(histstimtime{:});
interval=mean(diff(time));
h=histogram(histdata(:,1)-histstimtime,(time-interval./2)-max(time)./2,...
    'Normalization','pdf',...
    'FaceColor',linecolor,...
    'FaceAlpha',0.5,...
    'EdgeColor','none');
counts=h.Values;
yscale=get(gca,'ylim');

hold on
plot([0 0],yscale,'k','linewidth',1.5)
%%
set(gcf,'color',[1 1 1])
set(gca,'FontSize',20)
xlim([-0.2 0.8])
ylim(yscale)
xlabel('Time (sec)')
ylabel('Spike frequency (hz)')

