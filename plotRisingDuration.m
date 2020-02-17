% plot 1) spike number, 2) latency of response 3) amplitudes
% before plotting, open a time variable data is necessary
% better not run the whole function. 
% Instead, run every single block (see loading file section)-20200130

clearvars -except time
filesize=0;
FN=cell(0);
FP=cell(0);
SpikeIDX=[];
ConditionCell=[];
%% reading file
% step 1: go to the directory of where the *Spike.mat data are
% step 2: select all the pre-tetanus data and click select.
% step 3: the select data interface will pump up again, then select the
% early-post and then do the same thing for the late-post data.
% step 4: go to the directory of *Spike.mat data in the other days, and the
% do the same things

f=1;
while f
    [FileName,FolderPath] = uigetfile({'*timing.mat;*timinglist.mat'},'Select SpikeData files', 'Multiselect', 'on');
    
    if FolderPath==0;f=0;end
    
    if iscell(FileName)
        NewAddFile=size(FileName,2);
    elseif FileName~=0
        NewAddFile=1;
        if strfind(FileName,'timinglist')
            load([FolderPath,FileName])
            NewAddFile=size(FN,1);
        end
    else
        NewAddFile=0;
    end
    
    if NewAddFile~=0;
        if ~size(strfind(FileName,'timinglist'),1)|iscell(FileName)
            for fnumber=1:NewAddFile
                if iscell(FileName)
                    FN=cat(1,FN,FileName{fnumber});
                else
                    FN=cat(1,FN,FileName);
                end
                FP=cat(1,FP,FolderPath);
            end
            ConditionCell=vertcat(ConditionCell,f.*ones(NewAddFile,1));
            f=f+1;
        end
        
        Import_data=cellfun(@(x,y) importdata([x,y]),FP(filesize+1:filesize+NewAddFile),FN(filesize+1:filesize+NewAddFile));
        filesize=filesize+NewAddFile;
        
        for importN=1:NewAddFile
        SpikeIDX=vertcat(SpikeIDX,{cell2mat(Import_data(importN).outputmat)});
        end
        

        
    end
end

%% save the timing list of each cell
 % in the future, instead of open individual files one by one, a list file
 % could call all the individual file at once
    [file,path] = uiputfile('introduced controlled_timinglist.mat','save list of timing data for a specific condition')
    if path~=0
    save([path file],'FN','FP','ConditionCell');
    end
%% plotting the spike number within "window" sec after stim
window=0.5;

co=colormap(lines);
% co=[71, 97, 157;...
%     209, 55, 107;...
%     255, 164, 57;...
%     57, 195, 177]./255;
interval=mean(diff(time)).*1000;

x=1:3;
RisingDuration=cell2mat(cellfun(@(x) mean(interval.*(x(x(:,3)==0,2)-x(x(:,3)==0,1))),SpikeIDX,'uni',0));
for n=x
y(n,:)=RisingDuration(ConditionCell==n);
end

figure
coNum=1;

hold on
for n=1:size(y,2)
%     coNum=n+2;
    jitterx=x'+0.*rand(size(x'))
scatter(jitterx,y(:,n),200,...
    'MarkerFaceColor','flat',...
    'MarkerEdgeColor','flat',...
    'MarkerFaceAlpha',0.2,...
    'MarkerEdgeAlpha',0.2,...
    'MarkerFaceColor',co(coNum,:));
h=plot(jitterx,y(:,n),...
    'color',co(coNum,:),...
    'LineWidth',3)
h.Color(4) = 0.2;
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
[p,~,stats] = anova1(y',[],'off');
[multistats] = multcompare(stats,'Display','off');
%%
xticks(1:3)
xticklabels({'Pre','Early','Late'});
ylim([0 90])
xlim([0.8 3.2])

ylabel('Rise time (ms)')
set(gca,'FontSize',18)
set(gcf,'color',[1 1 1])

