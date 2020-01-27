function [MidVel,IntIDX]=FirstSecVel(TIME,VEL,IDX)
VelInt=1;%the interval of slow phase to be calculated
% figure
% plot(TIME,VEL,'k');
% hold on
for i=1:length(IDX)-1
    if TIME(IDX(i+1,1))-TIME(IDX(i,2))>VelInt
        SphEnd=sum(TIME<TIME(IDX(i,2))+VelInt);
        IntIDX(i,:)=[IDX(i,2) SphEnd];
        
        nNANvel=VEL(IntIDX(i,1):IntIDX(i,2));
        MidVel(i,:)=median(nNANvel(~isnan(nNANvel)));
        %         plot(TIME(IntIDX(i,1):IntIDX(i,2)),VEL(IntIDX(i,1):IntIDX(i,2)),'r');
    else
        IntIDX(i,:)=[IDX(i,2) IDX(i+1,1)];
        
        nNANvel=VEL(IntIDX(i,1):IntIDX(i,2));
        MidVel(i,:)=median(nNANvel(~isnan(nNANvel)));
        %         plot(TIME(IntIDX(i,1):IntIDX(i,2)),VEL(IntIDX(i,1):IntIDX(i,2)),'r');
    end
end
end