function outfilt=firfilt(signal,stopf1,stopf2,smpf,hp,rp,rs)
%function outfilt=firfilt(signal,stopf1,stopf2,smpf,hp)
%Lowpass filter with FIR filter (fwd and bcwd passes)
%stopping frequencies above stopf1 and decaying to -60dB
%to the second corner frequency stopf2
%stopf1<stopf2 , in Hz
%smpf is the sampling frequency
%High-pass if hp==1
%Updated 12/2005
%High-pass 01/2007
if nargin < 1
    help firfilt
    return
end
if nargin < 5
    hp=0;
end
if nargin<6
    rp=.01;
end
if nargin<7
    rs=40;
end
nyq=smpf/2;

%FILTER DESIGN FC=stopf1, Fstop=stopf2 Gains 1,0
%rp ripple in pass 0.01DB, min
%rs attenuation in stopband is 40DB
if ~hp
    [n,fo,ao,w] = firpmord([stopf1,stopf2],[1 0],[(10^(rp/20)-1)/(10^(rp/20)+1) 10^(-rs/20)],smpf);
else %High pass filter
    [n,fo,ao,w] = firpmord([stopf1,stopf2],[0 1],[(10^(rp/20)-1)/(10^(rp/20)+1) 10^(-rs/20)],smpf);
end
n
filcoef=firpm(n,fo,ao,w);
signalf=filtfilt(filcoef,1,signal);
outfilt=signalf;
