function out=pspect(signal,smpf,color,h)
%function pspect(signal,smpf,color,h)
%Calculates and shows the power spectrum of signal
%Eliminate DC from the plot if h==1

if nargin < 3
   color='b';
end

%if h is set to 1, only higher frequencies are shown, not DC
if nargin<4
   h=0;
end

y=fft(signal);
ylen=length(y);
P=y.*conj(y)/ylen;
f=smpf*(0:ylen-1)/ylen;
flen=floor(length(f)/2);
%plot(f(1:flen),P(1:flen))
%Eliminate DC from the plot
if h==1,
	plot(f(5:flen),P(5:flen),color)
else
   plot(f(1:flen),P(1:flen),color)
end
out=[f(1:flen)',P(1:flen)'];