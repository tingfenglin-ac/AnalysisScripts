function [outputpath]=autorunmedian(data,start_time,end_time,okanstart_time,okanend_time);

for i=1:length(data(:,1));
    temp=[];
    [temp]=findmedian(data{i,24},data{i,22});
    outputpath.median{i,1}=temp.median;
    outputpath.time{i,1}=temp.time;
    

end
figure
    [fitingoutput]=fit2exp([],outputpath.time{1,1}(:),outputpath.median{1,1}(:),start_time,end_time,okanstart_time,okanend_time);
for i=2:length(data(:,1));
    figure
    [fitingoutput]=fit2exp(fitingoutput,outputpath.time{i,1}(:),outputpath.median{i,1}(:),start_time,end_time,okanstart_time,okanend_time);
end
outputpath.fiting=fitingoutput;
end




