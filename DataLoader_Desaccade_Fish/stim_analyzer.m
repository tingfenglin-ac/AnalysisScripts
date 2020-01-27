function stimuluspar=stim_analyzer(data1,data2,chair_vel,speed,smpf)

if nargin<5
    smpf=100;
end

if nargin<4
    speed=60;
end

stimuluspar(4)=length(data1);
stimuluspar(3)=length(data2);

begidx=smpf;
endidx=smpf;
if not(isempty(chair_vel))
    chair_velabs=abs(chair_vel(begidx:end-endidx,:));
    [idx(1),idx(2)]=find_extremes(chair_velabs,speed,smpf,0);
    %adding 900 ms takes into account deceleration of the chair from 90 deg to 0
    %at 100 deg/s^2
    %default for cerebellar patients put idx(end)+begidx+660
    %default for healthy subject idx(end)+begidx+660

else
    sprintf('Chair velocity not found! ')
    idx=[1 1];
end
question=sprintf('Do you want per-rotatoy, post or both?');
answer=questdlg(question,'Per vs post','Per','Post','Both','Both');
if strcmp(answer,'Both')
    idxfit(1)=idx(1)+begidx;
    idxfit(2)=idx(end)+begidx+0.9*smpf;
    stimuluspar=[stimuluspar; stimuluspar]; %create two line of par: 1 per rot par, 2 post rot par
    stimuluspar(1,11)=sign(median(chair_vel(idxfit(1):idxfit(2)))); %rot direction
    stimuluspar(2,11)=-sign(median(chair_vel(idxfit(1):idxfit(2)))); %rot direction
    
    stimuluspar(1,9)=1; %flag for per rot
    stimuluspar(2,9)=2; %flag for post rot
elseif strcmp(answer,'Per')
    idxfit(1)=idx(1)+begidx;
    stimuluspar(1,9)=1; %flag for per rot
     stimuluspar(1,11)=sign(median(chair_vel(idx(1):idx(2))));% rot direction

elseif strcmp(answer,'Post')
    idxfit(1)=idx(end)+begidx+0.9*smpf;
    stimuluspar(1,9)=2; %flag for post rot
    stimuluspar(1,11)=-sign(median(chair_vel(idx(1):idx(2))));%rot direction
end

for zz=1:length(idxfit)

    figure
    plot(data1)
    hold on
    plot([idxfit(zz) idxfit(zz)],[min(data1) max(data1)],'r')
    question=sprintf('Are you satisfied with this onset(vertical red line)?');
    answer=questdlg(question,'Onset point','Yes','No','Yes');
    close
    if strcmp(answer,'Yes')
        stimuluspar(zz,6)=ceil(idxfit(zz));
    else
        %Manual selection of onset
        figure
        plot(data1)
        set(gcf,'CurrentCharacter','c')
        title('Zoom to the ONSET of the  response , than hit a button to end zooming and start the selection')
        zoom on
        while ~waitforbuttonpress
        end
        zoom off
        title ('Click on the response onset (It will be the first point of the EYE-fit)')
        [idxfit(zz),nothing]=ginput(1);
        stimuluspar(zz,6)=ceil(idxfit(zz));
        close
    end
    figure
    plot(data1(stimuluspar(zz,6):end)); answer='No';
%     question=sprintf('Do you want to exclude the initial part of the trace from the fit? (This will NOT change the position of the zero)');
%     answer=questdlg(question,'Skip seconds','Yes','No','No');
%     close
    if strcmp(answer,'No')
        stimuluspar(zz,1)=0;
    else
        %Manual selection of data to skip
        figure
        plot(data1(stimuluspar(zz,6):end))
        set(gcf,'CurrentCharacter','c')
        title('Zoom to the part of interest , than hit a button to end zooming and start the selection')
        zoom on
        while ~waitforbuttonpress
        end
        zoom off
        title ('Click on the end of the part to skip (It will be the first point fitted, NOT THE ZERO)')
        [nsec,nothing]=ginput(1);
        stimuluspar(zz,1)=ceil(nsec);
        close
    end
    
    
    
    figure
    plot(data2(max(stimuluspar(zz,6)-5*smpf,1):end))
    hold on
    if stimuluspar(zz,6)-5*smpf>1
        plot([5*smpf 5*smpf],[min(data2(max(stimuluspar(zz,6)-5*smpf,1):end)) max(data2(max(stimuluspar(zz,6)-5*smpf,1):end))],'r')
    else
        plot([1 1],[min(data2(max(stimuluspar(zz,6)-5*smpf,1):end)) max(data2(max(stimuluspar(zz,6)-5*smpf,1):end))],'r')
    end
    question=sprintf('Are you satisfied with this onset(vertical red line)?');
    answer=questdlg(question,'perception onset point','Yes','No','Yes');
    close
    if strcmp(answer,'Yes')
        stimuluspar(zz,5)=stimuluspar(zz,6);
    else
        figure
        plot(data2(max(stimuluspar(zz,6)-5*smpf,1):end))
        set(gcf,'CurrentCharacter','c')
        title('Zoom to the ONSET of the perception velocity trace , than hit a button to end zooming and start the selection')
        zoom on
        while ~waitforbuttonpress
        end
        zoom off
        title ('Click on the end of the rising of the perception velocity (It will be the first point of the PERC-fit)')
        [idx,nothing]=ginput(1);
        stimuluspar(zz,5)=ceil(idx)+max(stimuluspar(zz,6)-5*smpf,0);
        close
    end


    %Manual selection of perception drop-point
    figure
    plot(data2(stimuluspar(zz,5):end))
    set(gcf,'CurrentCharacter','c')
    title('Zoom to the DROP-ZONE of the response, than hit a button to end zooming and start the selection')
    zoom on
    while ~waitforbuttonpress
    end
    zoom off
    title ('Click on the response DROP point (It will be the end-time of perception fit)')
    [idx,idy]=ginput(1);
    stimuluspar(zz,7)=ceil(idx);
    stimuluspar(zz,8)=0.9*idy;%y value of the drop ok ma il resto del comento ???boh??%median(data2(stimuluspar(5)+stimuluspar(7)-1000:stimuluspar(5)+stimuluspar(7)+1000))
    close
end