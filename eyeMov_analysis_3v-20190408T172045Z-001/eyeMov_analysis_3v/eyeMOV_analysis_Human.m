function data=eyeMOV_analysis_Human()
close all

%if fgInterp=1, the missing data will be filled with linear interpolation
fgInterp=0;

addpath .\DataLoader_Desaccade_Fish\
[fileName,pathName] = uigetfile('*.mat');


out= FileReader([pathName,fileName]);

leye=out.pos_l(:,2); %only hor
reye=out.pos_r(:,2); %only hor
t=out.time;
smpf=out.SamplingRate;


if fgInterp
    leye(isnan(leye))=interp1(t(~isnan(leye)),leye(~isnan(leye)),t(isnan(leye)));
    reye(isnan(reye))=interp1(t(~isnan(reye)),reye(~isnan(reye)),t(isnan(reye)));
end


v_leye=out.vPos_l(:,2);
v_reye=out.vPos_r(:,2);

% v_leye=derivata(leye,1./smpf);
% v_reye=derivata(reye,1./smpf);



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



% cutoff=5.5;
% 
% %h = gengauss(cutoff);
% %h = h/sum(h);
% %leye=filtfilt(h,1,leye);
% %reye=filtfilt(h,1,reye);
% 
% [leye] = gengaussFilterNaN(leye,cutoff);
% [reye] = gengaussFilterNaN(reye,cutoff);



[desaccV_l,desaccT_l,~,~,~,posL]=Interactive_desaccader_2v(v_leye,t,leye); %with 0 the checkbox substract eyePos average uses the whole signal
[desaccV_r,desaccT_r,~,~,~,posR]=Interactive_desaccader_2v(v_reye,t,reye); % StimulusVelocity  the checkbox 'substract eyePos average' uses the first 5min of dark

%If the maxTimsacc>2, it will be cancelled
maxTimeSacc=200;

[data.SaccAmplL,data.SaccVelL,data.SaccTimeL,data.SaccFrqL,data.SaccExtremeIdxL]=saccadeAnalysis(data_leye.rawtime,data_leye.eyepos,data_leye.omega_r,data_leye.saccExtremeIdx,maxTimeSacc);
[data.SaccAmplR,data.SaccVelR,data.SaccTimeR,data.SaccFrqR,data.SaccExtremeIdxR]=saccadeAnalysis(data_reye.rawtime,data_reye.eyepos,data_reye.omega_r,data_reye.saccExtremeIdx,maxTimeSacc);


data.time_l=data_leye.rawtime;
data.time_r=data_reye.rawtime;
data.leye_raw=data_leye.eyepos;
data.reye_raw=data_reye.eyepos;

%figure(1); %check data saccades
%plot(data.time_l,data.leye_raw,'r');
%hold on
%plot(data.time_l(data.SaccExtremeIdxL(:,1)),data.leye_raw(data.SaccExtremeIdxL(:,1)),'.b','markersize',20);
%plot(data.time_l(data.SaccExtremeIdxL(:,2)),data.leye_raw(data.SaccExtremeIdxL(:,2)),'.m','markersize',20);

%figure(2); %plot main sequence
%plot([data.SaccAmplL;data.SaccVelL],[data.SaccAmplR;data.SaccVelR],'.')

save([pathName,fileName(1:end-4),'_TEMP.mat'],'data');
%uisave('data',[pathName,fileName(1:end-4),'.mat']);

end

function out= FileReader(filePath,cfFilt)
% FileReader(filePath)
%
%%%%% INPUT
%   filePath: the file path to analyse
%%%%% OUTPUT
%   void
if nargin==1
    cfFilt=0;
end

r2Deg=@(x) 2*atan(x)*180/pi;

load(filePath);
eval(EvalDataColumns);

out.Condition= Condition;
out.Examination= Examination;
out.SamplingRate=SamplingRate;
out.Subject=Subject;
out.Birthday=Birthday;

out.time=Data(:,col.Time);
out.pos_l=r2Deg(Data(:,[col.LeftEyeVer,col.LeftEyeHor]));
out.pos_r=r2Deg(Data(:,[col.RightEyeVer,col.RightEyeHor]));

out.rPos_l=Data(:,[col.LeftPupilRow,col.LeftPupilCol]);
out.rPos_r=Data(:,[col.RightPupilRow,col.RightPupilCol]);

out.vPos_l=Data(:,[col.LeftEyeVelY,col.LeftEyeVelZ]);
out.vPos_r=Data(:,[col.RightEyeVelY,col.RightEyeVelZ]);


eval(EvalDataColumns);


if  cfFilt>0
    
    out.pos_l = LPfiltering( out.pos_l,SamplingRate,cfFilt,14);
    out.pos_r = LPfiltering( out.pos_r,SamplingRate,cfFilt,14);
    
    out.rPos_l = LPfiltering( out.pos_l,SamplingRate,cfFilt,14);
    out.rPos_r  = LPfiltering( out.pos_r,SamplingRate,cfFilt,14);
end

% idxOut= (abs(LeftEyePos)>50)|(abs(RightEyePos)>50);
% LeftEyePos(idxOut)=NaN;
% RightEyePos(idxOut)=NaN;
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
