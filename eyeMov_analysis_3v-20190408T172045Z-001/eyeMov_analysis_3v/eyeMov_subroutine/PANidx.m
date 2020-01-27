function [dIDX,lIDXodd,lIDXeven]=PANidx(VEL,TIME,IDX,IndexPro);
VelInt=1;%duration of slow phase to be calculated
VelBuf=0.5;%slow phase start after VelBuf wll be calculated
[protocol,protocol_name]=ProtocolLibrary(IndexPro);
protocol=protocol*60
IDX=[IDX(1:end,2) [IDX(2:end,1);length(TIME)]];
time1=TIME(IDX(:,1));
time2=TIME(IDX(:,2));
dIDX=[];
lIDXodd=[];
lIDXeven=[];
T=[];

testIDX=[];


StimIndex=find(strcmp(protocol_name,'Dark'))+1;
OddInterval=[];
EvenInterval=[];
for p=1:length(StimIndex)-1
    OddInterval=[OddInterval protocol(StimIndex(p)):30:protocol(StimIndex(p)+1)-30];
    EvenInterval=[EvenInterval protocol(StimIndex(p))+15:30:protocol(StimIndex(p)+1)-15];
end


for s=1:length(IDX)
    for i=1:length(protocol_name)
        if time1(s)>=protocol(i) && protocol(i+1)-time1(s)>=VelInt;
            %if the start of slow phase if bigger than begining of
            %protocol and VelInt second before the end of the direction
            %change
            
            if strcmp(protocol_name(i),'Dark');
                [idxVelInt]=SPHend(TIME,IDX(s,1),VelInt);
                dIDX(size(dIDX,1)+1,:)=[IDX(s,1) min([IDX(s,2) idxVelInt])];             
            else
                Interval=protocol(i):30:protocol(i+1);
                EndInt=sum(time1(s)-Interval>=VelBuf)*30+protocol(i);
                %EndInt is the end of 30second interval of a slow phase
                T(length(T)+1)=EndInt-time1(s);
                
                if T(end)>=(VelInt+15)
                    [idxVelInt]=SPHend(TIME,IDX(s,1),VelInt);
                    lIDXodd(size(lIDXodd,1)+1,:)=[IDX(s,1) min([IDX(s,2) idxVelInt])];
                end
                if T(end)>=VelInt && T(end)<=(15-VelBuf)
                    [idxVelInt]=SPHend(TIME,IDX(s,1),VelInt);
                    lIDXeven(size(lIDXeven,1)+1,:)=[IDX(s,1) min([IDX(s,2) idxVelInt])];
                end
                
            end
        end
    end
    [lIDXodd]=CrossOverStim(OddInterval,time1(s),time2(s),VelBuf,VelInt,TIME,lIDXodd);
    [lIDXeven]=CrossOverStim(EvenInterval,time1(s),time2(s),VelBuf,VelInt,TIME,lIDXeven);

end    
% figure
% plot(TIME,VEL,'k');
% hold on
% plot(TIME(dIDX'),VEL(dIDX'),'g-o');
% plot(TIME(lIDXodd'),VEL(lIDXodd'),'b-o');
% plot(TIME(lIDXeven'),VEL(lIDXeven'),'r-o');
% plot(TIME(testIDX'),VEL(testIDX'),'b-o');


end 

function [idxVelInt]=SPHend(TIME,IDX,VelInt) 
%VelInt seconds after start of slow phase
timeVelInt=TIME(IDX)+VelInt;
TIMEmat=repmat(TIME,1,length(timeVelInt));
VelIntmat=repmat(timeVelInt',length(TIME),1);
idxVelInt=sum(TIMEmat-VelIntmat<=0,1)+1;
idxVelInt=idxVelInt';
end

function [IDXdata]=CrossOverStim(Interval,time1,time2,VelBuf,VelInt,TIME,IDXdata)
    if sum(Interval-time1>0 & Interval-time2<=-(VelBuf+VelInt))
        StartTime=Interval(Interval-time1>0 & Interval-time2<=-(VelBuf+VelInt));
        %start of slow phase after the stim direction change
        
        TIMEmat=repmat(TIME,1,length(StartTime));
        StartTimemat=repmat(StartTime,length(TIME),1);
        
        idx=(sum((TIMEmat-StartTimemat)<VelBuf,1)+1)';
        %start of slow phase
        
        [idxVelInt]=SPHend(TIME,idx,VelInt);
        %VelInt second after start of slow phase
        
        IDXdata=[IDXdata;[idx idxVelInt]];
    end
end
