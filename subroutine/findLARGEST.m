function [largest]=findLARGEST(data,n)
for m=1:n
    if m==1
    largest=max(data);
    data
    end
    if m~=1
        largest(end+1)=max(data(data<largest(end)));%if there are more than two number equal max, there is still a problem
    end
end