%% Run_by_hand_ROIs

% allows user to run "by_hand_ROIs.m and save output as a .mat structure
% called 'data' which contains the location of selected segments as well as
% F, Fc, and Fc3 for each of those segments.


[FileName,PathName,FilterIndex] = uigetfile('*.tif','select the tiff you wish to analyze');

[segments, F, Fc, Fc_smoothed, Fc3, Fc3_smoothed] = by_hand_ROIs([PathName FileName]);

data.F = F;
data.Fc = Fc;
data.Fc_smoothed = Fc_smoothed;
data.Fc3 = Fc3;
data.Fc3_smoothed = Fc3_smoothed;
data.segments = segments;

if exist([PathName FileName(1:end-4) '_handROIs.mat'], 'file')==2
newname= uiputfile('*.mat','Already name already exists. Please select new filename for data file',[PathName FileName(1:end-4) '_handROIs']);
save([PathName newname],'data');
else
save([PathName FileName(1:end-4) '_handROIs'],'data'); 
end




