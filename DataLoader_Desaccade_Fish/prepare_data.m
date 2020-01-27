function out=prepare_data(chans,smpf,versf,indices)
%function out=prepare_data(chans,smpf,versf,indices)
%used for SACCADIC OSCILLATIONS or selection of saccades
%it returns a 2 column array of beginning and end indices 
%chans contains the data channels (should be at least 2)
%versf is a flag to compute version if the channels are right and left eye
%indices an array of beginning and end indices as returned by this function which may come
%from a previous analysis or an interrupted procedure
%SR 2004 updated 2007

if nargin<4
    indices=[];
end
if nargin < 3
    versf=0;
end
if nargin<2
    smpf=100;
end
if nargin<1
    help prepare_data;
    return
end

%Each eye channel. Moving average, differentiate, smoothing
for j=1:size(chans,2)
%     ca(:,j)=movavg(chans(:,j),5);
ca=chans(:,j);
    ctv=derivata(ca(:,j),1/smpf);
    cv(:,j)=ctv;
%     cv(:,j)=remezfilt(ctv,10,40,smpf); 
end

if versf
    vers=(c1a+c2a)/2;
    versv=(c1v+c2v)/2;
end
idx=[];
t=buildtime(ca(:,1),smpf);
%dstr=struct;

[idx,datastr]=select_data(ca,cv,smpf,0,idx,indices);%Select indices for closer analysis

out=idx;