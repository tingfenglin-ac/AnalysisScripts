function [Mat]=MergeMat(Mat,Array)

if length(Mat)~=0 & length(Mat)<length(Array)
    Mat(end+1:length(Array),:)=nan;
end
if  length(Mat)>length(Array)
    Array(end+1:length(Mat),:)=nan;
end
Mat=[Mat Array];
end