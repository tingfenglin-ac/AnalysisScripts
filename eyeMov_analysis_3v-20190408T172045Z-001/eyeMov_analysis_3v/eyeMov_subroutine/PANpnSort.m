function [pMidVel,pMidIdx,nMidVel,nMidIdx]=PANpnSort(dMidVel,dIDX,MidVelodd,lIDXodd,MidVeleven,lIDXeven)

[pMidVel,pMidIdx,nMidVel,nMidIdx]=PNSorting(dMidVel,dIDX);

if sum(MidVelodd)>sum(MidVeleven)
    pMidVel=[pMidVel;MidVelodd];
    nMidVel=[nMidVel;abs(MidVeleven)];
    pMidIdx=[pMidIdx;lIDXodd];
    nMidIdx=[nMidIdx;lIDXeven];
else
    pMidVel=[pMidVel;MidVeleven];
    nMidVel=[nMidVel;abs(MidVelodd)];
    pMidIdx=[pMidIdx;lIDXeven];
    nMidIdx=[nMidIdx;lIDXodd];
end


end

