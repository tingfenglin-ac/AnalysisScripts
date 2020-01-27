addpath('C:\Users\lab\Desktop\scripts\subroutine');

%% configure
paw_move=0; %%if the paw movement will be included in the figure choose 1, or choose others  
vel_ana=0; %if the motion activity will be included in the figure choose 1, or choose others  
blink_ana=0; %if the eye blink will be included in the figure choose 1, or choose others  
Air_puff=1; %if the air puff will be included in the figure choose 1, or choose others  
CrossCor=0; %if the cross correlation among signals will be analyzed choose 1
StackOrOverlap=1; %if the signals will be placed in staks choose 1; if the signals will be placed overlapped choose 2
PlotMean=1; %if plot the mean of data
plotArea=1; %if plot the mean with shaded area as sdv

%n = ROI number I would like to analyze
n=[1:8 13];

%set color
linecolor=[0.5 0 0];
meancolor=[1 0 0];

% linecolor=[0 0 0.5];
% meancolor=[0 0 1];

%% read aligned velocity data
[FileName,FolderPath] = uigetfile('*speed.mat','Select aligned speed data');
load([FilePath,FolderName])

%% read Ca activity data
for fnumber=1:length(SelectedFile)
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
    
