
fitting.V10T8=[];


for i=1:1
[fitting.V10T8]=fit2exp(fitting.V10T8,mergedTU.V10T8{i,24},mergedTU.V10T8{i,22},5,13,13.5,25);
end

figure
boxplot([fitting.V10T8.b(:) fitting.V10T8.d(:)]);
figure
boxplot([fitting.V10T8.okr_adapt1st(:), fitting.V10T8.okr_adapt2nd(:), fitting.V10T8.okanamp(:)]);





figure(1)
x=1:7;
y=[mean(fitting.V10T4.b(:)) mean(fitting.V10T5.b(:)) mean(fitting.V10T6.b(:)) mean(fitting.V10T10.b(:)) mean(fitting.V10T20.b(:)) mean(fitting.V10T30.b(:)) mean(fitting.V10T40.b(:))];
bar(x,y);
title('b')


figure(2)
x=1:7;
y=[mean(fitting.V10T4.d(:)) mean(fitting.V10T5.d(:)) mean(fitting.V10T6.d(:)) mean(fitting.V10T10.d(:)) mean(fitting.V10T20.d(:)) mean(fitting.V10T30.d(:)) mean(fitting.V10T40.d(:))];
bar(x,y);
title('d')




figure
x=1:7;
y=[mean(fitting.V10T4.okr_adapt1st(:)) mean(fitting.V10T5.okr_adapt1st(:)) mean(fitting.V10T6.okr_adapt1st(:)) mean(fitting.V10T10.okr_adapt1st(:)) mean(fitting.V10T20.okr_adapt1st(:)) mean(fitting.V10T30.okr_adapt1st(:)) mean(fitting.V10T40.okr_adapt1st(:))];
bar(x,y);

figure
x=1:7;
y=[mean(fitting.V10T4.okr_adapt2nd(:)) mean(fitting.V10T5.okr_adapt2nd(:)) mean(fitting.V10T6.okr_adapt2nd(:)) mean(fitting.V10T10.okr_adapt2nd(:)) mean(fitting.V10T20.okr_adapt2nd(:)) mean(fitting.V10T30.okr_adapt2nd(:)) mean(fitting.V10T40.okr_adapt2nd(:))];
bar(x,y);

figure
x=[5 6 10 20 30 40];
y=[mean(fitting.V10T5.okr_adapt1st(:)+fitting.V10T5.okr_adapt2nd(:)) mean(fitting.V10T6.okr_adapt1st(1:3)+fitting.V10T6.okr_adapt2nd(1:3)) mean(fitting.V10T10.okr_adapt1st(:)+fitting.V10T10.okr_adapt2nd(:)) mean(fitting.V10T20.okr_adapt1st(:)+fitting.V10T20.okr_adapt2nd(:)) mean(fitting.V10T30.okr_adapt1st(:)+fitting.V10T30.okr_adapt2nd(:)) mean(fitting.V10T40.okr_adapt1st(:)+fitting.V10T40.okr_adapt2nd(:))];
bar(x,y);


figure
x=[4 5 6 10 20 30 40];
y=[mean(fitting.V10T4.okanamp(:)) mean(fitting.V10T5.okanamp(:)) mean(fitting.V10T6.okanamp(1:3)) mean(fitting.V10T10.okanamp(:)) mean(fitting.V10T20.okanamp(:)) mean([fitting.V10T30.okanamp(1:4) fitting.V10T30.okanamp(6:7)]) mean(fitting.V10T40.okanamp(:))];
bar(x,y);






median(fitting.V10T4.g(:)) ?
median(fitting.V10T6.g(1:3))?
 median(fitting.V10T6.g(3))

 




allData={testing.V10T4.fiting.g(:), testing.V10T5.fiting.g(:),testing.V10T6.fiting.g(:),testing.V10T10.fiting.g(:),testing.V10T20.fiting.g(:),testing.V10T30.fiting.g(:),testing.V10T40.fiting.g(:)};
allData=padcat(allData{:});

allRsq={testing.V10T4.fiting.okanrsquare(:), testing.V10T5.fiting.okanrsquare(:),testing.V10T6.fiting.okanrsquare(:),testing.V10T10.fiting.okanrsquare(:),testing.V10T20.fiting.okanrsquare(:),testing.V10T30.fiting.okanrsquare(:),testing.V10T40.fiting.okanrsquare(:)};
allRsq=padcat(allRsq{:});

xAllData=ones(size(allData,1),1)*x;

allData(allRsq<0.05)=nan;

errorbar(x,y,err,'bx');hold on; plot(xAllData,allData,'.')
scatter(x,y);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%V10 velocity fitting
[testing.V10T4]=autorunmedian(mergedTU.V10T4(:,:),5,9,9.5,19);
[testing.V10T6]=autorunmedian(mergedTU.V10T6(1:3,:),5,11,11.5,21);
[testing.V10T5]=autorunmedian(mergedTU.V10T5(1:end,:),5,10,10.5,20);
[testing.V10T10]=autorunmedian(mergedTU.V10T10(1:end,:),5,15,15.5,25);
[testing.V10T20]=autorunmedian(mergedTU.V10T20(1:end,:),5,25,25.5,45);
[testing.V10T40]=autorunmedian(mergedTU.V10T40(1:end,:),5,45,45.5,65);
[testing.V10T30]=autorunmedian(mergedTU.V10T30([1 2 4 6 7],:),5,35,35.5,55);
[testing.V10T8]=autorunmedian(mergedTU.V10T8(:,:),5,13,13.5,23);

%OKAN decay time constant
figure
x=[4 5 6 10 20 30 40];
y=[median(mergedTU.velocityfitting.V10T4.fiting.g(:)) median(mergedTU.velocityfitting.V10T5.fiting.g(:)) median(mergedTU.velocityfitting.V10T6.fiting.g(:)) median(mergedTU.velocityfitting.V10T10.fiting.g(:)) median(mergedTU.velocityfitting.V10T20.fiting.g(:)) median(mergedTU.velocityfitting.V10T30.fiting.g(:)) median(mergedTU.velocityfitting.V10T40.fiting.g(:))];
err=[mad(mergedTU.velocityfitting.V10T4.fiting.g(:),1) mad(mergedTU.velocityfitting.V10T5.fiting.g(:),1) mad(mergedTU.velocityfitting.V10T6.fiting.g(:),1) mad(mergedTU.velocityfitting.V10T10.fiting.g(:),1) mad(mergedTU.velocityfitting.V10T20.fiting.g(:),1) mad([mergedTU.velocityfitting.V10T30.fiting.g(:)],1) mad(mergedTU.velocityfitting.V10T40.fiting.g(:),1)];
scatter(x,y);

%OKR decay time constant
figure(2)
x=[4 5 6 10 20 30 40];
y=[median(testing.V10T4.fiting.b(:)) median(testing.V10T5.fiting.b(:)) median(testing.V10T6.fiting.b(:)) median(testing.V10T10.fiting.b(:)) median(testing.V10T20.fiting.b(:)) median(testing.V10T30.fiting.b(:)) median(testing.V10T40.fiting.b(:))];
% err=[mad(fitting.V10T4.g(:),1) mad(fitting.V10T5.g(:),1) mad(fitting.V10T6.g(:),1) mad(fitting.V10T10.g(:),1) mad(fitting.V10T20.g(:),1) mad([fitting.V10T30.g(:)],1) mad(fitting.V10T40.g(:),1)];
scatter(x,y);

%OKR decay time constant
figure(3)
x=[4 5 6 10 20 30 40];
y=[median(testing.V10T4.fiting.d(:)) median(testing.V10T5.fiting.d(:)) median(testing.V10T6.fiting.d(:)) median(testing.V10T10.fiting.d(:)) median(testing.V10T20.fiting.d(:)) median(testing.V10T30.fiting.d(:)) median(testing.V10T40.fiting.d(:))];
% err=[mad(fitting.V10T4.g(:),1) mad(fitting.V10T5.g(:),1) mad(fitting.V10T6.g(:),1) mad(fitting.V10T10.g(:),1) mad(fitting.V10T20.g(:),1) mad([fitting.V10T30.g(:)],1) mad(fitting.V10T40.g(:),1)];
scatter(x,y);

%adaptation and amplitude estimated by fitting curve
figure
x=[4 5 6 10 20 30 40];
y=[mean(testing.V10T4.fiting.okr_adapt1st(:)) mean(testing.V10T5.fiting.okr_adapt1st(:)) mean(testing.V10T6.fiting.okr_adapt1st(:)) mean(testing.V10T10.fiting.okr_adapt1st(:)) mean(testing.V10T20.fiting.okr_adapt1st(:)) mean(testing.V10T30.fiting.okr_adapt1st(:)) mean(testing.V10T40.fiting.okr_adapt1st(:))];
bar(x,y);
figure
x=[4 5 6 10 20 30 40];
y=[mean(testing.V10T4.fiting.okr_adapt2nd(:)) mean(testing.V10T5.fiting.okr_adapt2nd(:)) mean(testing.V10T6.fiting.okr_adapt2nd(:)) mean(testing.V10T10.fiting.okr_adapt2nd(:)) mean(testing.V10T20.fiting.okr_adapt2nd(:)) mean(testing.V10T30.fiting.okr_adapt2nd(:)) mean(testing.V10T40.fiting.okr_adapt2nd(:))];
bar(x,y);
figure
x=[4 5 6 10 20 30 40];
y=[mean(testing.V10T4.fiting.okr_adapt1st(:)+testing.V10T4.fiting.okr_adapt2nd(:)) mean(testing.V10T5.fiting.okr_adapt1st(:)+testing.V10T5.fiting.okr_adapt2nd(:)) mean(testing.V10T6.fiting.okr_adapt1st(:)+testing.V10T6.fiting.okr_adapt2nd(:)) mean(testing.V10T10.fiting.okr_adapt1st(:)+testing.V10T10.fiting.okr_adapt2nd(:)) mean(testing.V10T20.fiting.okr_adapt1st(:)+testing.V10T20.fiting.okr_adapt2nd(:)) mean(testing.V10T30.fiting.okr_adapt1st(:)+testing.V10T30.fiting.okr_adapt2nd(:)) mean(testing.V10T40.fiting.okr_adapt1st(:)+testing.V10T40.fiting.okr_adapt2nd(:))];
bar(x,y);
figure
x=[4 5 6 10 20 30 40];
y=[mean(testing.V10T4.fiting.okanamp(:)) mean(testing.V10T5.fiting.okanamp(:)) mean(testing.V10T6.fiting.okanamp(:)) mean(testing.V10T10.fiting.okanamp(:)) mean(testing.V10T20.fiting.okanamp(:)) mean(testing.V10T30.fiting.okanamp(:)) mean(testing.V10T40.fiting.okanamp(:))];
bar(x,y);

%%%%%%V10 adaptation and amplitude estimated by median
[testing.V10T4]=adap_amp(mergedTU.velocityfitting.V10T4,5,9);
[testing.V10T5]=adap_amp(mergedTU.velocityfitting.V10T5,5,10);
[testing.V10T6]=adap_amp(mergedTU.velocityfitting.V10T6,5,11);
[testing.V10T10]=adap_amp(mergedTU.velocityfitting.V10T10,5,15);
[testing.V10T20]=adap_amp(mergedTU.velocityfitting.V10T20,5,25);
[testing.V10T30]=adap_amp(mergedTU.velocityfitting.V10T30,5,35);
[testing.V10T40]=adap_amp(mergedTU.velocityfitting.V10T40,5,45);

%normalized adaptation and amplitude
figure
x=[4 5 6 10 20 30 40];
y1=[mean(testing.V10T4.normaladapt(:)) mean(testing.V10T5.normaladapt(:)) mean(testing.V10T6.normaladapt(:)) mean(testing.V10T10.normaladapt(:)) mean(testing.V10T20.normaladapt(:)) mean(testing.V10T30.normaladapt(:)) mean(testing.V10T40.normaladapt(:))];
scatter(x,y1,'r');
hold on;
x=[4 5 6 10 20 30 40];
y2=[mean(testing.V10T4.normalokanamp(:)) mean(testing.V10T5.normalokanamp(:)) mean(testing.V10T6.normalokanamp(:)) mean(testing.V10T10.normalokanamp(:)) mean(testing.V10T20.normalokanamp(:)) mean(testing.V10T30.normalokanamp(:)) mean(testing.V10T40.normalokanamp(:))]
scatter(x,y2,'b')

%raw adaptation and amplitude
figure
x=[4 5 6 10 20 30 40];
y1=[median(testing.V10T4.okrdrop(:)) median(testing.V10T5.okrdrop(:)) median(testing.V10T6.okrdrop(:)) median(testing.V10T10.okrdrop(:)) median(testing.V10T20.okrdrop(:)) median(testing.V10T30.okrdrop(:)) median(testing.V10T40.okrdrop(:))];
bar(x,y1);
err1=[mad(testing.V10T4.okrdrop(:),1) mad(testing.V10T5.okrdrop(:),1) mad(testing.V10T6.okrdrop(:),1) mad(testing.V10T10.okrdrop(:),1) mad(testing.V10T20.okrdrop(:),1) mad(testing.V10T30.okrdrop(:),1) mad(testing.V10T40.okrdrop(:),1)];

hold on;
x=[4 5 6 10 20 30 40];
y2=-[median(testing.V10T4.okanamp(:)) median(testing.V10T5.okanamp(:)) median(testing.V10T6.okanamp(:)) median(testing.V10T10.okanamp(:)) median(testing.V10T20.okanamp(:)) median(testing.V10T30.okanamp(:)) median(testing.V10T40.okanamp(:))]
bar(x,y2)
err2=[mad(testing.V10T4.okanamp(:),1) mad(testing.V10T5.okanamp(:),1) mad(testing.V10T6.okanamp(:),1) mad(testing.V10T10.okanamp(:),1) mad(testing.V10T20.okanamp(:),1) mad(testing.V10T30.okanamp(:),1) mad(testing.V10T40.okanamp(:),1)];

hold on
scatter(y1,y2,'b');






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%V5 velocity fitting
[testing.V5T5]=autorunmedian(mergedTU.V5T5([1:5 7:end],:),5,10,10.5,20);
[testing.V5T6]=autorunmedian(mergedTU.V5T6(1:end,:),5,11,11.5,21);
[testing.V5T7]=autorunmedian(mergedTU.V5T7(1:end,:),5,12,12.5,22);
[testing.V5T10]=autorunmedian(mergedTU.V5T10(1:end,:),5,15,15.5,35);
[testing.V5T20]=autorunmedian(mergedTU.V5T20([1:4 6:end],:),5,25,25.5,45);
[testing.V5T30]=autorunmedian(mergedTU.V5T30(1:end,:),5,35,35.5,55);
[testing.V5T40]=autorunmedian(mergedTU.V5T40(:,:),5,45,45.5,65);



mergedTU.velocityfitting.V5T5=testing.V5T5;
mergedTU.velocityfitting.V5T6=testing.V5T6;
mergedTU.velocityfitting.V5T7=testing.V5T7;
mergedTU.velocityfitting.V5T10=testing.V5T10;
mergedTU.velocityfitting.V5T20=testing.V5T20;
mergedTU.velocityfitting.V5T30=testing.V5T30;
mergedTU.velocityfitting.V5T40=testing.V5T40;

figure
x=[5 6 7 10 20 30 40];
y=[median(mergedTU.velocityfitting.V5T5.fiting.g(:)) median(mergedTU.velocityfitting.V5T6.fiting.g(:)) median(mergedTU.velocityfitting.V5T7.fiting.g(:)) median(mergedTU.velocityfitting.V5T10.fiting.g(:)) median(mergedTU.velocityfitting.V5T20.fiting.g(:)) median(mergedTU.velocityfitting.V5T30.fiting.g(:)) median(mergedTU.velocityfitting.V5T40.fiting.g(:))];
err=[mad(mergedTU.velocityfitting.V5T5.fiting.g(:),1) mad(mergedTU.velocityfitting.V5T6.fiting.g(:),1) mad(mergedTU.velocityfitting.V5T7.fiting.g(:),1) mad(mergedTU.velocityfitting.V5T10.fiting.g(:),1) mad(mergedTU.velocityfitting.V5T20.fiting.g(:),1) mad(mergedTU.velocityfitting.V5T30.fiting.g(:),1) mad(mergedTU.velocityfitting.V5T40.fiting.g(:),1)];
scatter(x,y);



%%%%%%V5 adaptation and amplitude estimated by median

[testing.V5T5]=adap_amp(mergedTU.velocityfitting.V5T5,5,10);
[testing.V5T6]=adap_amp(mergedTU.velocityfitting.V5T6,5,11);
[testing.V5T7]=adap_amp(mergedTU.velocityfitting.V5T7,5,12);
[testing.V5T10]=adap_amp(mergedTU.velocityfitting.V5T10,5,15);
[testing.V5T20]=adap_amp(mergedTU.velocityfitting.V5T20,5,25);
[testing.V5T30]=adap_amp(mergedTU.velocityfitting.V5T30,5,35);
[testing.V5T40]=adap_amp(mergedTU.velocityfitting.V5T40,5,45);

%normalized adaptation and amplitude
figure
x=[5 6 7 10 20 30 40];
y3=[mean(testing.V5T5.normaladapt(:)) mean(testing.V5T6.normaladapt(:)) mean(testing.V5T7.normaladapt(:)) mean(testing.V5T10.normaladapt(:)) mean(testing.V5T20.normaladapt(:)) mean(testing.V5T30.normaladapt(:)) mean(testing.V5T40.normaladapt(:))];
plot(x,y3,'ro');
hold on;
x=[5 6 7 10 20 30 40];
y4=[mean(testing.V5T5.normalokanamp(:)) mean(testing.V5T6.normalokanamp(:)) mean(testing.V5T7.normalokanamp(:)) mean(testing.V5T10.normalokanamp(:)) mean(testing.V5T20.normalokanamp(:)) mean(testing.V5T30.normalokanamp(:)) mean(testing.V5T40.normalokanamp(:))]
plot(x,y4,'bo')
figure
scatter(y1,y2);
hold on
scatter(y3,y4,'r');

%raw adaptation and amplitude
figure
x=[5 6 7 10 20 30 40];
y3=[median(testing.V5T5.okrdrop(:)) median(testing.V5T6.okrdrop(:)) median(testing.V5T7.okrdrop(:)) median(testing.V5T10.okrdrop(:)) median(testing.V5T20.okrdrop(:)) median(testing.V5T30.okrdrop(:)) median(testing.V5T40.okrdrop(:))];
bar(x,y3);
err3=[mad(testing.V5T5.okrdrop(:),1) mad(testing.V5T6.okrdrop(:),1) mad(testing.V5T7.okrdrop(:),1) mad(testing.V5T10.okrdrop(:),1) mad(testing.V5T20.okrdrop(:),1) mad(testing.V5T30.okrdrop(:),1) mad(testing.V5T40.okrdrop(:),1)];

hold on;
x=[5 6 7 10 20 30 40];
y4=-[median(testing.V5T5.okanamp(:)) median(testing.V5T6.okanamp(:)) median(testing.V5T7.okanamp(:)) median(testing.V5T10.okanamp(:)) median(testing.V5T20.okanamp(:)) median(testing.V5T30.okanamp(:)) median(testing.V5T40.okanamp(:))];
bar(x,y4);
hold on
err4=[mad(testing.V5T5.okanamp(:),1) mad(testing.V5T6.okanamp(:),1) mad(testing.V5T7.okanamp(:),1) mad(testing.V5T10.okanamp(:),1) mad(testing.V5T20.okanamp(:),1) mad(testing.V5T30.okanamp(:),1) mad(testing.V5T40.okanamp(:),1)];

plot(x,y4,'bo')
scatter(y3,y4,'r');















%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%V10 freq


[testing.V10T4]=autorunfreqmedian(mergedTU.V10T4(:,:),5,9,9.5,19);
[testing.V10T6]=autorunfreqmedian(mergedTU.V10T6(1:3,:),5,11,11.5,21);
[testing.V10T5]=autorunfreqmedian(mergedTU.V10T5(1:end,:),5,10,10.5,20);
[testing.V10T10]=autorunfreqmedian(mergedTU.V10T10([1:end-2 end],:),5,15,15.5,25);
[testing.V10T20]=autorunfreqmedian(mergedTU.V10T20(1:end,:),5,25,25.5,45);
[testing.V10T40]=autorunfreqmedian(mergedTU.V10T40(1:end,:),5,45,45.5,65);
[testing.V10T30]=autorunfreqmedian(mergedTU.V10T30([1:2 4:end],:),5,35,35.5,55);

%OKAN decay time constant
figure
x=[4 5 6 10 20 30 40];
y=[median(mergedTU.freqfitting.V10T4.fiting.g(:)) median(mergedTU.freqfitting.V10T5.fiting.g(:)) median(mergedTU.freqfitting.V10T6.fiting.g(:)) median(mergedTU.freqfitting.V10T10.fiting.g(:)) median(mergedTU.freqfitting.V10T20.fiting.g(:)) median(mergedTU.freqfitting.V10T30.fiting.g(:)) median(mergedTU.freqfitting.V10T40.fiting.g(:))];
err=[mad(mergedTU.freqfitting.V10T4.fiting.g(:),1) mad(mergedTU.freqfitting.V10T5.fiting.g(:),1) mad(mergedTU.freqfitting.V10T6.fiting.g(:),1) mad(mergedTU.freqfitting.V10T10.fiting.g(:),1) mad(mergedTU.freqfitting.V10T20.fiting.g(:),1) mad([mergedTU.freqfitting.V10T30.fiting.g(:)],1) mad(mergedTU.freqfitting.V10T40.fiting.g(:),1)];
scatter(x,y);

%OKR decay time constant
figure(2)
x=[4 5 6 10 20 30 40];
y=[median(mergedTU.freqfitting.V10T4.fiting.b(:)) median(mergedTU.freqfitting.V10T5.fiting.b(:)) median(mergedTU.freqfitting.V10T6.fiting.b(:)) median(mergedTU.freqfitting.V10T10.fiting.b(:)) median(mergedTU.freqfitting.V10T20.fiting.b(:)) median(mergedTU.freqfitting.V10T30.fiting.b(:)) median(mergedTU.freqfitting.V10T40.fiting.b(:))];
err=[mad(mergedTU.freqfitting.V10T4.fiting.g(:),1) mad(mergedTU.freqfitting.V10T5.fiting.g(:),1) mad(mergedTU.freqfitting.V10T6.fiting.g(:),1) mad(mergedTU.freqfitting.V10T10.fiting.g(:),1) mad(mergedTU.freqfitting.V10T20.fiting.g(:),1) mad([mergedTU.freqfitting.V10T30.fiting.g(:)],1) mad(mergedTU.freqfitting.V10T40.fiting.g(:),1)];
scatter(x,y);

%OKR decay time constant
figure(3)
x=[4 5 6 10 20 30 40];
y=[median(mergedTU.freqfitting.V10T4.fiting.d(:)) median(mergedTU.freqfitting.V10T5.fiting.d(:)) median(mergedTU.freqfitting.V10T6.fiting.d(:)) median(mergedTU.freqfitting.V10T10.fiting.d(:)) median(mergedTU.freqfitting.V10T20.fiting.d(:)) median(mergedTU.freqfitting.V10T30.fiting.d(:)) median(mergedTU.freqfitting.V10T40.fiting.d(:))];
err=[mad(mergedTU.freqfitting.V10T4.fiting.g(:),1) mad(mergedTU.freqfitting.V10T5.fiting.g(:),1) mad(mergedTU.freqfitting.V10T6.fiting.g(:),1) mad(mergedTU.freqfitting.V10T10.fiting.g(:),1) mad(mergedTU.freqfitting.V10T20.fiting.g(:),1) mad([mergedTU.freqfitting.V10T30.fiting.g(:)],1) mad(mergedTU.freqfitting.V10T40.fiting.g(:),1)];
scatter(x,y);

%adaptation and amplitude estimated by fitting curve
figure
x=[4 5 6 10 20 30 40];
y=[mean(mergedTU.freqfitting.V10T4.fiting.okr_adapt1st(:)) mean(mergedTU.freqfitting.V10T5.fiting.okr_adapt1st(:)) mean(mergedTU.freqfitting.V10T6.fiting.okr_adapt1st(:)) mean(mergedTU.freqfitting.V10T10.fiting.okr_adapt1st(:)) mean(mergedTU.freqfitting.V10T20.fiting.okr_adapt1st(:)) mean(mergedTU.freqfitting.V10T30.fiting.okr_adapt1st(:)) mean(mergedTU.freqfitting.V10T40.fiting.okr_adapt1st(:))];
bar(x,y);
figure
x=[4 5 6 10 20 30 40];
y=[mean(mergedTU.freqfitting.V10T4.fiting.okr_adapt2nd(:)) mean(mergedTU.freqfitting.V10T5.fiting.okr_adapt2nd(:)) mean(mergedTU.freqfitting.V10T6.fiting.okr_adapt2nd(:)) mean(mergedTU.freqfitting.V10T10.fiting.okr_adapt2nd(:)) mean(mergedTU.freqfitting.V10T20.fiting.okr_adapt2nd(:)) mean(mergedTU.freqfitting.V10T30.fiting.okr_adapt2nd(:)) mean(mergedTU.freqfitting.V10T40.fiting.okr_adapt2nd(:))];
bar(x,y);
figure
x=[4 5 6 10 20 30 40];
y=[mean(mergedTU.freqfitting.V10T4.fiting.okr_adapt1st(:)+mergedTU.freqfitting.V10T4.fiting.okr_adapt2nd(:)) mean(mergedTU.freqfitting.V10T5.fiting.okr_adapt1st(:)+mergedTU.freqfitting.V10T5.fiting.okr_adapt2nd(:)) mean(mergedTU.freqfitting.V10T6.fiting.okr_adapt1st(:)+mergedTU.freqfitting.V10T6.fiting.okr_adapt2nd(:)) mean(mergedTU.freqfitting.V10T10.fiting.okr_adapt1st(:)+mergedTU.freqfitting.V10T10.fiting.okr_adapt2nd(:)) mean(mergedTU.freqfitting.V10T20.fiting.okr_adapt1st(:)+mergedTU.freqfitting.V10T20.fiting.okr_adapt2nd(:)) mean(mergedTU.freqfitting.V10T30.fiting.okr_adapt1st(:)+mergedTU.freqfitting.V10T30.fiting.okr_adapt2nd(:)) mean(mergedTU.freqfitting.V10T40.fiting.okr_adapt1st(:)+mergedTU.freqfitting.V10T40.fiting.okr_adapt2nd(:))];
bar(x,y);
figure
x=[4 5 6 10 20 30 40];
y=[mean(mergedTU.freqfitting.V10T4.fiting.okanamp(:)) mean(mergedTU.freqfitting.V10T5.fiting.okanamp(:)) mean(mergedTU.freqfitting.V10T6.fiting.okanamp(:)) mean(mergedTU.freqfitting.V10T10.fiting.okanamp(:)) mean(mergedTU.freqfitting.V10T20.fiting.okanamp(:)) mean(mergedTU.freqfitting.V10T30.fiting.okanamp(:)) mean(mergedTU.freqfitting.V10T40.fiting.okanamp(:))];
bar(x,y);

%%%%%%V10 adaptation and amplitude estimated by median
[testing.V10T4]=adap_amp_freq(mergedTU.freqfitting.V10T4,5,9);
[testing.V10T5]=adap_amp_freq(mergedTU.freqfitting.V10T5,5,10);
[testing.V10T6]=adap_amp_freq(mergedTU.freqfitting.V10T6,5,11);
[testing.V10T10]=adap_amp_freq(mergedTU.freqfitting.V10T10,5,15);
[testing.V10T20]=adap_amp_freq(mergedTU.freqfitting.V10T20,5,25);
[testing.V10T30]=adap_amp_freq(mergedTU.freqfitting.V10T30,5,35);
[testing.V10T40]=adap_amp_freq(mergedTU.freqfitting.V10T40,5,45);

%normalized adaptation and amplitude
figure
x=[4 5 6 10 20 30 40];
y1=[mean(mergedTU.freqfitting.V10T4.normaladapt(:)) mean(mergedTU.freqfitting.V10T5.normaladapt(:)) mean(mergedTU.freqfitting.V10T6.normaladapt(:)) mean(mergedTU.freqfitting.V10T10.normaladapt(:)) mean(mergedTU.freqfitting.V10T20.normaladapt(:)) mean(mergedTU.freqfitting.V10T30.normaladapt(:)) mean(mergedTU.freqfitting.V10T40.normaladapt(:))];
scatter(x,y1,'r');
hold on;
x=[4 5 6 10 20 30 40];
y2=[mean(mergedTU.freqfitting.V10T4.normalokanamp(:)) mean(mergedTU.freqfitting.V10T5.normalokanamp(:)) mean(mergedTU.freqfitting.V10T6.normalokanamp(:)) mean(mergedTU.freqfitting.V10T10.normalokanamp(:)) mean(mergedTU.freqfitting.V10T20.normalokanamp(:)) mean(mergedTU.freqfitting.V10T30.normalokanamp(:)) mean(mergedTU.freqfitting.V10T40.normalokanamp(:))]
scatter(x,y2,'b')
figure(2)
scatter(y1,y2);

%raw adaptation and amplitude
figure
x=[4 5 6 10 20 30 40];
y=[mean(mergedTU.freqfitting.V10T4.okramp(:)) mean(mergedTU.freqfitting.V10T5.okramp(:)) mean(mergedTU.freqfitting.V10T6.okramp(:)) mean(mergedTU.freqfitting.V10T10.okramp(:)) mean(mergedTU.freqfitting.V10T20.okramp(:)) mean(mergedTU.freqfitting.V10T30.okramp(:)) mean(mergedTU.freqfitting.V10T40.okramp(:))];
scatter(x,y);
err1=[mad(mergedTU.freqfitting.V10T4.okanamp(:),1) mad(mergedTU.freqfitting.V10T5.okanamp(:),1) mad(mergedTU.freqfitting.V10T6.okanamp(:),1) mad(mergedTU.freqfitting.V10T10.okanamp(:),1) mad(mergedTU.freqfitting.V10T20.okanamp(:),1) mad(mergedTU.freqfitting.V10T30.okanamp(:),1) mad(mergedTU.freqfitting.V10T40.okanamp(:),1)];

hold on;
figure
x=[4 5 6 10 20 30 40];
y1=[median(mergedTU.freqfitting.V10T4.okrdrop(:)) median(mergedTU.freqfitting.V10T5.okrdrop(:)) median(mergedTU.freqfitting.V10T6.okrdrop(:)) median(mergedTU.freqfitting.V10T10.okrdrop(:)) median(mergedTU.freqfitting.V10T20.okrdrop(:)) median(mergedTU.freqfitting.V10T30.okrdrop(:)) median(mergedTU.freqfitting.V10T40.okrdrop(:))];
bar(x,y1);
err2=[mad(mergedTU.freqfitting.V10T4.okrdrop(:),1) mad(mergedTU.freqfitting.V10T5.okrdrop(:),1) mad(mergedTU.freqfitting.V10T6.okrdrop(:),1) mad(mergedTU.freqfitting.V10T10.okrdrop(:),1) mad(mergedTU.freqfitting.V10T20.okrdrop(:),1) mad(mergedTU.freqfitting.V10T30.okrdrop(:),1) mad(mergedTU.freqfitting.V10T40.okrdrop(:),1)];

hold on;
x=[4 5 6 10 20 30 40];
y2=-[median(mergedTU.freqfitting.V10T4.okanamp(:)) median(mergedTU.freqfitting.V10T5.okanamp(:)) median(mergedTU.freqfitting.V10T6.okanamp(:)) median(mergedTU.freqfitting.V10T10.okanamp(:)) median(mergedTU.freqfitting.V10T20.okanamp(:)) median(mergedTU.freqfitting.V10T30.okanamp(:)) median(mergedTU.freqfitting.V10T40.okanamp(:))]
bar(x,y2)
figure
scatter(y1,y2,'b')



%normalized adaptation and amplitude correlation
x=[mergedTU.freqfitting.V10T4.normaladapt(:);mergedTU.freqfitting.V10T5.normaladapt(:);mergedTU.freqfitting.V10T6.normaladapt(:);mergedTU.freqfitting.V10T10.normaladapt(:);mergedTU.freqfitting.V10T20.normaladapt(:);mergedTU.freqfitting.V10T30.normaladapt(:);mergedTU.freqfitting.V10T4.normaladapt(:)];
y=[mergedTU.freqfitting.V10T4.normalokanamp(:);mergedTU.freqfitting.V10T5.normalokanamp(:);mergedTU.freqfitting.V10T6.normalokanamp(:);mergedTU.freqfitting.V10T10.normalokanamp(:);mergedTU.freqfitting.V10T20.normalokanamp(:);mergedTU.freqfitting.V10T30.normalokanamp(:);mergedTU.freqfitting.V10T40.normalokanamp(:)];
scatter(x,y);





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%V5 freq


[testing.V5T7]=autorunfreqmedian(mergedTU.V5T7(:,:),5,12,12.5,22);
[testing.V5T6]=autorunfreqmedian(mergedTU.V5T6([1:4 6],:),5,11,11.5,21);
[testing.V5T5]=autorunfreqmedian(mergedTU.V5T5([1:3 5 7:end],:),5,10,10.5,20);
[testing.V5T10]=autorunfreqmedian(mergedTU.V5T10(:,:),5,15,15.5,25);
[testing.V5T20]=autorunfreqmedian(mergedTU.V5T20([1:4 6 7 9],:),5,25,25.5,45);
[testing.V5T40]=autorunfreqmedian(mergedTU.V5T40(:,:),5,45,45.5,65);
[testing.V5T30]=autorunfreqmedian(mergedTU.V5T30(:,:),5,35,35.5,55);

%OKAN decay time constant
figure
x=[5 6 7 10 20 30 40];
y=[median(mergedTU.freqfitting.V5T5.fiting.g(:)) median(mergedTU.freqfitting.V5T6.fiting.g(:)) median(mergedTU.freqfitting.V5T7.fiting.g(:)) median(mergedTU.freqfitting.V5T10.fiting.g(:)) median(mergedTU.freqfitting.V5T20.fiting.g(:)) median(mergedTU.freqfitting.V5T30.fiting.g(:)) median(mergedTU.freqfitting.V5T40.fiting.g(:))];
err=[mad(mergedTU.freqfitting.V5T5.fiting.g(:),1) mad(mergedTU.freqfitting.V5T6.fiting.g(:),1) mad(mergedTU.freqfitting.V5T7.fiting.g(:),1) mad(mergedTU.freqfitting.V5T10.fiting.g(:),1) mad(mergedTU.freqfitting.V5T20.fiting.g(:),1) mad([mergedTU.freqfitting.V5T30.fiting.g(:)],1) mad(mergedTU.freqfitting.V5T40.fiting.g(:),1)];
scatter(x,y);

figure
x7=[0:0.004:40];
y7=exp(-x7(:)/y(3));
plot(x7,y7,'y');
hold on;
y10=exp(-x7(:)/y(4));
plot(x2,y10,'m');
hold on;
y20=exp(-x2(:)/y(5));
plot(x2,y20,'c');
hold on;
y30=exp(-x2(:)/y(6));
plot(x2,y30,'r');
hold on;
y40=exp(-x2(:)/y(7));
plot(x2,y40,'g');
hold on;







%OKR decay time constant
figure(2)
x=[5 6 7 10 20 30 40];
y=[median(mergedTU.freqfitting.V5T5.fiting.b(:)) median(mergedTU.freqfitting.V5T6.fiting.b(:)) median(mergedTU.freqfitting.V5T7.fiting.b(:)) median(mergedTU.freqfitting.V5T10.fiting.b(:)) median(mergedTU.freqfitting.V5T20.fiting.b(:)) median(mergedTU.freqfitting.V5T30.fiting.b(:)) median(mergedTU.freqfitting.V5T40.fiting.b(:))];
err=[mad(mergedTU.freqfitting.V5T4.fiting.g(:),1) mad(mergedTU.freqfitting.V5T5.fiting.g(:),1) mad(mergedTU.freqfitting.V5T6.fiting.g(:),1) mad(mergedTU.freqfitting.V5T10.fiting.g(:),1) mad(mergedTU.freqfitting.V5T20.fiting.g(:),1) mad([mergedTU.freqfitting.V5T30.fiting.g(:)],1) mad(mergedTU.freqfitting.V5T40.fiting.g(:),1)];
scatter(x,y);

%OKR decay time constant
figure(3)
x=[5 6 7 10 20 30 40];
y=[median(mergedTU.freqfitting.V5T5.fiting.d(:)) median(mergedTU.freqfitting.V5T6.fiting.d(:)) median(mergedTU.freqfitting.V5T7.fiting.d(:)) median(mergedTU.freqfitting.V5T10.fiting.d(:)) median(mergedTU.freqfitting.V5T20.fiting.d(:)) median(mergedTU.freqfitting.V5T30.fiting.d(:)) median(mergedTU.freqfitting.V5T40.fiting.d(:))];
err=[mad(mergedTU.freqfitting.V5T4.fiting.g(:),1) mad(mergedTU.freqfitting.V5T5.fiting.g(:),1) mad(mergedTU.freqfitting.V5T6.fiting.g(:),1) mad(mergedTU.freqfitting.V5T10.fiting.g(:),1) mad(mergedTU.freqfitting.V5T20.fiting.g(:),1) mad([mergedTU.freqfitting.V5T30.fiting.g(:)],1) mad(mergedTU.freqfitting.V5T40.fiting.g(:),1)];
scatter(x,y);


%%%%%%V5 adaptation and amplitude estimated by median
[testing.V5T7]=adap_amp_freq(mergedTU.freqfitting.V5T7,5,12);
[testing.V5T5]=adap_amp_freq(mergedTU.freqfitting.V5T5,5,10);
[testing.V5T6]=adap_amp_freq(mergedTU.freqfitting.V5T6,5,11);
[testing.V5T10]=adap_amp_freq(mergedTU.freqfitting.V5T10,5,15);
[testing.V5T20]=adap_amp_freq(mergedTU.freqfitting.V5T20,5,25);
[testing.V5T30]=adap_amp_freq(mergedTU.freqfitting.V5T30,5,35);
[testing.V5T40]=adap_amp_freq(mergedTU.freqfitting.V5T40,5,45);

%normalized adaptation and amplitude
figure
x=[5 6 7 10 20 30 40];
y3=[mean(mergedTU.freqfitting.V5T5.normaladapt(:)) mean(mergedTU.freqfitting.V5T6.normaladapt(:)) mean(mergedTU.freqfitting.V5T7.normaladapt(:)) mean(mergedTU.freqfitting.V5T10.normaladapt(:)) mean(mergedTU.freqfitting.V5T20.normaladapt(:)) mean(mergedTU.freqfitting.V5T30.normaladapt(:)) mean(mergedTU.freqfitting.V5T40.normaladapt(1:2))];
scatter(x,y3,'r');
hold on;
x=[5 6 7 10 20 30 40];
y4=[mean(mergedTU.freqfitting.V5T5.normalokanamp(:)) mean(mergedTU.freqfitting.V5T6.normalokanamp(:)) mean(mergedTU.freqfitting.V5T7.normalokanamp(:)) mean(mergedTU.freqfitting.V5T10.normalokanamp(:)) mean(mergedTU.freqfitting.V5T20.normalokanamp(:)) mean(mergedTU.freqfitting.V5T30.normalokanamp(:)) mean(mergedTU.freqfitting.V5T40.normalokanamp(1:2))]
scatter(x,y4,'b')
figure
scatter(y3,y4);
hold on
scatter(y1,y2);

%raw adaptation and amplitude
figure
x=[5 6 7 10 20 30 40];
y3=[median(mergedTU.freqfitting.V5T5.okrdrop(:)) median(mergedTU.freqfitting.V5T6.okrdrop(:)) median(mergedTU.freqfitting.V5T7.okrdrop(:)) median(mergedTU.freqfitting.V5T10.okrdrop(:)) median(mergedTU.freqfitting.V5T20.okrdrop(:)) median(mergedTU.freqfitting.V5T30.okrdrop(:)) median(mergedTU.freqfitting.V5T40.okrdrop(:))];
bar(x,y3);
err3=[mad(mergedTU.freqfitting.V5T5.okrdrop(:),1) mad(mergedTU.freqfitting.V5T6.okrdrop(:),1) mad(mergedTU.freqfitting.V5T7.okrdrop(:),1) mad(mergedTU.freqfitting.V5T10.okrdrop(:),1) mad(mergedTU.freqfitting.V5T20.okrdrop(:),1) mad(mergedTU.freqfitting.V5T30.okrdrop(:),1) mad(mergedTU.freqfitting.V5T40.okrdrop(:),1)];

hold on;
x=[5 6 7 10 20 30 40];
y4=[median(mergedTU.freqfitting.V5T5.okanamp(:)) median(mergedTU.freqfitting.V5T6.okanamp(:)) median(mergedTU.freqfitting.V5T7.okanamp(:)) median(mergedTU.freqfitting.V5T10.okanamp(:)) median(mergedTU.freqfitting.V5T20.okanamp(:)) median(mergedTU.freqfitting.V5T30.okanamp(:)) median(mergedTU.freqfitting.V5T40.okanamp(:))]
bar(x,y4)
err4=[mad(mergedTU.freqfitting.V5T5.okanamp(:),1) mad(mergedTU.freqfitting.V5T6.okanamp(:),1) mad(mergedTU.freqfitting.V5T7.okanamp(:),1) mad(mergedTU.freqfitting.V5T10.okanamp(:),1) mad(mergedTU.freqfitting.V5T20.okanamp(:),1) mad(mergedTU.freqfitting.V5T30.okanamp(:),1) mad(mergedTU.freqfitting.V5T40.okanamp(:),1)];

hold on;
scatter(y3,y4,'r')

%normalized adaptation and amplitude correlation
x=[mergedTU.freqfitting.V5T7.normaladapt(:);mergedTU.freqfitting.V5T5.normaladapt(:);mergedTU.freqfitting.V5T6.normaladapt(:);mergedTU.freqfitting.V5T10.normaladapt(:);mergedTU.freqfitting.V5T20.normaladapt(:);mergedTU.freqfitting.V5T30.normaladapt(:);mergedTU.freqfitting.V5T40.normaladapt(:)];
y=[mergedTU.freqfitting.V5T7.normalokanamp(:);mergedTU.freqfitting.V5T5.normalokanamp(:);mergedTU.freqfitting.V5T6.normalokanamp(:);mergedTU.freqfitting.V5T10.normalokanamp(:);mergedTU.freqfitting.V5T20.normalokanamp(:);mergedTU.freqfitting.V5T30.normalokanamp(:);mergedTU.freqfitting.V5T40.normalokanamp(:)];
scatter(x,y);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% V10
%making matrix for plot in originlab
%raw data
clear exceldata;
okan_st=45
datapath=mergedTU.freqfitting.V10T40;
for i=1:length(datapath.diffmedian(:))
    for k=1:length(datapath.time{i,1});
    if datapath.time{i,1}(k,1)>okan_st && datapath.time{i,1}(k,1)<okan_st+0.5;
        exceldata{i,1}(:,2)=datapath.diffmedian{i,1}(k:end,1)/((datapath.diffmedian{i,1}(k+2,1)+datapath.diffmedian{i,1}(k+3,1))/2);
        exceldata{i,1}(:,1)=(((1:length(exceldata{i,1}(:,2)))-0.5)/2);
    end
    end
    figure
    x=exceldata{i,1}(:,1);
    y=exceldata{i,1}(:,2);
    scatter(x,y);
end
%exponential curve

%OKAN decay time constant
figure
x=[4 5 6 10 20 30 40];
y=[median(mergedTU.freqfitting.V10T4.fiting.g(:)) median(mergedTU.freqfitting.V10T5.fiting.g(:)) median(mergedTU.freqfitting.V10T6.fiting.g(:)) median(mergedTU.freqfitting.V10T10.fiting.g(:)) median(mergedTU.freqfitting.V10T20.fiting.g(:)) median(mergedTU.freqfitting.V10T30.fiting.g(:)) median(mergedTU.freqfitting.V10T40.fiting.g(:))];
% err=[mad(fitting.V10T4.g(:),1) mad(fitting.V10T5.g(:),1) mad(fitting.V10T6.g(:),1) mad(fitting.V10T10.g(:),1) mad(fitting.V10T20.g(:),1) mad([fitting.V10T30.g(:)],1) mad(fitting.V10T40.g(:),1)];
scatter(x,y);

%%%%%%%%%%freq
%median of a
a=median([mergedTU.freqfitting.V10T10.fiting.a(:);mergedTU.freqfitting.V10T20.fiting.a(:);mergedTU.freqfitting.V10T30.fiting.a(:);mergedTU.freqfitting.V10T40.fiting.a(:)]);


%median of b
b=median([mergedTU.freqfitting.V10T10.fiting.b(:);mergedTU.freqfitting.V10T20.fiting.b(:);mergedTU.freqfitting.V10T30.fiting.b(:);mergedTU.freqfitting.V10T40.fiting.b(:)]);

%median of c
c=median([mergedTU.freqfitting.V10T10.fiting.c(:);mergedTU.freqfitting.V10T20.fiting.c(:);mergedTU.freqfitting.V10T30.fiting.c(:);mergedTU.freqfitting.V10T40.fiting.c(:)]);

%median of d
d=median([mergedTU.freqfitting.V10T10.fiting.d(:);mergedTU.freqfitting.V10T20.fiting.d(:);mergedTU.freqfitting.V10T30.fiting.d(:);mergedTU.freqfitting.V10T40.fiting.d(:)]);

%median of e
e=median([mergedTU.freqfitting.V10T10.fiting.e(:);mergedTU.freqfitting.V10T20.fiting.e(:);mergedTU.freqfitting.V10T30.fiting.e(:);mergedTU.freqfitting.V10T40.fiting.e(:)]);


x=0:0.004:40;
y=a*exp(-x/b)+c*exp(-x/d)+e;
plot(x,y);
hold on
y2=c*exp(-x/d)+e;
plot(x,y2)

%%%%%%%%%%velocity
%median of a
a=median([mergedTU.velocityfitting.V10T10.fiting.a(:);mergedTU.velocityfitting.V10T20.fiting.a(:);mergedTU.velocityfitting.V10T30.fiting.a(:);mergedTU.velocityfitting.V10T40.fiting.a(:)]);


%median of b
b=median([mergedTU.velocityfitting.V10T10.fiting.b(:);mergedTU.velocityfitting.V10T20.fiting.b(:);mergedTU.velocityfitting.V10T30.fiting.b(:);mergedTU.velocityfitting.V10T40.fiting.b(:)]);

%median of c
c=median([mergedTU.velocityfitting.V10T10.fiting.c(:);mergedTU.velocityfitting.V10T20.fiting.c(:);mergedTU.velocityfitting.V10T30.fiting.c(:);mergedTU.velocityfitting.V10T40.fiting.c(:)]);

%median of d
d=median([mergedTU.velocityfitting.V10T10.fiting.d(:);mergedTU.velocityfitting.V10T20.fiting.d(:);mergedTU.velocityfitting.V10T30.fiting.d(:);mergedTU.velocityfitting.V10T40.fiting.d(:)]);

%median of e
e=median([mergedTU.velocityfitting.V10T10.fiting.e(:);mergedTU.velocityfitting.V10T20.fiting.e(:);mergedTU.velocityfitting.V10T30.fiting.e(:);mergedTU.velocityfitting.V10T40.fiting.e(:)]);


x=0:0.004:40;
y=a*exp(-x/b)+c*exp(-x/d)+e;
plot(x,y);
hold on
y2=c*exp(-x/d)+e;
plot(x,y2)





clear exceldata;
okan_st=45;
datapath=mergedTU.freqfitting.V10T40.fiting;
for i=1:length(datapath.fit_time_okan(:));
    
    exceldata40{i,1}(:,2)=datapath.fit_value_okan{i}(:)/datapath.fit_value_okan{i}(1);
    exceldata40{i,1}(:,1)=datapath.fit_time_okan{i}-datapath.fit_time_okan{i}(1);
    figure;
    x=exceldata40{i,1}(:,1);
    y=exceldata40{i,1}(:,2);
    scatter(x,y);
end

clear exceldata;
okan_st=35;
datapath=mergedTU.freqfitting.V10T30.fiting;
for i=1:length(datapath.fit_time_okan(:));
    
    exceldata30{i,1}(:,2)=datapath.fit_value_okan{i}(:)/datapath.fit_value_okan{i}(1);
    exceldata30{i,1}(:,1)=datapath.fit_time_okan{i}-datapath.fit_time_okan{i}(1);
    figure;
    x=exceldata30{i,1}(:,1);
    y=exceldata30{i,1}(:,2);
    scatter(x,y);
end

clear exceldata;
okan_st=25;
datapath=mergedTU.freqfitting.V10T20.fiting;
for i=1:length(datapath.fit_time_okan(:));
    
    exceldata20{i,1}(:,2)=datapath.fit_value_okan{i}(:)/datapath.fit_value_okan{i}(1);
    exceldata20{i,1}(:,1)=datapath.fit_time_okan{i}-datapath.fit_time_okan{i}(1);
    figure;
    x=exceldata20{i,1}(:,1);
    y=exceldata20{i,1}(:,2);
    scatter(x,y);
end

clear exceldata;
okan_st=15;
datapath=mergedTU.freqfitting.V10T10.fiting;
for i=1:length(datapath.fit_time_okan(:));
    
    exceldata10{i,1}(:,2)=datapath.fit_value_okan{i}(:)/datapath.fit_value_okan{i}(1);
    exceldata10{i,1}(:,1)=datapath.fit_time_okan{i}-datapath.fit_time_okan{i}(1);
    figure;
    x=exceldata10{i,1}(:,1);
    y=exceldata10{i,1}(:,2);
    scatter(x,y);
end

clear exceldata;
okan_st=11;
datapath=mergedTU.freqfitting.V10T6.fiting;
for i=1:length(datapath.fit_time_okan(:));
    
    exceldata6{i,1}(:,2)=datapath.fit_value_okan{i}(:)/datapath.fit_value_okan{i}(1);
    exceldata6{i,1}(:,1)=datapath.fit_time_okan{i}-datapath.fit_time_okan{i}(1);
    figure;
    x=exceldata6{i,1}(:,1);
    y=exceldata6{i,1}(:,2);
    scatter(x,y);
end

clear exceldata;
okan_st=10;
datapath=mergedTU.freqfitting.V10T5.fiting;
for i=1:length(datapath.fit_time_okan(:));
    
    exceldata5{i,1}(:,2)=datapath.fit_value_okan{i}(:)/datapath.fit_value_okan{i}(1);
    exceldata5{i,1}(:,1)=datapath.fit_time_okan{i}-datapath.fit_time_okan{i}(1);
    figure;
    x=exceldata5{i,1}(:,1);
    y=exceldata5{i,1}(:,2);
    scatter(x,y);
end

clear exceldata;
okan_st=9;
datapath=mergedTU.freqfitting.V10T4.fiting;
for i=1:length(datapath.fit_time_okan(:));
    
    exceldata4{i,1}(:,2)=datapath.fit_value_okan{i}(:)/datapath.fit_value_okan{i}(1);
    exceldata4{i,1}(:,1)=datapath.fit_time_okan{i}-datapath.fit_time_okan{i}(1);
    figure;
    x=exceldata4{i,1}(:,1);
    y=exceldata4{i,1}(:,2);
    scatter(x,y);
end




%%%%%%%%%%%%%%%%%%%%%%%%
%V5

%OKAN decay time constant
figure
x=[5 6 7 10 20 30 40];
y=[median(mergedTU.freqfitting.V5T5.fiting.g(:)) median(mergedTU.freqfitting.V5T6.fiting.g(:)) median(mergedTU.freqfitting.V5T7.fiting.g(:)) median(mergedTU.freqfitting.V5T10.fiting.g(:)) median(mergedTU.freqfitting.V5T20.fiting.g(:)) median(mergedTU.freqfitting.V5T30.fiting.g(:)) median(mergedTU.freqfitting.V5T40.fiting.g(:))];
% err=[mad(fitting.V5T4.g(:),1) mad(fitting.V5T5.g(:),1) mad(fitting.V5T6.g(:),1) mad(fitting.V5T10.g(:),1) mad(fitting.V5T20.g(:),1) mad([fitting.V5T30.g(:)],1) mad(fitting.V5T40.g(:),1)];
scatter(x,y);

%OKAN decay time constant
figure
x=[5 6 7 10 20 30 40];
y=[mean(mergedTU.freqfitting.V5T5.fiting.g(:)) mean(mergedTU.freqfitting.V5T6.fiting.g(:)) mean(mergedTU.freqfitting.V5T7.fiting.g(:)) mean(mergedTU.freqfitting.V5T10.fiting.g(:)) mean(mergedTU.freqfitting.V5T20.fiting.g(:)) mean(mergedTU.freqfitting.V5T30.fiting.g(:)) mean(mergedTU.freqfitting.V5T40.fiting.g(:))];
% err=[mad(fitting.V5T4.g(:),1) mad(fitting.V5T5.g(:),1) mad(fitting.V5T6.g(:),1) mad(fitting.V5T10.g(:),1) mad(fitting.V5T20.g(:),1) mad([fitting.V5T30.g(:)],1) mad(fitting.V5T40.g(:),1)];
scatter(x,y);

%OKR decay time constant
figure(2)
x=[5 6 7 10 20 30 40];
y=[median(mergedTU.freqfitting.V5T5.fiting.b(:)) median(mergedTU.freqfitting.V5T6.fiting.b(:)) median(mergedTU.freqfitting.V5T7.fiting.b(:)) median(mergedTU.freqfitting.V5T10.fiting.b(:)) median(mergedTU.freqfitting.V5T20.fiting.b(:)) median(mergedTU.freqfitting.V5T30.fiting.b(:)) median(mergedTU.freqfitting.V5T40.fiting.b(:))];
% err=[mad(fitting.V5T4.g(:),1) mad(fitting.V5T5.g(:),1) mad(fitting.V5T6.g(:),1) mad(fitting.V5T10.g(:),1) mad(fitting.V5T20.g(:),1) mad([fitting.V5T30.g(:)],1) mad(fitting.V5T40.g(:),1)];
scatter(x,y);



%%%%%%%%%%freq
%median of a
a=median([mergedTU.freqfitting.V5T10.fiting.a(:);mergedTU.freqfitting.V5T20.fiting.a(:);mergedTU.freqfitting.V5T30.fiting.a(:);mergedTU.freqfitting.V5T40.fiting.a(:)]);


%median of b
b=median([mergedTU.freqfitting.V5T10.fiting.b(:);mergedTU.freqfitting.V5T20.fiting.b(:);mergedTU.freqfitting.V5T30.fiting.b(:);mergedTU.freqfitting.V5T40.fiting.b(:)]);

%median of c
c=median([mergedTU.freqfitting.V5T10.fiting.c(:);mergedTU.freqfitting.V5T20.fiting.c(:);mergedTU.freqfitting.V5T30.fiting.c(:);mergedTU.freqfitting.V5T40.fiting.c(:)]);

%median of d
d=median([mergedTU.freqfitting.V5T10.fiting.d(:);mergedTU.freqfitting.V5T20.fiting.d(:);mergedTU.freqfitting.V5T30.fiting.d(:);mergedTU.freqfitting.V5T40.fiting.d(:)]);

%median of e
e=median([mergedTU.freqfitting.V5T10.fiting.e(:);mergedTU.freqfitting.V5T20.fiting.e(:);mergedTU.freqfitting.V5T30.fiting.e(:);mergedTU.freqfitting.V5T40.fiting.e(:)]);


x=0:0.004:40;
y=a*exp(-x/b)+c*exp(-x/d)+e;
plot(x,y);
hold on
y2=c*exp(-x/d)+e;
plot(x,y2)


%%%%%%%%%%velocity
%median of a
a=median([mergedTU.velocityfitting.V5T10.fiting.a(:);mergedTU.velocityfitting.V5T20.fiting.a(:);mergedTU.velocityfitting.V5T30.fiting.a(:);mergedTU.velocityfitting.V5T40.fiting.a(:)]);


%median of b
b=median([mergedTU.velocityfitting.V5T10.fiting.b(:);mergedTU.velocityfitting.V5T20.fiting.b(:);mergedTU.velocityfitting.V5T30.fiting.b(:);mergedTU.velocityfitting.V5T40.fiting.b(:)]);

%median of c
c=median([mergedTU.velocityfitting.V5T10.fiting.c(:);mergedTU.velocityfitting.V5T20.fiting.c(:);mergedTU.velocityfitting.V5T30.fiting.c(:);mergedTU.velocityfitting.V5T40.fiting.c(:)]);

%median of d
d=median([mergedTU.velocityfitting.V5T10.fiting.d(:);mergedTU.velocityfitting.V5T20.fiting.d(:);mergedTU.velocityfitting.V5T30.fiting.d(:);mergedTU.velocityfitting.V5T40.fiting.d(:)]);

%median of e
e=median([mergedTU.velocityfitting.V5T10.fiting.e(:);mergedTU.velocityfitting.V5T20.fiting.e(:);mergedTU.velocityfitting.V5T30.fiting.e(:);mergedTU.velocityfitting.V5T40.fiting.e(:)]);


x=0:0.004:40;
y=a*exp(-x/b)+c*exp(-x/d)+e;
plot(x,y);
hold on
y2=c*exp(-x/d)+e;
plot(x,y2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%normalized okan


value=[]
time=[]
valueerr=[]
for i=1:length(prevalue(:,1));
    
    value(i,:)=prevalue(i,:)./prevalue(1,:);
    valueerr(i,1)=mad(value(i,:),2);
end
medvalue=median(value,2);
time=pretime-pretime(1);
    figure;
    y=medvalue;
    x=time;
    plot(x,y);
    errorbar(x,y,valueerr);

 prevalue=[];
 pretime=[];
    
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%V5 velocity raw trace median
outputpath=[];
data=mergedTU.V5T7;
for i=1:length(data(:,1));
    timesize(i,1)=data{i,24}(end);
end
mediatimensize=floor(max(timesize));
outputpath.time=(((1:(mediatimensize*2))-0.5)/2)';
outputpath.median=nan(mediatimensize*2,length(data(:,1)));
for i=1:length(data(:,1));
    temp=[];
    [temp]=findmedian(data{i,24},data{i,22});
    outputpath.median(1:length(temp.median),i)=temp.median;
end
outputpath.median(mediatimensize*2+1:end,:)=[]
outputpath.medianofmedian=nanmedian(outputpath.median,2);
for i=1:length(outputpath.medianofmedian(:,1));
    outputpath.errmed(i,1)=mad(outputpath.median(i,:),2);
end
figure
plot(outputpath.time,outputpath.medianofmedian,'b');
output.V5T7=outputpath;


outputpath=[];
data=mergedTU.V5T10;
for i=1:length(data(:,1));
    timesize(i,1)=data{i,24}(end);
end
mediatimensize=floor(max(timesize));
outputpath.time=(((1:(mediatimensize*2))-0.5)/2)';
outputpath.median=nan(mediatimensize*2,length(data(:,1)));
for i=1:length(data(:,1));
    temp=[];
    [temp]=findmedian(data{i,24},data{i,22});
    outputpath.median(1:length(temp.median),i)=temp.median;
end
outputpath.median(mediatimensize*2+1:end,:)=[]
outputpath.medianofmedian=nanmedian(outputpath.median,2);
for i=1:length(outputpath.medianofmedian(:,1));
    outputpath.errmed(i,1)=mad(outputpath.median(i,:),2);
end
hold on
plot(outputpath.time,outputpath.medianofmedian,'r');
output.V5T10=outputpath;


outputpath=[];
data=mergedTU.V5T20;
for i=1:length(data(:,1));
    timesize(i,1)=data{i,24}(end);
end
mediatimensize=floor(max(timesize));
outputpath.time=(((1:(mediatimensize*2))-0.5)/2)';
outputpath.median=nan(mediatimensize*2,length(data(:,1)));
for i=1:length(data(:,1));
    temp=[];
    [temp]=findmedian(data{i,24},data{i,22});
    outputpath.median(1:length(temp.median),i)=temp.median;
end
outputpath.median(mediatimensize*2+1:end,:)=[]
outputpath.medianofmedian=nanmedian(outputpath.median,2);
for i=1:length(outputpath.medianofmedian(:,1));
    outputpath.errmed(i,1)=mad(outputpath.median(i,:),2);
end
hold on
plot(outputpath.time,outputpath.medianofmedian,'c');
output.V5T20=outputpath;

outputpath=[];
data=mergedTU.V5T30;
for i=1:length(data(:,1));
    timesize(i,1)=data{i,24}(end);
end
mediatimensize=floor(max(timesize));
outputpath.time=(((1:(mediatimensize*2))-0.5)/2)';
outputpath.median=nan(mediatimensize*2,length(data(:,1)));
for i=1:length(data(:,1));
    temp=[];
    [temp]=findmedian(data{i,24},data{i,22});
    outputpath.median(1:length(temp.median),i)=temp.median;
end
outputpath.median(mediatimensize*2+1:end,:)=[]
outputpath.medianofmedian=nanmedian(outputpath.median,2);
for i=1:length(outputpath.medianofmedian(:,1));
    outputpath.errmed(i,1)=mad(outputpath.median(i,:),2);
end
hold on
plot(outputpath.time,outputpath.medianofmedian,'k');
output.V5T20=outputpath;

outputpath=[];
data=mergedTU.V5T40;
for i=1:length(data(:,1));
    timesize(i,1)=data{i,24}(end);
end
mediatimensize=floor(max(timesize));
outputpath.time=(((1:(mediatimensize*2))-0.5)/2)';
outputpath.median=nan(mediatimensize*2,length(data(:,1)));
for i=1:length(data(:,1));
    temp=[];
    [temp]=findmedian(data{i,24},data{i,22});
    outputpath.median(1:length(temp.median),i)=temp.median;
end
outputpath.median(mediatimensize*2+1:end,:)=[]
outputpath.medianofmedian=nanmedian(outputpath.median,2);
for i=1:length(outputpath.medianofmedian(:,1));
    outputpath.errmed(i,1)=mad(outputpath.median(i,:),2);
end
hold on
plot(outputpath.time,outputpath.medianofmedian,'g');
output.V5T40=outputpath;

outputpath=[];
data=mergedTU.V5T5;
for i=1:length(data(:,1));
    timesize(i,1)=data{i,24}(end);
end
mediatimensize=floor(max(timesize));
outputpath.time=(((1:(mediatimensize*2))-0.5)/2)';
outputpath.median=nan(mediatimensize*2,length(data(:,1)));
for i=1:length(data(:,1));
    temp=[];
    [temp]=findmedian(data{i,24},data{i,22});
    outputpath.median(1:length(temp.median),i)=temp.median;
end
outputpath.median(mediatimensize*2+1:end,:)=[]
outputpath.medianofmedian=nanmedian(outputpath.median,2);
for i=1:length(outputpath.medianofmedian(:,1));
    outputpath.errmed(i,1)=mad(outputpath.median(i,:),2);
end
hold on
plot(outputpath.time,outputpath.medianofmedian,'k');
output.V5T5=outputpath;

outputpath=[];
data=mergedTU.V5T6;
for i=1:length(data(:,1));
    timesize(i,1)=data{i,24}(end);
end
mediatimensize=floor(max(timesize));
outputpath.time=(((1:(mediatimensize*2))-0.5)/2)';
outputpath.median=nan(mediatimensize*2,length(data(:,1)));
for i=1:length(data(:,1));
    temp=[];
    [temp]=findmedian(data{i,24},data{i,22});
    outputpath.median(1:length(temp.median),i)=temp.median;
end
outputpath.median(mediatimensize*2+1:end,:)=[]
outputpath.medianofmedian=nanmedian(outputpath.median,2);
for i=1:length(outputpath.medianofmedian(:,1));
    outputpath.errmed(i,1)=mad(outputpath.median(i,:),2);
end
hold on
plot(outputpath.time,outputpath.medianofmedian,'m');
output.V5T6=outputpath;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%V10 velocity raw trace median with NAN
outputpath=[];
data=mergedTU.V10T4;
for i=1:length(data(:,1));
    timesize(i,1)=data{i,24}(end);
end
mediatimensize=floor(max(timesize));
outputpath.time=(((1:(mediatimensize*2))-0.5)/2)';
outputpath.median=nan(mediatimensize*2,length(data(:,1)));
for i=1:length(data(:,1));
    temp=[];
    [temp]=findmedian(data{i,24},data{i,22});
    outputpath.median(1:length(temp.median),i)=temp.median;
end
outputpath.median(mediatimensize*2+1:end,:)=[]
outputpath.medianofmedian=nanmedian(outputpath.median,2);
for i=1:length(outputpath.medianofmedian(:,1));
    outputpath.errmed(i,1)=mad(outputpath.median(i,:),2);
end
figure
plot(outputpath.time,outputpath.medianofmedian,'b');
output.V10T4=outputpath;


outputpath=[];
data=mergedTU.V10T10;
for i=1:length(data(:,1));
    timesize(i,1)=data{i,24}(end);
end
mediatimensize=floor(max(timesize));
outputpath.time=(((1:(mediatimensize*2))-0.5)/2)';
outputpath.median=nan(mediatimensize*2,length(data(:,1)));
for i=1:length(data(:,1));
    temp=[];
    [temp]=findmedian(data{i,24},data{i,22});
    outputpath.median(1:length(temp.median),i)=temp.median;
end
outputpath.median(mediatimensize*2+1:end,:)=[]
outputpath.medianofmedian=nanmedian(outputpath.median,2);
for i=1:length(outputpath.medianofmedian(:,1));
    outputpath.errmed(i,1)=mad(outputpath.median(i,:),2);
end
hold on
plot(outputpath.time,outputpath.medianofmedian,'r');
output.V10T10=outputpath;


outputpath=[];
data=mergedTU.V10T20;
for i=1:length(data(:,1));
    timesize(i,1)=data{i,24}(end);
end
mediatimensize=floor(max(timesize));
outputpath.time=(((1:(mediatimensize*2))-0.5)/2)';
outputpath.median=nan(mediatimensize*2,length(data(:,1)));
for i=1:length(data(:,1));
    temp=[];
    [temp]=findmedian(data{i,24},data{i,22});
    outputpath.median(1:length(temp.median),i)=temp.median;
end
outputpath.median(mediatimensize*2+1:end,:)=[]
outputpath.medianofmedian=nanmedian(outputpath.median,2);
for i=1:length(outputpath.medianofmedian(:,1));
    outputpath.errmed(i,1)=mad(outputpath.median(i,:),2);
end
hold on
plot(outputpath.time,outputpath.medianofmedian,'c');
output.V10T20=outputpath;

outputpath=[];
data=mergedTU.V10T30;
for i=1:length(data(:,1));
    timesize(i,1)=data{i,24}(end);
end
mediatimensize=floor(max(timesize));
outputpath.time=(((1:(mediatimensize*2))-0.5)/2)';
outputpath.median=nan(mediatimensize*2,length(data(:,1)));
for i=1:length(data(:,1));
    temp=[];
    [temp]=findmedian(data{i,24},data{i,22});
    outputpath.median(1:length(temp.median),i)=temp.median;
end
outputpath.median(mediatimensize*2+1:end,:)=[];
outputpath.median(:,[3 5])=[];
outputpath.medianofmedian=nanmedian(outputpath.median,2);
for i=1:length(outputpath.medianofmedian(:,1));
    outputpath.errmed(i,1)=mad(outputpath.median(i,:),2);
end
hold on
plot(outputpath.time,outputpath.medianofmedian,'k');
output.V10T30=outputpath;

outputpath=[];
data=mergedTU.V10T40;
for i=1:length(data(:,1));
    timesize(i,1)=data{i,24}(end);
end
mediatimensize=floor(max(timesize));
outputpath.time=(((1:(mediatimensize*2))-0.5)/2)';
outputpath.median=nan(mediatimensize*2,length(data(:,1)));
for i=1:length(data(:,1));
    temp=[];
    [temp]=findmedian(data{i,24},data{i,22});
    outputpath.median(1:length(temp.median),i)=temp.median;
end
outputpath.median(mediatimensize*2+1:end,:)=[]
outputpath.medianofmedian=nanmedian(outputpath.median,2);
for i=1:length(outputpath.medianofmedian(:,1));
    outputpath.errmed(i,1)=mad(outputpath.median(i,:),2);
end
hold on
plot(outputpath.time,outputpath.medianofmedian,'g');
output.V10T40=outputpath;

outputpath=[];
data=mergedTU.V10T5;
for i=1:length(data(:,1));
    timesize(i,1)=data{i,24}(end);
end
mediatimensize=floor(max(timesize));
outputpath.time=(((1:(mediatimensize*2))-0.5)/2)';
outputpath.median=nan(mediatimensize*2,length(data(:,1)));
for i=1:length(data(:,1));
    temp=[];
    [temp]=findmedian(data{i,24},data{i,22});
    outputpath.median(1:length(temp.median),i)=temp.median;
end
outputpath.median(mediatimensize*2+1:end,:)=[]
outputpath.medianofmedian=nanmedian(outputpath.median,2);
for i=1:length(outputpath.medianofmedian(:,1));
    outputpath.errmed(i,1)=mad(outputpath.median(i,:),2);
end
hold on
plot(outputpath.time,outputpath.medianofmedian,'k');
output.V10T5=outputpath;

outputpath=[];
data=mergedTU.V10T6;
for i=1:length(data(:,1));
    timesize(i,1)=data{i,24}(end);
end
mediatimensize=floor(max(timesize));
outputpath.time=(((1:(mediatimensize*2))-0.5)/2)';
outputpath.median=nan(mediatimensize*2,length(data(:,1)));
for i=1:length(data(:,1));
    temp=[];
    [temp]=findmedian(data{i,24},data{i,22});
    outputpath.median(1:length(temp.median),i)=temp.median;
end
outputpath.median(mediatimensize*2+1:end,:)=[]
outputpath.medianofmedian=nanmedian(outputpath.median,2);
for i=1:length(outputpath.medianofmedian(:,1));
    outputpath.errmed(i,1)=mad(outputpath.median(i,:),2);
end
hold on
plot(outputpath.time,outputpath.medianofmedian,'m');
output.V10T6=outputpath;



%%%%adaptation and okan amplitude

%%%%%%V10 adaptation and amplitude estimated by median
[testing.V10T4]=adap_amp_withnan(mergedTU.velocitymedianwithnan.V10T4,9);
[testing.V10T5]=adap_amp_withnan(mergedTU.velocitymedianwithnan.V10T5,10);
[testing.V10T6]=adap_amp_withnan(mergedTU.velocitymedianwithnan.V10T6,11);
[testing.V10T10]=adap_amp_withnan(mergedTU.velocitymedianwithnan.V10T10,15);
[testing.V10T20]=adap_amp_withnan(mergedTU.velocitymedianwithnan.V10T20,25);
[testing.V10T30]=adap_amp_withnan(mergedTU.velocitymedianwithnan.V10T30,35);
[testing.V10T40]=adap_amp_withnan(mergedTU.velocitymedianwithnan.V10T40,45);

%normalized adaptation and amplitude
figure
x=[4 5 6 10 20 30 40];
y1=[mean(testing.V10T4.normaladapt(:)) mean(testing.V10T5.normaladapt(:)) mean(testing.V10T6.normaladapt(:)) mean(testing.V10T10.normaladapt(:)) mean(testing.V10T20.normaladapt(:)) mean(testing.V10T30.normaladapt(:)) mean(testing.V10T40.normaladapt(:))];
scatter(x,y1,'r');
hold on;
x=[4 5 6 10 20 30 40];
y2=[mean(testing.V10T4.normalokanamp(:)) mean(testing.V10T5.normalokanamp(:)) mean(testing.V10T6.normalokanamp(:)) mean(testing.V10T10.normalokanamp(:)) mean(testing.V10T20.normalokanamp(:)) mean(testing.V10T30.normalokanamp(:)) mean(testing.V10T40.normalokanamp(:))]
scatter(x,y2,'b')

%raw adaptation and amplitude
figure
x=[4 5 6 10 20 30 40];
y1=[median(testing.V10T4.okrdrop(:)) median(testing.V10T5.okrdrop(:)) median(testing.V10T6.okrdrop(:)) median(testing.V10T10.okrdrop(:)) median(testing.V10T20.okrdrop(:)) median(testing.V10T30.okrdrop(:)) median(testing.V10T40.okrdrop(:))];
bar(x,y1);
err1=[mad(testing.V10T4.okrdrop(:),1) mad(testing.V10T5.okrdrop(:),1) mad(testing.V10T6.okrdrop(:),1) mad(testing.V10T10.okrdrop(:),1) mad(testing.V10T20.okrdrop(:),1) mad(testing.V10T30.okrdrop(:),1) mad(testing.V10T40.okrdrop(:),1)];

hold on;
x=[4 5 6 10 20 30 40];
y2=-[median(testing.V10T4.okanamp(:)) median(testing.V10T5.okanamp(:)) median(testing.V10T6.okanamp(:)) median(testing.V10T10.okanamp(:)) median(testing.V10T20.okanamp(:)) median(testing.V10T30.okanamp(:)) median(testing.V10T40.okanamp(:))]
bar(x,y2)
err2=[mad(testing.V10T4.okanamp(:),1) mad(testing.V10T5.okanamp(:),1) mad(testing.V10T6.okanamp(:),1) mad(testing.V10T10.okanamp(:),1) mad(testing.V10T20.okanamp(:),1) mad(testing.V10T30.okanamp(:),1) mad(testing.V10T40.okanamp(:),1)];

hold on
scatter(y1,y2,'b');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




   
    
clear exceldata;
datapath=testing;
for i=1:length(datapath.diffmedian(:))
    for k=1:length(datapath.time{i,1});
    if datapath.time{i,1}(k,1)>okan_st && datapath.time{i,1}(k,1)<okan_st+0.5;
        exceldata{i,1}(:,2)=datapath.diffmedian{i,1}(k:end,1)/((datapath.diffmedian{i,1}(k+2,1)+datapath.diffmedian{i,1}(k+3,1))/2);
        exceldata{i,1}(:,1)=(((1:length(exceldata{i,1}(:,2)))-0.5)/2);
    end
    end
    figure
    x=exceldata{i,1}(:,1);
    y=exceldata{i,1}(:,2);
    scatter(x,y);
end


clear exceldata;
okan_st=45
datapath=mergedTU.freqfitting.V10T40;
for i=1:length(datapath.diffmedian(:))
    for k=1:length(datapath.time{i,1});
    if datapath.time{i,1}(k,1)>okan_st && datapath.time{i,1}(k,1)<okan_st+0.5;
        exceldata{i,1}(:,2)=datapath.diffmedian{i,1}(k:end,1)/((datapath.diffmedian{i,1}(k+2,1)+datapath.diffmedian{i,1}(k+3,1))/2);
        exceldata{i,1}(:,1)=(((1:length(exceldata{i,1}(:,2)))-0.5)/2);
    end
    end
    figure
    x=exceldata{i,1}(:,1);
    y=exceldata{i,1}(:,2);
    scatter(x,y);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%V5 velocity raw trace median with NAN
outputpath=[];
data=mergedTU.V5T7;
for i=1:length(data(:,1));
    timesize(i,1)=data{i,24}(end);
end
mediatimensize=floor(max(timesize));
outputpath.time=(((1:(mediatimensize*2))-0.5)/2)';
outputpath.median=nan(mediatimensize*2,length(data(:,1)));
for i=1:length(data(:,1));
    temp=[];
    [temp]=findmedian(data{i,24},data{i,22});
    outputpath.median(1:length(temp.median),i)=temp.median;
end
outputpath.median(mediatimensize*2+1:end,:)=[]
outputpath.medianofmedian=nanmedian(outputpath.median,2);
for i=1:length(outputpath.medianofmedian(:,1));
    outputpath.errmed(i,1)=mad(outputpath.median(i,:),2);
end
figure
plot(outputpath.time,outputpath.medianofmedian,'b');
output.V5T7=outputpath;


outputpath=[];
data=mergedTU.V5T10;
for i=1:length(data(:,1));
    timesize(i,1)=data{i,24}(end);
end
mediatimensize=floor(max(timesize));
outputpath.time=(((1:(mediatimensize*2))-0.5)/2)';
outputpath.median=nan(mediatimensize*2,length(data(:,1)));
for i=1:length(data(:,1));
    temp=[];
    [temp]=findmedian(data{i,24},data{i,22});
    outputpath.median(1:length(temp.median),i)=temp.median;
end
outputpath.median(mediatimensize*2+1:end,:)=[]
outputpath.medianofmedian=nanmedian(outputpath.median,2);
for i=1:length(outputpath.medianofmedian(:,1));
    outputpath.errmed(i,1)=mad(outputpath.median(i,:),2);
end
hold on
plot(outputpath.time,outputpath.medianofmedian,'r');
output.V5T10=outputpath;


outputpath=[];
data=mergedTU.V5T20;
for i=1:length(data(:,1));
    timesize(i,1)=data{i,24}(end);
end
mediatimensize=floor(max(timesize));
outputpath.time=(((1:(mediatimensize*2))-0.5)/2)';
outputpath.median=nan(mediatimensize*2,length(data(:,1)));
for i=1:length(data(:,1));
    temp=[];
    [temp]=findmedian(data{i,24},data{i,22});
    outputpath.median(1:length(temp.median),i)=temp.median;
end
outputpath.median(mediatimensize*2+1:end,:)=[]
outputpath.medianofmedian=nanmedian(outputpath.median,2);
for i=1:length(outputpath.medianofmedian(:,1));
    outputpath.errmed(i,1)=mad(outputpath.median(i,:),2);
end
hold on
plot(outputpath.time,outputpath.medianofmedian,'c');
output.V5T20=outputpath;

outputpath=[];
data=mergedTU.V5T30;
for i=1:length(data(:,1));
    timesize(i,1)=data{i,24}(end);
end
mediatimensize=floor(max(timesize));
outputpath.time=(((1:(mediatimensize*2))-0.5)/2)';
outputpath.median=nan(mediatimensize*2,length(data(:,1)));
for i=1:length(data(:,1));
    temp=[];
    [temp]=findmedian(data{i,24},data{i,22});
    outputpath.median(1:length(temp.median),i)=temp.median;
end
outputpath.median(mediatimensize*2+1:end,:)=[];
outputpath.medianofmedian=nanmedian(outputpath.median,2);
for i=1:length(outputpath.medianofmedian(:,1));
    outputpath.errmed(i,1)=mad(outputpath.median(i,:),2);
end
hold on
plot(outputpath.time,outputpath.medianofmedian,'k');
output.V5T30=outputpath;

outputpath=[];
data=mergedTU.V5T40;
for i=1:length(data(:,1));
    timesize(i,1)=data{i,24}(end);
end
mediatimensize=floor(max(timesize));
outputpath.time=(((1:(mediatimensize*2))-0.5)/2)';
outputpath.median=nan(mediatimensize*2,length(data(:,1)));
for i=1:length(data(:,1));
    temp=[];
    [temp]=findmedian(data{i,24},data{i,22});
    outputpath.median(1:length(temp.median),i)=temp.median;
end
outputpath.median(mediatimensize*2+1:end,:)=[]
outputpath.medianofmedian=nanmedian(outputpath.median,2);
for i=1:length(outputpath.medianofmedian(:,1));
    outputpath.errmed(i,1)=mad(outputpath.median(i,:),2);
end
hold on
plot(outputpath.time,outputpath.medianofmedian,'g');
output.V5T40=outputpath;

outputpath=[];
data=mergedTU.V5T5;
for i=1:length(data(:,1));
    timesize(i,1)=data{i,24}(end);
end
mediatimensize=floor(max(timesize));
outputpath.time=(((1:(mediatimensize*2))-0.5)/2)';
outputpath.median=nan(mediatimensize*2,length(data(:,1)));
for i=1:length(data(:,1));
    temp=[];
    [temp]=findmedian(data{i,24},data{i,22});
    outputpath.median(1:length(temp.median),i)=temp.median;
end
outputpath.median(mediatimensize*2+1:end,:)=[]
outputpath.medianofmedian=nanmedian(outputpath.median,2);
for i=1:length(outputpath.medianofmedian(:,1));
    outputpath.errmed(i,1)=mad(outputpath.median(i,:),2);
end
hold on
plot(outputpath.time,outputpath.medianofmedian,'k');
output.V5T5=outputpath;

outputpath=[];
data=mergedTU.V5T6;
for i=1:length(data(:,1));
    timesize(i,1)=data{i,24}(end);
end
mediatimensize=floor(max(timesize));
outputpath.time=(((1:(mediatimensize*2))-0.5)/2)';
outputpath.median=nan(mediatimensize*2,length(data(:,1)));
for i=1:length(data(:,1));
    temp=[];
    [temp]=findmedian(data{i,24},data{i,22});
    outputpath.median(1:length(temp.median),i)=temp.median;
end
outputpath.median(mediatimensize*2+1:end,:)=[]
outputpath.medianofmedian=nanmedian(outputpath.median,2);
for i=1:length(outputpath.medianofmedian(:,1));
    outputpath.errmed(i,1)=mad(outputpath.median(i,:),2);
end
hold on
plot(outputpath.time,outputpath.medianofmedian,'m');
output.V5T6=outputpath;



%%%%adaptation and okan amplitude

%%%%%%V5 adaptation and amplitude estimated by median

[testing.V5T5]=adap_amp_withnan(mergedTU.velocitymedianwithnan.V5T5,10);
[testing.V5T6]=adap_amp_withnan(mergedTU.velocitymedianwithnan.V5T6,11);
[testing.V5T7]=adap_amp_withnan(mergedTU.velocitymedianwithnan.V5T7,12);
[testing.V5T10]=adap_amp_withnan(mergedTU.velocitymedianwithnan.V5T10,15);
[testing.V5T20]=adap_amp_withnan(mergedTU.velocitymedianwithnan.V5T20,25);
[testing.V5T30]=adap_amp_withnan(mergedTU.velocitymedianwithnan.V5T30,35);
[testing.V5T40]=adap_amp_withnan(mergedTU.velocitymedianwithnan.V5T40,45);

%normalized adaptation and amplitude
figure
x=[5 6 7 10 20 30 40];
y1=[mean(testing.V5T5.normaladapt(:)) mean(testing.V5T6.normaladapt(:)) mean(testing.V5T7.normaladapt(:)) mean(testing.V5T10.normaladapt(:)) mean(testing.V5T20.normaladapt(:)) mean(testing.V5T30.normaladapt(:)) mean(testing.V5T40.normaladapt(:))];
scatter(x,y1,'r');
hold on;
x=[5 6 7 10 20 30 40];
y2=[mean(testing.V5T5.normalokanamp(:)) mean(testing.V5T6.normalokanamp(:)) mean(testing.V5T7.normalokanamp(:)) mean(testing.V5T10.normalokanamp(:)) mean(testing.V5T20.normalokanamp(:)) mean(testing.V5T30.normalokanamp(:)) mean(testing.V5T40.normalokanamp(:))]
scatter(x,y2,'b')

%raw adaptation and amplitude
figure
x=[5 6 7 10 20 30 40];
y1=[median(testing.V5T5.okrdrop(:)) median(testing.V5T6.okrdrop(:)) median(testing.V5T7.okrdrop(:)) median(testing.V5T10.okrdrop(:)) median(testing.V5T20.okrdrop(:)) median(testing.V5T30.okrdrop(:)) median(testing.V5T40.okrdrop(:))];
bar(x,y1);
err1=[ mad(testing.V5T5.okrdrop(:),1) mad(testing.V5T6.okrdrop(:),1) mad(testing.V5T7.okrdrop(:),1) mad(testing.V5T10.okrdrop(:),1) mad(testing.V5T20.okrdrop(:),1) mad(testing.V5T30.okrdrop(:),1) mad(testing.V5T40.okrdrop(:),1)];

hold on;
x=[5 6 7 10 20 30 40];
y2=[median(testing.V5T5.okanamp(:)) median(testing.V5T6.okanamp(:)) median(testing.V5T7.okanamp(:)) median(testing.V5T10.okanamp(:)) median(testing.V5T20.okanamp(:)) median(testing.V5T30.okanamp(:)) median(testing.V5T40.okanamp(:))]
bar(x,y2)
err2=[mad(testing.V5T5.okanamp(:),1) mad(testing.V5T6.okanamp(:),1) mad(testing.V5T7.okanamp(:),1) mad(testing.V5T10.okanamp(:),1) mad(testing.V5T20.okanamp(:),1) mad(testing.V5T30.okanamp(:),1) mad(testing.V5T40.okanamp(:),1)];

hold on
scatter(y1,y2,'b');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




   
    
clear exceldata;
datapath=testing;
for i=1:length(datapath.diffmedian(:))
    for k=1:length(datapath.time{i,1});
    if datapath.time{i,1}(k,1)>okan_st && datapath.time{i,1}(k,1)<okan_st+0.5;
        exceldata{i,1}(:,2)=datapath.diffmedian{i,1}(k:end,1)/((datapath.diffmedian{i,1}(k+2,1)+datapath.diffmedian{i,1}(k+3,1))/2);
        exceldata{i,1}(:,1)=(((1:length(exceldata{i,1}(:,2)))-0.5)/2);
    end
    end
    figure
    x=exceldata{i,1}(:,1);
    y=exceldata{i,1}(:,2);
    scatter(x,y);
end


clear exceldata;
okan_st=45
datapath=mergedTU.freqfitting.V10T40;
for i=1:length(datapath.diffmedian(:))
    for k=1:length(datapath.time{i,1});
    if datapath.time{i,1}(k,1)>okan_st && datapath.time{i,1}(k,1)<okan_st+0.5;
        exceldata{i,1}(:,2)=datapath.diffmedian{i,1}(k:end,1)/((datapath.diffmedian{i,1}(k+2,1)+datapath.diffmedian{i,1}(k+3,1))/2);
        exceldata{i,1}(:,1)=(((1:length(exceldata{i,1}(:,2)))-0.5)/2);
    end
    end
    figure
    x=exceldata{i,1}(:,1);
    y=exceldata{i,1}(:,2);
    scatter(x,y);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%OKR adaptation estimated 

%V10 velocity
merge.merged_a=[mergedTU.velocityfitting.V10T10.fiting.a mergedTU.velocityfitting.V10T20.fiting.a mergedTU.velocityfitting.V10T30.fiting.a([1 2 4 6 7]) mergedTU.velocityfitting.V10T40.fiting.a];
merge.merged_a_median=median([mergedTU.velocityfitting.V10T10.fiting.a mergedTU.velocityfitting.V10T20.fiting.a mergedTU.velocityfitting.V10T30.fiting.a([1 2 4 6 7]) mergedTU.velocityfitting.V10T40.fiting.a]);

merge.merged_b=[mergedTU.velocityfitting.V10T10.fiting.b mergedTU.velocityfitting.V10T20.fiting.b mergedTU.velocityfitting.V10T30.fiting.b([1 2 4 6 7]) mergedTU.velocityfitting.V10T40.fiting.b];
merge.merged_b_median=median([mergedTU.velocityfitting.V10T10.fiting.b mergedTU.velocityfitting.V10T20.fiting.b mergedTU.velocityfitting.V10T30.fiting.b([1 2 4 6 7]) mergedTU.velocityfitting.V10T40.fiting.b]);

merge.merged_c=[mergedTU.velocityfitting.V10T10.fiting.c mergedTU.velocityfitting.V10T20.fiting.c mergedTU.velocityfitting.V10T30.fiting.c([1 2 4 6 7]) mergedTU.velocityfitting.V10T40.fiting.c];
merge.merged_c_median=median([mergedTU.velocityfitting.V10T10.fiting.c mergedTU.velocityfitting.V10T20.fiting.c mergedTU.velocityfitting.V10T30.fiting.c([1 2 4 6 7]) mergedTU.velocityfitting.V10T40.fiting.c]);

merge.merged_d=[mergedTU.velocityfitting.V10T10.fiting.d mergedTU.velocityfitting.V10T20.fiting.d mergedTU.velocityfitting.V10T30.fiting.d([1 2 4 6 7]) mergedTU.velocityfitting.V10T40.fiting.d];
merge.merged_d_median=median([mergedTU.velocityfitting.V10T10.fiting.d mergedTU.velocityfitting.V10T20.fiting.d mergedTU.velocityfitting.V10T30.fiting.d([1 2 4 6 7]) mergedTU.velocityfitting.V10T40.fiting.d]);

merge.merged_e=[mergedTU.velocityfitting.V10T10.fiting.e mergedTU.velocityfitting.V10T20.fiting.e mergedTU.velocityfitting.V10T30.fiting.e([1 2 4 6 7]) mergedTU.velocityfitting.V10T40.fiting.e];
merge.merged_e_median=median([mergedTU.velocityfitting.V10T10.fiting.e mergedTU.velocityfitting.V10T20.fiting.e mergedTU.velocityfitting.V10T30.fiting.e([1 2 4 6 7]) mergedTU.velocityfitting.V10T40.fiting.e]);

path=mergedTU.velocityfitting.medianofokrparameter;
snapnow;
x=1:0.004:40;
y=path.merged_a_median*(exp(-x/path.merged_b_median))+path.merged_c_median*(exp(-x/path.merged_d_median))+path.merged_e_median;
plot(x,y);


ft=fittype('3.0856*(exp(-(x-s)/0.3985))+1.5512*(exp(-(x-s)/13.4428))-3.0856-1.5512');
[f,gof]=fit(amp(:,1),amp(:,2),ft);
parameters=coeffvalues(f)

%V10 freq


merge.merged_a=[mergedTU.freqfitting.V10T10.fiting.a mergedTU.freqfitting.V10T20.fiting.a mergedTU.freqfitting.V10T30.fiting.a([1:3 5 6 ]) mergedTU.freqfitting.V10T40.fiting.a];
merge.merged_a_median=median([mergedTU.freqfitting.V10T10.fiting.a mergedTU.freqfitting.V10T20.fiting.a mergedTU.freqfitting.V10T30.fiting.a([1:3 5 6 ]) mergedTU.freqfitting.V10T40.fiting.a]);

merge.merged_b=[mergedTU.freqfitting.V10T10.fiting.b mergedTU.freqfitting.V10T20.fiting.b mergedTU.freqfitting.V10T30.fiting.b([1:3 5 6 ]) mergedTU.freqfitting.V10T40.fiting.b];
merge.merged_b_median=median([mergedTU.freqfitting.V10T10.fiting.b mergedTU.freqfitting.V10T20.fiting.b mergedTU.freqfitting.V10T30.fiting.b([1:3 5 6 ]) mergedTU.freqfitting.V10T40.fiting.b]);

merge.merged_c=[mergedTU.freqfitting.V10T10.fiting.c mergedTU.freqfitting.V10T20.fiting.c mergedTU.freqfitting.V10T30.fiting.c([1:3 5 6 ]) mergedTU.freqfitting.V10T40.fiting.c];
merge.merged_c_median=median([mergedTU.freqfitting.V10T10.fiting.c mergedTU.freqfitting.V10T20.fiting.c mergedTU.freqfitting.V10T30.fiting.c([1:3 5 6 ]) mergedTU.freqfitting.V10T40.fiting.c]);

merge.merged_d=[mergedTU.freqfitting.V10T10.fiting.d mergedTU.freqfitting.V10T20.fiting.d mergedTU.freqfitting.V10T30.fiting.d([1:3 5 6 ]) mergedTU.freqfitting.V10T40.fiting.d];
merge.merged_d_median=median([mergedTU.freqfitting.V10T10.fiting.d mergedTU.freqfitting.V10T20.fiting.d mergedTU.freqfitting.V10T30.fiting.d([1:3 5 6 ]) mergedTU.freqfitting.V10T40.fiting.d]);

merge.merged_e=[mergedTU.freqfitting.V10T10.fiting.e mergedTU.freqfitting.V10T20.fiting.e mergedTU.freqfitting.V10T30.fiting.e([1:3 5 6 ]) mergedTU.freqfitting.V10T40.fiting.e];
merge.merged_e_median=median([mergedTU.freqfitting.V10T10.fiting.e mergedTU.freqfitting.V10T20.fiting.e mergedTU.freqfitting.V10T30.fiting.e([1:3 5 6 ]) mergedTU.freqfitting.V10T40.fiting.e]);

mergedTU.freqfitting.medianofokrparameters=merge;
path=mergedTU.freqfitting.medianofokrparameters;
x=1:0.004:40;
y=path.merged_a_median*(exp(-x/path.merged_b_median))+path.merged_c_median*(exp(-x/path.merged_d_median))+path.merged_e_median;
plot(x,y);

ft=fittype('6.3467*(exp(-(x-s)/0.3151))+4.8459*(exp(-(x-s)/6.0061))-6.3467-4.8459');
[f,gof]=fit(amp(:,1),amp(:,2),ft);
parameters=coeffvalues(f);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%%%OKR adaptation estimated 

%V5 velocity
merge.merged_a=[mergedTU.velocityfitting.V5T10.fiting.a mergedTU.velocityfitting.V5T20.fiting.a mergedTU.velocityfitting.V5T30.fiting.a mergedTU.velocityfitting.V5T40.fiting.a];
merge.merged_a_median=median(merge.merged_a);

merge.merged_b=[mergedTU.velocityfitting.V5T10.fiting.b mergedTU.velocityfitting.V5T20.fiting.b mergedTU.velocityfitting.V5T30.fiting.b mergedTU.velocityfitting.V5T40.fiting.b];
merge.merged_b_median=median(merge.merged_b);

merge.merged_c=[mergedTU.velocityfitting.V5T10.fiting.c mergedTU.velocityfitting.V5T20.fiting.c mergedTU.velocityfitting.V5T30.fiting.c mergedTU.velocityfitting.V5T40.fiting.c];
merge.merged_c_median=median(merge.merged_c);

merge.merged_d=[mergedTU.velocityfitting.V5T10.fiting.d mergedTU.velocityfitting.V5T20.fiting.d mergedTU.velocityfitting.V5T30.fiting.d mergedTU.velocityfitting.V5T40.fiting.d];
merge.merged_d_median=median(merge.merged_d);

merge.merged_e=[mergedTU.velocityfitting.V5T10.fiting.e mergedTU.velocityfitting.V5T20.fiting.e mergedTU.velocityfitting.V5T30.fiting.e mergedTU.velocityfitting.V5T40.fiting.e];
merge.merged_e_median=median(merge.merged_e);



path=mergedTU.velocityfitting.medianofokrparameter.V5;
x=0:0.004:40;
y=path.merged_a_median*(exp(-x/path.merged_b_median))+path.merged_c_median*(exp(-x/path.merged_d_median))+path.merged_e_median;
y2=path.merged_a_median*(exp(-x/path.merged_b_median))+path.merged_c_median*(exp(-x/path.merged_d_median))-path.merged_a_median-path.merged_c_median;
figure
plot(x,y2);

%V5 freq


merge.merged_a=[mergedTU.freqfitting.V5T10.fiting.a mergedTU.freqfitting.V5T20.fiting.a mergedTU.freqfitting.V5T30.fiting.a mergedTU.freqfitting.V5T40.fiting.a];
merge.merged_a_median=median(merge.merged_a);

merge.merged_b=[mergedTU.freqfitting.V5T10.fiting.b mergedTU.freqfitting.V5T20.fiting.b mergedTU.freqfitting.V5T30.fiting.b mergedTU.freqfitting.V5T40.fiting.b];
merge.merged_b_median=median(merge.merged_b);

merge.merged_c=[mergedTU.freqfitting.V5T10.fiting.c mergedTU.freqfitting.V5T20.fiting.c mergedTU.freqfitting.V5T30.fiting.c mergedTU.freqfitting.V5T40.fiting.c];
merge.merged_c_median=median(merge.merged_c);

merge.merged_d=[mergedTU.freqfitting.V5T10.fiting.d mergedTU.freqfitting.V5T20.fiting.d mergedTU.freqfitting.V5T30.fiting.d mergedTU.freqfitting.V5T40.fiting.d];
merge.merged_d_median=median(merge.merged_d);

merge.merged_e=[mergedTU.freqfitting.V5T10.fiting.e mergedTU.freqfitting.V5T20.fiting.e mergedTU.freqfitting.V5T30.fiting.e mergedTU.freqfitting.V5T40.fiting.e];
merge.merged_e_median=median(merge.merged_e);

mergedTU.freqfitting.medianofokrparameters.V5=merge;
path=mergedTU.freqfitting.medianofokrparameters.V5;
x=0:0.004:40;
y=path.merged_a_median*(exp(-x/path.merged_b_median))+path.merged_c_median*(exp(-x/path.merged_d_median))+path.merged_e_median;
y2=path.merged_a_median*(exp(-x/path.merged_b_median))+path.merged_c_median*(exp(-x/path.merged_d_median))-path.merged_a_median-path.merged_c_median;
plot(x,y2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%find the median of position

for i=1:length(data.freq.SaccExtremeIdx(:,1));
tempme=mean([data.freq.eye_raw(data.freq.SaccExtremeIdx(i,1),1) data.freq.eye_raw(data.freq.SaccExtremeIdx(i,2),1)]);
temp=data.freq.eye_raw(data.freq.SaccExtremeIdx(i,1):data.freq.SaccExtremeIdx(i,2),1);
tempabs=abs(temp-tempme);
[idx idx]=min(tempabs);
data.freq.medpointIdx(i,1)=idx-1+data.freq.SaccExtremeIdx(i,1);
data.freq.medpointtime(i,1)=data.freq.time(data.freq.medpointIdx(i,1),1);
data.freq.medpoint(i,1)=temp(idx);
end
plot(data.freq.time,data.freq.eye_raw);
hold on
plot(data.freq.medpointtime,data.freq.medpoint,'r');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
decay curve

path=mergedTU.freqfitting.V10T10.fiting.g
x=(0:0.004:10)';
f=[];
y=[];
for i=2:6;
    f=exp(-x/path(i))';
    y=[y f];
    hold on;
    plot(x,f);
end
ymedian=median(y,2);
ymad=[];
for i=1:length(y(:,1));
    ymad(i,1)=mad(y(i,:),1);
end


