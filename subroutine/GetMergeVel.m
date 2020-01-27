function [MergeDATA]=GetMergeVel(MergeDATA)
lr='lr';
for j=1:2
    for d=1:length(MergeDATA);
        eye_raw=MergeDATA(d).([lr(j),'eye_raw']);
        MergeDATA(d).([lr(j),'vel'])=derivate(eye_raw,1/40);
    end
end
end