%% Plot F and norm F (dF/F0 for all analyses in this script) from ImageJ pixel intensity plot csv file
file2open = '168 243 140_puffwhisk__ISOFL2_007 heatmap intensity.csv';

temp_data = csvread(file2open,1,0); 
F = temp_data;
scalewindow = 0.5 * length(F);
smoothwindow = 5;
baseline_range = 25:35; 
F0 = mean(raw_F(:,baseline_range),2);
F0_mat = repmat(F0, [1, size(raw_F,2)]);
df_f0 = (raw_F - F0_mat) ./ F0_mat;
scaled = mean(df_f0, 1);
Fc  = FtoFc(F,scalewindow);
Fc_smoothed = smoothdata(Fc(:,2),'gaussian',smoothwindow);
df_f0_smoothed = smoothdata(mean(df_f0),'gaussian',smoothwindow);

figure;
plot(mean(df_f0));
hold on;
plot(df_f0_smoothed);
title('Normalized F (dF/F0) vs Smoothed dF/F0');


%% Whole Dendrite (Plot F, Norm F and intensity plots for each with event times included)
raw_F = double(imread('168 243 140_puffwhisk_fading_ISOFL006 kept stack_MotCor time series masked extra.tif'));

trigger_stim = find(csvread('Trigger Values.csv',1,1)); %trigger event times from 2nd channel in original video
trigger_stim(find(abs(diff(trigger_stim)) == 1) + 1) = '';
baseline_range = 25:35; 
F0 = mean(raw_F(:,baseline_range),2);
F0_mat = repmat(F0, [1, size(raw_F,2)]);
df_f0 = (raw_F - F0_mat) ./ F0_mat;
scaled = mean(df_f0, 1);

figure;
subplot(4,1,1);
image(raw_F,'CDataMapping', 'scaled');
title('Raw F of Dendrite');
subplot(4,1,2);
image(df_f0,'CDataMapping', 'scaled');
title('Normalized F (dF/F0) of Dendrite');
subplot(4,1,3);
hold on;
avr_rawF = mean(raw_F,1); 
plot(avr_rawF);
plot(trigger_stim, ones(1, length(trigger_stim)) * (min(avr_rawF)), ...
    '^', 'markersize', 5, 'markerfacecolor', 'k','markeredgecolor', 'none');
title('Raw intensity profile');
% y0_left = avr_rawF(1); 
% ylim([min(avr_rawF)-1,max(avr_rawF)+1]); 
% ylim_left = ylim(gca);
% ylim([-0.2 0.7].*mean(avr_rawF(1:10))+mean(avr_rawF(1:10)))


subplot(4,1,4);
% yyaxis right;
hold on;
plot(scaled);
plot(trigger_stim, ones(1, length(trigger_stim)) * (min(scaled)), ...
    '^', 'markersize', 5, 'markerfacecolor', 'k','markeredgecolor', 'none');
title('Normalized (dF/F0) intensity profile');
% ylim([min(scaled),max(scaled)] + 0.01*[-1,1]); 
% y0_right = scaled(1); 
% ylim_right = ylim(gca); 
% ylim_right(2) = abs(diff(ylim_left))*(y0_right - ylim_right(1))/(y0_left - ylim_left(1)) + ylim_right(1);
% ylim(ylim_right);
% legend('Raw fluorescence', 'Normalized fluorescence (dF/F0)', 'Stimulus trigger');
% ylim([-0.2,0.7])

%% Separate ROIs (plot norm F amd intensity trace for different sections of dendrite)
num_roi = 4;
count = 1;
range = size(raw_F,1) / num_roi;
range = ceil(range);
figure;
hold on;
top = 0.8*max(df_f0(:));
bottom = min(df_f0(:));

cmap = jet(1000)*0.8; 
line_col = rand(num_roi,3); 
for i = 1:num_roi
    subplot(num_roi+2, 1, i);
    slice_i = count:min(count+range-1,size(raw_F,1));
    profile = df_f0(slice_i,:);
    avg_profile = mean(profile,1);
    image(profile,'CDataMapping', 'scaled');
    caxis([bottom,top]);
    colormap(cmap); 
    set(gca, 'xcolor', 'none','box','off','ytick','');
    ylabel(['Region = ' num2str(i)], 'fontweight', 'normal', ...
        'fontsize', 12, 'color', line_col(i,:)); 
    
    subplot(num_roi+2, 1, num_roi+[1,2]);
    hold on;
    offset = -0.5*(i-1);
    plot(avg_profile + offset,'-', 'linewidth', 1, ...
        'displayname',num2str(i), 'Color', line_col(i,:));
    plot(offset * ones(size(avg_profile)), ':', 'Color', ones(1,3)*0.6); 
    set(gca, 'TickLength', [0.01,0.01], 'TickDir', 'out'); 
    box off 
    count = count + range;
end
subplot(num_roi+2, 1, num_roi+[1,2]); 
vr = 1:num_roi; 
[yt, ti] = sort(-0.5*(vr-1));
set(gca,'ytick',yt,'yticklabel',num2cell(vr(ti)));
plot(trigger_stim, ones(1, length(trigger_stim)) * (-0.5*(num_roi)), ...
    '^', 'markersize', 10, 'markerfacecolor', 'k','markeredgecolor', 'none');
%%
figure;
image(df_f0,'CDataMapping', 'scaled');

%%
imwrite(df_f0, 'df_F0.tif')

%% Separate ROIs and peaks
num_roi = 4;
count = 1;
range = size(raw_F,1) / num_roi;
range = ceil(range);
figure;
hold on;
top = 0.8*max(df_f0(:));
bottom = min(df_f0(:));

cmap = jet(1000)*0.8; 
line_col = rand(num_roi,3); 
for i = 1:num_roi
    
    slice_i = count:min(count+range-1,size(raw_F,1));
    profile = df_f0(slice_i,:);
    avg_profile = mean(profile,1);
    
    offset = -0.5*(i-1);
    plot(avg_profile + offset,'-', 'linewidth', 1, ...
        'displayname',num2str(i), 'Color', line_col(i,:));
    
    findpeaks(avg_profile + offset, ...
        'MinPeakProminence', 0.4, 'MinPeakDistance', 3); 
    plot(offset * ones(size(avg_profile)), ':', 'Color', ones(1,3)*0.6); 
    set(gca, 'TickLength', [0.01,0.01], 'TickDir', 'out'); 
    box off 
    count = count + range;
end
vr = 1:num_roi; 
[yt, ti] = sort(-0.5*(vr-1));
set(gca,'ytick',yt,'yticklabel',num2cell(vr(ti)));
plot(trigger_stim, ones(1, length(trigger_stim)) * (-0.5*(num_roi)), ...
    '^', 'markersize', 10, 'markerfacecolor', 'k','markeredgecolor', 'none');
title('prom');
%%
num_roi = 4;
range = ceil(size(raw_F,1) / num_roi);
range = ceil(range);

count = 1; 
for i = 1:num_roi
    slice_i = count:min(count+range-1,size(raw_F,1));
    profile = df_f0(slice_i,:);
    avg_profile = mean(profile,1);  
    
    [locs, peaks] = findpeaks(avg_profile, 'MinPeakProminence', 0.4, 'MinPeakDistance', 3); 
end

