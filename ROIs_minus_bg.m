%% compute Fc

% load ROI data file first, assign data_full = data. then load background ROI data file.
% now, "data_full" will reference complete ROI data, and "data" will reference background ROI data

data_bg = zeros(length(data.F),1); % initialize vector: this will be the average background noise for each frame
% average all of the background ROIs together at each frame
for i=1:length(data.F)
    data_bg(i) = mean(data.F(i,:)); 
end

data_minus_bg = zeros(length(data.F),size(data_full.F,2)); % initialize vector: this will be the edited data for each ROI
num_frames = 15000; % how many frames does your video have?

for i=1:size(data_full.F,2) % subtract background noise from all ROIs
    for j=1:length(data_full.F)
        data_minus_bg(j,i) = (data_full.F(j,i) - data_bg(j));
    end
end

 %for j=1:size(data_minus_bg,2)
 %   figure; plot(data_minus_bg(:,j));
 %end
 
Fc_minus_bg = FtoFc(data_minus_bg, num_frames); % compute Fc without sliding window

% save file (I'm not sure if this works so it's commented out)
% data_final.data_minus_bg = data_minus_bg;
% data_final.Fc_minus_bg = Fc_minus_bg;
% save([PathName Filename(1:end-4) '_ROIs_minus_bg'], 'data_bg');


%% analysis

divisor = 15; % specify how many chunks you want
chunk_size = round(length(Fc_minus_bg) / divisor);
bin_edge = [];
for i=1:chunk_size:length(Fc_minus_bg)
    bin_edge = [bin_edge i];
end

Fc_means = zeros(length(bin_edge),size(Fc_minus_bg,2)); % initialize: rows = chunks, columns = ROIs

% find the mean Fc value for each ROI, for each chunk
for i=1:length(bin_edge)
    for j=1:size(Fc_minus_bg,2)
        if i == length(bin_edge)
            Fc_means(i,j) = mean(Fc_minus_bg((bin_edge(i):end), j));
        else
            Fc_means(i,j) = mean(Fc_minus_bg((bin_edge(i):bin_edge(i)+chunk_size-1), j));
        end
            
    end  
end 

%% individual ROI figures
 for j=64 %1:size(Fc_minus_bg,2)
    figure; hold on;
    for i=1:length(bin_edge)
        plot(i,Fc_means(i,j),'o');
    end
 end
 
 %% overall figure
 avgs = [];
stds = [];
%edges = [1:2:100]; edges2 = [1:1:50]; edges3 = [1:1:20];
for i=1:length(bin_edge)
    avgs = [avgs mean(Fc_means(i,:))];
    stds = [stds std(Fc_means(i,:))];
   % figure;histogram(Fc_means(i,:),edges);
end
%figure;histogram(Fc_means);

figure('Name','Mean Fc of each ROI'); bar(avgs, 'facecolor', [.8 .8 .8]);
hold on;
for i=1:length(bin_edge)
    plot(i,Fc_means(i,:),'o');
    errorbar(1:length(bin_edge), avgs, stds, '.');
end
hold off;

%%
 %% overall figure
 avgs2 = [];
stds2 = [];
%edges = [1:2:100]; edges2 = [1:1:50]; edges3 = [1:1:20];
for i=1:length(bin_edge)
    avgs2 = [avgs2 mean(remove_bleaching(i,:))];
    stds2 = [stds2 std(remove_bleaching(i,:))];
   % figure;histogram(Fc_means(i,:),edges);
end
%figure;histogram(Fc_means);

figure('Name','Mean Fc of each ROI'); bar(avgs2, 'facecolor', [.8 .8 .8]);
hold on;
for i=1:length(bin_edge)
    plot(i,remove_bleaching(i,:),'o');
    errorbar(1:length(bin_edge), avgs2, stds2, '.');
end
hold off;