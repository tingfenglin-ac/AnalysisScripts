function stimuluspar=Onsetfinder(data1,chair_vel,time,speed,smpf)

%OUTPUT
%Stimuluspar 1) length (in points); 2) direction of rotation (pos or negative) 3) stimulus onset (in points), 4)endtime (in points) 5) 1 per rot, 2 post rot
if nargin<5
    smpf=100;
end

if nargin<4
    speed=90;
end
if nargin<3
time=1:length(data1);
end

stimuluspar(1)=length(chair_vel);

begidx=smpf;
endidx=smpf;
if not(isempty(chair_vel))
    chair_velabs=abs(chair_vel(begidx:end-endidx,:));
    [idx(1),idx(2)]=find_extremes(chair_velabs,speed,smpf,0);
    idx=idx+begidx; %begidx is needed to avoid singularity at the beginning
    %adding 900 ms takes into account deceleration of the chair from 90 deg to 0
    %at 100 deg/s^2
  

else
    sprintf('Chair velocity not found! ')
    idx=[1 1];
end

% idx(1)=(find(time>idx(1),1,'first'));
% idx(2)=(find(time>idx(2),1,'first'));

question=sprintf('Do you want per-rotatoy, post or both?');
answer=questdlg(question,'Per vs post','Per','Post','Both','Both');
if strcmp(answer,'Both')
    idxfit(1)=idx(1);
    idxfit(2)=idx(end);
    stimuluspar=[stimuluspar; stimuluspar]; %create two line of par: 1 per rot par, 2 post rot par
    stimuluspar(1,2)=sign(chair_vel(idxfit(1))); %rot direction
    stimuluspar(2,2)=-sign(chair_vel(idxfit(1))); %rot direction
    
    stimuluspar(1,5)=1; %flag for per rot
    stimuluspar(2,5)=2; %flag for post rot
elseif strcmp(answer,'Per')
    idxfit(1)=idx(1);
    stimuluspar(1,5)=1; %flag for per rot
     stimuluspar(1,2)=sign(chair_vel(idxfit(1)));% rot direction

elseif strcmp(answer,'Post')
    idxfit(1)=idx(end);
    stimuluspar(1,5)=2; %flag for post rot
    stimuluspar(1,2)=-sign(mean(chair_vel(idxfit(1)-smpf:idxfit(1)+smpf)));%rot direction
end

for zz=1:length(idxfit)

    figure
    plot(time,data1,'.')
    hold on
    plot([idxfit(zz)/smpf idxfit(zz)/smpf],[min(data1) max(data1)],'r')
    question=sprintf('Are you satisfied with this onset(vertical red line)?');
    answer=questdlg(question,'Onset point','Yes','No','Yes');
    close
    if strcmp(answer,'Yes')
        stimuluspar(zz,3)=ceil(idxfit(zz));
       
    else
        %Manual selection of onset
        figure
        plot(time,data1)
        set(gcf,'CurrentCharacter','c')
        title('Zoom to the ONSET of the  response , than hit a button to end zooming and start the selection')
        zoom on
        while ~waitforbuttonpress
        end
        zoom off
        title ('Click on the response onset (It will be the first point of the EYE-fit)')
        [idxfit(zz),nothing]=ginput(1);
        stimuluspar(zz,3)=ceil(idxfit(zz)*smpf);
        close
    end
    %setting end point of trace
     if zz==2 %second line in stimuluspar --> per and post and working on post
            stimuluspar(zz,3)=ceil(idxfit(zz));
            %stimuluspar(zz-1,4)=stimuluspar(zz,3)-smpf; % perrot end point set 1 second befor onset of postrot
            stimuluspar(zz,4)=stimuluspar(zz,1)-smpf; % postrot end point set at the end of the trace
     elseif stimuluspar(zz,5)==1%per rot
         figure
         plot(time,data1,'.')
         hold on
         plot([(idxfit(2)/smpf)-1 (idxfit(2)/smpf)-1],[min(data1) max(data1)],'r')
         question=sprintf('Are you satisfied with this endpoint for the perrot (vertical red line)?');
         answer=questdlg(question,'End point','Yes','No','Yes');
         close
         if strcmp(answer,'Yes')
            stimuluspar(zz,4)=ceil(idxfit(zz)-smpf);
         else
             %Manual selection of onset
             figure
             plot(time,data1)
             set(gcf,'CurrentCharacter','c')
             title('Zoom to the ENDPOINT of the per rot response , than hit a button to end zooming and start the selection')
             zoom on
             while ~waitforbuttonpress
             end
             zoom off
             title ('Click on the response ENDPOINT for per rot')
             [idxfit(2),nothing]=ginput(1);
             stimuluspar(zz,4)=ceil(idxfit(2)*smpf);
             close
         end
         
     elseif stimuluspar(zz,5)==2 %post rot
          stimuluspar(zz,4)=stimuluspar(zz,1)-smpf; % postrot end point set at the end of the trace
     end
%     figure
%     plot(data1(stimuluspar(zz,3):end))
%     question=sprintf('Do you want to exclude the initial part of the trace from the fit? (This will NOT change the position of the zero)');
%     answer=questdlg(question,'Skip seconds','Yes','No','No');
%     close
%     if strcmp(answer,'No')
%         stimuluspar(zz,1)=0;
%     else
%         %Manual selection of data to skip
%         figure
%         plot(data1(stimuluspar(zz,6):end))
%         set(gcf,'CurrentCharacter','c')
%         title('Zoom to the part of interest , than hit a button to end zooming and start the selection')
%         zoom on
%         while ~waitforbuttonpress
%         end
%         zoom off
%         title ('Click on the end of the part to skip (It will be the first point fitted, NOT THE ZERO)')
%         [nsec,nothing]=ginput(1);
%         stimuluspar(zz,1)=ceil(nsec);
%         close
end
    
    
   