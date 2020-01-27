function [pMidVel,pMidIdx,nMidVel,nMidIdx]=PNSorting(MidVel,IDX);
pMidVel=(MidVel(MidVel>0));
pMidIdx=(IDX(MidVel>0,:));
nMidVel=abs(MidVel(MidVel<0));
nMidIdx=(IDX(MidVel<0,:));
end