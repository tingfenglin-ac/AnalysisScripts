function [vp,sp,vn,sn]=SortPN(v,s);
%v=velocity s=datasize
vp=v(v>=0);
sp=s(v>=0);
vn=flipud(abs(v(v<=0)));
sn=flipud(s(v<=0));
% sp(end+1:numel(sn))=0;
% sn(end+1:numel(sp))=0;
vp=[(0:300)'];
vn=[(0:300)'];
end