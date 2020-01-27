function [outputpath]=autorunfreqmedian(data,start_time,end_time,okanstart_time,okanend_time);

for i=1:length(data(:,1));
    postemp=[];
    [postemp]=findfreqmedian(data{i,16},data{i,17},data{i,12});
    negtemp=[];
    [negtemp]=findfreqmedian(data{i,17},data{i,16},data{i,13});
    difftemp.median=negtemp.median-postemp.median;
    
    outputpath.posmedian{i,1}=postemp.median;
    outputpath.negmedian{i,1}=negtemp.median;
    outputpath.diffmedian{i,1}=difftemp.median;
    outputpath.time{i,1}=postemp.time;
%     figure
%     x=outputpath.time{i,1}(:);
%     y1=outputpath.posmedian{i,1}(:);
%     y2=outputpath.negmedian{i,1}(:);
%     y3=outputpath.diffmedian{i,1}(:);
%     plot(x,y1,'bo',x,y2,'ro',x,y3,'go');
end
figure
    [fitingoutput]=fit2exp([],outputpath.time{1,1}(:),outputpath.diffmedian{1,1}(:),start_time,end_time,okanstart_time,okanend_time);
for i=2:length(data(:,1));
    figure
    [fitingoutput]=fit2exp(fitingoutput,outputpath.time{i,1}(:),outputpath.diffmedian{i,1}(:),start_time,end_time,okanstart_time,okanend_time);
end
outputpath.fiting=fitingoutput;
end




