%% Define general variables
[ROI_filename, path_name] = uigetfile('*ROI*.mat', ...
    'Choose file to visualize', 'MultiSelect','off');
file2open = [path_name ROI_filename];

load(file2open);

num_rois = length(ROI_names);
t = data.t;
%% POSSIBLE_TYPES
%  F
%  Fc
%  Fc_smoothed
%  Fc3
%  Fc3_smoothed

type_label = struct(); 
type_label.F            = 'Raw F'; 
type_label.Fc           = 'dF/F0'; 
type_label.Fc_smoothed  = 'Smoothed dF/F0'; 
type_label.Fc3          = 'Thresholded dF/F0'; 
type_label.Fc3_smoothed = 'Smoothed thresholded dF/F0'; 

%% Plotting separately
TYPE_FLUO = 'F';
FURTHER_SMOOTH = 1; 

figure;
nsplt = ceil(sqrt(num_rois));
dat2plt = data.(TYPE_FLUO);
lim_y = [min(dat2plt(:)), max(dat2plt(:))];
label = type_label.(TYPE_FLUO); 

for i = 1:num_rois
    
    subplot(nsplt,nsplt,i); hold on 
    plt_i = FtoFc(dat2plt(:,i), length(t)/5); 
%     plt_i = smooth(dat2plt(:,i),FURTHER_SMOOTH);

%     findpeaks(plt_i,t,'MinPeakProminence', 0.35, 'MinPeakDistance', 0.5)
    plot(t, plt_i, ...
        '-', 'LineWidth', 1,'color',[0.3,0.1,0.9]);
    
    xlim(t([1,end]));
%     ylim(lim_y);
    
    title(ROI_names{i}, 'fontsize', 15, 'fontweight', 'normal');
    xlabel('Time (s)', 'fontsize', 12);
    ylabel(label, 'fontsize', 12);
    box off
end


%% Find peaks 
TYPE_FLUO = 'Fc';
SMOOTH_WIN = 5; 
PEAK_PRM = {'MinPeakProminence', 0.35, 'MinPeakDistance', 0.2}; 
T_WIN = ceil(0.5*PEAK_PRM{4}); 


nsplt = ceil(sqrt(num_rois));
dat2plt = data.(TYPE_FLUO);
lim_y = [min(dat2plt(:)), max(dat2plt(:))];
label = type_label.(TYPE_FLUO); 

CSV_MATRIX = cell(num_rois,1); 
for i = 1:num_rois
    figure('Color',[1,1,1],  'units', 'normalized','position', [0.1,0.1,0.4,0.2]);
%     subplot(nsplt,nsplt,i); 
    hold on 
    dat_i = dat2plt(:,i);
    smoothed_i = smooth(dat_i,SMOOTH_WIN);
    [smoothedpeak,smoothedlocs] = findpeaks(smoothed_i,t,PEAK_PRM{:}); 
    rawpeak = arrayfun(@(x) max(dat_i(t >= x-T_WIN & t <= x+T_WIN)), smoothedlocs, 'uni', 1); 
    rawlocs = arrayfun(@(x,y) t(dat_i' == x & t >= y-T_WIN & t <= y+T_WIN), rawpeak, smoothedlocs, 'uni', 1);

    pklc = [rawpeak; rawlocs]; 
    pklc = pklc(:)'; 
    
    num_peak = length(rawpeak); 
    avr_peak = mean(rawpeak); 
    CSV_MATRIX{i} = {ROI_names{i}, ...
        num_peak, avr_peak, pklc}; 
    findpeaks(smoothed_i,t,PEAK_PRM{:}); 
    plot(t, dat2plt(:,i), ...
        '-', 'LineWidth', 1,'color',[0.3,0.1,0.9]);
    arrayfun(@(x,y) plot([x,x],[0,y],'-r','LineWidth',1), rawlocs, rawpeak); 
    
    xlim(t([1,end]));
    ylim(lim_y);
    
    title(ROI_names{i}, 'fontsize', 15, 'fontweight', 'normal');
    xlabel('Time (s)', 'fontsize', 12);
    ylabel(label, 'fontsize', 12);
    box off
end


%% Plotting together
PATTERN = 'S[3-8]$';
TYPE_FLUO = 'Fc';
FURTHER_SMOOTH = 5; 

% roi_idx = contains(ROI_names, PATTERN);
roi_idx = find(cellfun(@(x) ~isempty(regexp(x, PATTERN, 'once')), ROI_names, 'uni', 1)); 
actual_idx = cellfun(@(x) str2double(regexp(x,'\d','match')), ROI_names(roi_idx), 'uni', 1); 
[~,ordered_idx] = sort(actual_idx); 
roi_idx = roi_idx(ordered_idx); 
roi2plt = ROI_names(roi_idx);
dat2plt = data.(TYPE_FLUO);
dat2plt = dat2plt(:,roi_idx);
label = type_label.(TYPE_FLUO);

nroi2plt = length(roi_idx); 
figure; set(gcf, 'units', 'normalized', 'position', [0.1,0.1,0.4,0.2]); 
hold on;
lim_y = [min(dat2plt(:)), max(dat2plt(:))];
lim_y = lim_y + 0.5*[-1,1]*abs(diff(lim_y)); 

% cmap = hsv(nroi2plt)*0.8; 
% cmap = rand(nroi2plt,3); 
cmap = 0.8*parula(nroi2plt);
for i = 1:nroi2plt
    plot(t, smooth(dat2plt(:,i),FURTHER_SMOOTH),...
        'LineWidth', 1.25, 'Color', cmap(i,:));
end
xlim(t([1,end]));
ylim(lim_y);

% title(sprintf('%s of ROIs from %s', label, PATTERN), ...
%     'fontsize', 15, 'fontweight', 'normal');
xlabel('Time (s)', 'fontsize', 12);
ylabel(label, 'fontsize', 12);
box off 
legend(roi2plt, 'fontsize', 10);

set(gcf, 'Color',[1,1,1]);
