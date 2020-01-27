function [coeffFit1,coeffFit2,rmse]=vogdatacalibFR(dataraw,calibpoints,laserfile,polyFit,nameEye,smpf)


int=15;
Np= length(calibpoints(:,1)); % Np -- Number of Point
varData=mad(dataraw,1,1);
limAx=[nanmedian(dataraw,1)-5*varData;nanmedian(dataraw,1)+5*varData];

incr=[(abs(limAx)<10).*sign(limAx)*5];
%mod=sqrt(sum((dataraw-ones(size(dataraw,1),1)*nanmean(dataraw,1)).^2,2));
%mod=mod.*[-1*((dataraw(:,1)-nanmean(dataraw(:,1)))<0)+1*((dataraw(:,1)-nanmean(dataraw(:,1)))>=0)];

h=figure('Name',nameEye);
%subplot(3,3,4:6);plot(mod,'m')

%[dataraw] = butterFilterNaN( dataraw,smpf,5);

subplot(3,3,4:9);plot(dataraw); hold on; ylim(limAx(:,1)'); 
if ~isempty(laserfile)
    disp(length(laserfile(:,1))==length(dataraw(:,1)));

    plot(laserfile(:,1),'--k','LineWidth',2);
    plot(laserfile(:,2),'--r','LineWidth',2)
    hold off;
end
subplot(3,3,2);plot(dataraw(:,1),dataraw(:,2),'*b');hold on; axis(limAx(:)'+incr(:)');
figureScreenSize(h,1,1);

[calibvalue,calibpointReal]=deal(nan(Np,2));
selectedPoint=[];

msgbox('Please Adjust Zoom in the figures!')
pause;
for k=1:Np
    
    subplot(3,3,4:9);title({sprintf('Select the Calibration Point at [%d°,%d°][Hor,Vert]',calibpoints(k,1),calibpoints(k,2));'To skip the point press any key on keyboard!'});
    [ind,~,button]=ginput(1);
    if button==1 %i.e. right clik on mouse
        ind=round(ind);
        vect=ind-int:ind+int;
        
        
        selectedPoint=[selectedPoint; dataraw(vect,:)];
        
        calibvalue(k,:)=[nanmedian(dataraw(vect,1)),nanmedian(dataraw(vect,2))];
        calibpointReal(k)=calibpoints(k);
        
        
        subplot(3,3,4:9);hold on;plot(vect,calibvalue(k,1)*ones(size(vect)),'*r')
        subplot(3,3,2);plot(dataraw(vect,1),dataraw(vect,2),'*g',calibvalue(k,1),calibvalue(k,2),'*r');hold on;
        %vline([ind(1),ind(2)],'--k')
    else
        disp(sprintf('Calibration Point at [%d°,%d°][Hor,Vert] has been skipped!',calibpoints(k,1),calibpoints(k,2)))
    end
end


coeffFit1=estimateVogCalibFit(calibpoints,calibvalue,polyFit{1});
coeffFit2=estimateVogCalibFit(calibpoints,calibvalue,polyFit{2});


%Figure 1
hh=figure;
valCal_1=evalVogCalib(calibvalue(:,[2,1]),coeffFit1); %vert, hor
valCal_2=evalVogCalib(calibvalue(:,[2,1]),coeffFit2); %vert, hor

subplot(1,2,1);plot(dataraw(:,1),dataraw(:,2),'*b',selectedPoint(:,1),selectedPoint(:,2),'*r',calibvalue(:,1),calibvalue(:,2),'*y');
subplot(1,2,2);plot(calibpoints(:,1),calibpoints(:,2),'ob',valCal_1(:,2),valCal_1(:,1),'*m',valCal_2(:,2),valCal_2(:,1),'*g'); legend('CalibPoints',polyFit{1},polyFit{2});
figureScreenSize(hh,1,1);
rmse=[nanmean(sqrt(nansum((calibpoints-valCal_1).^2,1))),nanmean(sqrt(nansum((calibpoints-valCal_2).^2,1)))];
subplot(1,2,2);title({'RMSE';[polyFit{1},'(',num2str(rmse(1)),')'];[polyFit{2},'(',num2str(rmse(2)),')']});

%Figure 2
hh1=figure;
valCal_1=evalVogCalib(dataraw(:,[2,1]),coeffFit1); %vert, hor
valCal_2=evalVogCalib(dataraw(:,[2,1]),coeffFit2); %vert, hor
[X,Y]=meshgrid(min(calibvalue(:,1))-15:max(calibvalue(:,1))+15,min(calibvalue(:,2))-5:max(calibvalue(:,2))+5);


mesh_1=evalVogCalib([Y(:),X(:)],coeffFit1); %vert, hor
mesh_2=evalVogCalib([Y(:),X(:)],coeffFit2); %vert, hor
subplot(2,2,1);plot(dataraw(:,1),dataraw(:,2),'*b');hold on;contour(X,Y,reshape(mesh_1(:,2),size(X)),100);axis([min(X(:)),max(X(:)),min(Y(:)),max(Y(:))]);title(polyFit{1});
subplot(2,2,2);plot(valCal_1(:,2),valCal_1(:,1),'*m'); axis([-40 40 -12 12]);
subplot(2,2,3);plot(dataraw(:,1),dataraw(:,2),'*b');hold on;contour(X,Y,reshape(mesh_2(:,2),size(X)),100);axis([min(X(:)),max(X(:)),min(Y(:)),max(Y(:))]);title(polyFit{2});
subplot(2,2,4);plot(valCal_2(:,2),valCal_2(:,1),'*g'); axis([-40 40 -12 12]);
figureScreenSize(hh1,1,1);

%Figure 3
hh2=figure;
subplot(1,2,1);plot3(calibvalue(:,1),calibvalue(:,2),calibpoints(:,1),'ob','MarkerFaceColor','b');hold on;surf(X,Y,reshape(mesh_1(:,2),size(X))); grid on; title(polyFit{1});
subplot(1,2,2);plot3(calibvalue(:,1),calibvalue(:,2),calibpoints(:,1),'ob','MarkerFaceColor','b');hold on;surf(X,Y,reshape(mesh_2(:,2),size(X)));grid on;title(polyFit{2});
figureScreenSize(hh2,1,1);

pause;
close([h,hh,hh1,hh2]);

end


