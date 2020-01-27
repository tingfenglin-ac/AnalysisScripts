clear all;

%% parameters
measurements=2;
scalewindow=50; %#of frames should be setted differently according to the data

%%get data
[ROI_filepaths, temp]=uigetfile('*.csv', 'Chose cellsort files to load:','MultiSelect','on');
temp_data=xlsread([temp ROI_filepaths]); 
temp_data(:,1)=[];
F=temp_data(:,2:measurements:size(temp_data,2)); 

Fc = FtoFc(F,scalewindow);
Fc3 = FctoFc3(Fc,upperbase(Fc,true));

for i=1:size(Fc,2)
   Fc_smoothed(:,i) = smooth(Fc(:,i),5);
%    Fc3_smoothed(:,i)=FctoFc3(Fc_smoothed(:,i),upperbase(Fc_smoothed(:,i),true)); % try this
end
Fc3_smoothed = FctoFc3(Fc_smoothed,upperbase(Fc_smoothed,true));


data.F = F;
data.Fc = Fc;
data.Fc_smoothed = Fc_smoothed;
data.Fc3 = Fc3;
data.Fc3_smoothed = Fc3_smoothed;
% data.segments = segments;

if exist([temp ROI_filepaths(1:end-4) '_ROIs.mat'], 'file')==2
newname= uiputfile('*.mat','Already name already exists. Please select new filename for data file',[temp ROI_filepaths(1:end-4) '_handROIs']);
save([temp newname],'data');
else
save([temp ROI_filepaths(1:end-4) '_ROIs_sw500.mat'],'data');
end