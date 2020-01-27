
% data=ans;
data.freq.eye_raw=data.reye_raw;
data.freq.time=data.time_r;
data.freq.SaccExtremeIdx=data.SaccExtremeIdxR;


%definition
%SaccExtremeIdx(:,1)=start point of saccades(index)
%SaccExtremeIdx(:,1)=end point of saccades(index)
%TIME_pos=end time point of positive directed saccades(time(sec))
%TIME_neg=end time point of negative directed saccades(time(sec))
%Freq_pos=saccades frequency of positive directed saccades(numbers/min)
%Freq_neg=saccades frequency of negative directed saccades(numbers/min)
%Freq_diff=Freq_pos-Freq_neg(numbers/min)



%end time of left eyes saccades
data.freq.SaccExtremeIdx(isnan(data.freq.SaccExtremeIdx(:,1)),:)=[];

for i=1:length(data.freq.SaccExtremeIdx)


if data.freq.eye_raw(data.freq.SaccExtremeIdx(i,1),1)-data.freq.eye_raw(data.freq.SaccExtremeIdx(i,2),1)>0
    data.freq.end_time_of_neg(i,1)=data.freq.SaccExtremeIdx(i,2);  

elseif data.freq.eye_raw(data.freq.SaccExtremeIdx(i,1),1)-data.freq.eye_raw(data.freq.SaccExtremeIdx(i,2),1)<0
    data.freq.end_time_of_pos(i,1)=data.freq.SaccExtremeIdx(i,2);

end
end
%delete the zeros
data.freq.end_time_of_pos(data.freq.end_time_of_pos==0)=[];
data.freq.end_time_of_neg(data.freq.end_time_of_neg==0)=[];

for i=1:length(data.freq.end_time_of_pos)
data.freq.TIME_pos(i,1)=data.freq.time(data.freq.end_time_of_pos(i,1));
end
for i=1:length(data.freq.end_time_of_neg)
data.freq.TIME_neg(i,1)=data.freq.time(data.freq.end_time_of_neg(i,1));
end



%Freq_pos&neg_l&r=frequency/1min

data.freq.Freq_pos = histc(data.freq.TIME_pos,[0:60:(floor(data.freq.time(end,1)/60))*60]);
data.freq.Freq_neg = histc(data.freq.TIME_neg,[0:60:(floor(data.freq.time(end,1)/60))*60]);
for i=1:length(data.freq.Freq_pos)
data.freq.Freq_diff(i,1)= data.freq.Freq_pos(i,1)-data.freq.Freq_neg(i,1);
end




figure(1)
subplot(2,1,1)
plot(data.freq.time/60,data.freq.eye_raw); hold on;
x1 = data.freq.time(data.freq.end_time_of_pos(:,1))/60;
y1 = data.freq.eye_raw(data.freq.end_time_of_pos(:,1));
plot(x1,y1,'*r');
title('left eyes raw traces')
x2 = data.freq.time(data.freq.end_time_of_neg(:,1))/60;
y2 = data.freq.eye_raw(data.freq.end_time_of_neg(:,1));
plot(x2,y2,'*g');
title('left eyes raw traces')




subplot(2,1,2)
x=1:length(data.freq.Freq_pos);
y1=data.freq.Freq_pos(x,1);
y2=data.freq.Freq_neg(x,1);
y3=data.freq.Freq_diff(x,1);
plot(x,y1,'ro',x,y2,'go',x,y3,'bo');
legend('positive directed saccades','negative directed saccades','difference')



