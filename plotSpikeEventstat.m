filesize=0;
FN=cell(0);
FP=cell(0);
SpikeAmpCell=[];
SpikeTimeCell=[];
StimTimeCell=[];
ConditionCell=[];
FileSizeNum=[];
FileSizeNumCell=[];
%%
f=1;
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
        
        ConditionCell=horzcat(ConditionCell,f.*ones(size(SpikeAmp)));
        f=f+1;
        
        FileSizeNum=horzcat(FileSizeNum,length(find(diff(SpikeTime{1}(:,1))<0))+1.*ones(size(SpikeAmp)));
    end
end


%% plotting the spike number within 0.5 s after stim
figure
co=colormap(lines);
interval=mean(diff(time));

x=1:3;
t=cellfun(@(x,y) x(:,1)-y,SpikeTimeCell,StimTimeCell,'uni',0);
y=[];
FileSizeNumCell=mat2cell(FileSizeNum,1,ones(1,size(SpikeTimeCell,2)));
for n=x
y(n,:)=cellfun(@(a,b) sum(a>0 & a<0.5)./b,t(ConditionCell==n),FileSizeNumCell(ConditionCell==n));
end

coNum=6;
hold on
for n=1:size(y,2)
    jitterx=x'+0.*rand(size(x'))
scatter(jitterx,y(:,n),200,...
    'MarkerFaceColor','flat',...
    'MarkerEdgeColor','flat',...
    'MarkerFaceAlpha',0.5,...
    'MarkerEdgeAlpha',0.5,...
    'MarkerFaceColor',co(coNum,:));
plot(jitterx,y(:,n),...
    'color',co(coNum,:),...
    'LineWidth',3)
end
%%
hold on
ymean=mean(y,2);
ystd=std(y,0,2)
errorbar(x,ymean,ystd,'o-',...
    'MarkerSize',18,...
    'MarkerFaceColor',[.3 .3 .3],...
    'Color',[.3 .3 .3],...
    'LineWidth',3);

%% stat
[p,~,stats] = anova1(y');
[multistats] = multcompare(stats,'Display','off');
%%
xticks(1:3)
xticklabels({'Pre','Early','Late'});
ylim([0 1.1])
xlim([0.8 3.2])

ylabel('Spike numbers')
set(gca,'FontSize',18)
set(gcf,'color',[1 1 1])

%% plotting the latency of response
figure

for n=x
y(n,:)=cellfun(@(a,b) nanmean(a(a>0 & a<0.5)).*1000,t(ConditionCell==n));
end

hold on
for n=1:size(y,2)
    jitterx=x'+0.*rand(size(x'))
scatter(jitterx,y(:,n),200,...
    'MarkerFaceColor','flat',...
    'MarkerEdgeColor','flat',...
    'MarkerFaceAlpha',0.5,...
    'MarkerEdgeAlpha',0.5,...
    'MarkerFaceColor',co(coNum,:));
plot(jitterx,y(:,n),...
    'color',co(coNum,:),...
    'LineWidth',3)
end
%%
hold on
ymean=nanmean(y,2);
ystd=nanstd(y,0,2)
errorbar(x,ymean,ystd,'o-',...
    'MarkerSize',18,...
    'MarkerFaceColor',[.3 .3 .3],...
    'Color',[.3 .3 .3],...
    'LineWidth',3);
%% stat
[p,~,stats] = anova1(y');
[multistats] = multcompare(stats,'Display','off');
%%
xticks(1:3)
xticklabels({'Pre','Early','Late'});
ylim([0 350])
xlim([0.8 3.2])

ylabel('Latency of response (ms)')
set(gca,'FontSize',18)
set(gcf,'color',[1 1 1])

%% plotting the amp
figure

y=[];
for n=x
y(n,:)=cellfun(@(a,b) mean(b(a>0 & a<0.5)),t(ConditionCell==n),SpikeAmpCell(ConditionCell==n));
end

hold on
for n=1:size(y,2)
    jitterx=x'+0.*rand(size(x'))
scatter(jitterx,y(:,n),200,...
    'MarkerFaceColor','flat',...
    'MarkerEdgeColor','flat',...
    'MarkerFaceAlpha',0.5,...
    'MarkerEdgeAlpha',0.5,...
    'MarkerFaceColor',co(coNum,:));
plot(jitterx,y(:,n),...
    'color',co(coNum,:),...
    'LineWidth',3)
end
%%
hold on
ymean=nanmean(y,2);
ystd=nanstd(y,0,2)
errorbar(x,ymean,ystd,'o-',...
    'MarkerSize',18,...
    'MarkerFaceColor',[.3 .3 .3],...
    'Color',[.3 .3 .3],...
    'LineWidth',3);

%% stat
[p,~,stats] = anova1(y');
[multistats] = multcompare(stats,'Display','off');

%%
xticks(1:3)
xticklabels({'Pre','Early','Late'});
ylim([0 0.7])
xlim([0.8 3.2])

ylabel('Ampitude (dF/F0)')
set(gca,'FontSize',18)
set(gcf,'color',[1 1 1])