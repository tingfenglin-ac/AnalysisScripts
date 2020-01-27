function [out] = load_dataFR(cellfilename, referencefilename,polyFit, cut_off,Correspname,CorrespPath)

if nargin<4
    CorrespPath=[];
    Correspname={};
end

if isempty(polyFit)
    polyFit={'poly22','poly32'};
end

pathName=strsplit(referencefilename,'\');
pathName=[strcat(pathName(1:end-1),'\')];
pathName=[pathName{:}];

fg=1;


%close all;
%%% Filter for eye data
%Default 40 for cerebellar (i.e. [b,a] = butter(2,40/1000)) and 80 for healthy subjects (i.e. [b,a] = butter(2,80/1000))

out=struct('chair_pos',{},'chair_vel',{},'chairtime',{},'reye_pos',{},'reye_vel',{},'time_r',{},'leye_pos',{},'leye_vel',{},'time_l',{},'laser',{},'signals',{});
outcell=cell(size(cellfilename));
for i=1:length(cellfilename)
    fname=strsplit(cellfilename{i},'\');
    fname=fname{end};
    if iscell(cellfilename)
        filename=cellfilename{i};
    else
        filename=cellfilename;
    end
    
    %%% File loading and channel definition
    % Loading the gain array - gain isa cell array with reye, leye and head
    % gain (eventually some cells will be empty)
    load(filename,'Data','EvalDataColumns');
    eval(EvalDataColumns);
    alldata=Data;
    out(i).time=alldata(:,1);
    smpf=nanmedian(1./diff(out(i).time));
    
    clear Data
    
    if not(isempty(Correspname)) %if is not emtphy we use tönnies, if not 3d turntable
        nrchans=5;
        %FoR tönnies
        channels=read_ADChannels(col,'1DT',fname); %With EvalDataColumns (---------> to do monocular)
        [alldata,alldata2,out(i).time]=alignVectorsTonies(alldata,out(i).time,[CorrespPath,Correspname{i}],nrchans,channels);
    else
        %For 3D turntable
        channels=read_ADChannels(col,'3DT',fname);%EvalDataColumns (---------> to do monocular)
        alldata2=alldata;
    end
    
    %%% Start unpacking.
    [out(i),raw]=unpackData(out(i),alldata,alldata2,channels,smpf);
    
    %%% Estimate Calibration Matrix
    if i==1 && not(isempty([channels.LeftEyeChannels,channels.RightEyeChannels])) %--- do it just once and if eye data are present
        calibDataFile=load(referencefilename);
        if isfield(calibDataFile,'coeffleft1') && isfield(calibDataFile,'coeffright1')
            coeffright1=calibDataFile.coeffright1;
            coeffleft1=calibDataFile.coeffleft1;
            rmseR=calibDataFile.rmseR;
            rmseL=calibDataFile.rmseL;
            if isfield(calibDataFile,'coeffleft2') && isfield(calibDataFile,'coeffright2')
                coeffright2=calibDataFile.coeffright2;
                coeffleft2=calibDataFile.coeffleft2;
            else
                coeffright2=[];rmseR=0;
                coeffleft2=[];rmseL=0;
            end
        else
            [coeffright1,coeffright2,rmseR]=computeCalib(channels,'RightEyeChannels',calibDataFile.Data,~isempty(Correspname),polyFit,smpf);
            [coeffleft1,coeffleft2,rmseL]=computeCalib(channels,'LeftEyeChannels',calibDataFile.Data,~isempty(Correspname),polyFit,smpf);
            
            answer=questdlg('Do you want to save the calibration file? ','Saving','Yes','No','Yes');
            if strcmp(answer,'Yes')
                [filename, pathname] = uiputfile({'*.mat','MATLAB Files (*.m,*.fig,*.mat,*.mdl)'; '*.*',  'All Files (*.*)'}, 'Save as',pathName);
                save([pathname '\' filename],'coeffleft1','coeffright1','coeffleft2','coeffright2','rmseR','rmseL');
            else
                save('tempCalib.mat','coeffleft1','coeffright1','coeffleft2','coeffright2','rmseR','rmseL');
            end
            
            
        end
        clear calibFile
    end
    
    %%% CALIBRATION raw Data
    out(i)=calibEyePos('RightEyeChannels',channels,coeffright1,coeffright2,out(i),raw,smpf,polyFit,cut_off,fg,rmseR); %i==1 selction function calib for first trial only
    out(i)=calibEyePos('LeftEyeChannels',channels,coeffleft1,coeffleft2,out(i),raw,smpf,polyFit,cut_off,fg,rmseL);
    
    %figure;plot(out(i).time_l*ones(1,3),out(i).leye_pos);hold on, plot(out(i).time_r*ones(1,3),out(i).reye_pos);
    %figure;plot([raw.leye_pos]);hold on, plot(raw.reye_pos);
    outcell{i}=out(i);
end

if length(outcell)==1
    out=outcell{1};
else
    out=outcell;
end
end


function channels=read_ADChannels(col,type,fname)

if sum(isfield(col,{'RightPupilRow','RightPupilCol'}))<2
    [channels.RightEyeChannels,channels.RightEyeChannels1]=deal([]);
else
    channels.RightEyeChannels=[col.RightEyeTor,col.RightPupilRow,col.RightPupilCol];%  Tor, vert, horiz
    channels.RightEyeChannels1=[col.RightEyeTor,col.RightEyeVer,col.RightEyeHor];% Eyeseecam_precalibrated_channel
    channels.timeR=col.RightTime;
end

if sum(isfield(col,{'LeftPupilRow','LeftPupilCol'}))<2
    [channels.LeftEyeChannels,channels.LeftEyeChannels1,channels.timeL]=deal([]);
else
    channels.LeftEyeChannels=[col.LeftEyeTor, col.LeftPupilRow,col.LeftPupilCol];% Tor, vert, horiz
    channels.LeftEyeChannels1=[col.LeftEyeTor,col.LeftEyeVer,col.LeftEyeHor];% Eyeseecam_precalibrated_channel
    channels.timeL=col.LeftTime;
end

switch type
    case '3DT'
        noADC=[];
        if sum(isfield(col,{'ADChannel5','ADChannel4','ADChannel3'}))<3
            channels.ChairChannels=[];
            channels.OtherChannels=[];
            noADC=[noADC,'ChairChannels, '];
        else
            channels.ChairChannels=[col.ADChannel5,col.ADChannel4,col.ADChannel3];%
            channels.OtherChannels=[col.ADChannel5];%[75 76 77];%[62]; Head inertial vel (roll, pitch, yaw)
        end
        if sum(isfield(col,{'ADChannel2','ADChannel1','ADChannel0','ADChannel6'}))<4
            channels.LaserChannels=[];
            noADC=[noADC,'LaserChannels'];
        else
            channels.LaserChannels=[col.ADChannel2,col.ADChannel1,col.ADChannel0,col.ADChannel6]; % LAser + left  Led
        end
        
        if ~isempty(noADC);
            disp(['No 3Dturntable ADChannels (',noADC,') were plugged during the recording (',fname,')!']);
        end
    case '1DT'
        channels.ChairChannels=[1 2 3];% drum and chair <---- to check
        channels.LaserChannels=[4 5]; %left led central led %[4 5] <-------to check
        channels.OtherChannels=[61 62 63];%% Head inertial vel (roll, pitch, yaw) <--- to check
end

end

function  [alldata,alldata2,t]=alignVectorsTonies(alldata,t,CorrespPath,nrchans,channels)

alldata2 =readlv_dbl(CorrespPath,nrchans,1:nrchans);
%Align the vectors
u=figure;
plot(cumsum(alldata(:,channels.OtherChannels(3))-median(alldata(:,channels.OtherChannels(3))))); helpdlg('Select the beggining of chair movement (1 deg)');
while ~waitforbuttonpress
end
[ind]=round(ginput(1));ind=ind(1);  close(u)
t=t(ind:end)-t(ind);
alldata=alldata(ind:end,:);

u=figure;
plot(alldata2(:,2));helpdlg('Select the beggining of chair movement (1 deg)');
while ~waitforbuttonpress
end
[ind2]=round(ginput(1));ind2=ind2(1); close(u)
alldata2=alldata2(ind2:end,:);
end

function [out,raw]=unpackData(out,alldata,alldata2,channels,smpf)

%chair
if(~isempty(channels.ChairChannels))
    out.chair_pos = alldata2(:,channels.ChairChannels)*18; %Convert from +5/-5 V to +180/-180 degrees
    %filter Chair signal at 10HZ
    [b,a] = butter(2,10/smpf);
    out.chair_pos = filtfilt(b,a,out.chair_pos);
    out.chair_vel =derivata(out.chair_pos,1/smpf); %degrees /s
    out.chairtime= buildtime(out.chair_pos(:,1), 1./smpf);
end

%right Eye
if( ~isempty(channels.RightEyeChannels));
    raw.reye_pos = alldata(:,channels.RightEyeChannels); % Voltage
    raw.reye_pos(isnan(alldata(:,channels.RightEyeChannels1)))=NaN; % Voltage
    out.time_r=alldata(:, channels.timeR);
else
    raw.reye_pos = [];
end

%left eye
if( ~isempty(channels.LeftEyeChannels));
    raw.leye_pos = alldata(:,channels.LeftEyeChannels); %Voltage
    raw.leye_pos(isnan(alldata(:,channels.LeftEyeChannels1)))=NaN; % Voltage
    out.time_l=alldata(:, channels.timeL);
else
    raw.leye_pos = [];
end

%laser
if ~isempty(channels.LaserChannels) %Voltage
    out.laser=alldata2(:,channels.LaserChannels);
else
    out.laser=[];
end
if ~isempty(channels.OtherChannels)
    out.signals = alldata(:,channels.OtherChannels); %Voltage
else
    out.signals=[];
end

end

function [coeff1,coeff2,rmse]=computeCalib(channels,nameEye,Data,fg,polyFit,smpf)

%alldata2_calib=[];

if ~isempty(channels.LaserChannels)
    load('laserCal.mat')
    laserSignals=Data(:,channels.LaserChannels([3,2]));%hor signals;
    tempLaser(:,1)=eval2dPoly(laserSignals(:,1),laserSignals(:,2), coeffX);
    tempLaser(:,2)=eval2dPoly(laserSignals(:,1),laserSignals(:,2), coeffY);
    laserSignals=tempLaser;
else
    laserSignals=[];
end



if fg
    [y,x]=meshgrid(-10:10:10,-30:10:30);
else
    [y,x]=meshgrid(-10:10:10,[-25,-20:10:20,25]);
    %[y,x]=meshgrid(-10:10:10,-20:10:20);
end
idx=find(x(:,1)==0);
x=-1*[x(idx:end,:);flipud(x(1:idx-1,:))];
calibpoints(:,1)= x(:); %horizontal
calibpoints(:,2)= [y(:,2);y(:,1);y(:,3)]; %vertical points

if( ~isempty(channels.(nameEye)))
    dataraw=Data(:,channels.(nameEye)([3,2])); %hor+vert
    [coeff1,coeff2,rmse]=vogdatacalibFR(dataraw,calibpoints,laserSignals,polyFit,nameEye,smpf);
else
    [coeff1,coeff2]=deal([]);
    errordlg(['No ', nameEye, 'found! Data are not calibrated']);
end
end

function [out]=calibEyePos(nameEye,channels,coeffCalib1,coeffCalib2,out,raw,smpf,polyFit,cut_off,fg,rmse)


%right Eye

%horizontal =3, vertical=2

eyeN=lower(nameEye(1));
if ~isempty(channels.(nameEye))
    
    temp1=evalVogCalib(raw.([eyeN,'eye_pos'])(:,2:3),coeffCalib1); 
    temp2=evalVogCalib(raw.([eyeN,'eye_pos'])(:,2:3),coeffCalib2);
    
    
    h=figure('Name',nameEye); figureScreenSize(h,1,1)
    subplot(3,1,1);plot(temp1); hline([-20,20,-40,40],'--k'); ylim([-41,41]); title(polyFit{1}); 
    

    subplot(3,1,2);plot(temp2); hline([-20,20,-40,40],'--k'); ylim([-41,41]); title(polyFit{2});hold on;
    
    if ~isempty(out.chair_pos)
        subplot(3,1,1); hold on;plot([mapminmax(out.chair_pos(:,[1 3])'*-1,20,-40)]');
        subplot(3,1,2);hold on;plot([mapminmax(out.chair_pos(:,[1 3])'*-1,20,-40)]');
    end
    
    subplot(3,1,3),plot(raw.([eyeN,'eye_pos'])(:,2:3)); hline([-20,20,-40,40],'--k'); title('Raw')
    
    
    hh=figure; 
    subplot(2,1,1);plot(sqrt((sum(temp1,2).^2)).*[-1*(temp2(:,2)<0)+1*(temp2(:,2)>=0)]);
    hline([-20,20,-40,40],'--k'); title(polyFit{1})
    subplot(2,1,2);plot(sqrt((sum(temp2,2).^2)).*[-1*(temp2(:,2)<0)+1*(temp2(:,2)>=0)]);
    hline([-20,20,-40,40],'--k'); title(polyFit{2})
     
    hh1=figure; figureScreenSize(hh1,1,1)
    subplot(2,2,1),plot(temp1(:,2),temp1(:,1),'*g'); axis([-45,45,-20,20,]); title(polyFit{1}); vline([-40,40],'--');
    subplot(2,2,2),plot(temp2(:,2),temp2(:,1),'*m'); axis([-45,45,-20,20,]); title(polyFit{2});vline([-40,40],'--');
    subplot(2,2,3),plot(raw.([eyeN,'eye_pos'])(:,3),raw.([eyeN,'eye_pos'])(:,2),'*b'); title('Raw')
    
    pause;
    
    if fg
        answer=questdlg('Select Calibration Method','Select Calib',[polyFit{1},'(',num2str(rmse(1)),')'],[polyFit{2},'(',num2str(rmse(2)),')'],[polyFit{1},'(',num2str(rmse(1)),')']);
        if strcmpi(answer,[polyFit{1},'(',num2str(rmse(1)),')'])
            out.([eyeN,'eye_pos'])(:,2:3)=temp1;
        else
            out.([eyeN,'eye_pos'])(:,2:3)=temp2;
        end
    end
    
    % Cleaning from NaN and Interp Data
    notNanIdx=find(~isnan(out.([eyeN,'eye_pos'])(:,3)));
    temp=interp1(out.(['time_',eyeN])(notNanIdx),out.([eyeN,'eye_pos'])(notNanIdx,:),out.(['time_',eyeN]));  %This will be use for both filtering and derivative
    
    if cut_off>0
        ind_Temp=not(isnan(temp(:,3)));
        [b,a] = butter(2,cutout/smpf);
        out.([eyeN,'eye_pos'])(ind_Temp,:) =  filtfilt(b,a,temp(ind_Temp,:));
        temp(ind_Temp,:)=out.([eyeN,'eye_pos'])(ind_Temp,:); %the temp will be use for derivative, so it must be aligned to the leye_pos in case of filtering
    end
    
    ind_Temp=not(isnan(temp(:,3))); %check again nan
    out.([eyeN,'eye_vel'])=NaN(size(out.([eyeN,'eye_pos'])));
    out.([eyeN,'eye_vel'])(ind_Temp,:)= derivata(temp(ind_Temp,:),1/smpf); %1/smpf of Eyesee cam is 0.0045
    out.([eyeN,'eye_vel'])= out.([eyeN,'eye_vel'])(notNanIdx,:); %remove interp data
    
    out.([eyeN,'eye_pos'])=out.([eyeN,'eye_pos'])(notNanIdx,:); %remove interp data
    out.(['time_',eyeN])=out.(['time_',eyeN])(notNanIdx); %remove interp data
else
    [out.([eyeN,'eye_pos']),out.([eyeN,'eye_vel']),out.(['time_',eyeN])]=deal([]);
end


    close([h,hh,hh1]);
end
