function [out,varargout]=select_data(data,derdata,smpf,versverg,varargin)
%function out=select_data(data,derdata,smpf,versverg,varargin)
%Interactively select indices of events (e.g. saccades) from a signal
%data contains position channels and derdata its derivative
%if versverg==1 computes mean (vers) and difference (verg) of the two
%channels
%Invoked by prepare_data
%Presents a dialog to select file name for saving data
%To stop interactive analysis select STOP when asked to confirm selection
%of indices.

%% Initialize: verify function arguments
if nargin< 3
    smpf=1000;
end

if nargin<4
    versverg=1; %Default to display version and vergence
end

if nargin<5 %Fifth argument are indices for showing a specific portion of data
    interval_indices=[1 size(data,1)];
else
    interval_indices=varargin{1};
    if isempty(interval_indices)
        interval_indices=[1 size(data,1)];
    end
end

if nargin>=6
    indices=varargin{2};
else
    indices=[];
end

if nargin>7 %If there are more input arguments then it is the right and left eye vertical components
    revert=varargin{3};
    levert=varargin{4};
    versvert=(revert+levert)/2;
else
    versvert=[];
end
close all

t=buildtime(data(:,1),smpf);
figh=figure;
ordr=20;
sampint=1/smpf;

%% Selection of plot type - Always two channels
if versverg==1 %Work on version and vergence
    vers=(data(:,1)+data(:,2))/2;
    versv=derivata(vers,sampint);
%     versv=remezf([90 120],[1 .001],smpf,versv,ordr);
    verg=(data(:,2)-data(:,1));
    vergv=derivata(verg,sampint);
%     vergv=remezf([90 120],[1 .001],smpf,vergv,ordr)
end

if ~isempty(versvert)
    versvertv=derivata(versvert,sampint);
%     versvertv=remezf([90 120],[1 .001],smpf,versvertv,ordr);
end
%versacc=derivata(versvel,sampint);
%vergacc=derivata(vergvel,sampint);


%% PLOT DATA

scrsize=get(0,'ScreenSize');
set(figh,'Position',scrsize*.95);
%Version and vergence
if versverg==1 %Plot horizontal version and vergence
    if isempty(versvert) %No vertical: top plot is version and vergence vel; bottom is vers and verg
        subplot(2,1,1), plot(t,versvel,t,vergvel);
        legend('Version velocity','Vergence velocity')
        axh=gca;

        subplot(2,1,2),plot(t,vers,t,verg);
        legend('Version','Vergence');
        %set(gca,'Xlim',[t(indices(1)) Inf])
    else               %vertical: top plot is version, vergence and vertical vel; bottom is vers, verg and vert
        subplot(2,1,1), plot(t,versvel,t,vergvel,t,versvertv);
        legend('Version velocity','Vergence velocity','Vertical vers. vel.')
        axh=gca;
        subplot(2,1,2),plot(t,vers,t,verg,t,versvert);
        legend('Version','Vergence','Vertical vers');
    end
else
    %General plot - No version/vergence
    if isempty(versvert) %General case
        %Top panel: velocities
        subplot(2,1,1)
        %Build plotting instruction for variable number of channels
        txt='plot(t,derdata(:,1)';
        legtxt={'1'};
        for j=2:size(derdata,2)
            txt=[txt ',t,derdata(:,' num2str(j) ')'];
            legtxt={legtxt{:} num2str(j)};
        end
        txt=[txt ')'];
        eval(txt)
        legend('Right eye velocity','Left eye velocity')
        %Thicker lines for presentations
        %         childs=allchild(gca);
        %         for ik=1:length(childs)
        %             if get(childs(ik),'type')=='line'
        %                 set(childs(ik),'linewidth',2)
        %             end
        %         end

        %if we have previous indices, show them
        if ~isempty(indices)
            hold on
            plot(t(indices(:,1)),derdata(indices(:,1),1),'m+',t(indices(:,2)),derdata(indices(:,2),1),'k+')
        end
        axh=gca;

        %Bottom panel: positions
        subplot(2,1,2)
        %Build plotting instruction for variable number of channels
        txt='plot(t,data(:,1)';
        for j=2:size(data,2)
            txt=[txt ',t,data(:,' num2str(j) ')'];
        end
        txt=[txt ')'];
        eval(txt)
        %Thicker lines for presentations
        %         childs=allchild(gca);
        %         for ik=1:length(childs)
        %             if get(childs(ik),'type')=='line'
        %                 set(childs(ik),'linewidth',2)
        %             end
        %         end

        legend(legtxt);
        %set(gca,'Xlim',[t(indices(1)) Inf])
    else %VERTICAL
        subplot(2,1,1), plot(t,c1v,t,c2v,t,versvertv);
        legend('Right eye velocity','Left eye velocity','Vertical vers. vel.')
        axh=gca;
        subplot(2,1,2),plot(t,c1v,t,c2v,t,versvert);
        legend('Right eye','Left eye','Vertical vers');
    end
end
ax1=gca;
set(axh,'ylim',[-600 600]); %Limit Y axis to 600 on velocity plot (velocity data may present spikes)
figure(figh)

%% GET INDICES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

while 1
    %Get the indices required
    %Function at the bottom of this program. Allows
    %zooming in on the data on both windows simultaneously
    idx=ceil(getindicesbox(gcf,axh,smpf,ax1,size(data,2))); %Get the indices interactively

    disp(sprintf('Selected %5.3f to %5.3f',idx/smpf))

    %Show selected indices on top panel
    figure(figh)
    subplot(2,1,1)
    hold on
    plot([t(idx(1)) t(idx(2))],[derdata(idx(1),1) derdata(idx(2),1)],'r+')

    answer=questdlg('Keep this trial?','Save data','Yes','No','Stop','No'); %Save in structure

    if strcmp(answer,'Yes')
        disp(['Accept: ' num2str(idx)])
        indices=[indices; idx];
        %            fitparms=[fitparms; a f ph];
        dstr.indices=indices;
        %         dstr.fitparms=fitparms;
        assignin('base','dstr',dstr); %'publish' data in workspace in case of errors
    elseif strcmp(answer,'Stop')    %Stop analysis - does not add the last trial
        %out=dstr;   %Return structure (contains also the data
        savestr=dstr;   %Structure to be saved

        %savestr=rmfield(savestr,'data') %Remove data field from structure to save

        if strcmp(questdlg('Save data to file?','Saccadic oscillations','Yes','No','Cancel','Yes'),'Yes') %Save to file
            s=inputdlg('Enter file name, no extension','Saccadic oscillations',1,{'selected'});
            eval([lower(s{1}) '=savestr;']);
            eval(['save ' lower(s{1}) '.mat '  lower(s{1})])
        end
        break
    end
end

if nargout>1    %With more than one output, return the modified structure as the second output
    dstruct.smpf=smpf;
    if versverg~=1
        dstruct.data=data;
        dstruct.derdata=derdata;
        dstruct.idxs=savestr;
    else
        dstruct.vers=vers;
        dstruct.verg=verg;
        dstruct.versv=versvel;
        dstruct.vergv=vergvel;
    end
    if ~isempty(versvert)
        dstruct.vertv=versvertv;
    end
    varargout{1}=dstruct;   %It allows to retrieve the version and vergence velocities
end
out=indices;  %Return the selected indices
return

%% Interactive selection
function out=getindicesbox(fighandle,axhandle,smpf,varargin)
%If a 3rd argument is provided as a axis handle,
%the second axis is synchronized with the first when zooming
%The second varargin indicates the number of channels


axes(axhandle)
set(fighandle,'buttondownfcn','mousehandler')
zoom on

%set(gca,'XLimMode','auto')
title('Hit enter when done zooming')
while ~waitforbuttonpress
    xl=get(axhandle,'Xlim');
    if ~isempty(varargin)
        set(varargin{1},'Xlim',xl); %Synchronize the provided axis handle (the position plot)
    end
end
zoom off
axes(axhandle)
title('Select the desired interval for the X coordinate')
%Box selection
%lim=getidx(fighandle,axhandle); %graphically select indices of portions
%
child=get(axhandle,'children');

viewidxs=get(axhandle,'xlim')*smpf+1;

if ~isempty(varargin)
        if size(varargin,2)>1
            nchans=varargin{2}
        end
end
    
data1=get(child(end),'ydata');
if nchans>1
    data2=get(child(end-1),'ydata');
end
%Cursor selection
if nchans>1
    lim=getindices(data1(viewidxs(1):viewidxs(2)),data2(viewidxs(1):viewidxs(2)),[],0)
    xidxs=[lim.reye.sacidxs]+viewidxs(1)-1;
else
    lim=getindices_oneye(data1(viewidxs(1):viewidxs(2)),0)
    xidxs=[lim.sacidxs]+viewidxs(1)-1;
end


out=xidxs;