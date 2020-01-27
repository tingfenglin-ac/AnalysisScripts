%% PIPELINE 2P DATA PROCESSING 
% Code from Sheffield's lab 
% Adpated for Hansel's lab 

%% Adding essential paths 
addpath('C:\Users\lab\Desktop\scripts'); 

%% Converting SBX files to TIF 
% 1. First locate to the folder of files 

% 2. Open either of these versions 
% 2.a. Edited version, select the following then "Evaluate" or "F9" it 
open sbx2tif_shef_hanseledits

% 2.b. Original Sheffield
%      Note: there's a bug if you want to do a bunch of files with
%      different 

% Uncomment the following (Ctrl + T):
% open sbx2tif_shef

% 3. In the function, edit as instructed





% 4. Then click "Run" or press "F5" 

%% Batch motion correction 
open Batch_motion_correct_shef

%% Analyze and save data 
% 1. Open either of these scripts
% 2. Change these parameters that best fit your data and desired analysis
%       measurements:   which index in your CSV file containing the data 
%       scalewindow:    scaling window? like for smoothing - we think 
%       smoothwindow:   the bigger the smoother the `Fc*smoothed` 

% 1.a. Edited version 
open read_and_analysis_ROI_Hansel

% 1.b. Original Sheffield 
% open read_and_analysis_ROI

%% Visualization 
open visualize_ROItraces_Hansel.m 