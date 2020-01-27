divisor = 6; % specify how many chunks you want
chunk_size = round(length(data.Fc3) / divisor);
bin_edge = [];
for i=1:chunk_size:length(data.Fc3)
    bin_edge = [bin_edge i];
end

num_events = zeros(length(bin_edge),size(data.Fc3,2));
counts = zeros(length(bin_edge),size(data.Fc3,2));
avg_length = zeros(length(bin_edge),size(data.Fc3,2));
avg_max_Fc3 = zeros(length(bin_edge),size(data.Fc3,2));

check_events = [];
check_lengths = [];
check_Fc3 = [];

for i=1:length(bin_edge)
    holding_label = [];
    for j=1:size(data.Fc3,2)
        num_events(i,j) = max(bwlabel(data.Fc3((bin_edge(i):bin_edge(i)+chunk_size-1), j)));
        holding_label = [holding_label bwlabel(data.Fc3((bin_edge(i):bin_edge(i)+chunk_size-1), j))];
        counts(i,j) = max(holding_label(:,j)); % should be same as num_events
        holding_lengths = [];
        holding_startpts = [];
        holding_endpts = [];
        holding_max_Fc3s = [];
        if num_events(i,j) > 0   
           holding_max_Fc3s = [];
           for k=1:num_events(i,j)
               holding_lengths = [holding_lengths length(find(holding_label(:,j)==k))];
               holding_startpts = [holding_startpts find((holding_label(:,j)==k),1)];
               holding_endpts = [holding_endpts find((holding_label(:,j)==k),1,'last')];
              % if k==num_events(i,j) && length(holding_startpts)>length(holding_endpts)
              %       holding_endpts = [holding_endpts chunk_size];
              % end
               avg_length(i,j) = mean(holding_lengths);
               for m=1:length(holding_startpts)
                   holding_max_Fc3s(m) = max(data.Fc3(holding_startpts(m)+(i-1)*chunk_size:holding_endpts(m)+(i-1)*chunk_size,j));
                   
               end    
               avg_max_Fc3(i,j) = mean(holding_max_Fc3s);
           end
        else
            avg_length(i,j) = 0;
            avg_max_Fc3(i,j) = 0;
        end
    end  
end 

sum_events = [];
for j=1:size(data.Fc3,2)
    sum_events = [sum_events sum(num_events(:,j))];
end
check_events = find(sum_events > 19);
for i=1:length(bin_edge)
    for j=1:size(data.Fc3,2)
        if avg_length(i,j) > 9
            check_lengths = [check_lengths j];
        end
        if avg_max_Fc3(i,j) > 8
            check_Fc3 = [check_Fc3 j];
        end
    end
end

to_check = unique(horzcat(check_events,check_lengths,check_Fc3));
%%
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


