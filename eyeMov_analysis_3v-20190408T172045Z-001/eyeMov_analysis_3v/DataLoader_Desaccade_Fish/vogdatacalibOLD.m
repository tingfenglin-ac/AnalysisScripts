function [coeff]=vogdatacalibOLD(dataraw,calibpoint,laserfile)

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
        hh=figure;plot(dataraw(:,1))
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
    calibvalue=NaN*ones(size(calibpoint));
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
            zoom out
            hold on
            plot(horiz_vect,vert_vect,'*r')
            plot(calibvalue(i,1),calibvalue(i,2),'*g')
        end
    end
    
    
    %ind=[1 7; 2 6; 3 5; 8 10; 11 13];
    %ind_pair=[1 7; 2 6; 3 5; [1 7; 2 6; 3 5;]+7; [1 7; 2 6; 3 5;]+14];
    [coeff]=estimateVogCalibGB(calibpoint,calibvalue);

    % L=length(calibpoint)/3;
    % ind_pair=[];
    % for ij=1:L
    %     ind_pair=[ind_pair; ij ij+L; ij ij+2*L; ij+L ij+2*L];
    % end
    % kk=0;
    % for i=1:length(ind_pair)
    %     if not(isnan(calibvalue(ind_pair(i,1)))) &&  not(isnan(calibvalue(ind_pair(i,2))))
    %         kk=kk+1;
    %         %I add a minus because the rot was wrong, check and try other ways.
    %         alpha(kk)=-atand((calibvalue(ind_pair(i,1),1)-calibvalue(ind_pair(i,2),1))/(calibvalue(ind_pair(i,1),2)-calibvalue(ind_pair(i,2),2)));
    %     end
    % end
    % 
    % alpha=median(alpha);
    % 
    % x=dataraw(:,1);y=dataraw(:,2);
    % x_new=x.*cosd(alpha)+y.*sind(alpha);
    % y_new=-x.*sind(alpha)+y.*cosd(alpha);
    % calibvalue(:,1)=calibvalue(:,1).*cosd(alpha)+calibvalue(:,2).*sind(alpha);
    % calibvalue(:,2)=-calibvalue(:,1).*sind(alpha)+calibvalue(:,2).*cosd(alpha);
    % ind=(not(isnan(calibvalue(:,1))) & not(isnan(calibvalue(:,2))));
    % coeffH = fit2dPolySVD( calibvalue(ind,1), calibvalue(ind,2), calibpoint(ind,1), 2);
    % coeffV = fit2dPolySVD( calibvalue(ind,1), calibvalue(ind,2), calibpoint(ind,2), 2);
    % coeff=[coeffH coeffV [alpha; zeros(5,1)]];
   
    %% Part discarted - was for the interpolation!
    % % %     h_calib= ones(3,1)*[40:-10:-40];
    % %     h_calib= ones(3,1)*[50:-10:-50];
    % % %     v_calib= [10:-10:-10]'*ones(1,9);
    % %     v_calib= [10:-10:-10]'*ones(1,11);
    % %
    % %     %Creating the new mesh for interp
    % %     %horiz
    % %     %h_mat=[NaN NaN NaN calibvalue(8:10,1)' NaN NaN NaN; NaN calibvalue(1:7,1)' NaN ;NaN NaN NaN calibvalue(11:13,1)' NaN NaN NaN;];
    % %     h_mat=[NaN NaN NaN NaN calibvalue(8:10,1)' NaN NaN NaN NaN; NaN NaN calibvalue(1:7,1)' NaN NaN ;NaN NaN NaN NaN calibvalue(11:13,1)' NaN NaN NaN NaN;];
    % %     ord=2;
    % %     %horizontal zero
    % %     X=calibpoint(1:7,1);Y=calibvalue(1:7,1);
    % %     [coeff_temp]=polyfit(X(not(isnan(Y))),Y(not(isnan(Y))),ord);
    % %     h_mat(2,isnan(h_mat(2,:)))=polyval(coeff_temp,h_calib(2,isnan(h_mat(2,:))));
    % %     coeff_temp_ground=coeff_temp;
    % %
    % %     X=calibpoint(8:10,1);Y=calibvalue(8:10,1);
    % %     if sum(isnan(Y))
    % %         coeff_temp=coeff_temp_ground;
    % %     else
    % %         [coeff_temp]=polyfit(X(not(isnan(Y))),Y(not(isnan(Y))),ord);
    % %     end
    % %     h_mat(1,isnan(h_mat(1,:)))=polyval(coeff_temp,h_calib(1,isnan(h_mat(1,:))));
    % %     X=calibpoint(11:13,1);Y=calibvalue(11:13,1);
    % %     if sum(isnan(Y))
    % %         coeff_temp=coeff_temp_ground;
    % %     else
    % %         [coeff_temp]=polyfit(X(not(isnan(Y))),Y(not(isnan(Y))),ord);
    % %     end
    % %     h_mat(3,isnan(h_mat(3,:)))=polyval(coeff_temp,h_calib(3,isnan(h_mat(3,:))));
    % %
    % %
    % %     %vert
    % %     %vertical zero
    % %     %v_mat=[NaN NaN NaN calibvalue(8:10,2)' NaN NaN NaN; NaN calibvalue(1:7,2)' NaN;NaN NaN NaN calibvalue(11:13,2)' NaN NaN NaN;];
    % %     v_mat=[NaN NaN NaN NaN calibvalue(8:10,2)' NaN NaN NaN NaN; NaN NaN calibvalue(1:7,2)' NaN NaN;NaN NaN NaN NaN calibvalue(11:13,2)' NaN NaN NaN NaN;];
    % %     X=calibpoint(1:7,1);Y=calibvalue(1:7,2);
    % %     [coeff_temp]=polyfit(X(not(isnan(Y))),Y(not(isnan(Y))),ord);
    % %     v_mat(2,isnan(v_mat(2,:)))=polyval(coeff_temp,h_calib(2,isnan(v_mat(2,:))));
    % %     coeff_temp_ground=coeff_temp;
    % %     X=calibpoint(8:10,1);Y=calibvalue(8:10,2);
    % %     if sum(isnan(Y))
    % %         coeff_temp=coeff_temp_ground;
    % %         if sum(isnan(Y))<3
    % %             vert_shift=mean(Y(find(not(isnan(Y))))- calibvalue((find(not(isnan(Y))))+2,2));
    % %         else
    % %             return;
    % %         end
    % %         v_mat(1,isnan(v_mat(1,:)))=polyval(coeff_temp,h_calib(1,isnan(v_mat(1,:))))+vert_shift;
    % %     else
    % %         [coeff_temp]=polyfit(X(not(isnan(Y))),Y(not(isnan(Y))),ord);
    % %         v_mat(1,isnan(v_mat(1,:)))=polyval(coeff_temp,h_calib(1,isnan(v_mat(1,:))));
    % %     end
    % %
    % %     X=calibpoint(11:13,1);Y=calibvalue(11:13,2);
    % %      if sum(isnan(Y))
    % %         coeff_temp=coeff_temp_ground;
    % %         if sum(isnan(Y))<3
    % %             vert_shift=mean(Y(find(not(isnan(Y))))- calibvalue((find(not(isnan(Y))))+2,2));
    % %         else
    % %             return;
    % %         end
    % %         v_mat(3,isnan(v_mat(3,:)))=polyval(coeff_temp,h_calib(3,isnan(v_mat(3,:))))+vert_shift;
    % %     else
    % %         [coeff_temp]=polyfit(X(not(isnan(Y))),Y(not(isnan(Y))),ord);
    % %         v_mat(3,isnan(v_mat(3,:)))=polyval(coeff_temp,h_calib(3,isnan(v_mat(3,:))));
    % %     end
    % %
    % %
    % %
    % %
    % % %     [coeff(1,:)]=polyfit(calibvalue(1:7,1),calibpoint(1:7,1),2);
    % % %     [coeff(2,:)]=polyfit(calibvalue(8:10,1),calibpoint(8:10,1),2);
    % % %     [coeff(3,:)]=polyfit(calibvalue(11:13,1),calibpoint(11:13,1),2);
    % % %     [coeff(4,:)]=polyfit(calibvalue([8 3 11],2),calibpoint([8 3 11],2),2);
    % % %     [coeff(5,:)]=polyfit(calibvalue([9 4 12],2),calibpoint([9 4 12],2),2);
    % % %     [coeff(6,:)]=polyfit(calibvalue([10 5 13],2),calibpoint([10 5 13],2),2);
    % % %     [coeff(7,:)]=polyfit(calibvalue(1:7,2),calibvalue(1:7,1),2);
    % %     %coeff=[h_mat;v_mat;  h_calib; v_calib;alpha 0 0 0 0 0 0 0 0];
    % %         coeff=[h_mat;v_mat;  h_calib; v_calib;alpha 0 0 0 0 0 0 0 0 0 0];
    %% End of part discarted
end
end
