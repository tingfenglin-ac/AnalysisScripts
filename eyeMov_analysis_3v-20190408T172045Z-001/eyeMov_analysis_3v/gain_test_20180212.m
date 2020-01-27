data=ans;
for n=1:2;

clear temp
if n==1;
    temp.SaccExtremeIdx=data.SaccExtremeIdxL;
    temp.eye_raw=data.leye_raw;
    temp.time=data.time_l;
else
    temp.SaccExtremeIdx=data.SaccExtremeIdxR;
    temp.eye_raw=data.reye_raw;
    temp.time=data.time_r;
end

fit_lenght=40;

%velocity obtained by derivetives
temp.dydt = diff(temp.eye_raw(:))./diff(temp.time(:));
temp.SaccExtremeIdx(isnan(temp.SaccExtremeIdx(:,1)),:)=[];
temp.velocity=[];
for i=1:length(temp.SaccExtremeIdx)

if i<length(temp.SaccExtremeIdx(:,1));
    y=temp.dydt(temp.SaccExtremeIdx(i,2):(temp.SaccExtremeIdx(i+1,1)));
else
    y=temp.dydt(temp.SaccExtremeIdx(i,2):end);
end
if length(y)>fit_lenght
    y=y(1:fit_lenght,1);
end
  
temp.velocity=[temp.velocity;median(y)];
end



figure;
scatter(temp.time(temp.SaccExtremeIdx(:,2))/60,temp.velocity,'B');
hold on
plot(0:0.1:temp.time(temp.SaccExtremeIdx(end,2))/60,0,'k');

%velocity obtained by fitting

for i=1:length(temp.SaccExtremeIdx)
if i<length(temp.SaccExtremeIdx(:,1));
    y=temp.eye_raw(temp.SaccExtremeIdx(i,2):(temp.SaccExtremeIdx(i+1,1)));
    x=temp.time(temp.SaccExtremeIdx(i,2):(temp.SaccExtremeIdx(i+1,1)));
else
    y=temp.eye_raw(temp.SaccExtremeIdx(i,2):end);
    x=temp.time(temp.SaccExtremeIdx(i,2):end);
end
if length(x)>fit_lenght
    x=x(1:fit_lenght,1);
    y=y(1:fit_lenght,1);
end
X = [ones(length(x),1) x];
b = X\y
temp.slop(i,1)=b(2);
reg_time(i,1)={x};
reg_line(i,1)={X*b};
end

figure
scatter(temp.time(temp.SaccExtremeIdx(:,2)),temp.slop);
figure
x=temp.time;
y=temp.eye_raw;
plot(x,y); 
hold on;
for i=1:length(temp.SaccExtremeIdx)
    plot(reg_time{i,1},reg_line{i,1},'r');
end

if n==1
    data.vel_l.time=temp.time;
    data.vel_l.SaccExtremeIdx=temp.SaccExtremeIdx;
    data.vel_l.velocity=temp.velocity;
    data.vel_l.slop=temp.slop;
    data.vel_l.eye_raw=temp.eye_raw;
else
    data.vel_r.time=temp.time;
    data.vel_r.SaccExtremeIdx=temp.SaccExtremeIdx;
    data.vel_r.velocity=temp.velocity;
    data.vel_r.slop=temp.slop;
    data.vel_r.eye_raw=temp.eye_raw;
end
clear temp
end



prompt = 'Which gain test protocal is it? ';
x = input(prompt)

data.vel_lrpn_median=[]; 
data.vel_pn_median=[];
data.vel_median=[]; 
data.slop_lrpn_median=[]; 
data.slop_pn_median=[]; 
data.slop_median=[]

if x==1
        for j=1:9;
            temp.v_l_pos=[];
            temp.s_l_pos=[];
            temp.v_l_neg=[];
            temp.s_l_neg=[];
            temp.v_r_pos=[];
            temp.s_r_pos=[];
            temp.v_r_neg=[];
            temp.s_r_neg=[];
            for g=1:length(data.vel_l.SaccExtremeIdx);
            if data.vel_l.time(data.vel_l.SaccExtremeIdx(g,2))>(j-1)*30 & data.vel_l.time(data.vel_l.SaccExtremeIdx(g,2))<=j*30-15;
                temp.v_l_pos(end+1,1)=data.vel_l.velocity(g);
                temp.s_l_pos(end+1,1)=data.vel_l.slop(g);
            end
            if data.vel_l.time(data.vel_l.SaccExtremeIdx(g,2))>(j-1)*30+15 & data.vel_l.time(data.vel_l.SaccExtremeIdx(g,2))<=j*30;
                temp.v_l_neg(end+1,1)=data.vel_l.velocity(g);
                temp.s_l_neg(end+1,1)=data.vel_l.slop(g);
            end
            end
            
            
            for g=1:length(data.vel_r.SaccExtremeIdx);
            if data.vel_r.time(data.vel_r.SaccExtremeIdx(g,2))>(j-1)*30 & data.vel_r.time(data.vel_r.SaccExtremeIdx(g,2))<=j*30-15;
                temp.v_r_pos(end+1,1)=data.vel_r.velocity(g);
                temp.s_r_pos(end+1,1)=data.vel_r.slop(g);
            end
            if data.vel_r.time(data.vel_r.SaccExtremeIdx(g,2))>(j-1)*30+15 & data.vel_r.time(data.vel_r.SaccExtremeIdx(g,2))<=j*30;
                temp.v_r_neg(end+1,1)=data.vel_r.velocity(g);
                temp.s_r_neg(end+1,1)=data.vel_r.slop(g);
            end
            end
            
        
            
        data.vel_lrpn_median(end+1,1:4)=[abs(nanmedian(temp.v_l_pos)) abs(nanmedian(temp.v_l_neg)) abs(nanmedian(temp.v_r_pos)) abs(nanmedian(temp.v_r_neg))]; %left_pos left_neg right_pos right_neg
        data.vel_pn_median(end+1,1:2)=[nanmedian(data.vel_lrpn_median(end,[1 3])) nanmedian(data.vel_lrpn_median(end,[2 4]))]; %pos neg 
        data.vel_median(end+1,1)=[nanmedian(data.vel_pn_median(end,:))]; %total
        data.slop_lrpn_median(end+1,1:4)=[abs(nanmedian(temp.s_l_pos)) abs(nanmedian(temp.s_l_neg)) abs(nanmedian(temp.s_r_pos)) abs(nanmedian(temp.s_r_neg))]; %left_pos left_neg right_pos right_neg
        data.slop_pn_median(end+1,1:2)=[nanmedian(data.slop_lrpn_median(end,[1 3])) nanmedian(data.slop_lrpn_median(end,[2 4]))]; %pos neg
        data.slop_median(end+1,1)=[nanmedian(data.slop_pn_median(end,[1 2]))];%total
    end
        figure
        subplot(2,1,1)
        plot([1:9],data.vel_median);
        subplot(2,1,2)
        plot([1:9],data.slop_median);
end

if x==2
        for j=9:-1:1;
            temp.v_l_pos=[];
            temp.s_l_pos=[];
            temp.v_l_neg=[];
            temp.s_l_neg=[];
            temp.v_r_pos=[];
            temp.s_r_pos=[];
            temp.v_r_neg=[];
            temp.s_r_neg=[];
            for g=1:length(data.vel_l.SaccExtremeIdx);
            if data.vel_l.time(data.vel_l.SaccExtremeIdx(g,2))>(j-1)*30 & data.vel_l.time(data.vel_l.SaccExtremeIdx(g,2))<=j*30-15;
                temp.v_l_pos(end+1,1)=data.vel_l.velocity(g);
                temp.s_l_pos(end+1,1)=data.vel_l.slop(g);
            end
            if data.vel_l.time(data.vel_l.SaccExtremeIdx(g,2))>(j-1)*30+15 & data.vel_l.time(data.vel_l.SaccExtremeIdx(g,2))<=j*30;
                temp.v_l_neg(end+1,1)=data.vel_l.velocity(g);
                temp.s_l_neg(end+1,1)=data.vel_l.slop(g);
            end
            end
            
            
            for g=1:length(data.vel_r.SaccExtremeIdx);
            if data.vel_r.time(data.vel_r.SaccExtremeIdx(g,2))>(j-1)*30 & data.vel_r.time(data.vel_r.SaccExtremeIdx(g,2))<=j*30-15;
                temp.v_r_pos(end+1,1)=data.vel_r.velocity(g);
                temp.s_r_pos(end+1,1)=data.vel_r.slop(g);
            end
            if data.vel_r.time(data.vel_r.SaccExtremeIdx(g,2))>(j-1)*30+15 & data.vel_r.time(data.vel_r.SaccExtremeIdx(g,2))<=j*30;
                temp.v_r_neg(end+1,1)=data.vel_r.velocity(g);
                temp.s_r_neg(end+1,1)=data.vel_r.slop(g);
            end
            end
            
        
            
        data.vel_lrpn_median(end+1,1:4)=[abs(nanmedian(temp.v_l_pos)) abs(nanmedian(temp.v_l_neg)) abs(nanmedian(temp.v_r_pos)) abs(nanmedian(temp.v_r_neg))]; %left_pos left_neg right_pos right_neg
        data.vel_pn_median(end+1,1:2)=[nanmedian(data.vel_lrpn_median(end,[1 3])) nanmedian(data.vel_lrpn_median(end,[2 4]))]; %pos neg 
        data.vel_median(end+1,1)=[nanmedian(data.vel_pn_median(end,:))]; %total
        data.slop_lrpn_median(end+1,1:4)=[abs(nanmedian(temp.s_l_pos)) abs(nanmedian(temp.s_l_neg)) abs(nanmedian(temp.s_r_pos)) abs(nanmedian(temp.s_r_neg))]; %left_pos left_neg right_pos right_neg
        data.slop_pn_median(end+1,1:2)=[nanmedian(data.slop_lrpn_median(end,[1 3])) nanmedian(data.slop_lrpn_median(end,[2 4]))]; %pos neg
        data.slop_median(end+1,1)=[nanmedian(data.slop_pn_median(end,[1 2]))];%total
    end
        figure
        subplot(2,1,1)
        plot([1:9],data.vel_median);
        subplot(2,1,2)
        plot([1:9],data.slop_median);
end

if x==3
        for j=[8 6 4 2 1 3 5 7 9];
            temp.v_l_pos=[];
            temp.s_l_pos=[];
            temp.v_l_neg=[];
            temp.s_l_neg=[];
            temp.v_r_pos=[];
            temp.s_r_pos=[];
            temp.v_r_neg=[];
            temp.s_r_neg=[];
            for g=1:length(data.vel_l.SaccExtremeIdx);
            if data.vel_l.time(data.vel_l.SaccExtremeIdx(g,2))>(j-1)*30 & data.vel_l.time(data.vel_l.SaccExtremeIdx(g,2))<=j*30-15;
                temp.v_l_pos(end+1,1)=data.vel_l.velocity(g);
                temp.s_l_pos(end+1,1)=data.vel_l.slop(g);
            end
            if data.vel_l.time(data.vel_l.SaccExtremeIdx(g,2))>(j-1)*30+15 & data.vel_l.time(data.vel_l.SaccExtremeIdx(g,2))<=j*30;
                temp.v_l_neg(end+1,1)=data.vel_l.velocity(g);
                temp.s_l_neg(end+1,1)=data.vel_l.slop(g);
            end
            end
            
            
            for g=1:length(data.vel_r.SaccExtremeIdx);
            if data.vel_r.time(data.vel_r.SaccExtremeIdx(g,2))>(j-1)*30 & data.vel_r.time(data.vel_r.SaccExtremeIdx(g,2))<=j*30-15;
                temp.v_r_pos(end+1,1)=data.vel_r.velocity(g);
                temp.s_r_pos(end+1,1)=data.vel_r.slop(g);
            end
            if data.vel_r.time(data.vel_r.SaccExtremeIdx(g,2))>(j-1)*30+15 & data.vel_r.time(data.vel_r.SaccExtremeIdx(g,2))<=j*30;
                temp.v_r_neg(end+1,1)=data.vel_r.velocity(g);
                temp.s_r_neg(end+1,1)=data.vel_r.slop(g);
            end
            end
            
        
            
        data.vel_lrpn_median(end+1,1:4)=[abs(nanmedian(temp.v_l_pos)) abs(nanmedian(temp.v_l_neg)) abs(nanmedian(temp.v_r_pos)) abs(nanmedian(temp.v_r_neg))]; %left_pos left_neg right_pos right_neg
        data.vel_pn_median(end+1,1:2)=[nanmedian(data.vel_lrpn_median(end,[1 3])) nanmedian(data.vel_lrpn_median(end,[2 4]))]; %pos neg 
        data.vel_median(end+1,1)=[nanmedian(data.vel_pn_median(end,:))]; %total
        data.slop_lrpn_median(end+1,1:4)=[abs(nanmedian(temp.s_l_pos)) abs(nanmedian(temp.s_l_neg)) abs(nanmedian(temp.s_r_pos)) abs(nanmedian(temp.s_r_neg))]; %left_pos left_neg right_pos right_neg
        data.slop_pn_median(end+1,1:2)=[nanmedian(data.slop_lrpn_median(end,[1 3])) nanmedian(data.slop_lrpn_median(end,[2 4]))]; %pos neg
        data.slop_median(end+1,1)=[nanmedian(data.slop_pn_median(end,[1 2]))];%total
    end
        figure
        subplot(2,1,1)
        plot([1:9],data.vel_median);
        subplot(2,1,2)
        plot([1:9],data.slop_median);
end

prompt = 'Do you want to merge the data to the total data? ';
x = input(prompt)
if x==1
merge.vel_median(:,end+1)=data.vel_median;
merge.slop_median(:,end+1)=data.slop_median;
end



% merge.vel_median=[];
% merge.slop_median=[];
