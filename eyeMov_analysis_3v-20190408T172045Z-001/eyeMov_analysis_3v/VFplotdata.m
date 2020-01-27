function [mergeddata]=VFplotdata(inputdata,second_n,third_n);
%sencond_n=time of end of OKR
%third_n=time of end of whole recording


mergeddata.VF1dark=[];
mergeddata.VF2okn=[];
mergeddata.VF3dark=[];



for i=1:length(inputdata(:,25));
hold on;
mergeddata.VF1dark=[mergeddata.VF1dark inputdata{i,25}(1:5,1) inputdata{i,20}(1:5,1)];
mergeddata.VF2okn=[mergeddata.VF2okn inputdata{i,25}(6:second_n,1) inputdata{i,20}(6:second_n,1)];



if length(inputdata{i,25}(:,1))<third_n;
velocity=[inputdata{i,25}(second_n+1:end);nan(third_n-length(inputdata{i,25}(:,1)),1)];
frequency=[inputdata{i,20}(second_n+1:end);nan(third_n-length(inputdata{i,25}(:,1)),1)];
mergeddata.VF3dark=[mergeddata.VF3dark velocity frequency];

else if length(inputdata{i,25}(:,1))>=third_n;
mergeddata.VF3dark=[mergeddata.VF3dark inputdata{i,25}(1+second_n:third_n,1) inputdata{i,20}(1+second_n:third_n,1)];
    end
end

end

end