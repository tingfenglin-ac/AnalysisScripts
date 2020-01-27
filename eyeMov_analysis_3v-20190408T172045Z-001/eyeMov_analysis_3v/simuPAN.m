[fileName,pathName] = uigetfile('*.mat');
load([pathName,fileName]);
% data=ans;
clear temp

%if protocol is WT protocol fish =0, if protocol is bel protocol fish= any
%number
fish=0;
if fish==0
    protocol=[0 5 25 30 50 60];
    protocol_name={'Dark' 'OKR' 'Dark' 'OKR' 'Dark'}
else
    protocol=[0 5 25 30 50 60 80 85 105 115];
    protocol_name={'Dark' 'OKR' 'Dark' 'OKR' 'Dark' 'OKR' 'Dark' 'OKR' 'Dark'}
end

for g=1:2
    if g==1
        temp.SaccExtremeIdx=data.SaccExtremeIdxL;
        temp.eye_raw=data.leye_raw;
        temp.time=data.time_l;
    end
    if g==2
        temp.SaccExtremeIdx=data.SaccExtremeIdxR;
        temp.eye_raw=data.reye_raw;
        temp.time=data.time_r;
    end

%for simulate PAN (square stimuli)
%beginning of first stimuli (sec)
dele.b1=5*60;
%end of first stimuli (sec)
dele.e1=25*60;
%beninning of second stimuli (sec)
dele.b2=30*60;
%end of second stimuli (sec)
dele.e2=50*60;
%the dele.duration of direction exchange cycle (sec)
dele.dur=15;

temp.SaccExtremeIdx(isnan(temp.SaccExtremeIdx(:,1)),:)=[];
temp.SphIdx_d1=[];
temp.SphIdx_d2=[];
temp.SphIdx_d3=[];
temp.SphIdx_p1=[];
temp.SphIdx_n1=[];
temp.SphIdx_p2=[];
temp.SphIdx_n2=[];


for i=1:length(temp.SaccExtremeIdx);
%     if length(temp.SaccExtremeIdx)<10;
%         temp.SphIdx_d1=[1];
%         temp.SphIdx_d2=[1];
%         temp.SphIdx_d3=[1];
%         temp.SphIdx_p1=[1];
%         temp.SphIdx_n1=[1];
%         temp.SphIdx_p2=[1];
%         temp.SphIdx_n2=[1];
%     else
if temp.time(max(temp.SaccExtremeIdx(:,2)))<=dele.e2;
    temp.SaccExtremeIdx(end+1,:)=[length(temp.time) length(temp.time)];
end
    
    
            dele.T1=temp.time(temp.SaccExtremeIdx(i,1));%make the floowing function shorter
            dele.T2=temp.time(temp.SaccExtremeIdx(i,2));%make the floowing function shorter
            % first 5 minutes of dark
            if dele.T2+1.5 < dele.b1 %if dele.T2 is 1.5 second before the stimulus
                if temp.time(temp.SaccExtremeIdx(i+1,1))>dele.b1;
                    temp.SphIdx_d1(end+1,:)=[temp.SaccExtremeIdx(i,2),max(find(temp.time<dele.b1))];
                else
                temp.SphIdx_d1(end+1,:)=[temp.SaccExtremeIdx(i,2),temp.SaccExtremeIdx(i+1,1)];
                end
            end

            % second 5 minutes of dark
            if dele.T2>dele.e1 & dele.T2+1.5<dele.b2  %if dele.T2 is 1.5 second before the second stimulus
                    if temp.time(temp.SaccExtremeIdx(i+1,1))>dele.b2;
                        temp.SphIdx_d2(end+1,:)=[temp.SaccExtremeIdx(i,2),max(find(temp.time<dele.b2))];
                    else
                    temp.SphIdx_d2(end+1,:)=[temp.SaccExtremeIdx(i,2),temp.SaccExtremeIdx(i+1,1)];
                    end
            end

            % third 5 minutes of dark
            if dele.T2>dele.e2 %if dele.T2 is after the previous stimulus
                if i==length(temp.SaccExtremeIdx(:,1));
                    temp.SphIdx_d3(end+1,:)=[temp.SaccExtremeIdx(i,2),length(temp.time)];
                else
                temp.SphIdx_d3(end+1,:)=[temp.SaccExtremeIdx(i,2),temp.SaccExtremeIdx(i+1,1)];
                end
            end


            %%first 20minute of positive
            if dele.T1>dele.b1 & dele.T2<dele.e1;
                    if mod(ceil((dele.T1-dele.b1)/dele.dur),2)==1; %dele.T1 is in positive stimuli (/dele.dur=odd number)
                        if and((dele.T1-dele.b1)-floor((dele.T1-dele.b1)/dele.dur)*dele.dur>=2,temp.time(temp.SaccExtremeIdx(i-1,2))-dele.b1<floor((dele.T1-dele.b1)/dele.dur)*dele.dur); % if dele.T1 is 2 second after the beggining of pos stimuli & the previous dele.T2<dele.b1 or previous dele.T2 is dele.during neg stimuli
                            temp.SphIdx_p1(end+1,:)=[find(temp.time>(floor((dele.T1-dele.b1)/dele.dur)*dele.dur+dele.b1+1),1),temp.SaccExtremeIdx(i,1)];
                        end
                    end
                    if mod(ceil((dele.T2-dele.b1)/dele.dur),2)==1; %dele.T2 is in positive stimuili (/dele.dur=odd number)
                        if and(ceil((dele.T2-dele.b1)/dele.dur)*dele.dur-(dele.T2-dele.b1)>=1.5,temp.time(temp.SaccExtremeIdx(i+1,1))-dele.b1>ceil((dele.T2-dele.b1)/dele.dur)*dele.dur);% if dele.T1 is 1.5 second before the end of pos stimuli & if the next dele.T1>dele.e1 or next dele.T1 is dele.during neg stimuli
                            temp.SphIdx_p1(end+1,:)=[temp.SaccExtremeIdx(i,2),max(find(temp.time<(ceil((dele.T2-dele.b1)/dele.dur)*dele.dur+dele.b1-0.5)))];
                        end
                        if and((dele.T2-dele.b1)>=floor((dele.T2-dele.b1)/dele.dur)*dele.dur,temp.time(temp.SaccExtremeIdx(i+1,1))-dele.b1<=ceil((dele.T2-dele.b1)/dele.dur)*dele.dur);% if dele.T2 and next dele.T1 are both in the same pos stimulus phaase
                            temp.SphIdx_p1(end+1,:)=[temp.SaccExtremeIdx(i,2),temp.SaccExtremeIdx(i+1,1)];
                        end
                    end
                    if mod(ceil((dele.T2-dele.b1)/dele.dur),2)==0 & temp.time(temp.SaccExtremeIdx(i+1,1))-dele.b1>(ceil((dele.T2-dele.b1)/dele.dur)+1)*dele.dur & dele.T2<(dele.e1-dele.dur); %dele.T2 is in neg stimuili (/dele.dur=even number) & end of dele.T2 slow phase is greater than next neg stimuli
                        temp.SphIdx_p1(end+1,:)=[find(temp.time>(ceil((dele.T2-dele.b1)/dele.dur)*dele.dur+dele.b1+1),1),max(find(temp.time<(ceil((dele.T2-dele.b1)/dele.dur+1)*dele.dur+dele.b1-1)))];
                    end
        %first 20minute of negative
                if mod(ceil((dele.T1-dele.b1)/dele.dur),2)==0; %dele.T1 is in negtive stimuli (/dele.dur=even number)
                    if and((dele.T1-dele.b1)-floor((dele.T1-dele.b1)/dele.dur)*dele.dur>=2,temp.time(temp.SaccExtremeIdx(i-1,2))-dele.b1<floor((dele.T1-dele.b1)/dele.dur)*dele.dur); % if dele.T1 is 2 second after the beggining of pos stimuli & the previous dele.T2<dele.b1 or previous dele.T2 is dele.during neg stimuli
                        temp.SphIdx_n1(end+1,:)=[find(temp.time>(floor((dele.T1-dele.b1)/dele.dur)*dele.dur+dele.b1+1),1),temp.SaccExtremeIdx(i,1)];
                    end
                end
                if mod(ceil((dele.T2-dele.b1)/dele.dur),2)==0; %dele.T2 is in negative stimuili (/dele.dur=even number)
                    if and(ceil((dele.T2-dele.b1)/dele.dur)*dele.dur-(dele.T2-dele.b1)>=1.5,temp.time(temp.SaccExtremeIdx(i+1,1))-dele.b1>ceil((dele.T2-dele.b1)/dele.dur)*dele.dur);% if dele.T1 is 1.5 second before the end of pos stimuli & if the next dele.T1>dele.e1 or next dele.T1 is dele.during neg stimuli
                        temp.SphIdx_n1(end+1,:)=[temp.SaccExtremeIdx(i,2),max(find(temp.time<(ceil((dele.T2-dele.b1)/dele.dur)*dele.dur+dele.b1-0.5)))];
                    end
                    if and((dele.T2-dele.b1)>=floor((dele.T2-dele.b1)/dele.dur)*dele.dur,temp.time(temp.SaccExtremeIdx(i+1,1))-dele.b1<=ceil((dele.T2-dele.b1)/dele.dur)*dele.dur);% if dele.T2 and next dele.T1 are both in the same pos stimulus phaase
                        temp.SphIdx_n1(end+1,:)=[temp.SaccExtremeIdx(i,2),temp.SaccExtremeIdx(i+1,1)];
                    end
                end
                if mod(ceil((dele.T2-dele.b1)/dele.dur),2)==1 & temp.time(temp.SaccExtremeIdx(i+1,1))-dele.b1>(ceil((dele.T2-dele.b1)/dele.dur)+1)*dele.dur & dele.T2<(dele.e1-dele.dur); %dele.T2 is in pos stimuili (/dele.dur=even number) & end of dele.T2 slow phase is greater than next pos stimuli
                    temp.SphIdx_n1(end+1,:)=[find(temp.time>(ceil((dele.T2-dele.b1)/dele.dur)*dele.dur+dele.b1+1),1),max(find(temp.time<(ceil((dele.T2-dele.b1)/dele.dur+1)*dele.dur+dele.b1-1)))];
                end        
            end

        %p2 and n2
            %%first 20minute of positive
            if dele.T1>dele.b2 & dele.T2<dele.e2; 
                if mod(ceil((dele.T1-dele.b2)/dele.dur),2)==1; %dele.T1 is in positive stimuli (/dele.dur=odd number)
                    if and((dele.T1-dele.b2)-floor((dele.T1-dele.b2)/dele.dur)*dele.dur>=2,temp.time(temp.SaccExtremeIdx(i-1,2))-dele.b2<floor((dele.T1-dele.b2)/dele.dur)*dele.dur); % if dele.T1 is 2 second after the beggining of pos stimuli & the previous dele.T2<dele.b2 or previous dele.T2 is dele.during neg stimuli
                        temp.SphIdx_p2(end+1,:)=[find(temp.time>(floor((dele.T1-dele.b2)/dele.dur)*dele.dur+dele.b2+1),1),temp.SaccExtremeIdx(i,1)];
                    end
                end
                if mod(ceil((dele.T2-dele.b2)/dele.dur),2)==1; %dele.T2 is in positive stimuili (/dele.dur=odd number)
                    if and(ceil((dele.T2-dele.b2)/dele.dur)*dele.dur-(dele.T2-dele.b2)>=1.5,temp.time(temp.SaccExtremeIdx(i+1,1))-dele.b2>ceil((dele.T2-dele.b2)/dele.dur)*dele.dur);% if dele.T1 is 1.5 second before the end of pos stimuli & if the next dele.T1>dele.e1 or next dele.T1 is dele.during neg stimuli
                        temp.SphIdx_p2(end+1,:)=[temp.SaccExtremeIdx(i,2),max(find(temp.time<(ceil((dele.T2-dele.b2)/dele.dur)*dele.dur+dele.b2-0.5)))];
                    end
                    if and((dele.T2-dele.b2)>=floor((dele.T2-dele.b2)/dele.dur)*dele.dur,temp.time(temp.SaccExtremeIdx(i+1,1))-dele.b2<=ceil((dele.T2-dele.b2)/dele.dur)*dele.dur);% if dele.T2 and next dele.T1 are both in the same pos stimulus phaase
                        temp.SphIdx_p2(end+1,:)=[temp.SaccExtremeIdx(i,2),temp.SaccExtremeIdx(i+1,1)];
                    end
                end
                if mod(ceil((dele.T2-dele.b2)/dele.dur),2)==0 & temp.time(temp.SaccExtremeIdx(i+1,1))-dele.b2>(ceil((dele.T2-dele.b2)/dele.dur)+1)*dele.dur & dele.T2<(dele.e1-dele.dur); %dele.T2 is in neg stimuili (/dele.dur=even number) & end of dele.T2 slow phase is greater than next neg stimuli
                    temp.SphIdx_p2(end+1,:)=[find(temp.time>(ceil((dele.T2-dele.b2)/dele.dur)*dele.dur+dele.b2+1),1),max(find(temp.time<(ceil((dele.T2-dele.b2)/dele.dur+1)*dele.dur+dele.b2-1)))];
                end        


        %%first 20minute of negative
                if mod(ceil((dele.T1-dele.b2)/dele.dur),2)==0; %dele.T1 is in negtive stimuli (/dele.dur=even number)
                    if and((dele.T1-dele.b2)-floor((dele.T1-dele.b2)/dele.dur)*dele.dur>=2,temp.time(temp.SaccExtremeIdx(i-1,2))-dele.b2<floor((dele.T1-dele.b2)/dele.dur)*dele.dur); % if dele.T1 is 2 second after the beggining of pos stimuli & the previous dele.T2<dele.b2 or previous dele.T2 is dele.during neg stimuli
                        temp.SphIdx_n2(end+1,:)=[find(temp.time>(floor((dele.T1-dele.b2)/dele.dur)*dele.dur+dele.b2+1),1),temp.SaccExtremeIdx(i,1)];
                    end
                end
                if mod(ceil((dele.T2-dele.b2)/dele.dur),2)==0; %dele.T2 is in negative stimuili (/dele.dur=even number)
                    if and(ceil((dele.T2-dele.b2)/dele.dur)*dele.dur-(dele.T2-dele.b2)>=1.5,temp.time(temp.SaccExtremeIdx(i+1,1))-dele.b2>ceil((dele.T2-dele.b2)/dele.dur)*dele.dur);% if dele.T1 is 1.5 second before the end of pos stimuli & if the next dele.T1>dele.e1 or next dele.T1 is dele.during neg stimuli
                        temp.SphIdx_n2(end+1,:)=[temp.SaccExtremeIdx(i,2),max(find(temp.time<(ceil((dele.T2-dele.b2)/dele.dur)*dele.dur+dele.b2-0.5)))];
                    end
                    if and((dele.T2-dele.b2)>=floor((dele.T2-dele.b2)/dele.dur)*dele.dur,temp.time(temp.SaccExtremeIdx(i+1,1))-dele.b2<=ceil((dele.T2-dele.b2)/dele.dur)*dele.dur);% if dele.T2 and next dele.T1 are both in the same pos stimulus phaase
                        temp.SphIdx_n2(end+1,:)=[temp.SaccExtremeIdx(i,2),temp.SaccExtremeIdx(i+1,1)];
                    end
                end
                if mod(ceil((dele.T2-dele.b2)/dele.dur),2)==1 & temp.time(temp.SaccExtremeIdx(i+1,1))-dele.b2>(ceil((dele.T2-dele.b2)/dele.dur)+1)*dele.dur & dele.T2<(dele.e1-dele.dur); %dele.T2 is in neg stimuili (/dele.dur=even number) & end of dele.T2 slow phase is greater than next neg stimuli
                    temp.SphIdx_n2(end+1,:)=[find(temp.time>(ceil((dele.T2-dele.b2)/dele.dur)*dele.dur+dele.b2+1),1),max(find(temp.time<(ceil((dele.T2-dele.b2)/dele.dur+1)*dele.dur+dele.b2-1)))];
                end        
            end
%     end        
    end

figure
plot(temp.time/60,temp.eye_raw,'k');
if g==1
    title('left eye');
    PAN.leye=temp;
else
    title('right eye');
    PAN.reye=temp;
end
hold on
dele.ylebel=median(temp.eye_raw)+30;

for i=2:length(protocol)
if mod(i,2)==0;
    plot([protocol(i-1) protocol(i)],[dele.ylebel dele.ylebel],'k');
else
    plot([protocol(i-1) protocol(i)],[dele.ylebel dele.ylebel],'k:');
end
end
ylim([-50 50])

% plot(temp.time(temp.SphIdx_d1(:,2)),temp.eye_raw(temp.SphIdx_d1(:,2)),'go');
% plot(temp.time(temp.SphIdx_d1(:,1)),temp.eye_raw(temp.SphIdx_d1(:,1)),'ro');
% for i=1:length(temp.SphIdx_d1(:,1));
% plot(temp.time(temp.SphIdx_d1(i,:)),temp.eye_raw(temp.SphIdx_d1(i,:)),'r');
% end
% 
% figure
% plot(temp.time,temp.eye_raw);
% hold on
% plot(temp.time(temp.SphIdx_d2(:,2)),temp.eye_raw(temp.SphIdx_d2(:,2)),'go');
% plot(temp.time(temp.SphIdx_d2(:,1)),temp.eye_raw(temp.SphIdx_d2(:,1)),'ro');
% for i=1:length(temp.SphIdx_d2(:,1));
% plot(temp.time(temp.SphIdx_d2(i,:)),temp.eye_raw(temp.SphIdx_d2(i,:)),'r');
% end
% 
% figure
% plot(temp.time,temp.eye_raw);
% hold on
% plot(temp.time(temp.SphIdx_d3(:,2)),temp.eye_raw(temp.SphIdx_d3(:,2)),'go');
% plot(temp.time(temp.SphIdx_d3(:,1)),temp.eye_raw(temp.SphIdx_d3(:,1)),'ro');
% for i=1:length(temp.SphIdx_d3(:,1));
% plot(temp.time(temp.SphIdx_d3(i,:)),temp.eye_raw(temp.SphIdx_d3(i,:)),'r');
% end
% 
% figure
% plot(temp.time,temp.eye_raw);
% hold on
% plot(temp.time(temp.SphIdx_p1(:,2)),temp.eye_raw(temp.SphIdx_p1(:,2)),'go');
% plot(temp.time(temp.SphIdx_p1(:,1)),temp.eye_raw(temp.SphIdx_p1(:,1)),'ro');
% for i=1:length(temp.SphIdx_p1(:,1));
% plot(temp.time(temp.SphIdx_p1(i,:)),temp.eye_raw(temp.SphIdx_p1(i,:)),'r');
% end
% 
% figure
% plot(temp.time,temp.eye_raw);
% hold on
% plot(temp.time(temp.SphIdx_n1(:,2)),temp.eye_raw(temp.SphIdx_n1(:,2)),'go');
% plot(temp.time(temp.SphIdx_n1(:,1)),temp.eye_raw(temp.SphIdx_n1(:,1)),'ro');
% for i=1:length(temp.SphIdx_n1(:,1));
% plot(temp.time(temp.SphIdx_n1(i,:)),temp.eye_raw(temp.SphIdx_n1(i,:)),'r');
% end
% 
% figure
% plot(temp.time,temp.eye_raw);
% hold on
% plot(temp.time(temp.SphIdx_p2(:,2)),temp.eye_raw(temp.SphIdx_p2(:,2)),'go');
% plot(temp.time(temp.SphIdx_p2(:,1)),temp.eye_raw(temp.SphIdx_p2(:,1)),'ro');
% for i=1:length(temp.SphIdx_p2(:,1));
% plot(temp.time(temp.SphIdx_p2(i,:)),temp.eye_raw(temp.SphIdx_p2(i,:)),'r');
% end
% 
% figure
% plot(temp.time,temp.eye_raw);
% hold on
% plot(temp.time(temp.SphIdx_n2(:,2)),temp.eye_raw(temp.SphIdx_n2(:,2)),'go');
% plot(temp.time(temp.SphIdx_n2(:,1)),temp.eye_raw(temp.SphIdx_n2(:,1)),'ro');
% for i=1:length(temp.SphIdx_n2(:,1));
% plot(temp.time(temp.SphIdx_n2(i,:)),temp.eye_raw(temp.SphIdx_n2(i,:)),'r');
% end




% figure
% plot(temp.time,temp.eye_raw);
% hold on
% plot(temp.time(temp.SaccExtremeIdx(:,2)),temp.eye_raw(temp.SaccExtremeIdx(:,2)),'ro');
% plot(temp.time(temp.SaccExtremeIdx(:,1)),temp.eye_raw(temp.SaccExtremeIdx(:,1)),'go');


%dele.velocity obtained by derivetives
temp.dydt = derivate(temp.eye_raw,1/40);
%data.Velocity.SaccExtremeIdx(isnan(data.Velocity.SaccExtremeIdx(:,1)),:)=[];

[temp.vel_d1]=velocity(temp.eye_raw,temp.time,temp.SphIdx_d1,1);
[temp.vel_d2]=velocity(temp.eye_raw,temp.time,temp.SphIdx_d2,1);
[temp.vel_d3]=velocity(temp.eye_raw,temp.time,temp.SphIdx_d3,1);
[temp.vel_p1]=velocity(temp.eye_raw,temp.time,temp.SphIdx_p1,1);
[temp.vel_n1]=velocity(temp.eye_raw,temp.time,temp.SphIdx_n1,1);
[temp.vel_p2]=velocity(temp.eye_raw,temp.time,temp.SphIdx_p2,1);
[temp.vel_n2]=velocity(temp.eye_raw,temp.time,temp.SphIdx_n2,1);




figure;
test={'p1','n1','p2','n2','d1','d2','d3'};
idx=cell(1,length(test));
for k=1:length(test);
    vel=temp.(['vel_',test{k}]);
    SphIdx=temp.(['SphIdx_',test{k}]);
    if ~isempty(vel)  ;
        idx{k}=1;
    end
    hold on
    idx_neg=vel<0
    scatter(temp.time(SphIdx(idx_neg,idx{k}))/60,abs(vel(idx_neg)),'r');
    scatter(temp.time(SphIdx(~idx_neg,idx{k}))/60,abs(vel(~idx_neg)),'b');
    clear vel SphIdx
end

dele.ylebel=median(abs(temp.vel_p1))+5;

for i=2:length(protocol)
if mod(i,2)==0;
    plot([protocol(i-1) protocol(i)],[dele.ylebel dele.ylebel],'k');
else
    plot([protocol(i-1) protocol(i)],[dele.ylebel dele.ylebel],'k:');
end
end


if g==1
    title('left eye');
    PAN.leye=temp;
else
    title('right eye');
    PAN.reye=temp;
end
clear dele g i temp;

end

velocity_distribution;