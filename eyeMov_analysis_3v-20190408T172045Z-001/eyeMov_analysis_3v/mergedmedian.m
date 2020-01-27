%1 name 2 raw trace,3 time per minutes,
%4 index of pos saccades,5 time of pos saccades,6 index of neg saccades,7 time of neg saccades,
%8 freq_pos number/minute,9 freq_neg number/minute,10 freq diff number/minute,
%11 freq sum number/minute
%12 freq pos estimated by duration, 13 freq neg estimated by duration,
%14 freq pos estimated by duration index, 15 freq neg estimated by
% duration index
%16 time of freq pos estimated by duration, %17 time of freq neg estimated by duration
%18 freq pos estimated by duration(/min), 19 freq neg estimated by duration(/min)
%20 freq diff estimated by duration(/min),21 freq sum estimated by
%duration(/min),
% 22 velocity, 23 velocity index, 24 velocity time, 25 velocity median


function [mergeddata]=mergedmedian(inputdata,n,second_n);


mergeddata=[];
mergeddata.medianpermin=[];
mergeddata.adaptation=[];
mergeddata.OKANamplitude_dark_1min=[];
mergeddata.OKANamplitude_dark_2min=[];

for i=1:length(inputdata(:,25));

if length(inputdata{i,25}(:,1))<n;
nextdata=[inputdata{i,25}(:,1);nan(n-length(inputdata{i,25}(:,1)),1)];
mergeddata.medianpermin=[mergeddata.medianpermin nextdata];

else if length(inputdata{i,25}(:,1))>=n;
mergeddata.medianpermin=[mergeddata.medianpermin inputdata{i,25}(1:n,1)];
    end
end
end

mergeddata.normalized_decay=mergeddata.medianpermin(second_n+1:n,:)./repmat(mergeddata.medianpermin(second_n+2,:),n-second_n,1);

mergeddata.adaptation=1-mergeddata.medianpermin(second_n,:)./mergeddata.medianpermin(5+1,:);
mergeddata.OKANamplitude_dark_1min=(0-mergeddata.medianpermin(second_n+1,:))./mergeddata.medianpermin(5+1,:);
mergeddata.OKANamplitude_dark_2min=(0-mergeddata.medianpermin(second_n+2,:))./mergeddata.medianpermin(5+1,:);



end

