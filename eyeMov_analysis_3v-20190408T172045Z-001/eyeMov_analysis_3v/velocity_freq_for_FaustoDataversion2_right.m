%data=ans;


data.Velocity.SaccExtremeIdx=data.SaccExtremeIdxR;
data.Velocity.eye_raw=data.reye_raw;
data.Velocity.time=data.time_r;


data.Velocity.dydt = diff(data.Velocity.eye_raw(:))./diff(data.Velocity.time(:));


data.Velocity.SaccExtremeIdx(isnan(data.Velocity.SaccExtremeIdx(:,1)),:)=[];
data.Velocity.velocity=[];
for i=1:length(data.Velocity.SaccExtremeIdx)-1
velocity=(data.Velocity.dydt(data.Velocity.SaccExtremeIdx(i,2):data.Velocity.SaccExtremeIdx(i,2)+ceil((data.Velocity.SaccExtremeIdx(i+1,1)-data.Velocity.SaccExtremeIdx(i,2))/10),1)');
data.Velocity.velocity=[data.Velocity.velocity;median(velocity)];
end

data.Velocity.velocity_time=data.Velocity.time(data.Velocity.SaccExtremeIdx(1:end-1,2))/60;
data.Velocity.velocity_lowess=malowess(data.Velocity.time(data.Velocity.SaccExtremeIdx(1:end-1,2))/60,data.Velocity.velocity(:));

figure;
scatter(data.Velocity.velocity_time,data.Velocity.velocity,'B');
hold on
plot(data.Velocity.velocity_time,data.Velocity.velocity_lowess,'R');
hold on
plot(0:0.1:data.Velocity.velocity_time(end,1),0,'k');





%Frequency estimated by duration
data.freq.byduration.eye_raw=data.reye_raw;
data.freq.byduration.time=data.time_r;
data.freq.byduration.SaccExtremeIdx=data.SaccExtremeIdxR;


%definition
%SaccExtremeIdx(:,1)=start point of saccades(index)
%SaccExtremeIdx(:,1)=end point of saccades(index)
%TIME_pos=end time point of positive directed saccades(time(sec))
%TIME_neg=end time point of negative directed saccades(time(sec))
%Freq_pos=saccades frequency of positive directed saccades(numbers/min)
%Freq_neg=saccades frequency of negative directed saccades(numbers/min)
%Freq_diff=Freq_pos-Freq_neg(numbers/min)



%end time of left eyes saccades
data.freq.byduration.SaccExtremeIdx(isnan(data.freq.byduration.SaccExtremeIdx(:,1)),:)=[];
data.freq.byduration.end_time_of_neg=[];
data.freq.byduration.end_time_of_pos=[];
for i=1:length(data.freq.byduration.SaccExtremeIdx)


if data.freq.byduration.eye_raw(data.freq.byduration.SaccExtremeIdx(i,1),1)-data.freq.byduration.eye_raw(data.freq.byduration.SaccExtremeIdx(i,2),1)>0
    data.freq.byduration.end_time_of_neg=[data.freq.byduration.end_time_of_neg;data.freq.byduration.SaccExtremeIdx(i,:)];
   
elseif data.freq.byduration.eye_raw(data.freq.byduration.SaccExtremeIdx(i,1),1)-data.freq.byduration.eye_raw(data.freq.byduration.SaccExtremeIdx(i,2),1)<0
    data.freq.byduration.end_time_of_pos=[data.freq.byduration.end_time_of_pos;data.freq.byduration.SaccExtremeIdx(i,:)];
   
end
end



for i=1:length(data.freq.byduration.end_time_of_pos)
data.freq.byduration.TIME_pos(i,1)=data.freq.byduration.time(data.freq.byduration.end_time_of_pos(i,2));
end
for i=1:length(data.freq.byduration.end_time_of_neg)
data.freq.byduration.TIME_neg(i,1)=data.freq.byduration.time(data.freq.byduration.end_time_of_neg(i,2));
end



%Freq_pos&neg_l&r=frequency/1min

data.freq.byduration.duration_pos_index=[];
data.freq.byduration.Freq_pos_freq_from_duration=[]; 
for i=1:length(data.freq.byduration.end_time_of_pos)-1
duration=(data.freq.byduration.time(data.freq.byduration.end_time_of_pos(i+1,2),1)-data.freq.byduration.time(data.freq.byduration.end_time_of_pos(i,2),1));
freq=60./duration;
if duration>60;
    freq=0;  
end
data.freq.byduration.duration_pos_index=[data.freq.byduration.duration_pos_index;data.freq.byduration.end_time_of_pos(i,2)];
data.freq.byduration.Freq_pos_freq_from_duration=[data.freq.byduration.Freq_pos_freq_from_duration;freq];
end


data.freq.byduration.duration_neg_index=[];
data.freq.byduration.Freq_neg_freq_from_duration=[]; 
for i=1:length(data.freq.byduration.end_time_of_neg)-1
duration=(data.freq.byduration.time(data.freq.byduration.end_time_of_neg(i+1,2),1)-data.freq.byduration.time(data.freq.byduration.end_time_of_neg(i,2),1));
freq=60./duration;
if duration>60;
    freq=0;
end

data.freq.byduration.duration_neg_index=[data.freq.byduration.duration_neg_index;data.freq.byduration.end_time_of_neg(i,2)];
data.freq.byduration.Freq_neg_freq_from_duration=[data.freq.byduration.Freq_neg_freq_from_duration;freq];
end





for k=1:floor((data.freq.byduration.time(data.freq.byduration.SaccExtremeIdx(end,2)))/60)
    freq=[];
for i=1:length(data.freq.byduration.duration_pos_index)
    if ceil((data.freq.byduration.time(data.freq.byduration.duration_pos_index(i,1)))/60)==k;
        freq=[freq data.freq.byduration.Freq_pos_freq_from_duration(i,1)]
    end
end
data.freq.byduration.Freq_pos(k,1)=median(freq)
end

for k=1:floor((data.freq.byduration.time(data.freq.byduration.SaccExtremeIdx(end,2)))/60)
    freq=[];
for i=1:length(data.freq.byduration.duration_neg_index)
    if ceil((data.freq.byduration.time(data.freq.byduration.duration_neg_index(i,1)))/60)==k;
        freq=[freq data.freq.byduration.Freq_neg_freq_from_duration(i,1)]
    end
end
data.freq.byduration.Freq_neg(k,1)=median(freq)
end

data.freq.byduration.Freq_pos(isnan(data.freq.byduration.Freq_pos(:,1)),:)=0;
data.freq.byduration.Freq_neg(isnan(data.freq.byduration.Freq_neg(:,1)),:)=0;



for i=1:length(data.freq.byduration.Freq_pos)
data.freq.byduration.Freq_diff(i,1)= data.freq.byduration.Freq_pos(i,1)-data.freq.byduration.Freq_neg(i,1);
end




figure
x=data.freq.byduration.time/60;
y=data.freq.byduration.eye_raw;
plot(data.freq.byduration.time/60,data.freq.byduration.eye_raw); hold on;

x1 = data.freq.byduration.time(data.freq.byduration.end_time_of_pos(:,2))/60;
y1 = data.freq.byduration.eye_raw(data.freq.byduration.end_time_of_pos(:,2));
plot(x1,y1,'*r');
title('left eyes raw traces')


x2 = data.freq.byduration.time(data.freq.byduration.end_time_of_neg(:,2))/60;
y2 = data.freq.byduration.eye_raw(data.freq.byduration.end_time_of_neg(:,2));
plot(x2,y2,'*g');
title('left eyes raw traces')
xlim([0 length(data.freq.byduration.Freq_pos)])

figure
subplot(2,1,1)
x1=data.freq.byduration.time(data.freq.byduration.duration_pos_index(:))/60;
x2=data.freq.byduration.time(data.freq.byduration.duration_neg_index(:))/60;
y1=data.freq.byduration.Freq_pos_freq_from_duration(:);
y2=data.freq.byduration.Freq_neg_freq_from_duration(:);
plot(x1,y1,'ro',x2,y2,'go');
legend('positive directed saccades','negative directed saccades');




subplot(2,1,2)
x=1:length(data.freq.byduration.Freq_pos);
y1=data.freq.byduration.Freq_pos(x,1);
y2=data.freq.byduration.Freq_neg(x,1);
y3=data.freq.byduration.Freq_diff(x,1);
plot(x,y1,'ro',x,y2,'go',x,y3,'bo');
legend('positive directed saccades','negative directed saccades','difference');
