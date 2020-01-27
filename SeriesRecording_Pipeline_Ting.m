
addpath(genpath('C:\Users\lab\Desktop\scripts'));

%% analyze series of Ca signal
%concatenate series of 2P image
TiffConcatenator;

%motion correct 2P image
motion_correct_shef

%split 2P image
TiffSplitter;

% analyze ROI
ROI2signal;

%visulization ROI data
ShowROIdata_2;

%visulization ROI data
ShowROIdata_3;

%visualize dF/F0 traces of spontaneous spikes (threshold the global fluorescence)
ShowROIdata_ResponsiveSpecific;

%visualize dF/F0 traces of spontaneous spikes (threshold the local fluorescence)
%output spike data (time and amp)
ShowROIdata_ResponsiveSpecific_v2;
%% analyze treadmill velocity
% transfer ball tracker matrix data from matlab file to AVI file
Frame2AVI_2v;

% analyze treadmill velocity 
balltrackerestimation_3v;

% align treadmill movement data and save the idx
AlignVelocity;

% ploting Ca activity and aligned velocity data
ShowROIdata_AlignVelocity_2v;

%% analyze the caclium distribution
CaDistribution;

open CaDistribution_v2;%plot the post-stimulus Ca signal heatmap

CaDistribution_v3; %heatmap of spontaneous spke

PCAspike %pca analysis and statistic comparison of multiple ROIs

CaDistribution_MultiTrial;

%% analyze the frequency

deconvolveCa