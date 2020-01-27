
function [outputdata]=merge(outputdata,inputdata,dataname);

%1 name 
%2 raw trace
%3 time per minutes,
%4 index of pos saccades
%5 time of pos saccades
%6 index of neg saccades
%7 time of neg saccades,
%8 freq_pos number/minute
%9 freq_neg number/minute
%10 freq diff number/minute
%11 freq sum number/minute
%12 freq pos estimated by duration
%13 freq neg estimated by duration,
%14 freq pos estimated by duration index
%15 freq neg estimated by duration index
%16 time of freq pos estimated by duration
%17 time of freq neg estimated by duration
%18 freq pos estimated by duration(/min)
%19 freq neg estimated by duration(/min)
%20 freq diff estimated by duration(/min)
%21 freq sum estimated by duration(/min),
%22 velocity
%23 velocity index
%24 velocity time
%25 velocity median
outputdata=[outputdata;{'dataname'},{inputdata.freq.eye_raw},{inputdata.freq.time/60},{inputdata.freq.end_time_of_pos},{inputdata.freq.TIME_pos/60},{inputdata.freq.end_time_of_neg},{inputdata.freq.TIME_neg/60},{inputdata.freq.Freq_pos},{inputdata.freq.Freq_neg},{inputdata.freq.Freq_neg-inputdata.freq.Freq_pos},{inputdata.freq.Freq_neg+inputdata.freq.Freq_pos},{inputdata.freq.byduration.Freq_pos_freq_from_duration},{inputdata.freq.byduration.Freq_neg_freq_from_duration},{inputdata.freq.byduration.duration_pos_index},{inputdata.freq.byduration.duration_neg_index},{inputdata.freq.byduration.time(inputdata.freq.byduration.duration_pos_index(:),1)/60},{inputdata.freq.byduration.time(inputdata.freq.byduration.duration_neg_index(:),1)/60},{inputdata.freq.byduration.Freq_pos},{inputdata.freq.byduration.Freq_neg},{inputdata.freq.byduration.Freq_neg-inputdata.freq.byduration.Freq_pos},{inputdata.freq.byduration.Freq_neg+inputdata.freq.byduration.Freq_pos},{inputdata.Velocity.velocity},{inputdata.Velocity.SaccExtremeIdx(1:end-1,1)},{inputdata.Velocity.velocity_time},{inputdata.Velocity.velocity_everymin}];
outputdata{end,1}=[dataname];


%eye trace
figure(1);
for i=1:length(outputdata(:,1));

subplot(ceil(length(outputdata(:,1))/2),2,i);

plot(outputdata{i,3},outputdata{i,2}); 
hold on;

x1 = outputdata{i,5};
y1 = outputdata{i,2}(outputdata{i,4},1);
plot(x1,y1,'*r');

x2 = outputdata{i,7};
y2 = outputdata{i,2}(outputdata{i,6},1);
plot(x2,y2,'*g');
title('eyes raw traces');
end
legend('raw trace','positive directed saccades','negative directed saccades');

% saveas(figure(1), ['E:/TURN TABLE/RPN project/TUtotaldata/figure/eye_trace.fig']);




%freq n/min
figure(2);
for i=1:length(outputdata(:,1));
subplot(ceil(length(outputdata(:,1))/2),2,i);
x=1:length(outputdata{i,8});
y1=outputdata{i,8};
y2=outputdata{i,9};
y3=outputdata{i,10};
plot(x,y1,'ro',x,y2,'go',x,y3,'bo');
title('freq n/min');
end
legend('positive directed saccades','negative directed saccades','difference');
% saveas(figure(2), ['E:/TURN TABLE//RPN project/TUtotaldata/figure/freq_per_min.fig']);

%freq diff and sum n/min
figure(3)
for i=1:length(outputdata(:,1));
subplot(ceil(length(outputdata(:,1))/2),2,i);
x=1:length(outputdata{i,8});
y1=outputdata{i,10};
y2=outputdata{i,11};
plot(x,y1,'ro',x,y2,'go');
title('freq diff and sum n/min');
end
legend('difference','sum');
% saveas(figure(3), ['E:/TURN TABLE//RPN project/TUtotaldata/figure/freq_diff_sum.fig']);


%freq estimated by duration
figure(4)
for i=1:length(outputdata(:,1));
subplot(ceil(length(outputdata(:,1))/2),2,i);

x1=outputdata{i,16};
y1=outputdata{i,12};
x2=outputdata{i,17};
y2=outputdata{i,13};
plot(x1,y1,'ro',x2,y2,'go');
title('freq estimated by duration');
end
legend('positive directed saccades','negative directed saccades');
% saveas(figure(4), ['E:/TURN TABLE//RPN project/TUtotaldata/figure/freq_byduration.fig']);

% median of freq estimated by duration
figure(5)
for i=1:length(outputdata(:,1));
subplot(ceil(length(outputdata(:,1))/2),2,i);
x=1:length(outputdata{i,18});
y1=outputdata{i,18};
y2=outputdata{i,19};
y3=outputdata{i,20};
plot(x,y1,'ro',x,y2,'go',x,y3,'bo');
title('median of freq estimated by duration');
end
legend('positive directed saccades','negative directed saccades','difference');
% saveas(figure(5), ['E:/TURN TABLE//RPN project/TUtotaldata/figure/freq_byduration_median.fig']);

%freq diff and sum n/min estimated by duration
figure(6)
for i=1:length(outputdata(:,1));
subplot(ceil(length(outputdata(:,1))/2),2,i);
x=1:length(outputdata{i,18});
y1=outputdata{i,20};
y2=outputdata{i,21};
plot(x,y1,'ro',x,y2,'go');
title('freq diff and sum n/min estimated by duration');
end
legend('difference','sum');
% saveas(figure(6), ['E:/TURN TABLE//RPN project/TUtotaldata/figure/freq_byduration_diff_sum.fig']);

%velocity
figure(7)
for i=1:length(outputdata(:,1));

subplot(ceil(length(outputdata(:,1))/2),2,i);

plot(1:length(outputdata{i,25}),outputdata{i,25}); 
hold on;

x1 = outputdata{i,24};
y1 = outputdata{i,22};
plot(x1,y1,'ro');

title('velocity');
end
legend('median of velocity','velocity');
% saveas(figure(7), ['E:/TURN TABLE//RPN project/TUtotaldata/figure/velocity.fig']);

end




