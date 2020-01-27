%mark spike timing of global ROI from several files-20200123

% insert the roi would like to analyze to n
% mark spike timing of different ROI from one file-20200123

clear
addpath(genpath('C:\Users\teamo\Google Drive\UChicago\Hansel lab\databackup'));


%% configure
paw_move=0; %%if the paw movement will be included in the figure choose 1, or choose others  
vel_ana=0; %if the motion activity will be included in the figure choose 1, or choose others  
blink_ana=0; %if the eye blink will be included in the figure choose 1, or choose others  
Air_puff=0; %if the air puff will be included in the figure choose 1, or choose others  
CrossCor=0; %if the cross correlation among signals will be analyzed choose 1
StackOrOverlap=0; %if the signals will be placed in stacks choose 1; if the signals will be placed overlapped choose 2
PlotMean=0; %if plot the mean of data
plotArea=1; %if plot the mean with shaded area as sdv

dimension=3; % analyze roi from a file insert 2, analyze roi from files insert 3
%n = ROI number I would like to analyze
n=[1:10];

% if different ROI are from the same cell and want to merge ROIs to one
% signal
if dimension==2
ROIgroup={};
else
ROIgroup={n};    %21  22    23    24    25    26    27    28    29    30    31    32    33    34    35    36    37};
end

ROIlabel=[cellfun(@num2str,num2cell(n),'uni',0)];

increvalue=1.5;

%set color
linecolor=[0.5 0 0];
meancolor=[1 0 0];

% linecolor=[0 0 0.5];
% meancolor=[0 0 1];

%% load ROI analysis data
all_velocity=[];
all_pks=[];
signal=[];

f=1;

filesize=0;
FN=cell(0);
FP=cell(0);

    [FileName,FolderPath] = uigetfile({'*.csv;*analysis.mat'},'Select an ROI file', 'Multiselect', 'on');
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
    %% read ROI size
    [ROIName,ROIPath] = uigetfile('*set.zip');
    [sROI] = ReadImageJROI([ROIPath,ROIName]);
    coords = cellfun(@(x) [x.mnCoordinates;x.mnCoordinates(1,:)], sROI, 'uni', 0);
    masks = cellfun(@(x) poly2mask(x(:,1), x(:,2), max(x(:)), max(x(:))), coords, 'uni', 0);
    weight=cell2mat(cellfun(@(x) sum(x(:)),masks, 'uni', 0));
    
    %% converge
    for group=1:length(ROIgroup)
    activ(:,group,:)=sum(weight(ROIgroup{group}).*signal(:,ROIgroup{group},:),2)./sum(weight(ROIgroup{group}),2);
    end
    signal=activ;
    n=1:length(ROIgroup);
end

    
    %% get time variables from file
    % Instead of time, we use ROI now
    
    %                     load(['D:\2pdata\Ting\GCaMP 20190820\820','\820_000_001','_ball.mat']);% load time dataset
    %     if isfile([FP{1},FN{1}(1:11),'_ball.mat'])
    %         load([FP{1},FN{1}(1:11),'_ball.mat']);
    %         balltime=time;
    %     elseif isfile([FP{1},FN{1}(1:11),'_eye.mat'])
    %         load([FP{1},FN{1}(1:11),'_eye.mat']);
    %     else
    %         load('D:\2pdata\Ting\time variables\011_006_002_eye')
    %         time=(time(1):time(930)/(930*2):time(end))';
    %     end
    time=1:size(signal,1);
    
    % if its's concatenated data, FramePerFile is the frame number of each
    % recording
    %     load([FP{1},FN{1}(1:11),'.mat']);
    FramePerFile=size(signal,1);
    
    
    % ratio of camera sampling rate and 2P sampling rate
    %     step=round(size(time,1)./FramePerFile);
    %time of the 2P signal
    %     time=time(1:step:step.*FramePerFile);
    %     FrameRate=mean(1./diff(time));
    FrameRate=60;
    
    % for concatenated data
    %     timestep=time;
    %     for ext_time=1:round(size(signal,1)/size(time,1))-1
    %         time=[time;time(end)+timestep];
    %     end

    %% analyze ROI
    figure;
    kn=get(gcf,'Number');
    defautPosition=get(gcf,'Position');
    set(gcf,'position',[1 1 defautPosition(3) 840]);
    BC_signal=[];
    
    % raw traces color
%     LC=copper(size(signal,3));%gradient color
    %     LC=winter(size(signal,2));%gradient color
    %     LC=[1 140/255 0].*ones(size(signal,2),3);%orange
    %     LC=[0 1 1].*ones(size(signal,2),3);%orange
    
%     co = colormap([0.031372549019608,0.250980392156863,0.505882352941176;...
%                 0.031372549019608,0.407843137254902,0.674509803921569;...
%                 0.168627450980392,0.549019607843137,0.745098039215686;...
%                 0.305882352941177,0.701960784313725,0.827450980392157;...
%                 0.482352941176471,0.800000000000000,0.768627450980392;...
%                 0.658823529411765,0.866666666666667,0.709803921568628;...
%                 0.800000000000000,0.921568627450980,0.772549019607843;...
%                 0.878431372549020,0.952941176470588,0.858823529411765]);
%             set(groot,'defaultAxesColorOrder',co);
incre=increvalue.*(1:size(signal,dimension)); %plot the signal from top to down

for nfile=1:size(signal,3)
    %background correction
    BC_signal=cat(3,BC_signal,FBackCorr(signal(:,:,nfile),FrameRate));

    for i=1:size(signal,2)
        increidx=[i nfile];
        plot(time,BC_signal(:,i,nfile)+incre(increidx(dimension-1)),'linewidth',2);
        %             ,'color',LC(nfile,:)
        yticks(incre)
        yticklabels(ROIlabel)
        hold on
    end
end

% plot stim
plot([928 928+31;928 928+31],[incre(1) incre(1);incre(end)+increvalue incre(end)+increvalue],'r');

    
%% select points    
terminate_key = 'T'; 
delete_prev_key = 'D'; 
add_key = 'A';
thatanan_key = 'N'; 
keystroke = 'G'; 
outputdata=[];
hold on;
point_plot = [];
title(sprintf('Press A to add, %s to add NaN, %s to delete , %s to terminate',...
    thatanan_key,delete_prev_key, terminate_key));

while ~strcmpi(keystroke, terminate_key)
    
    zoom on;
    pause()
    
    keystroke = upper(get(gcf, 'CurrentCharacter'));
    
    switch keystroke
        case add_key
            zoom off; % to escape the zoom mode
            rect = ginput(2);            
            [~, b_idxtime] = min(abs(time - rect(1,1)));
            [~, b_idxroi] = min(abs((BC_signal(b_idxtime,:)+incre)-rect(1,2)));
            [~, e_idxtime] = min(abs(time - rect(2,1)));
            [~, e_idxroi] = min(abs((BC_signal(b_idxtime,:)+incre)-rect(2,2)));
            
            outputdata=[outputdata;time(b_idxtime) BC_signal(b_idxtime,b_idxroi)+incre(b_idxroi),...
                time(e_idxtime) BC_signal(e_idxtime,e_idxroi)+incre(e_idxroi),...
                b_idxroi 0];
        case thatanan_key
            zoom off; % to escape the zoom mode
            rect = ginput(1);
            [~, n_idxtime] = min(abs(time - rect(1)));
            [~, n_idxroi] = min(abs((BC_signal(n_idxtime,:)+incre)-rect(2)));
            
            outputdata=[outputdata;time(n_idxtime) BC_signal(n_idxtime,n_idxroi)+incre(n_idxroi),...
                time(n_idxtime) BC_signal(n_idxtime,n_idxroi)+incre(n_idxroi),...
                n_idxroi 1];
        case terminate_key
            choice = questdlg('Would you like to terminate?', ...
                'Safeguard early termination', ...
                'Yes','No','No');
            if strcmpi(choice, 'No'), keystroke = 'C'; end
        case delete_prev_key
            zoom off; % to escape the zoom mode
            rect = ginput(1);
            [~, d_idxtime] = min(abs(time - rect(1)));
            [~, d_idxroi] = min(abs((BC_signal(d_idxtime,:)+incre)-rect(2)));
            
            d_roi=find(outputdata(:,5)==d_idxroi);
            [~,d_idx]=min(abs(mean(outputdata(d_roi,[1 3]),2)-d_idxtime));
            
            outputdata(d_roi(d_idx),:) = [];            
% outputdata(end,:) = [];  
    end   
    
    delete(point_plot);
    
    
    is_nan_values = outputdata(:,6) == 1;
    
    if any(~is_nan_values)
        point_plot(1) = plot(outputdata(~is_nan_values,1), outputdata(~is_nan_values,2), 'ko', 'markersize', 8);
        point_plot(2) = plot(outputdata(~is_nan_values,1), outputdata(~is_nan_values,2), 'k+', 'markersize', 8);
        point_plot(3) = plot(outputdata(~is_nan_values,3), outputdata(~is_nan_values,4), 'bo', 'markersize', 8);
        point_plot(4) = plot(outputdata(~is_nan_values,3), outputdata(~is_nan_values,4), 'b+', 'markersize', 8);
    end
    if any(is_nan_values)
        point_plot(5) = plot(outputdata(is_nan_values,1), outputdata(is_nan_values,2), 'ro', 'markersize', 8);
        point_plot(6) = plot(outputdata(is_nan_values,1), outputdata(is_nan_values,2), 'r+', 'markersize', 8);
    end
end
outputdata = unique(outputdata, 'rows'); 

%%
% outputdata(outputdata(:,4)==1,1)=nan;
outputmat = cell(max(outputdata(:,5)), 1);

%% sorting
for roi=1:max(outputdata(:,5))
    [~,I]=sort(outputdata(outputdata(:,5)==roi,1));
outputmat{roi}=outputdata(outputdata(:,5)==roi,[1 3 6]);
outputmat{roi}=outputmat{roi}(I,:);

end

%% replace the idx with nan
% for roi=1:max(outputdata(:,5))
% outputmat{roi}(outputmat{roi}(:,3)==1,[1 2])=nan;
% end

%% transfer cell to mat
% outputmat = horzcat(outputmat{:});
% outputmat(:,2:2:end)=[];
%% save data
FileName = fullfile(FolderPath, FileName); 
if iscell(FileName)
FileName=[FileName{1}(1:end-28),'-',FileName{end}(end-30:end)];
end

roi_number = n;
file_name_to_save = sprintf('%s%s_ca_timing.mat', ...
    regexprep(FileName, '.mat', ''), ...
    sprintf('_%d', roi_number)); 
save(file_name_to_save, 'outputmat', 'roi_number', 'FN'); 