function [out] = load_dataFR_OLD(cellfilename, gainfile, nrchans, channels, machine ,referencefilename, undersampling, cut_off, Correspname,CorrespPath)

if nargin<9
    CorrespPath=[];
    Correspname={};
end

pathName=strsplit(referencefilename,'\');

pathName=[strcat(pathName(1:end-1),'\')];
pathName=[pathName{:}];


for i=1:length(cellfilename)
    fname=strsplit(cellfilename{i},'\');
    fname=fname{end};
    if iscell(cellfilename)
        filename=cellfilename{i};
    else
        filename=cellfilename;
    end
    
    if i==1 && machine<3 %--- do it just once and do not for hopkins data
        if nargin < 3 || isempty(nrchans)
            [nrchans] = guess_coil_channels(filename);
            question=sprintf('I''ve counted %d channel recorded. Is it correct?',nrchans);
            answer=questdlg(question,'Default Channels','yes','no','yes');
            if strcmp(answer,'no')
                nrchans=nrchans/2;
            end
        end
    end
    
    %% File loading and channel definition
    % Loading the gain array - gain isa cell array with reye, leye and head
    % gain (eventually some cells will be empty)
    if machine<3 && i==1 && not(isempty(gainfile)) %--- do it just once
        [gain]=load_gain(gainfile);
    end
       
    if machine==3 %hopkins
        par = rexopena(filename(1:end-2));
        alldata= rexreada(par,1,Inf);
    elseif machine<3 %zurich
        smpf=1000;
        alldata = readlv(filename,nrchans,1:nrchans) ; alldata = lvbinary2volt(alldata);
        n = length(alldata) ;
        out(i).time = (0:n-1)/smpf ;
    elseif machine ==4 %Eyesee cam
        load(filename,'Data','EvalDataColumns');
        eval(EvalDataColumns);
        alldata=Data;
        out(i).time=alldata(:,1);
        smpf=median([ 1./median(diff(out(i).time))]);
        clear Data
    end
    
    if i==1 %--- do it just once
        if (nargin < 4) || isempty(channels)
            %             question=sprintf('Do you want to load script-defined channels?');
            %             answer=questdlg(question,'Default Channels','yes','no','yes');
            answer='yes';
            if strcmp(answer,'yes')
                if machine==3 %hopkins
                    channels.RightEyeChannels=[];
                    channels.LeftEyeChannels=[4 2 3 7 5 6 ]; % Hopkins eye channel are Y Z X for directional coil and Y Z X for the torsional, while here is needed X Y Z
                    channels.ChairChannels=[1];
                    channels.LaserChannels=[];
                    channels.OtherChannels=[9];
                elseif machine==2
                    %hexapod tilt-translation
                    channels.RightEyeChannels=[]; % default [2 3 4 5 6 7]; for left eye [8 9 10 11 12 13]
                    channels.LeftEyeChannels=[];% default []
                    channels.ChairChannels=[1 2 3 4 5 6];% default [1 8 9] => if recording both eyes [1 14 15]
                    channels.LaserChannels=[]; %default []
                    channels.OtherChannels=[7 8];%[ 11 12 13 14 ];% default for data recording > Nov 2008 [11 12 13 14];
                elseif machine==1
                    % Chair one eye and 4 other channels
                    channels.RightEyeChannels= [];% [2 3 4 5 6 7]; %for left eye [8 9 10 11 12 13]
                    channels.LeftEyeChannels=[];%[8 9 10 11 12 13];% default []
                    channels.ChairChannels=[1 14 15];%[1 14 15];% default [1 8 9] => if recording both eyes [1 14 15]
                    channels.LaserChannels=[]; %default []
                    channels.OtherChannels=[];%[ 10 11 12 13 ];% default for data recording > Nov 2008 [11 12 13 14];
                    % default for data recording < Nov 2008 (old data) [17]
                end
                
            else
                Channel_selector(nrchans);
            end
        end
    end
    if machine==4
        if not(isempty(Correspname)) %if is not emtphy we use tönnies, if not 3d turntable
            nrchans=5;
            %With EvalDataColumns (---------> to do monocular)
            channels.RightEyeChannels=[col.RightEyeTor, RightPupilRow,col.RightPupilCol];%  Tor, vert, horiz
            channels.RightEyeChannels1=[col.RightEyeTor,col.RightEyeVer,col.RightEyeHor];% Eyeseecam_precalibrated_channel
            channels.LeftEyeChannels=[col.LeftEyeTor, LeftPupilRow,col.LeftPupilCol];% Tor, vert, horiz
            channels.LeftEyeChannels1=[col.LeftEyeTor,col.LeftEyeVer,col.LeftEyeHor];% Eyeseecam_precalibrated_channel
            channels.ChairChannels=[1 2 3];% drum and chair <---- to check
            channels.LaserChannels=[4 5]; %left led central led %[4 5] <-------to check
            channels.OtherChannels=[61 62 63];%% Head inertial vel (roll, pitch, yaw) <--- to check
            alldata2 =readlv_dbl([CorrespPath Correspname{i}],nrchans,1:nrchans);
            %Align the vectors
            u=figure;
            plot(cumsum(alldata(:,channels.OtherChannels(3))-median(alldata(:,channels.OtherChannels(3)))))
            set(gca,'Title',text('String',sprintf('Select the beggining of chair movement (1 deg)' )));
            while ~waitforbuttonpress
            end
            [ind]=round(ginput(1));ind=ind(1);
            close(u)
            out(i).time=out(i).time(ind:end)-out(i).time(ind);
            alldata=alldata(ind:end,:);
            
            u=figure;
            plot(alldata2(:,2))
            set(gca,'Title',text('String',sprintf('Select the beggining of chair movement (1 deg)' )));
            while ~waitforbuttonpress
            end
            [ind2]=round(ginput(1));ind2=ind2(1);
            close(u)
            alldata2=alldata2(ind2:end,:);
        else
            %For 3D turntable
            %EvalDataColumns (---------> to do monocular)
            channels.RightEyeChannels=[col.RightEyeTor, col.RightPupilRow,col.RightPupilCol];%  Tor, vert, horiz
            channels.RightEyeChannels1=[col.RightEyeTor,col.RightEyeVer,col.RightEyeHor];% Eyeseecam_precalibrated_channel
            channels.LeftEyeChannels=[col.LeftEyeTor, col.LeftPupilRow,col.LeftPupilCol];% Tor, vert, horiz
            channels.LeftEyeChannels1=[col.LeftEyeTor,col.LeftEyeVer,col.LeftEyeHor];% Eyeseecam_precalibrated_channel
            
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
            alldata2=alldata;
            
        end
    end
    
    
    %% Start unpacking.
    if not(isempty([channels.RightEyeChannels channels.LeftEyeChannels])) && isempty(gainfile) && (machine<3) %In hopkins and Eyesee cam gains file is loaded automatically
        err=errordlg('You forgot to set the gain file','Gain file needed!!');
        while ishandle(err)
            pause(2)
        end
        return
    end
    
    if(~isempty(channels.ChairChannels))
        switch machine
            case 1 % Chair (3D)
                out(i).chair_pos = alldata(:,channels.ChairChannels)*18; %Convert from +5/-5 V to +180/-180 degrees
            case 2 %exapod
                out(i).chair_pos(:,1:3) = alldata(:,channels.ChairChannels(1:3))./16; %volt to meters
                out(i).chair_pos(:,4:6) = alldata(:,channels.ChairChannels(4:6)).*9./pi; %volt to degrees
            case 3 %Hop chair
                out(i).chair_pos = (((alldata(:,channels.ChairChannels)-min(alldata(:,channels.ChairChannels)))./(max(alldata(:,channels.ChairChannels))-min(alldata(:,channels.ChairChannels))))-0.5)*360; %Convert to +180/-180 degrees
            case 4 %Eyeseecam
                out(i).chair_pos = alldata2(:,channels.ChairChannels)*18; %Convert from +5/-5 V to +180/-180 degrees
        end
        if cut_off>0
            [b,a] = butter(2,cut_off/smpf);
            if not(isempty(Correspname))
                [b,a] = butter(2,cut_off/smpf);
            end
            out(i).chair_pos = filter(b,a,out(i).chair_pos);
        end
        out(i).chair_vel =derivata(out(i).chair_pos,1/smpf); %degrees /s
    else
        [out(i).chair_pos,out(i).chairtime,out(i).chair_vel]=deal(NaN);
    end
    
    if( ~isempty(channels.RightEyeChannels));
        raw.reye_pos = alldata(:,channels.RightEyeChannels); % Voltage
        raw.reye_pos(isnan(alldata(:,channels.RightEyeChannels1)))=NaN; % Voltage
    else
        raw.reye_pos = [];
    end
    if( ~isempty(channels.LeftEyeChannels));
        raw.leye_pos = alldata(:,channels.LeftEyeChannels); %Voltage
        raw.leye_pos(isnan(alldata(:,channels.LeftEyeChannels1)))=NaN; % Voltage
    else
        raw.leye_pos = [];
    end
    if ~isempty(channels.LaserChannels) %Voltage
        if machine==4
            out(i).laser=alldata2(:,channels.LaserChannels);
        else
            out(i).laser=alldata(:,channels.LaserChannels);
        end
    else
        out(i).laser=[];
    end
    if ~isempty(channels.OtherChannels)
        out(i).signals = alldata(:,channels.OtherChannels); %Voltage
    else
        out(i).signals=[];
    end
    
    %% Filter for eye data
    %Default 40 for cerebellar (i.e. [b,a] = butter(2,40/1000)) and 80 for healthy subjects (i.e. [b,a] = butter(2,80/1000))
    if cut_off>0
        [b,a] = butter(2,cut_off/smpf);
    end
    
    %% Reference file loading and calculus of calib values
    if i==1 && not(isempty([channels.LeftEyeChannels channels.RightEyeChannels])) %--- do it just once and if eye data are present
        switch machine
            case {1,2,3}
                if machine==1 || machine==2
                    if (~strcmp(referencefilename, filename) && ~isempty(referencefilename))
                        refdata = readlv(referencefilename, nrchans,[channels.RightEyeChannels channels.LeftEyeChannels]);
                    else
                        refdata = [raw.reye_pos raw.leye_pos];
                    end
                elseif machine==3 %Hopkins
                    if (~strcmp(referencefilename, filename) && ~isempty(referencefilename))
                        par = rexopena(referencefilename(1:end-2));
                        refdata = rexreada(par,1,10000);
                        refdata=refdata(:,[channels.RightEyeChannels channels.LeftEyeChannels]);
                    else
                        refdata = [raw.reye_pos raw.leye_pos];
                    end
                end
                
                time= 1:length(refdata);
                % downsample
                samp =5;
                w = 1:samp:length(refdata);
                
                ptr_cell = seltime(time(w), [refdata(w,:)], ' - Reference point from');
                for x = 1:length(ptr_cell)
                    ref.onset(x) = samp*ptr_cell{x}(1);
                    ref.offset(x) = samp*ptr_cell{x}(end);
                end
                
                % -------------- Calculate the reference position -----------------
                % ... by calculating the median over the selected interval, and
                % when more then one interval selected, by further calculating the
                % means of those medians (!).
                for x =1:length(ref.onset)
                    disp(['Reading reference sample number ', num2str(x)]);
                    want = ref.onset(x):ref.offset(x);
                    mref(x,:) = median(refdata(want,:));
                end
                if x ==1
                    ref.val = mref;
                else
                    ref.val = mean(mref);
                end
                
                if(~isempty(channels.LeftEyeChannels) && ~isempty(channels.RightEyeChannels))
                    ref.reye = ref.val(1:6);
                    ref.leye = ref.val(7:12);
                elseif ~isempty(channels.RightEyeChannels)
                    ref.reye = ref.val;
                else
                    ref.leye = ref.val;
                end
            case 4
                coeff=zeros(3,3);
                load(referencefilename);
                if not(exist('coeffleft')) && not(exist('coeffright'))
                    question=sprintf('How many channels you want to calibrate?');
                    answer=questdlg(question,'Channels','Hor','Vert','Hor+Vert','Hor');
                    
                    if strcmp(answer,'Hor')
                        jend=3;
                    elseif strcmp(answer,'Vert')
                        jend=2;
                    elseif strcmp(answer,'Hor+Vert')
                        jend=1;
                    end
                    
                    %question2=sprintf('Laser support?');
                    %answer2=questdlg(question2,'Laser','Yes','No','No');
                    answer2='No';
                    %Laser file to allign calib
                    if strcmp(answer2,'Yes')
                        alldata2_calib =readlv_dbl([CorrespPath Correspname{end}],nrchans,1:nrchans);
                        
                        %Align the vectors
                        u=figure;
                        plot(cumsum(Data(:,channels.OtherChannels(3))-median(Data(:,channels.OtherChannels(3)))))
                        set(gca,'Title',text('String',sprintf('Select the beggining of chair movement (1 deg)' )));
                        zoom on
                        while ~waitforbuttonpress
                        end
                        [ind]=round(ginput(1));ind=ind(1);
                        zoom off
                        close(u)
                        Data=Data(ind:end,:);
                        
                        u=figure;
                        plot(alldata2_calib(:,2))
                        set(gca,'Title',text('String',sprintf('Select the beggining of chair movement (1 deg)' )));
                        zoom on
                        while ~waitforbuttonpress
                        end
                        [ind2]=round(ginput(1));ind2=ind2(1);
                        zoom off
                        close(u)
                        alldata2_calib=alldata2_calib(ind2:end,:);
                    else
                        alldata2_calib=[];
                    end
                    
                    
                    if( ~isempty(channels.RightEyeChannels))
                        coeffright=zeros(3,3);
                        
                        if jend==2
                            calibpoint=[10 0 -10];
                            dataraw=Data(:,channels.RightEyeChannels(jend));
                            [coeffright(jend,:)]=vogdatacalib(dataraw,calibpoint,alldata2_calib);
                        elseif jend==3
                            if not(isempty(Correspname))
                                calibpoint=[30 20 10 0 -10 -20 -30];
                            else
                                calibpoint=[25 20 10 0 -10 -20 -25];
                            end
                            dataraw=Data(:,channels.RightEyeChannels(jend));
                            [coeffright(jend,:)]=vogdatacalib(dataraw,calibpoint,alldata2_calib);
                        else
                            if not(isempty(Correspname))
                                calibpoint=[[[30 20 10 0 -10 -20 -30]' zeros(7,1)]; [[30 20 10 0 -10 -20 -30]' 10.*ones(7,1)]; [[30 20 10 0 -10 -20 -30]' -10.*ones(7,1)]  ];
                            else
                                calibpoint=[[[25 20 10 0 -10 -20 -25]' zeros(7,1)]; [[25 20 10 0 -10 -20 -25]' 10.*ones(7,1)]; [[25 20 10 0 -10 -20 -25]' -10.*ones(7,1)]  ];
                            end
                            dataraw=[Data(:,channels.RightEyeChannels(jend+2)) Data(:,channels.RightEyeChannels(jend+1))];
                            laserSignals=Data(:,channels.LaserChannels([3,2]));%hor signals;
                            
                            load('laserCal.mat')
                            tempLaser(:,1)=eval2dPoly(laserSignals(:,1),laserSignals(:,2), coeffX);
                            tempLaser(:,2)=eval2dPoly(laserSignals(:,1),laserSignals(:,2), coeffY);    
                            laserSignals=tempLaser;
                            %laserSignals=[mapminmax(laserSignals(:,1)',min(calibpoint(:,1)),max(calibpoint(:,1)))',mapminmax(laserSignals(:,2)',min(calibpoint(:,2)),max(calibpoint(:,2)))'];
                            
                            [coeffright]=vogdatacalib(dataraw,calibpoint,laserSignals);
                            %                             calibpoint=[10 0 -10];
                            %                             dataraw=Data(:,channels.RightEyeChannels(jend+1));
                            %                             [coeffright(jend+1,:)]=vogdatacalib(dataraw,calibpoint,alldata2_calib);
                            %                              calibpoint=[30 20 10 0 -10 -20 -30];
                            %                              dataraw=Data(:,channels.RightEyeChannels(jend+2));
                            %                             [coeffright(jend+2,:)]=vogdatacalib(dataraw,calibpoint,alldata2_calib);
                        end
                        
                        
                        
                        
                    else
                        coeffright=[];
                    end
                    
                    if( ~isempty(channels.LeftEyeChannels))
                        coeffleft=zeros(3,3);
                        
                        if jend==2
                            calibpoint=[10 0 -10];
                            dataraw=Data(:,channels.LeftEyeChannels(jend));
                            [coeffleft(jend,:)]=vogdatacalib(dataraw,calibpoint);
                        elseif jend==3
                            if not(isempty(Correspname))
                                calibpoint=[30 20 10 0 -10 -20 -30];
                            else
                                calibpoint=[25 20 10 0 -10 -20 -25];
                            end
                            dataraw=Data(:,channels.LeftEyeChannels(jend));
                            [coeffleft(jend,:)]=vogdatacalib(dataraw,calibpoint);
                        else
                            if not(isempty(Correspname))
                                calibpoint=[[[30 20 10 0 -10 -20 -30]' zeros(7,1)]; [[30 20 10 0 -10 -20 -30]' 10.*ones(7,1)]; [[30 20 10 0 -10 -20 -30]' -10.*ones(7,1)]  ];
                            else
                                calibpoint=[[[25 20 10 0 -10 -20 -25]' zeros(7,1)]; [[25 20 10 0 -10 -20 -25]' 10.*ones(7,1)]; [[25 20 10 0 -10 -20 -25]' -10.*ones(7,1)]  ];
                            end
                            dataraw=[Data(:,channels.LeftEyeChannels(jend+2)) Data(:,channels.LeftEyeChannels(jend+1))];
                            [coeffleft]=vogdatacalib(dataraw,calibpoint,alldata2_calib);
                            %                             calibpoint=[10 0 -10];
                            %                             dataraw=Data(:,channels.LeftEyeChannels(jend+1));
                            %                             [coeffleft(jend+1,:)]=vogdatacalib(dataraw,calibpoint);
                            %                              calibpoint=[30 20 10 0 -10 -20 -30];
                            %                              dataraw=Data(:,channels.LeftEyeChannels(jend+2));
                            %                             [coeffleft(jend+2,:)]=vogdatacalib(dataraw,calibpoint);
                        end
                        
                    else
                        coeffleft=[];
                    end
                    clear Data
                    question=sprintf('Do you want to save the calibration file? ');
                    answer=questdlg(question,'Saving','Yes','No','No');
                    if strcmp(answer,'Yes')
                        [filename, pathname] = uiputfile({'*.mat','MATLAB Files (*.m,*.fig,*.mat,*.mdl)'; '*.*',  'All Files (*.*)'}, 'Save as',pathName);
                        save([pathname '\' filename],'coeffleft','coeffright');
                    end
                end
                
        end
    end
    
    %% CALIBRATION
    % calibrate left eye
    if machine<4
        if( ~isempty(channels.LeftEyeChannels))
            if machine==3
                currentdir=cd;
                cd(cellfilename{1}(1:find(cellfilename{1}=='\',1,'last')));
                tmprv_l = wraw2rot( raw.leye_pos, ref.leye, 'l', 'room2', 0); % Create the angular vector
                cd(currentdir);
            else
                tmprv_l = bin2rot([ref.leye; raw.leye_pos], gain{2}, 0, 2); % Create the angular vector
            end
            out(i).leye_pos = rot2deg(tmprv_l(2:end,:));
            %out(i).leye_pos = remezfilt(out(i).leye_pos,60,100,1000);
            if cut_off>0
                out(i).leye_pos = filter(b,a,out(i).leye_pos);
            end
            % Calculate the velocity:
            vel_le = savgol(tmprv_l(2:end,:), 2, 7, 1, smpf);
            omega_l = rottoang(tmprv_l(2:end,:), vel_le)*( 180/pi) * 2;
            if cut_off>0
                out(i).leye_vel = filter(b,a,omega_l);
            else
                out(i).leye_vel = omega_l;
            end
            if (isempty(channels.RightEyeChannels))
                out(i).leye_vel=[];
            end
            %out(i).leye_vel =derivata(out(i).leye_pos,1/1000); %degrees /s
        end
        
        
        
        %% calibrate right eye
        if( ~isempty(channels.RightEyeChannels))
            if machine==3
                currentdir=cd;
                cd(cellfilename{1}(1:find(cellfilename{1}=='\',1,'last')));
                tmprv_r = wraw2rot( raw.reye_pos, ref.reye, 'l', 'room2', 0); % Create the angular vector
                cd(currentdir);
            else
                tmprv_r = bin2rot([ref.reye; raw.reye_pos], gain{1}, 0, 2); % Create the angular vector
            end
            out(i).reye_pos = rot2deg(tmprv_r(2:end,:));
            %out(i).reye_pos = remezfilter(out(i).reye_pos,60,100,1000);
            if cut_off>0
                out(i).reye_pos = filter(b,a,out(i).reye_pos);
            end
            % Calculate the velocity:
            vel_re = savgol(tmprv_r(2:end,:), 2, 7, 1, smpf);
            omega_r = rottoang(tmprv_r(2:end,:), vel_re)*( 180/pi) * 2;
            if cut_off>0
                out(i).reye_vel = filter(b,a,omega_r);
            else
                out(i).reye_vel = omega_r;
            end
            if (isempty(channels.LeftEyeChannels))
                out(i).reye_vel=[];
            end
            %out(i).reye_vel =derivata(out(i).reye_pos,1/1000); %degrees /s
        end
    end
    
    %calib eye for eye see cam
    if machine ==4
        clear temp
        %right Eye
        if( ~isempty(channels.RightEyeChannels))
            if size(coeffright)<4
                for j=1:3
                    out(i).reye_pos(:,j)=polyval(coeffright(j,:),raw.reye_pos(:,j));
                end
            else
                [out(i).reye_pos(:,3),out(i).reye_pos(:,2)]=evalVogCalibGB(raw.reye_pos(:,3),raw.reye_pos(:,2),coeffright);
            end
        else
            out(i).reye_pos=[];
        end
        
        %left Eye
        if( ~isempty(channels.LeftEyeChannels))
            if size(coeffleft)<4
                for j=1:3
                    out(i).leye_pos(:,j)=polyval(coeffleft(j,:),raw.leye_pos(:,j));
                end
            else
                [out(i).leye_pos(:,3),out(i).leye_pos(:,2)]=evalVogCalibGB(raw.leye_pos(:,3),raw.leye_pos(:,2),coeffleft);
            end
        else
            out(i).leye_pos=[];
        end
        
        % Cleaning from NaN
        if (isempty(channels.RightEyeChannels))
            NANINDl=find((not(isnan(out(i).leye_pos(:,3)))));
            %This will be use for both filtering and derivative
            temp_leye_pos=interp1(out(i).time(NANINDl),out(i).leye_pos(NANINDl,:),out(i).time);
        elseif (isempty(channels.LeftEyeChannels))
            NANINDr=find((not(isnan(out(i).reye_pos(:,3)))));
            %This will be use for both filtering and derivative
            temp_reye_pos=interp1(out(i).time(NANINDr),out(i).reye_pos(NANINDr,:),out(i).time);
        else
            %             NANIND=find((not(isnan(out(i).leye_pos(:,3))) & not(isnan(out(i).reye_pos(:,3)))));
            NANINDl=find((not(isnan(out(i).leye_pos(:,3)))));
            NANINDr=find((not(isnan(out(i).reye_pos(:,3)))));
            %This will be use for both filtering and derivative
            temp_leye_pos=interp1(out(i).time(NANINDl),out(i).leye_pos(NANINDl,:),out(i).time);
            temp_reye_pos=interp1(out(i).time(NANINDr),out(i).reye_pos(NANINDr,:),out(i).time);
        end
        
        %
        
        
        if cut_off>0
            if( ~isempty(channels.LeftEyeChannels))
                %out(i).leye_pos = medfilt1(,cut_off);
                ind=not(isnan(temp_leye_pos(:,3)));
                out(i).leye_pos(ind,:) = filter(b,a,temp_leye_pos(ind,:));
                temp_leye_pos(ind,:)=out(i).leye_pos(ind,:); %the temp will be use for derivative, so it must be aligned to the leye_pos in case of filtering
            end
            
            if( ~isempty(channels.RightEyeChannels))
                %out(i).reye_pos = medfilt1(temp_reye_pos,cut_off);
                ind=not(isnan(temp_reye_pos(:,3)));
                out(i).reye_pos(ind,:) = filter(b,a,temp_reye_pos(ind,:));
                temp_reye_pos(ind,:)=out(i).reye_pos(ind,:); %the temp will be use for derivative, so it must be aligned to the leye_pos in case of filtering
                
            end
        end
        
        if (isempty(channels.RightEyeChannels))
            ind=not(isnan(temp_leye_pos(:,3)));
            out(i).leye_vel=NaN.*ones(size(out(i).leye_pos));
            out(i).leye_vel(ind,:) =derivata(temp_leye_pos(ind,:),1/smpf); %1/smpf of Eyesee cam is 0.0045
            out(i).leye_pos=out(i).leye_pos(NANINDl,:);
            out(i).leye_vel=out(i).leye_vel(NANINDl,:);
            out(i).reye_pos=[];
            out(i).reye_vel=[];
            out(i).time_r=[];
            out(i).time_l=out(i).time(NANINDl);
            
        elseif( isempty(channels.LeftEyeChannels))
            ind=not(isnan(temp_reye_pos(:,3)));
            out(i).reye_vel=NaN.*ones(size(out(i).reye_pos));
            out(i).reye_vel(ind,:) =derivata(temp_reye_pos(ind,:),1/smpf); %1/smpf of Eyesee cam is 0.0045
            out(i).reye_pos=out(i).reye_pos(NANINDr,:);
            out(i).reye_vel=out(i).reye_vel(NANINDr,:);
            out(i).leye_pos=[];
            out(i).leye_vel=[];
            out(i).time_r=out(i).time(NANINDr);
            out(i).time_l=[]; 
        else
            ind=not(isnan(temp_reye_pos(:,3)));
            out(i).reye_vel=NaN.*ones(size(temp_reye_pos));
            out(i).reye_vel(ind,:) =derivata(temp_reye_pos(ind,:),1/smpf); %1/smpf of Eyesee cam is 0.0045
            ind=not(isnan(temp_leye_pos(:,3)));
            out(i).leye_vel=NaN.*ones(size(temp_leye_pos));
            out(i).leye_vel(ind,:) =derivata(temp_leye_pos(ind,:),1/smpf); %1/smpf of Eyesee cam is 0.0045
            out(i).leye_pos=out(i).leye_pos(NANINDl,:);
            out(i).reye_pos=out(i).reye_pos(NANINDr,:);
            out(i).leye_vel=out(i).leye_vel(NANINDl,:);
            out(i).reye_vel=out(i).reye_vel(NANINDr,:);
            out(i).time_r=out(i).time(NANINDr);
            out(i).time_l=out(i).time(NANINDl);   
            
        end        
    end
    
    if machine<4
        n = length(alldata) ;
        out(i).time = (0:n-1)/smpf ;
    end
    
    
    %% Undersampling
    if undersampling>0
        temprep=[];temprev=[];templep=[];templev=[];
        
        
        
        if machine==4 %in Eyesee cam 1/smpf is 0.0045, to change the smpf, before we change smpf to 1000
            if( ~isempty(channels.RightEyeChannels))
                for z=1:min(size(out(i).reye_pos))
                    temprep(:,z)= interp1(out(i).time_r,out(i).reye_pos(:,z),0:0.001:out(i).time_r(end));
                    temprev(:,z)= interp1(out(i).time_r,out(i).reye_vel(:,z),0:0.001:out(i).time_r(end));
                end
                out(i).reye_pos=temprep;
                out(i).reye_vel=temprev;
                out(i).time_r = 0:0.001:out(i).time_r(end);
                
            end
            
            if( ~isempty(channels.LeftEyeChannels))
                for z=1:min(size(out(i).leye_pos))
                    templep(:,z)= interp1(out(i).time_l,out(i).leye_pos(:,z),0:0.001:out(i).time_l(end));
                    templev(:,z)= interp1(out(i).time_l,out(i).leye_vel(:,z),0:0.001:out(i).time_l(end));
                end
                out(i).leye_pos=templep;
                out(i).leye_vel=templev;
                out(i).time_l = 0:0.001:out(i).time_l(end);
            end
            
            
            if( ~isempty(channels.OtherChannels))
                for z=1:min(size(out(i).signals))
                    tempsign(:,z)= interp1(out(i).time,out(i).signals(:,z),0:0.001:out(i).time(end));
                end
                out(i).signals=tempsign;
            end
            if (isempty(Correspname)) %if is  emtphy we use 3d turntable
                if( ~isempty(channels.LaserChannels))
                    for z=1:min(size(out(i).laser))
                        templas(:,z)= interp1(out(i).time,out(i).laser(:,z),0:0.001:out(i).time(end));
                    end
                    out(i).laser=templas;
                end
                
                if( ~isempty(channels.ChairChannels))
                    for z=1:min(size(out(i).chair_pos))
                        tempchairp(:,z)= interp1(out(i).time,out(i).chair_pos(:,z),0:0.001:out(i).time(end));
                        tempchairv(:,z)= interp1(out(i).time,out(i).chair_vel(:,z),0:0.001:out(i).time(end));
                    end
                    out(i).chair_pos=tempchairp;
                    out(i).chair_vel=tempchairv;
                end
                
            end
            
            
            out(i).time = 0:0.001:out(i).time(end);
            out(i).chairtime = 0:0.001:(length(out(i).chair_pos(:,1))-1)/1000;
            
        end
        clear temprep temprev templep templev tempsign tempchairp tempchairv templas
        temprep=[];temprev=[];templep=[];templev=[];
        tempcp=[];tempcv=[];temps=[];templ=[];
        
        
        
        step=1000/undersampling;
        if( ~isempty(channels.RightEyeChannels))
            for z=1:min(size(out(i).reye_pos))
                temprep(:,z)=out(i).reye_pos(1:step:end,z);
                temprev(:,z)=out(i).reye_vel(1:step:end,z);
            end
            out(i).reye_pos=temprep;
            out(i).reye_vel=temprev;
        end
        
        if( ~isempty(channels.LeftEyeChannels))
            for z=1:min(size(out(i).leye_pos))
                templep(:,z)=out(i).leye_pos(1:step:end,z);
                templev(:,z)=out(i).leye_vel(1:step:end,z);
            end
            out(i).leye_pos=templep;
            out(i).leye_vel=templev;
        end
        if(~isempty(channels.ChairChannels))
            for z=1:min(size(out(i).chair_pos))
                tempcp(:,z)=out(i).chair_pos(1:step:end,z);
                tempcv(:,z)=out(i).chair_vel(1:step:end,z);
            end
            out(i).chair_pos=tempcp;
            out(i).chair_vel=tempcv;
        end
        if ~isempty(channels.OtherChannels)
            for z=1:min(size(out(i).signals,2))
                temps(:,z)=out(i).signals(1:step:end,z);
            end
            out(i).signals=temps;
        end
        
        if ~isempty(channels.LaserChannels)
            for z=1:min(size(out(i).laser,2))
                templ(:,z)=out(i).laser(1:step:end,z);
            end
            out(i).laser=templ;
        end
        
        out(i).time=out(i).time(1:step:end);
        if( ~isempty(channels.RightEyeChannels))
            out(i).time_r=out(i).time_r(1:step:end);
        end
        if( ~isempty(channels.LeftEyeChannels))
            out(i).time_l=out(i).time_l(1:step:end);
        end
        
        if machine==4
            n = length(out(i).chair_pos(:,1)) ;
            out(i).chairtime= (0:n-1)/undersampling;
        end
        % end undersampling.
    else
        %%%%%%%%%%%%%%%%%%
        if machine==4
            out(i).chairtime= buildtime(out(i).chair_pos(:,1), 1./nanmean(diff(out(i).time)));
        end
    end    
    outcell{i}=out(i);
end

if length(outcell)==1
    out=outcell{i};
else
    out=outcell;
end
end
