


pooldata.allV10T4time=[];
pooldata.allV10T4value=[];
for i=2:length(mergedTU.V10T4(:,1));
pooldata.allV10T4time=[pooldata.allV10T4time;mergedTU.V10T4{i,24}(:)];
pooldata.allV10T4value=[pooldata.allV10T4value;mergedTU.V10T4{i,22}(:)];
end
[pooldata.V10T4]=fit2exp([],pooldata.allV10T4time,pooldata.allV10T4value,5,9,9.5,19);



pooldata.allV10T5time=[];
pooldata.allV10T5value=[];
for i=1:length(mergedTU.V10T5(:,1));
pooldata.allV10T5time=[pooldata.allV10T5time;mergedTU.V10T5{i,24}(:)];
pooldata.allV10T5value=[pooldata.allV10T5value;mergedTU.V10T5{i,22}(:)];
end
[pooldata.V10T5]=fit2exp([],pooldata.allV10T5time,pooldata.allV10T5value,5,10,10.5,20);

pooldata.allV10T6time=[];
pooldata.allV10T6value=[];
for i=1:length(mergedTU.V10T6(:,1))-1;
pooldata.allV10T6time=[pooldata.allV10T6time;mergedTU.V10T6{i,24}(:)];
pooldata.allV10T6value=[pooldata.allV10T6value;mergedTU.V10T6{i,22}(:)];
end
[pooldata.V10T6]=fit2exp([],pooldata.allV10T6time,pooldata.allV10T6value,5,11,11.5,21);

pooldata.allV10T10time=[];
pooldata.allV10T10value=[];
for i=1:length(mergedTU.V10T10(:,1));
pooldata.allV10T10time=[pooldata.allV10T10time;mergedTU.V10T10{i,24}(:)];
pooldata.allV10T10value=[pooldata.allV10T10value;mergedTU.V10T10{i,22}(:)];
end
[pooldata.V10T10]=fit2exp([],pooldata.allV10T10time,pooldata.allV10T10value,5,15,15.5,25);


pooldata.allV10T20time=[];
pooldata.allV10T20value=[];
for i=1:length(mergedTU.V10T20(:,1));
pooldata.allV10T20time=[pooldata.allV10T20time;mergedTU.V10T20{i,24}(:)];
pooldata.allV10T20value=[pooldata.allV10T20value;mergedTU.V10T20{i,22}(:)];
end
[pooldata.V10T20]=fit2exp([],pooldata.allV10T20time,pooldata.allV10T20value,5,25,25.5,45);

pooldata.allV10T30time=[];
pooldata.allV10T30value=[];
for i=1:length(mergedTU.V10T30(:,1));
pooldata.allV10T30time=[pooldata.allV10T30time;mergedTU.V10T30{i,24}(:)];
pooldata.allV10T30value=[pooldata.allV10T30value;mergedTU.V10T30{i,22}(:)];
end
[pooldata.V10T30]=fit2exp([],pooldata.allV10T30time,pooldata.allV10T30value,5,35,35.5,55);


pooldata.allV10T40time=[];
pooldata.allV10T40value=[];
for i=1:length(mergedTU.V10T40(:,1));
pooldata.allV10T40time=[pooldata.allV10T40time;mergedTU.V10T40{i,24}(:)];
pooldata.allV10T40value=[pooldata.allV10T40value;mergedTU.V10T40{i,22}(:)];
end
[pooldata.V10T40]=fit2exp([],pooldata.allV10T40time,pooldata.allV10T40value,5,45,45.5,65);


allData=[pooldata.V10T4.g(:), pooldata.V10T5.g(:),pooldata.V10T6.g(:),pooldata.V10T10.g(:),pooldata.V10T20.g(:),pooldata.V10T30.g(:),pooldata.V10T40.g(:)];
x=[4 5 6 10 20 30 40];
plot(x,allData,'O')















pooldata.allV10T4time=[];
pooldata.allV10T4value=[];
for i=2:length(mergedTU.V10T4(:,1));
pooldata.allV10T4time=[pooldata.allV10T4time;mergedTU.V10T4{i,24}(:)];
pooldata.allV10T4value=[pooldata.allV10T4value;mergedTU.V10T4{i,22}(:)];
end

[pooldata.median.V10T4]=medianpermin(pooldata.allV10T4time,pooldata.allV10T4value);
pooldata.median.V10T4(end+1,1)=nan;
[pooldata.V10T4]=fit2exp([],[(1:(length(pooldata.median.V10T4))/2)]',pooldata.median.V10T4,5,9,10,(length(pooldata.median.V10T4))/2);



pooldata.allV10T5time=[];
pooldata.allV10T5value=[];
for i=1:length(mergedTU.V10T5(:,1));
pooldata.allV10T5time=[pooldata.allV10T5time;mergedTU.V10T5{i,24}(:)];
pooldata.allV10T5value=[pooldata.allV10T5value;mergedTU.V10T5{i,22}(:)];
end
[pooldata.V10T5]=fit2exp([],pooldata.allV10T5time,pooldata.allV10T5value,5,10,10.5,20);

pooldata.allV10T6time=[];
pooldata.allV10T6value=[];
for i=1:length(mergedTU.V10T6(:,1))-1;
pooldata.allV10T6time=[pooldata.allV10T6time;mergedTU.V10T6{i,24}(:)];
pooldata.allV10T6value=[pooldata.allV10T6value;mergedTU.V10T6{i,22}(:)];
end
[pooldata.V10T6]=fit2exp([],pooldata.allV10T6time,pooldata.allV10T6value,5,11,11.5,21);

pooldata.allV10T10time=[];
pooldata.allV10T10value=[];
for i=1:length(mergedTU.V10T10(:,1));
pooldata.allV10T10time=[pooldata.allV10T10time;mergedTU.V10T10{i,24}(:)];
pooldata.allV10T10value=[pooldata.allV10T10value;mergedTU.V10T10{i,22}(:)];
end
[pooldata.V10T10]=fit2exp([],pooldata.allV10T10time,pooldata.allV10T10value,5,15,15.5,25);


pooldata.allV10T20time=[];
pooldata.allV10T20value=[];
for i=1:length(mergedTU.V10T20(:,1));
pooldata.allV10T20time=[pooldata.allV10T20time;mergedTU.V10T20{i,24}(:)];
pooldata.allV10T20value=[pooldata.allV10T20value;mergedTU.V10T20{i,22}(:)];
end
[pooldata.V10T20]=fit2exp([],pooldata.allV10T20time,pooldata.allV10T20value,5,25,25.5,45);

pooldata.allV10T30time=[];
pooldata.allV10T30value=[];
for i=1:length(mergedTU.V10T30(:,1));
pooldata.allV10T30time=[pooldata.allV10T30time;mergedTU.V10T30{i,24}(:)];
pooldata.allV10T30value=[pooldata.allV10T30value;mergedTU.V10T30{i,22}(:)];
end
[pooldata.V10T30]=fit2exp([],pooldata.allV10T30time,pooldata.allV10T30value,5,35,35.5,55);


pooldata.allV10T40time=[];
pooldata.allV10T40value=[];
for i=1:length(mergedTU.V10T40(:,1));
pooldata.allV10T40time=[pooldata.allV10T40time;mergedTU.V10T40{i,24}(:)];
pooldata.allV10T40value=[pooldata.allV10T40value;mergedTU.V10T40{i,22}(:)];
end
[pooldata.V10T40]=fit2exp([],pooldata.allV10T40time,pooldata.allV10T40value,5,45,45.5,65);


allData=[pooldata.V10T4.g(:), pooldata.V10T5.g(:),pooldata.V10T6.g(:),pooldata.V10T10.g(:),pooldata.V10T20.g(:),pooldata.V10T30.g(:),pooldata.V10T40.g(:)];
x=[4 5 6 10 20 30 40];
plot(x,allData,'O')
