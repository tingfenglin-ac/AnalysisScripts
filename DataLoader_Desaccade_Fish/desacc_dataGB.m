function [out1,out2,out3]=desacc_dataGB(data,smpf,sacidxs,draw, interp)
%function out=desacc_data(data,smpf,sacidxs,draw);
%Remove the data between the beginning and end of each saccade
%sacidxs needs to be sorted and containing non overlapping saccades
%call duplicate
%SR 2005; 2007


if nargin<4
    draw=0;
end
if nargin<5
   interp=1;
end
if length(smpf)==1
    time=buildtime(data,smpf)';
else
    time=smpf;
    if size(time,2)>size(time,1)
        time=time';
    end
    smpf=round(1/median(diff(time)));
end

numsacc=size(sacidxs,1);
bix=sacidxs(:,1);
eix=sacidxs(:,2);

%Moving average, differentiate and lowpass filter eye velocity
% ca(:,1)=movavg(data(:,1),5);
% ctv=derivata(ca(:,1),1/smpf);
% data=remezfilt(ctv,2,10,smpf);

%If there are saccade indices, remove the saccade and interpolate
if numsacc>1
    eyedata=[data(1:bix(1)); data(eix(1):bix(2))];
    timedata=[time(1:bix(1)); time(eix(1):bix(2))];
    index=[[1:bix(1)]'; [eix(1):bix(2)]'];
    i=2;
    while i<numsacc
        eyedata=[eyedata;data(eix(i):bix(i+1))];
        timedata=[timedata;time(eix(i):bix(i+1))];
        index=[index; [eix(i):bix(i+1)]'];
        i=i+1;
    end
    eyedata=[eyedata; data(eix(i)+2:end)];
    timedata=[timedata; time(eix(i)+2:end)];
    index=[index; [eix(i)+2:length(data)]'];
    if interp==1
        y=interp1(timedata,eyedata,time);
    else 
    y=eyedata;
    
    %    y=spline(timedata,eyedata,time);
    end
elseif numsacc>0
    eyedata=[data(1:bix(1)); data(eix(1):end)];
    timedata=[time(1:bix(1)); time(eix(1):end)];
    index=[[1:bix(1)]'; [eix(1):length(data)]'];
if interp==1
    y=interp1(timedata,eyedata,time);
else 
    y=eyedata;
    
    %    y=spline(timedata,eyedata,time);
end
else
    eyedata=data;
    timedata=time;
    y=data;
end


%low pass filter output data after interpolation
%y=firfilt(y,.5,5,smpf);
%y=firfilt(y,3,10,smpf);
if draw
    figure
    plot(time,y,'r',time,data,'b',timedata,eyedata,'m')
    set(gca,'ylim',[-50 50])
end

out(:,1)=y;
if not(interp==1)
    out(:,2)=timedata;
else
    out(:,2)=0:1/smpf:(length(out)-1)/smpf;
end
%out(:,3)=index;
if nargout>1
    if numsacc>0
        varargout{1}=[bix' eix'];
    else
        varargout{1}=[];
    end
end
out1=out(:,1);
out2=out(:,2);
%out3=out(:,3);
out3=index;