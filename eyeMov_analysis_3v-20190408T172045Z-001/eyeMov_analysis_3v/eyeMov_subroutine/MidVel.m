function [MidVel]=MidVel(Vel,idx)
MidVel=[]
for i=1:length(idx)
    MidVel=[MidVel;median(Vel(idx(i,1):idx(i,2)))]
end

% Velmat=repmat(Vel',length(idx),1);
% idxmat1=repmat(idx(:,1),1,length(Vel));
% idxmat2=repmat(idx(:,2),1,length(Vel));
% number=repmat(1:length(Vel),length(idx),1);
% 
% Velmat(~(number>=idxmat1 & number<=idxmat2))=nan
% MidVel=nanmedian(Velmat,2)
end