function [binVel,binIdx,MidbinVel,Midinterval]=PANbinSort(time,vel,idx,IndexPro);
bin=15;
[protocol,protocol_name]=ProtocolLibrary(IndexPro);
protocol=protocol*60;
interval=[]
for i=1:length(protocol_name)
    if strcmp(protocol_name(i),'Dark')
        Tempinterval=protocol(i):bin:protocol(i+1);
%         Tempinterval=[Tempinterval(1:end-1);Tempinterval(2:end)]
        interval=[interval Tempinterval];
    else
        Tempinterval=protocol(i)+bin*2:bin*2:protocol(i+1)-bin*2;
%         Tempinterval=[Tempinterval(1:end-1);Tempinterval(2:end)]
        interval=[interval Tempinterval];
    end
end

binVel=cell(length(interval)-1,1);
binIdx=cell(length(interval)-1,1);
for j=1:length(idx)
    binloc=sum(interval-time(idx(j))<=0)
    binIdx{binloc}=[binIdx{binloc} idx(j)]
    binVel{binloc}=[binVel{binloc} vel(j)]
end

interval=[interval(1:end-1);interval(2:end)];
Midinterval=median(interval,1);

for k=1:length(binVel)
% MidbinVel(k)=median(binVel{k});
MidbinVel(k)=mean(binVel{k});
end
end
