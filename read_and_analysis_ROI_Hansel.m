clear; 
%% Parameters for extraction/deconvolution 
def_inp = {'1','20','20','Y','15'}; 

prompts = {sprintf('Measurement column (from ImageJ) (default = %s)', def_inp{1}), ...
    sprintf('Scale window for normalization (default = %s)', def_inp{2}), ...
    sprintf('Smoothing window to smooth fluorescence data (default = %s)', def_inp{3}), ...
    sprintf('Did you scan in Scanbox? (default = %s) \n If Yes, ignore following.', def_inp{4}), ...
    sprintf(['If you did NOT scan in Scanbox, what is the frame rate?\n' ...
            'If unknown, the default will be 15 fps'], def_inp{5})}; 

answers = inputdlg(prompts,'Edit parameters for analysis',[1,60],def_inp);

measurements = str2double(answers{1}); 
scalewindow =  str2double(answers{2});  %#of frames should be set differently according to the data
smoothwindow =  str2double(answers{3});  % for smoothing fluorescence

if any(isnan([measurements,scalewindow,smoothwindow]))
    error('The first 3 inputs must be numeric. One of them was not. Please rerun!'); 
end

FRAMERATE_ANSWER = answers{4};
if strcmpi(FRAMERATE_ANSWER, 'Y') || strcmpi(FRAMERATE_ANSWER, 'Yes')
    %% THE INFO FILE AND DATA FILE NEED TO BELONG TO THE SAME EXPERIMENT
    % Obtain info
    [info_filename, path_name]=uigetfile('*.mat', 'Choose INFO file to load:','MultiSelect','off');
    load([path_name info_filename]);
    FrameRate = info.resfreq/info.recordsPerBuffer;
else     
    %% Assigning frame rate 
    FrameRate = str2double(answers{5});
    if isnan(FrameRate) 
        error('The input frame rate must be numberic');
    end
end
    
%% Obtain data
% Open path 
[ROI_filename, path_name]=uigetfile('*.csv', 'Choose ROI file to load:','MultiSelect','off');
file2open = [path_name ROI_filename];

% Get header 
fobj = fopen(file2open);
header = textscan(fobj,'%s',1);
header = header{1}{1};
header = strsplit(header,',');
fclose(fobj);
ROI_names = regexprep(header, {'Mean', '_', '(', ')'}, ''); 

% Get data
% make sure file only has 1st line as header
temp_data = csvread(file2open,1,0); 
 
% Skip first column (cuz it's indices) 
ROI_names(1)= ''; 
temp_data(:,1)=[];

%% Fluorescence extraction/normalization/thresholding 
F   = temp_data(:, measurements:measurements:size(temp_data,2)); 
Fc  = FtoFc(F,scalewindow);
success_conversion = false; 
while ~success_conversion
    try
        Fc3 = FctoFc3(Fc,upperbase(Fc,true));
        success_conversion = true; 
    catch
        msgbox({'"Fc" to "Fc3" conversion failed due to weird threshold selection!',...
            'Please select again!'});
        success_conversion = false; 
    end
end

for i=1:size(Fc,2)
   Fc_smoothed(:,i) = smooth(Fc(:,i),smoothwindow);
%    Fc3_smoothed(:,i)=FctoFc3(Fc_smoothed(:,i),upperbase(Fc_smoothed(:,i),true)); % try this
end

success_conversion = false; 
while ~success_conversion
    try
        Fc3_smoothed = FctoFc3(Fc_smoothed,upperbase(Fc_smoothed,true));
        success_conversion = true; 
    catch        
        answer = questdlg({'"Fc_smoothed" to "Fc3_smoothed" conversion failed due to weird threshold selection', ...
            'Do you want to reselect or continue without having "Fc3_smoothed"'},...
            'Conversion issue','Reselect','Continue','Continue');
        switch lower(answer) 
            case 'reselect'
                success_conversion = false; 
            case 'continue' 
                Fc3_smoothed = 'WAS NOT GENERATED DURING ANALYSIS'; 
                success_conversion = true; 
        end
    end
end


% Construct a time vector 
t = (0:(length(F(:,1))-1)) / FrameRate;
%% Saving data 
data.t = t; 
data.F = F;
data.Fc = Fc;
data.Fc_smoothed = Fc_smoothed;
data.Fc3 = Fc3;
data.Fc3_smoothed = Fc3_smoothed;

var2save = {'FrameRate', 'data', 'ROI_names'}; 

file_pref = [path_name ROI_filename(1:end-4)]; 
if exist([file_pref '_ROIs.mat'], 'file')==2
    newname = uiputfile('*.mat','Name already exists. Please select new filename for data file',[file_pref '_handROIs']);
    save([path_name newname], var2save{:});
else
    save([file_pref sprintf('_ROIs_sw%d.mat', scalewindow)], var2save{:});
end
