function [rect]=RectAdjust(frame,rect);

%if ROI id is too small
rect(find(rect<1))=1;
%if ROI id is too large
OverSizeID=find((rect(:,2)+rect(:,4))>size(frame,1));
LargestID=size(frame,1)-rect(:,2);
rect(OverSizeID,4)=LargestID(OverSizeID);
OverSizeID=find((rect(:,1)+rect(:,3))>size(frame,2));
LargestID=size(frame,2)-rect(:,1);
rect(OverSizeID,3)=LargestID(OverSizeID);