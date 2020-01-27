clear temp
if exist('fileName')==0;
    [fileName,pathName] = uigetfile('*.mat');
    load([pathName,fileName]);
    [choice]=L_R_analysis();
end


[protocol,protocol_name,result_cat]=ProtocolLibrary(0);
for i=1:length(result_cat)
    temp.(['SphIdx_' result_cat{i}])=[];
end




for g=choice;
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



[temp]=PANindex(temp,dele);

    
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

L_R='LR';
print(gcf,[pathName,fileName(1:end-9),'_raw',L_R(g)],'-dtiff','-r300');

%to check if the positions of index are correct
Check_index_position=1;
if Check_index_position==1
    figure
    G_R={'go' 'ro'};
    for i=1:length(result_cat)
        plot(temp.time,temp.eye_raw,'k');
        hold on
        for a=1:2 %1=beginning of slow phase 2=end of slow phase
            plottime=temp.(['SphIdx_' result_cat{i}]);
            plotraw=temp.(['SphIdx_' result_cat{i}]);
            plot(temp.time(plottime(:,a)),temp.eye_raw(plotraw(:,a)),G_R{a});
            hold on;
        end
        plot(temp.time(plottime)',temp.eye_raw(plotraw)','g');
    end
end



temp.dydt = derivate(temp.eye_raw,1/40);
for i=1:length(result_cat)
    temp.(['vel_', result_cat{i}])=velocity(temp.eye_raw,temp.time,temp.(['SphIdx_' result_cat{i}]),1);
end

figure;
test={'p1','n1','p2','n2','d1','d2','d3'};
idx=cell(1,length(result_cat));
for k=1:length(result_cat);
    vel=temp.(['vel_',result_cat{k}]);
    SphIdx=temp.(['SphIdx_',result_cat{k}]);
    if ~isempty(vel)  ;
        idx{k}=1;
    end
    hold on
    idx_neg=vel<0;
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
print(gcf,[pathName,fileName(1:end-9),'_midvel',L_R(g)],'-dtiff','-r300');

save([pathName,fileName(1:end-9),'_PAN.mat'],'PAN');


end
clear;