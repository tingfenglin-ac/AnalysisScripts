function [MidPos]=MidPosition(Position,IntIDX)
MidPos=[];
for i=1:length(IntIDX(:,1));
    MidPos=[MidPos;median(Position(IntIDX(i,1):IntIDX(i,2)))]
end
end