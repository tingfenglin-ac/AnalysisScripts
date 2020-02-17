clearvars -except time
filesize=0;
FN=cell(0);
FP=cell(0);
SpikeAmpCell=[];
SpikeTimeCell=[];
StimTimeCell=[];
%%
f=1;
while f
    [FileName,FolderPath] = uigetfile({'*Spike.mat;*Spikelist.mat'},'Select SpikeData files', 'Multiselect', 'on');
    
    if FolderPath==0;f=0;end
    
    if iscell(FileName)
        NewAddFile=size(FileName,2);
    elseif FileName~=0
        NewAddFile=1;
        if strfind(FileName,'Spikelist')
            load([FolderPath,FileName])
            NewAddFile=size(FN,1);
        end
    else
        NewAddFile=0;
    end
    
    if NewAddFile~=0;
        if ~strfind(FileName,'Spikelist') | iscell(FileName)
            for fnumber=1:NewAddFile
                if iscell(FileName)
                    FN=cat(1,FN,FileName{fnumber});
                else
                    FN=cat(1,FN,FileName);
                end
                FP=cat(1,FP,FolderPath);
            end
        end
               
        
        Import_data=cellfun(@(x,y) importdata([x,y]),FP(filesize+1:filesize+NewAddFile),FN(filesize+1:filesize+NewAddFile));
        filesize=filesize+NewAddFile;
        
        if ~size(strfind(FileName,'Spikelist'),1)
            SpikeAmp=vertcat(Import_data.SponSpikeAmp);
            SpikeAmp=arrayfun(@(x) vertcat(SpikeAmp{:,x}),1:size(SpikeAmp,2),'uni',0);
            
            SpikeTime=vertcat(Import_data.SponSpikeTime);
            SpikeTime=arrayfun(@(x) vertcat(SpikeTime{:,x}),1:size(SpikeTime,2),'uni',0);
        
            StimTime=mean(vertcat(Import_data.StimTime));
            StimTimeCell=horzcat(StimTimeCell,cellfun(@(x) StimTime.*ones(size(x)),SpikeAmp,'uni',0));
        else
            SpikeAmp=horzcat(Import_data(:).SponSpikeAmp);
            SpikeTime=horzcat(Import_data(:).SponSpikeTime);
        
            StimTime=arrayfun(@(x) ones(size(Import_data(x).SponSpikeAmp)).*Import_data(x).StimTime,1:size(Import_data,1),'uni',0);
            StimTime=num2cell(horzcat(StimTime{:}))
        end
        
        SpikeAmpCell=horzcat(SpikeAmpCell,SpikeAmp);
        SpikeTimeCell=horzcat(SpikeTimeCell,SpikeTime);
        StimTimeCell=horzcat(StimTimeCell,StimTime);
    end
end

%% save the timing list of each cell
 % in the future, instead of open individual files one by one, a list file
 % could call all the individual file at once
    [file,path] = uiputfile('ControlorInduced_pre early late_Spikelist.mat','save list of timing data for a specific condition')
    if path~=0
    save([path file],'FN','FP');
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

InductCon=1; %before induction protocal (tetanization)=1; after induction protocal (tetanization)=2
linecolor=linecolorPalette(InductCon,:);
meancolor=meancolorPalette(InductCon,:);
%%
figure
hold on
histdata=SpikeTimeCell';
histstimtime=StimTimeCell';

% average clls
interval=mean(diff(time));
edges=(time-interval./2)-max(time)./2;
sweepNum=cellfun(@(x) sum(diff(x(:,1))<0)+1,SpikeTimeCell,'uni',0);
counts = cellfun(@(x,y,z) histcounts(x(:,1)-y,edges)./z,SpikeTimeCell,StimTimeCell,sweepNum,'uni',0)';
% cellfun(@(x) histogram('BinEdges',edges','BinCounts',x./interval,'FaceColor','none'),counts,'uni',0)

meancounts=mean(vertcat(counts{:}),1);
histogram('BinEdges',edges','BinCounts',meancounts./interval,...
    'FaceColor',linecolor,...
    'FaceAlpha',0.5,...
    'EdgeColor','none');
yscale=get(gca,'ylim');

hold on
plot([0 0],[0 6],'k','linewidth',1.5)
%%
set(gcf,'color',[1 1 1])
set(gca,'FontSize',20)
 xlim([-0.3 0.7])
ylim([0 6])
xlabel('Time (sec)')
ylabel('Spike frequency (hz)')

