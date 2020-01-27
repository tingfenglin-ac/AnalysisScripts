function [PosIdx,NegIdx]=SaccDir(data,l_r)
% l_r='r'
IDX=data.(['SaccExtremeIdx',upper(l_r)]);
EYE=data.([l_r,'eye_raw']);
Diff=EYE(IDX(:,2))-EYE(IDX(:,1));
PosIdx=IDX(Diff>0,2);
NegIdx=IDX(Diff<0,2);
end