function data=eyeMOV_analysis_3v()
close all

%if fgInterp=1, the missing data will be filled with linear interpolation
fgInterp=1;
% if the eye trace degree bigger than anleOut, the data will be deleted
angleOut=100000;

str = which('eyeMOV_analysis_3v');
addpath([str(1:end-21),'\DataLoader_Desaccade_Fish']);
[fileName,pathName] = uigetfile('*.txt');


[fps,tTxt,leye,reye,bodyP,StimulusVelocity,SpatialFrequency]= FileReader([pathName,fileName],angleOut);

[t,dataRS]=resDataNaN_fish(tTxt,[leye,reye,bodyP],fps);
leye=dataRS(:,1);reye=dataRS(:,2);bodyP=dataRS(:,3);

if fgInterp
    leye(isnan(leye))=interp1(t(~isnan(leye)),leye(~isnan(leye)),t(isnan(leye)));
    reye(isnan(reye))=interp1(t(~isnan(reye)),reye(~isnan(reye)),t(isnan(reye)));
end


% gaussian kernel smooth
   % training data x
%    % training data y
% h=0.18; % kernel bandwidth
% 
% for i=1:length(leye);
%     xs(i)=t(i,1);
%     leye1(i)=gaussian_kern_reg(xs(i),t,leye,h);
%     reye1(i)=gaussian_kern_reg(xs(i),t,reye,h);
% end



cutoff=5.5;

%h = gengauss(cutoff);
%h = h/sum(h);
%leye=filtfilt(h,1,leye);
%reye=filtfilt(h,1,reye);

[leye] = gengaussFilterNaN(leye,cutoff);
[reye] = gengaussFilterNaN(reye,cutoff);
[bodyP] = gengaussFilterNaN(bodyP,cutoff);%Ting add


bodyP=butterFilterNaN(bodyP,fps,5);%filter body ang

[data_leye]=Interactive_desaccader_fish(derivata(leye,1./fps),t,leye,bodyP,StimulusVelocity); %with 0 the checkbox substract eyePos average uses the whole signal
[data_reye]=Interactive_desaccader_fish(derivata(reye,1./fps),t,reye,bodyP,StimulusVelocity); % StimulusVelocity  the checkbox 'substract eyePos average' uses the first 5min of dark

%If the maxTimsacc>2, it will be cancelled
maxTimeSacc=200;

[data.SaccAmplL,data.SaccVelL,data.SaccTimeL,data.SaccFrqL,data.SaccExtremeIdxL]=saccadeAnalysis(data_leye.rawtime,data_leye.eyepos,data_leye.omega_r,data_leye.saccExtremeIdx,maxTimeSacc);
[data.SaccAmplR,data.SaccVelR,data.SaccTimeR,data.SaccFrqR,data.SaccExtremeIdxR]=saccadeAnalysis(data_reye.rawtime,data_reye.eyepos,data_reye.omega_r,data_reye.saccExtremeIdx,maxTimeSacc);


data.time_l=data_leye.rawtime;
data.time_r=data_reye.rawtime;
data.leye_raw=data_leye.eyepos;
data.reye_raw=data_reye.eyepos;
data.bodyP_l=data_leye.bodyP; %Ting add
data.bodyP_r=data_reye.bodyP; %Ting add

%figure(1); %check data saccades
%plot(data.time_l,data.leye_raw,'r');
%hold on
%plot(data.time_l(data.SaccExtremeIdxL(:,1)),data.leye_raw(data.SaccExtremeIdxL(:,1)),'.b','markersize',20);
%plot(data.time_l(data.SaccExtremeIdxL(:,2)),data.leye_raw(data.SaccExtremeIdxL(:,2)),'.m','markersize',20);

%figure(2); %plot main sequence
%plot([data.SaccAmplL;data.SaccVelL],[data.SaccAmplR;data.SaccVelR],'.')

save([pathName,fileName(1:end-4),'_TEMP.mat'],'data');
disp([pathName,fileName(1:end-4),'_TEMP.mat']);
%uisave('data',[pathName,fileName(1:end-4),'.mat']);

end

function [fps,Time,LeftEyePos,RightEyePos,BodyPosition,StimulusVelocity,SpatialFrequency,dataOut,idx]= FileReader(filePath,angleOut,cfFilt)
% FileReader(filePath)
%
%%%%% INPUT
%   filePath: the file path to analyse
%%%%% OUTPUT
%   void
if nargin==2
    cfFilt=0;
end
fid=fopen(filePath);
str=[];
for i=1:35
    str=[str,'%f '];
end
C= textscan(fid, str, 'HeaderLines',1);
fclose(fid);


variables= {'Time','LeftEyePos', 'LXPx','LYPx' ,...
    'RightEyePos', 'LXPx','LYPx' , 'BodyPosition', ...
    'BPXPx', 'BPYPx','Shutter', 'Contrast'...
    'SpatialFrequency'  'StimulusVelocity','TemporalFrequency','Mode'...
    'Contrast'};

idx=[1,2,5,8,13,14,11,12,15,16];

for i=1:size(idx,2)
    eval([variables{idx(i)} '= C{idx(i)};']);
end

dataOut=[SpatialFrequency,StimulusVelocity,Shutter,Contrast,TemporalFrequency,Mode];


if  cfFilt>0
    smpf=round(mean(1./diff(Time)));
    [ LeftEyePos ] = LPfiltering( LeftEyePos,smpf,cfFilt,14);
    [ RightEyePos ] = LPfiltering( RightEyePos,smpf,cfFilt,14);
    
    [ BodyPosition ] = LPfiltering( BodyPosition,smpf,1,14);
end

idxOut= (abs(LeftEyePos)>angleOut)|(abs(RightEyePos)>angleOut);
LeftEyePos(idxOut)=NaN;
RightEyePos(idxOut)=NaN;
Time=Time-Time(1,1);
fps=round(median(1./diff(Time)));

end

function [amplSacc,velSacc,timeSacc,freqSacc,idxNew]=saccadeAnalysis(time,pos,vel,idx,maxDuration)

velSacc=nan(size(idx(:,1)));
timeSacc=time(idx(:,2))-time(idx(:,1));
amplSacc=pos(idx(:,2))-pos(idx(:,1));
idxNew=idx;
for k=1:length(idx(:,1))
    
    if timeSacc(k) > maxDuration
        timeSacc(k)=nan;
        amplSacc(k)=nan;
        idxNew(k,:)=nan(1,2);
        continue
    else
        idxSacc=idx(k,1)-1:idx(k,2)+1;
        if idxSacc(1)<1 
            idxSacc(1)=1;
        end
        if idxSacc(end)>length(vel)
            idxSacc(end)=length(vel);
        end
        
        [~,idxMax]=max(abs(vel(idxSacc)));
        velSacc(k)=vel(idxSacc(idxMax));             %vel con segno
    end
end

freqSacc= sum(~isnan(timeSacc))./(time(end)-time(1));


end
