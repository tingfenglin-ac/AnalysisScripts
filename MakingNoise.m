TrialT=2; %duration of trial (s)
ST=0; % stimulation timing (s)
SD=2; % stimulation duration (s)
SFs=2000; % sound frequency

Fs=8192; %defaut sampling rate of sound function
y=zeros(Fs*TrialT,1);
y(ST.*Fs+(1:Fs.*SD))=sin(SFs.*2.*pi*(1:Fs.*SD)./Fs);
plot((1:length(y))./Fs,y);

sound(y);