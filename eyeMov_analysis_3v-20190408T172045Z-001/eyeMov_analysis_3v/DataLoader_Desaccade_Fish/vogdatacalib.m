function [coeff]=vogdatacalib(dataraw,calibpoint,laserfile)

if nargin<1
    [name,path]=uigetfile;
    load([path name]);
    dataraw=Data(:,8); %horizzontal eye position uncalibrated
end

if nargin<2
    calibpoint=[30 20 10 0 -10 -20 -30]; %in degree
end
if nargin<3
    laserfile=[];
end

if size(calibpoint,1)==1
    % Calibvalue in degree
    Np= size(calibpoint,2);
    % Np -- Number of Point
    
    h=figure;plot(dataraw)
    kk=0;
    set(gcf,'CurrentCharacter','l')
    for i=1:Np
        set(gca,'Title',text('String',sprintf('Press ''u'' if you want to skipp the point corresponding to %d angle',calibpoint(i))));
        while ~waitforbuttonpress
        end
        if strcmp(get(gcf,'CurrentCharacter'),'u')
            set(gcf,'CurrentCharacter','l');
        else
            set(gca,'Title',text('String',sprintf('Select the beggining and the end of fixation correspondig to %d angle\nZoom the point (if needed) and press enter to activate selection',calibpoint(i))));
            zoom on
            pause
            %             while ~waitforbuttonpress
            %             end
            kk=kk+1;
            [ind]=round(ginput(2));
            vect=ind(1,1):ind(2,1);
            vect=vect(not(isnan(dataraw(vect))));
            calibvalue(kk)=median(dataraw(vect));
            calibpoint_temp(kk)=calibpoint(i);
            zoom out
            hold on
            plot([ind(1,1):ind(2,1)],calibvalue(kk)*ones(size([ind(1,1):ind(2,1)])),'*r')
        end
    end
    calibpoint=calibpoint_temp;
    close(h)
    [coeff]=polyfit(calibvalue,calibpoint,2);
    
else
    radius=min(min(abs(max(dataraw(:,1))-min(dataraw(:,1))),abs(max(dataraw(:,2))-min(dataraw(:,2))))/10,5);
    % Calibvalue in degree
    Np= size(calibpoint,1);
    % Np -- Number of Point
    h=figure;plot(dataraw(:,1),dataraw(:,2),'.')
    horiz_vect1=[];vert_vect1=[];%vectors for possible suggestions from single dimension (only if too difficult)
    set(gcf,'CurrentCharacter','l')
    set(gca,'Title',text('String',sprintf('Press ''x'' if it is too complicate')))
    while ~waitforbuttonpress
    end
    if strcmp(get(gcf,'CurrentCharacter'),'x') % is too complicate, goo back to single axis for suggestion
        set(gcf,'CurrentCharacter','l');
        hh=figure;plot(dataraw(:,1),'b');hold on; plot(dataraw(:,2),'g')
        if ~isempty(laserfile)      
            hold on; plot(laserfile,'r'); hold off;
        end       
        set(gcf,'CurrentCharacter','l')
        for i=1:7
            set(gca,'Title',text('String',sprintf('Press ''u'' if you want to skipp the point corresponding to %d angle',calibpoint(i))));
            while ~waitforbuttonpress
            end
            if strcmp(get(gcf,'CurrentCharacter'),'u')
                set(gcf,'CurrentCharacter','l');
            else
                set(gca,'Title',text('String',sprintf('Select the beggining and the end of fixation correspondig to %d angle\nZoom the point (if needed) and press enter to activate selection',calibpoint(i))));
                %while ~waitforbuttonpress
                %end
                zoom on
                pause
                [ind]=round(ginput(2));
                horiz_vect1=[horiz_vect1; dataraw(ind(1,1):ind(2,1),1)];
                vert_vect1=[vert_vect1; dataraw(ind(1,1):ind(2,1),2)];
                zoom out
            end
        end
        close(hh)
        hold on;
        plot(horiz_vect1,vert_vect1,'*m')
    end
    calibvalue=NaN(size(calibpoint));
    calibAllval=cell(Np,1);
    for i=1:Np
        set(gca,'Title',text('String',sprintf('Press ''u'' if you want to skipp the point corresponding to %d horzontal %d vertical angle',calibpoint(i,1),calibpoint(i,2))));
        while ~waitforbuttonpress
        end
        if strcmp(get(gcf,'CurrentCharacter'),'u')
            set(gcf,'CurrentCharacter','l');
        else
            set(gca,'Title',text('String',sprintf('Select the fixation point corresponding to %d horzontal %d vertical angle\nZoom the point (if needed) and press enter to activate selection',calibpoint(i,1),calibpoint(i,2))));
            %while ~waitforbuttonpress
            %end
            zoom on
            pause
            [ind]=ginput(1);
            horiz_vect=dataraw((dataraw(:,1)>ind(1)-radius & dataraw(:,1)<ind(1)+radius) & (dataraw(:,2)>ind(2)-radius & dataraw(:,2)<ind(2)+radius),1);
            vert_vect=dataraw((dataraw(:,1)>ind(1)-radius & dataraw(:,1)<ind(1)+radius) & (dataraw(:,2)>ind(2)-radius & dataraw(:,2)<ind(2)+radius),2);
            
            calibvalue(i,:)=[nanmedian(horiz_vect) nanmedian(vert_vect)];
            calibAllval{i}=[horiz_vect,vert_vect,ones(size(horiz_vect))*calibpoint(i,:)];
            zoom out
            hold on
            plot(horiz_vect,vert_vect,'*r')
            plot(calibvalue(i,1),calibvalue(i,2),'*g')
        end
    end
    [coeff]=estimateVogCalibGB(calibpoint,calibvalue);
    
    figure;
    plot(calibpoint(:,1),calibpoint(:,2),'or');hold on;
    
    [hCal,vCal]=evalVogCalibGB(calibvalue(:,1),calibvalue(:,2),coeff);
    plot(hCal,vCal,'*b');hold on;
    save('dataCalibCompR.mat','calibAllval','coeff','calibpoint','calibvalue','dataraw')
end
end
