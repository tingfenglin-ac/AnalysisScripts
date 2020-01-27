clear
addpath(genpath('C:\Users\lab\Desktop\scripts'));


%% configure
paw_move=0; %%if the paw movement will be included in the figure choose 1, or choose others  
vel_ana=0; %if the motion activity will be included in the figure choose 1, or choose others  
blink_ana=0; %if the eye blink will be included in the figure choose 1, or choose others  
Air_puff=0; %if the air puff will be included in the figure choose 1, or choose others  
CrossCor=0; %if the cross correlation among signals will be analyzed choose 1
StackOrOverlap=1; %if the signals will be placed in stacks choose 1; if the signals will be placed overlapped choose 2
PlotMean=0; %if plot the mean of data
plotArea=1; %if plot the mean with shaded area as sdv
useFilter=1; % cut out extrem large spike

n=[1:40];
ROIgroup={[1:35] ,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35 };
ROIlabel=[{'cell 1'} cellfun(@num2str,num2cell(1:35),'uni',0)];
increvalue=2;
%set color
linecolor=[0.5 0 0];
meancolor=[1 0 0];

% linecolor=[0 0 0.5];
% meancolor=[0 0 1];

%% load ROI analysis data
all_velocity=[];
all_pks=[];


f=1;
FolderPath=1;
filesize=0;
FN=cell(0);
FP=cell(0);
Groupedsignal=cell(0)
ROIPath=[];
while FolderPath~=0
    signal=[];
    activ=[];
    [FileName,FolderPath] = uigetfile({'*.csv;*analysis.mat'},'Select an ROI file', 'Multiselect', 'on');
    if FolderPath~=0
    if iscell(FileName)
        NewAddFile=size(FileName,2);
    elseif FileName~=0
        NewAddFile=1;
    else
        NewAddFile=0;
    end
    filesize=filesize+NewAddFile;
    
    for fnumber=1:NewAddFile
        if iscell(FileName)
            FN=cat(1,FN,FileName{fnumber});
        else
            FN=cat(1,FN,FileName);
        end
        FP=cat(1,FP,FolderPath);
        if strfind(FN{end},'csv')
            Import_data=importdata([FP{end},FN{end}]);
            signal=cat(3,signal,Import_data.data(:,3+(n-1)*2));
        else
            Import_data=load([FP{end},FN{end}]);
            signal=cat(3,signal,Import_data.activs(:,n));
        end
    end
    
    FN
    
    
    if length(ROIgroup)
        if length(ROIPath)==0
            %% read ROI size
            [ROIName,ROIPath] = uigetfile('*set.zip');
            [sROI] = ReadImageJROI([ROIPath,ROIName]);
            coords = cellfun(@(x) [x.mnCoordinates;x.mnCoordinates(1,:)], sROI, 'uni', 0);
            masks = cellfun(@(x) poly2mask(x(:,1), x(:,2), max(x(:)), max(x(:))), coords, 'uni', 0);
            weight=cell2mat(cellfun(@(x) sum(x(:)),masks, 'uni', 0));
        end
        
        %% converge
        for group=1:length(ROIgroup)
            activ(:,group,:)=sum(weight(ROIgroup{group}).*signal(:,ROIgroup{group},:),2)./sum(weight(ROIgroup{group}),2);
        end
%         signal=activ;
        
    end
    Groupedsignal=[Groupedsignal activ];
    end
end
    n=1:length(ROIgroup);
    %% get time variables from file
    %                     load(['D:\2pdata\Ting\GCaMP 20190820\820','\820_000_001','_ball.mat']);% load time dataset
    if isfile([FP{1},FN{1}(1:11),'_ball.mat'])
        load([FP{1},FN{1}(1:11),'_ball.mat']);
        balltime=time;
    elseif isfile([FP{1},FN{1}(1:11),'_eye.mat'])
        load([FP{1},FN{1}(1:11),'_eye.mat']);
    else
        load('D:\2pdata\Ting\time variables\011_006_002_eye')
        time=(time(1):time(930)/(930*2):time(end))';
    end
    
    % if its's concatenated data, FramePerFile is the frame number of each
    % recording
    load([FP{1},FN{1}(1:11),'.mat']);
    FramePerFile=info.config.frames;
    
    
    % ratio of camera sampling rate and 2P sampling rate
    step=round(size(time,1)./FramePerFile);
    %time of the 2P signal
    time=time(1:step:step.*FramePerFile);
    FrameRate=mean(1./diff(time));
    
    
    % for concatenated data
%     timestep=time;
%     for ext_time=1:round(size(signal,1)/size(time,1))-1
%         time=[time;time(end)+timestep];
%     end   

    %% analyze ROI
  
            
    %pool data from different groups
    idxgroup=[];
    signal=[];
    for group=1:length(Groupedsignal)
        signal=cat(3,signal,Groupedsignal{group});
        idxgroup=[idxgroup repmat(group,1,size(Groupedsignal{group},3))];
    end
    idxgroup=repmat(idxgroup,size(signal,1),1);
    idxgroup=idxgroup(:);
    
    BC_signal=[];
    for   nfile=1:size(signal,3)
        %background correction
        BC_signal=cat(3,BC_signal,FBackCorr(signal(:,:,nfile),FrameRate));  
           
        %ploting signal
        if StackOrOverlap==1    
            incre=increvalue.*(1:size(signal,2)); %plot the signal from top to down
        else
            incre=zeros(size(signal,2));
        end
    end
    
    
%% PCA
thr=0.09; %threshold
window=10; % time wiwndow for the median 

concatBC_signal=[];
concattime=0;

for filen=1:size(BC_signal,3)
concatBC_signal=[concatBC_signal;BC_signal(:,:,filen)];
end
concattime=repmat(time,size(BC_signal,3),1);



%get rid of extreme number
% if useFilter==1
% thr_ext=0.6;
% keepn=find(concatBC_signal(:,1)<thr_ext);
% losen=find(concatBC_signal(:,1)>thr_ext);
% time_temp=concattime(keepn);
% BC_signal_temp=concatBC_signal(keepn,:);
% for t=1:3
% intersignal(:,t)=interp1(keepn,BC_signal_temp(:,t),1:length(concattime))';
% end
% concatBC_signal=intersignal;
% end

[~,locs]=findpeaks(smooth(concatBC_signal(:,1),window), 'MinPeakProminence', thr, 'MinPeakDistance', window);

% get average value around peaks
d_points = floor(window/2); 
IDX = arrayfun(@(x) (x-d_points):(x+d_points), locs, 'uni', 0); 
peaks_rois = cellfun(@(x) mean(concatBC_signal(x,:), 1),IDX, 'uni', 0);
peaks_rois = cell2mat(peaks_rois);

baseline=concattime(locs)>1 & concattime(locs)<10;
response=concattime(locs)>10 & concattime(locs)<10.5;

[coeff,score,latent] = pca(peaks_rois(logical(baseline+response),2:end));



% linecolor=[71, 97, 157;...
%     209, 55, 107;...
%     255, 164, 57;...
%     57, 195, 177]./255;
linecolor=return_colorbrewer('Dark2');
mksize=10;
stim_num=2;%how many stimulation conditions
figure;hold on;
prestim=ismember(idxgroup(locs(baseline)),1:stim_num);
plot3(score(prestim,1),score(prestim,2),score(prestim,3),'ko','MarkerSize',mksize);

for group=1:stim_num
stim{group}=ismember(idxgroup(locs(response)),group);
plot3(score(stim{group},1),score(stim{group},2),score(stim{group},3),'o','color',linecolor(group,:),'MarkerSize',mksize)
end


prestim=ismember(idxgroup(locs(baseline)),stim_num+1:2.*stim_num);
plot3(score(prestim,1),score(prestim,2),score(prestim,3),'ko','MarkerFaceColor',[0.5,0.5,0.5],'MarkerSize',mksize)

for group=stim_num+1:2.*stim_num
stim{group}=ismember(idxgroup(locs(response)),group);
plot3(score(stim{group},1),score(stim{group},2),score(stim{group},3),'o',...
    'color',linecolor(group-stim_num,:),...
    'MarkerFaceColor',linecolor(group,:),...
    'MarkerSize',mksize)
end
% 
% legend('prestim & pretetanus',...
%     'location 1 & pretetanus',...
%     'location 2 & pretetanus',...
%     'location 3 & pretetanus',...
%     'location 4 & pretetanus',...
%     'prestim & posttetanus',...
%     'location 1 & posttetanus',...
%     'location 2 & posttetanus',...
%     'location 3 & posttetanus',...
%     'location 4 & posttetanus');

set(gcf,'color',[1 1 1]);
xlabel('PC1');
ylabel('PC2');

% ylim([-0.5 0.5])
% xlim([-2 7])
% 
% audi= concattime(locs)<0.5 & ismember(idxgroup(locs),1:4);
% plot(score(prestim,1),score(prestim,2),'ro')
% 
% prestim=concattime(locs)>1 & concattime(locs)<0.5 & ismember(idxgroup(locs),5:8);
% plot(score(prestim,1),score(prestim,2),'ro','MarkerFaceColor',[0.5])
% 
% figure
% for trace=1:size(concatBC_signal,2)
% plot(smooth(concatBC_signal(:,trace),window)+trace*ones(size(concatBC_signal,1),1))
% hold on
% plot(locs,peaks_rois(:,trace)+trace*ones(size(peaks_rois,1),1),'ro')
% end


%% comparing two set of data

preteta=peaks_rois(logical(response)&ismember(idxgroup(locs),1:stim_num),:);
postteta=peaks_rois(logical(response)&ismember(idxgroup(locs),stim_num+1:2.*stim_num),:);

h=[];
p=[];
stats=[];

for roi=n
[h(roi),p(roi),ci,stats] = ttest2(preteta(:,roi),postteta(:,roi));
popustd(roi)=stats.sd;
end
h=logical(h);

figure
X = categorical(ROIlabel);
X = reordercats(X,ROIlabel);
% bar(X,[mean(preteta)' mean(postteta)'],'FaceColor','flat');
b=bar(X,[mean(preteta)' mean(postteta)'],'FaceColor','flat');
for k = 1:2
    b(k).CData = k;
end


% signinificant symbol
Si='*';
cellfun(@(x,y,z) text(x-0.1,y+0.01,Si(z),'FontSize',20),num2cell(n),num2cell(max([mean(preteta)' mean(postteta)'],[],2))',num2cell(h),'uni',0)


set(gcf,'color',[1 1 1]);

%%
% 
[Xmasks Ymasks]=cellfun(@find,masks,'uni',0);
xydimension=cell2mat(cellfun(@size,masks,'uni',0)');
ROIheatmap=zeros(max(xydimension));
for group=2:length(ROIgroup)
    addingarea=ROIheatmap(1:xydimension(ROIgroup{group},1),1:xydimension(ROIgroup{group},2));
    ROIheatmap(1:xydimension(ROIgroup{group},1),1:xydimension(ROIgroup{group},2))=addingarea+masks{ROIgroup{group}}.*(mean(postteta(:,group))-mean(preteta(:,group)))/popustd(group);
end
figure
cmap_mat = flipud(return_colorbrewer('RdBu', 1000));
colormap(cmap_mat);
imagesc(ROIheatmap)
axis image;
colorbar
caxis([-0.7 0.7]);

hold on
[centerX centerY]=cellfun(@(x) centroid(polyshape(x(:,1), x(:,2))), coords(cell2mat(ROIgroup(2:end))), 'uni', 0);
cellfun(@(x,y) plot(x,y,'m*'),centerX(h(2:length(h))),centerY(h(2:length(h))),'uni',0)

%%
% peaks_rois = arrayfun(@(x) smooth(concatBC_signal(:,x),window), 1:size(concatBC_signal,2), 'uni', 0);
% peaks_rois = horzcat(peaks_rois{:});
% 
% select_time = concattime > 10 & concattime < 16 & (idxgroup == 2 | idxgroup == 6);
% [coeff,score,latent] = pca(peaks_rois(select_time,2:end));
% 
% time_vec = concattime(select_time); 
% idxgroup_vec = idxgroup(select_time); 
% % idx_select4time = idxgroup_vec == 6;
% stim_select = find(time_vec > 15 & time_vec < 16); 
% base_select = find(time_vec > 10 & time_vec < 15); 
% % aftr_select = find(time_vec > 16 & time_vec < 17); 
% 
% begin_trial_indices = [1;find(diff(time_vec) < 0)+1]; 
% end_trial_indices = [begin_trial_indices(2:end)-1;length(time_vec)]; 
% 
% base_colors = [0.7,0.7,0.7,0.5];
% stim_colors = [0.7,0.1,0.2,0.9];
% aftr_colors = [0.1,0.3,0.8];
% 
% num_steps = end_trial_indices(1) - begin_trial_indices(1);
% figure;
% for i = 1:num_steps
%      hold on; 
% for ind = 1:length(begin_trial_indices) 
%     b_ind = begin_trial_indices(ind);
%     e_ind = end_trial_indices(ind);
%     stim_ind = stim_select(stim_select >= b_ind & stim_select <= e_ind); 
%     base_ind = base_select(base_select >= b_ind & base_select <= e_ind); 
%     if idxgroup_vec(b_ind+2) == 2, break; end 
% %     aftr_ind = aftr_select(aftr_select >= b_ind & aftr_select <= e_ind);
%     ind_vec = b_ind : e_ind; 
%     %     plot3(score(base_ind,1), score(base_ind,2), score(base_ind,3), 'color', base_colors);
%     %     plot3(score(stim_ind,1), score(stim_ind,2), score(stim_ind,3), 'color', stim_colors);
%     %     plot3(score(aftr_ind,1), score(aftr_ind,2), score(aftr_ind,3), 'color', aftr_colors);
%     
%     if isempty(find(stim_ind == ind_vec(i),1))       
%         plot3(score(ind_vec(1:i),1), score(ind_vec(1:i),2), score(ind_vec(1:i),3), 'color', base_colors);
%     else
%         plot3(score(base_ind,1), score(base_ind,2), score(base_ind,3), 'color', base_colors);
%         mystim = base_ind(end) : ind_vec(i);
%         plot3(score(mystim,1), score(mystim,2), score(mystim,3), 'color', stim_colors);
%     end
% end
% view([-45, 40]);
% title(sprintf('i = %d', i));
% pause(0.005);
% if i < num_steps, cla;end 
% end