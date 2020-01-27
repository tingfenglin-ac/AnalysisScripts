divisor = 5; % specify how many chunks you want
chunk_size = round(length(data.Fc3) / divisor);
bin_edge = [];
for i=1:chunk_size:length(data.Fc3)
    bin_edge = [bin_edge i];
end

%% for normal Fc and Fc3
num_events = zeros(length(bin_edge),size(data.Fc3,2)); % initialize
avg_length = zeros(length(bin_edge),size(data.Fc3,2));
avg_max_Fc3 = zeros(length(bin_edge),size(data.Fc3,2));

%check_events = []; % for identifying potential problem ROIs to check by eye
%check_lengths = [];
%check_Fc3 = [];

for i=1:length(bin_edge)
    holding_label = [];
    for j=1:size(data.Fc3,2)
        num_events(i,j) = max(bwlabel(data.Fc3((bin_edge(i):bin_edge(i)+chunk_size-1), j))); 
        % ^labels each fluorescent event in Fc3 of each ROI with a unique number, then finds the max of each ROI, which = number of distinct fluor. events
        holding_label = [holding_label bwlabel(data.Fc3((bin_edge(i):bin_edge(i)+chunk_size-1), j))];
        % ^labels each fluorescent event in Fc3 of each ROI WITHIN EACH CHUNK
        holding_lengths = [];
        holding_startpts = [];
        holding_endpts = [];
        holding_max_Fc3s = [];
        if num_events(i,j) > 0   % if there were 1 or more events for this ROI in this chunk
           holding_max_Fc3s = [];
           for k=1:num_events(i,j) % for each event
               holding_lengths = [holding_lengths length(find(holding_label(:,j)==k))]; % find length of event in frames
               holding_startpts = [holding_startpts find((holding_label(:,j)==k),1)]; % find first frame of event
               holding_endpts = [holding_endpts find((holding_label(:,j)==k),1,'last')]; % find last frame of event
               avg_length(i,j) = mean(holding_lengths); % find average length of each event for this chunk for this ROI
               for m=1:length(holding_startpts) % for each unique event in the chunk
                   holding_max_Fc3s(m) = max(data.Fc3(holding_startpts(m)+(i-1)*chunk_size:holding_endpts(m)+(i-1)*chunk_size,j));
                   % find the max Fc3 value for that event
               end    
               avg_max_Fc3(i,j) = mean(holding_max_Fc3s); % find the average max Fc3 value of all events in that chunk
           end
        else % if there were no events for this ROI in this chunk
            avg_length(i,j) = 0; 
            avg_max_Fc3(i,j) = 0;
        end
    end  
end 

% identifies potential outliers/ROIs to check by eye:
% sum_events = [];
% for j=1:size(data.Fc3,2)
%     sum_events = [sum_events sum(num_events(:,j))];
% end
% check_events = find(sum_events > 19);
% for i=1:length(bin_edge)
%     for j=1:size(data.Fc3,2)
%         if avg_length(i,j) > 9
%             check_lengths = [check_lengths j];
%         end
%         if avg_max_Fc3(i,j) > 8
%             check_Fc3 = [check_Fc3 j];
%         end
%     end
% end
% 
% to_check = unique(horzcat(check_events,check_lengths,check_Fc3));
%% for smoothed Fc and Fc3
% does the same as the first part of this script for smoothed data
num_events_smooth = zeros(length(bin_edge),size(data.Fc3_smoothed,2));
avg_length_smooth = zeros(length(bin_edge),size(data.Fc3_smoothed,2));
avg_max_Fc3_smooth = zeros(length(bin_edge),size(data.Fc3_smoothed,2));

check_events_smooth = [];
check_lengths_smooth = [];
check_Fc3_smooth = [];

for i=1:length(bin_edge)
    holding_label_smooth = [];
    for j=1:size(data.Fc3_smoothed,2)
        num_events_smooth(i,j) = max(bwlabel(data.Fc3_smoothed((bin_edge(i):bin_edge(i)+chunk_size-1), j)));
        holding_label_smooth = [holding_label_smooth bwlabel(data.Fc3_smoothed((bin_edge(i):bin_edge(i)+chunk_size-1), j))];
        holding_lengths_smooth = [];
        holding_startpts_smooth = [];
        holding_endpts_smooth = [];
        holding_max_Fc3s_smooth = [];
        if num_events_smooth(i,j) > 0   
           holding_max_Fc3s_smooth = [];
           for k=1:num_events_smooth(i,j)
               holding_lengths_smooth = [holding_lengths_smooth length(find(holding_label_smooth(:,j)==k))];
               holding_startpts_smooth = [holding_startpts_smooth find((holding_label_smooth(:,j)==k),1)];
               holding_endpts_smooth = [holding_endpts_smooth find((holding_label_smooth(:,j)==k),1,'last')];
               avg_length_smooth(i,j) = mean(holding_lengths_smooth);
               for m=1:length(holding_startpts_smooth)
                   holding_max_Fc3s_smooth(m) = max(data.Fc3_smoothed(holding_startpts_smooth(m)+(i-1)*chunk_size:holding_endpts_smooth(m)+(i-1)*chunk_size,j));
                   
               end    
               avg_max_Fc3_smooth(i,j) = mean(holding_max_Fc3s_smooth);
           end
        else
            avg_length_smooth(i,j) = 0;
            avg_max_Fc3_smooth(i,j) = 0;
        end
    end  
end 

%sum_events_smooth = [];
% for j=1:size(data.Fc3_smoothed,2)
%     sum_events_smooth = [sum_events_smooth sum(num_events_smooth(:,j))];
% end
% check_events_smooth = find(sum_events_smooth > 19);
% for i=1:length(bin_edge)
%     for j=1:size(data.Fc3_smoothed,2)
%         if avg_length_smooth(i,j) > 9
%             check_lengths_smooth = [check_lengths_smooth j];
%         end
%         if avg_max_Fc3_smooth(i,j) > 8
%             check_Fc3_smooth = [check_Fc3_smooth j];
%         end
%     end
% end
% 
% to_check_smooth = unique(horzcat(check_events_smooth,check_lengths_smooth,check_Fc3_smooth));
%% figures for normal Fc3
avgs = [];
stds = [];
avg_by_chunk_length = [];
std_by_chunk_length = [];
avg_by_chunk_meanFc3 = [];
std_by_chunk_meanFc3 = [];
edges = [1:2:100]; edges2 = [1:1:50]; edges3 = [1:1:20];
for i=1:length(bin_edge)
    avgs = [avgs mean(num_events(i,:))];
    stds = [stds std(num_events(i,:))];
    avg_by_chunk_length = [avg_by_chunk_length mean(avg_length(i,:))];
    std_by_chunk_length = [std_by_chunk_length std(avg_length(i,:))];
    avg_by_chunk_meanFc3 = [avg_by_chunk_meanFc3 mean(avg_max_Fc3(i,:))];
    std_by_chunk_meanFc3 = [std_by_chunk_meanFc3 std(avg_max_Fc3(i,:))];
   % figure;histogram(num_events(i,:),edges);
   % figure;histogram(avg_length(i,:),edges2);
   % figure;histogram(avg_max_Fc3(i,:),edges3);
end
%figure;histogram(num_events);
%figure;histogram(avg_length);
%figure;histogram(avg_max_Fc3);

figure('Name','Number of Events'); bar(avgs, 'facecolor', [.8 .8 .8]);
hold on;
for i=1:length(bin_edge)
    plot(i,num_events(i,:),'o');
    errorbar(1:length(bin_edge), avgs, stds, '.');
end
hold off;

figure('Name','Avg Length'); bar(avg_by_chunk_length, 'facecolor', [.8 .8 .8]);
hold on;
for i=1:length(bin_edge)
    plot(i,avg_length(i,:),'o');
    errorbar(1:length(bin_edge), avg_by_chunk_length, std_by_chunk_length, '.');
end
hold off;

figure('Name','Avg Max Fc3'); bar(avg_by_chunk_meanFc3, 'facecolor', [.8 .8 .8]);
hold on;
for i=1:length(bin_edge)
    plot(i,avg_max_Fc3(i,:),'o');
    errorbar(1:length(bin_edge), avg_by_chunk_meanFc3, std_by_chunk_meanFc3, '.');
end
hold off;

%% figures for smoothed Fc3
avgs_smooth = [];
stds_smooth = [];
avg_by_chunk_length_smooth = [];
std_by_chunk_length_smooth = [];
avg_by_chunk_meanFc3_smooth = [];
std_by_chunk_meanFc3_smooth = [];
edges = [1:2:100]; edges2 = [1:1:50]; edges3 = [1:1:20];
for i=1:length(bin_edge)
    avgs_smooth = [avgs_smooth mean(num_events_smooth(i,:))];
    stds_smooth = [stds_smooth std(num_events_smooth(i,:))];
    avg_by_chunk_length_smooth = [avg_by_chunk_length_smooth mean(avg_length_smooth(i,:))];
    std_by_chunk_length_smooth = [std_by_chunk_length_smooth std(avg_length_smooth(i,:))];
    avg_by_chunk_meanFc3_smooth = [avg_by_chunk_meanFc3_smooth mean(avg_max_Fc3_smooth(i,:))];
    std_by_chunk_meanFc3_smooth = [std_by_chunk_meanFc3_smooth std(avg_max_Fc3_smooth(i,:))];
   % figure;histogram(num_events(i,:),edges);
   % figure;histogram(avg_length(i,:),edges2);
   % figure;histogram(avg_max_Fc3(i,:),edges3);
end
%figure;histogram(num_events);
%figure;histogram(avg_length);
%figure;histogram(avg_max_Fc3);

figure('Name','Number of Events Smoothed'); bar(avgs_smooth, 'facecolor', [.8 .8 .8]);
hold on;
for i=1:length(bin_edge)
    plot(i,num_events_smooth(i,:),'o');
    errorbar(1:length(bin_edge), avgs_smooth, stds_smooth, '.');
end
hold off;

figure('Name','Avg Length Smoothed'); bar(avg_by_chunk_length_smooth, 'facecolor', [.8 .8 .8]);
hold on;
for i=1:length(bin_edge)
    plot(i,avg_length_smooth(i,:),'o');
    errorbar(1:length(bin_edge), avg_by_chunk_length_smooth, std_by_chunk_length_smooth, '.');
end
hold off;

figure('Name','Avg Max Fc3 Smoothed'); bar(avg_by_chunk_meanFc3_smooth, 'facecolor', [.8 .8 .8]);
hold on;
for i=1:length(bin_edge)
    plot(i,avg_max_Fc3_smooth(i,:),'o');
    errorbar(1:length(bin_edge), avg_by_chunk_meanFc3_smooth, std_by_chunk_meanFc3_smooth, '.');
end
hold off;
