function plotSpike
% insert the roi would like to analyze to n
% mark spike timing of different ROI from one file-20200123
% output structure: spike initiation idx, spike amp, spike peak idx, spike peak amp, nan (1=nan,0 is not) 
clear
addpath(genpath(pwd));


%% configure
ROIgroup=[{1:23} num2cell([1:21 23])];
ROIlabel=['global' cellfun(@num2str,num2cell([1:21 23]),'uni',0)];

increvalue=1;

    %% create figure
    UIFigure=figure('Position',[0 50 1000 740])
    set(UIFigure,'Units','normalized');
%     set(UIFigure,'color',[0.8118    0.7059    0.9255])

    %% select to create a new file or reanalysis
    answer = questdlg('', ...
        'Load', ...
        'Create New Project','Open','Create New Project');
    % Handle response
    switch answer
        case 'Create New Project'
            %% load Ca signal
            [signal,n,FileName]=CreateNew(ROIgroup,ROIlabel);
            %% stim condition
            load('003_012_001.mat');
            stim=info.frame;
            
            %% get time variables
            % time=1:size(signal,1)';
            load('011_026_010_ball.mat');
            
            time=time(1:size(signal,1));
            FramePerFile=size(signal,1);
            FrameRate=1./mean(diff(time));
    
            %% Background corrected and smooth
            swindow=5;
            [smoothBC_signal]=BCandSmooth(signal,FrameRate,swindow);

            %% defaut value config
            pks_thr=0.09;
            pks_window=5;
            vel_thr=1;%1st derivative threshold
            acc_thr=0.3;%2nd derivative threshold
            lead=0.234;%time of rise leading peak
            accumu_thr=0.08;%threhold to show accumulated signal
            
           
            %% store data in gui structure for a new created project
            setappdata(UIFigure,'signal',signal);
            setappdata(UIFigure,'smoothBC_signal',smoothBC_signal);
            setappdata(UIFigure,'FrameRate',FrameRate);
            setappdata(UIFigure,'FileName',FileName);
            setappdata(UIFigure,'time',time);
            setappdata(UIFigure,'ROIlabel',ROIlabel);
            setappdata(UIFigure,'swindow',swindow);
            setappdata(UIFigure,'pks_thr',pks_thr);
            setappdata(UIFigure,'pks_window',pks_window);
            setappdata(UIFigure,'acc_thr',acc_thr);
            setappdata(UIFigure,'lead',lead);
            setappdata(UIFigure,'vel_thr',vel_thr);
            setappdata(UIFigure,'accumu_thr',accumu_thr);
            setappdata(UIFigure,'stim',stim);
            
        NewOld=1;%1=create new project
        case 'Open'
        [UIFigure]=Reanalysis(UIFigure)
        
        signal=getappdata(UIFigure,'signal');
        smoothBC_signal=getappdata(UIFigure,'smoothBC_signal');
        FrameRate=getappdata(UIFigure,'FrameRate');
        FileName=getappdata(UIFigure,'FileName');
        time=getappdata(UIFigure,'time');
        swindow=getappdata(UIFigure,'swindow');
        pks_thr=getappdata(UIFigure,'pks_thr');
        pks_window=getappdata(UIFigure,'pks_window');
        PKS=getappdata(UIFigure,'PKS');
        pksLOCS=getappdata(UIFigure);
        acc_thr=getappdata(UIFigure,'acc_thr');
        lead=getappdata(UIFigure,'lead');
        vel_thr=getappdata(UIFigure,'vel_thr');
        riseLOCS=getappdata(UIFigure,'riseLOCS');
        upLOCS=getappdata(UIFigure,'upLOCS');
        stim=getappdata(UIFigure,'stim');
        NanLOCS=getappdata(UIFigure,'NanLOCS');
        accumu_thr=getappdata(UIFigure,'accumu_thr');
        
        NewOld=0;%1=create new project

    end    

    %% Create UIAxes 
    UIAxes = axes(UIFigure);
    title(UIAxes, 'Ca signals')
    set(UIAxes, 'Units', 'normalized')
    set(UIAxes, 'Position', [ 0.1300 0.2100 0.7750 0.7150]);
    %increase step of signal
    for nfile=1:size(signal,3)
        incre=increvalue.*(1:size(signal,2));
    end
    setappdata(UIFigure,'incre',incre);
    %ploting
%     yyaxis left;
    MyGraph=plot(UIAxes,time,smoothBC_signal(:,:,1)+incre,'-','linewidth',2,'color',[.5 .5 .5]);
    UIAxes.YTick=incre;
    UIAxes.YTickLabel=ROIlabel;
    UIAxes.YLabel.String='ROI or cell';
    UIAxes.XLim = [0 time(end)];
    ax1_pos = UIAxes.Position; % position of first axes
    yscale=UIAxes.YLim;
    set(UIAxes, 'UserData', MyGraph);
    %set defaut plot info
    setappdata(UIAxes,'file',1);
    
    
    %second axis forspike numbers
    ax1_pos = UIAxes.Position; % position of first axes
    MyApp.ax2 = axes(UIFigure,'Position',ax1_pos,...
        'XAxisLocation','top',...
        'YAxisLocation','right',...
        'Color','none');
        linkaxes([UIAxes MyApp.ax2],'xy');
    MyApp.ax2.XTick=[];
    MyApp.ax2.YTick=incre;
    MyApp.ax2.YLabel.String='Spike numer';




    %% create properties
    % file popmenu label
    FileSliderLabel = uicontrol(UIFigure,'Style','text',...
        'String','File',...
        'Position',[38 715 25 22]);
    % file number and popmenu
    if iscell(FileName)
        Filelist= cellfun(@(x,y) [num2str(x) ' -' y(1:11)],num2cell(1:length(FileName)),FileName,'uni',0);
    else
        Filelist= ['1 -' FileName(1:11)];
    end
    MyApp.Filepopupmenu = uicontrol(UIFigure,'Style','popupmenu',...
        'String',Filelist,...
        'Position',[64 715 150 22]);
        
    % smooth window label
    MyApp.SmoothWindowLabel = uicontrol(UIFigure,'Style','text'	,...
        'String','Smooth window',...
        'Position',[215 715 90 22]);
    % Edit smooth window
    MyApp.SmoothwindowEditField = uicontrol(UIFigure,'Style','edit'	,...
        'String',num2str(swindow),...
        'Position',[303 720 30 22]);
    
    % Create property: peak
    % show peak box
    MyApp.ShowpeaksCheckBox = uicontrol(UIFigure,'Style','checkbox'	,...
        'String','Show peaks',...
        'Position',[100 80 87 22],...
        'HorizontalAlignment','Left');
    
    % pks threshold label
      MyApp.pks_thresholdEditFieldLabel = uicontrol(UIFigure,'Style','text'	,...
        'String','pks_thr',...
        'Position',[100 50 100 22],...
        'HorizontalAlignment','Left');
    % Edit pks threhold
       MyApp.pks_thresholdEditField = uicontrol(UIFigure,'Style','edit'	,...
        'String',num2str(pks_thr),...
        'Position',[180 55 45 18]);
    
    % pks window label
          MyApp.pks_windowEditFieldLabel = uicontrol(UIFigure,'Style','text'	,...
        'String','pks_window',...
        'Position',[100 30 100 22],...
        'HorizontalAlignment','Left');
    % Edit pks threhold
       MyApp.pks_windowEditField = uicontrol(UIFigure,'Style','edit'	,...
        'String',num2str(pks_window),...
        'Position',[180 35 45 18]);
    
    % Create property: rise
    % Show rise checkbox
         MyApp.ShowriseCheckBox = uicontrol(UIFigure,'Style','checkbox'	,...
        'String','Show rise',...
        'Position',[250 80 87 22],...
        'HorizontalAlignment','Left');
    
    % rise 1st threold label
      MyApp.rise_thresholdEditFieldLabel = uicontrol(UIFigure,'Style','text'	,...
        'String','1st_thr',...
        'Position',[250 50 100 22],...
        'HorizontalAlignment','Left');
    % Edit rise threhold
       MyApp.rise_thresholdEditField = uicontrol(UIFigure,'Style','edit'	,...
        'String',num2str(vel_thr),...
        'Position',[330 55 45 18]);
    
    % rise leading label
    MyApp.rise_leadingEditFieldLabel = uicontrol(UIFigure,'Style','text'	,...
        'String','rise_leading',...
        'Position',[250 30 100 22],...
        'HorizontalAlignment','Left');
    % Edit rise leading time
    MyApp.rise_leadingEditField = uicontrol(UIFigure,'Style','edit'	,...
        'String',num2str(lead),...
        'Position',[330 35 45 18]);
    
    
    % Create 2nd_threholdEditFieldLabel
        MyApp.nd_threholdEditFieldLabel = uicontrol(UIFigure,'Style','text'	,...
            'String','2nd_th',...
            'Position',[250 10 100 22],...
            'HorizontalAlignment','Left');
    % Create nd_threholdEditField
       MyApp.nd_threholdEditField = uicontrol(UIFigure,'Style','edit'	,...
            'String',num2str(acc_thr),...
            'Position',[330 15 45 18]);

    % accumu_thrEditFieldLabel
    MyApp.accumu_thrEditFieldLabel = uicontrol(UIFigure,'Style','text'	,...
        'String','accumu_thr',...
        'Position',[250 10 100 22],...
        'HorizontalAlignment','Left');
    % Edit accumu_thrEditField
    MyApp.accumu_thrEditField = uicontrol(UIFigure,'Style','edit'	,...
        'String',num2str(accumu_thr),...
        'Position',[330 15 45 18]);
    
    % show NAN checkbox
    MyApp.NanCheckBox = uicontrol(UIFigure,'Style','checkbox'	,...
        'String','Show Nan',...
        'Position',[400 80 87 22],...
        'HorizontalAlignment','Left');
    
    % Manual manual checkbox
    MyApp.ManualCheckBox = uicontrol(UIFigure,'Style','checkbox'	,...
        'String','Manual editing',...
        'Position',[400 720 87 22],...
        'HorizontalAlignment','Left');
    
    %Zoom on button
    MyApp.Zoomonbutton = uicontrol(UIFigure,'Style','pushbutton'	,...
        'String','Zoom on',...
        'Position',[700 720 87 22],...
        'HorizontalAlignment','Left');
    %Zoom out button
    MyApp.Zoomoutbutton = uicontrol(UIFigure,'Style','pushbutton'	,...
        'String','Zoom out',...
        'Position',[800 720 87 22],...
        'HorizontalAlignment','Left');
    MyApp.movebutton = uicontrol(UIFigure,'Style','pushbutton'	,...
        'String','move',...
        'Position',[900 720 87 22],...
        'HorizontalAlignment','Left');

    % SaveButton
    MyApp.SaveButton = uicontrol(UIFigure);
    MyApp.SaveButton.Position = [755 27 70 22];
    MyApp.SaveButton.String = 'Save';
    
    %% callback        
    MyApp.Filepopupmenu.Callback  = @(FileS,Axe,app) plotPR(UIAxes,UIFigure,MyApp)

    
    % smoth window
    MyApp.SmoothwindowEditField.Callback = @(FileS,Axe,app) ...
        SmoothwindowEditFieldValueChanged(UIFigure,UIAxes,MyApp);
    
    if NewOld
    % calculate the peak and the rise
    pks_thresholdEditFieldValueChanged(UIAxes,UIFigure,MyApp);
    ShowriseCheckBoxValueChanged(UIAxes,UIFigure,MyApp);
    end

    % peak check box
    MyApp.ShowpeaksCheckBox.Callback = @(Axe,f,app) plotPR(UIAxes,UIFigure,MyApp);
    % rise check box
    MyApp.ShowriseCheckBox.Callback = @(Axe,f,app) plotPR(UIAxes,UIFigure,MyApp);
    % nan check box
    MyApp.NanCheckBox.Callback = @(Axe,f,app) plotPR(UIAxes,UIFigure,MyApp);
    
    % peak threshold
    MyApp.pks_thresholdEditField.Callback = @(Axe,f,app) ...
        pks_thresholdEditFieldValueChanged(UIAxes,UIFigure,MyApp);
    % peak window
    MyApp.pks_windowEditField.Callback = @(Axe,f,app) ...
        pks_thresholdEditFieldValueChanged(UIAxes,UIFigure,MyApp);
        
    % rise 1st threshold
    MyApp.rise_thresholdEditField.Callback = @(Axe,f,app) ...
        ShowriseCheckBoxValueChanged(UIAxes,UIFigure,MyApp);
    % rise time interval leading peak
    MyApp.rise_leadingEditField.Callback = @(Axe,f,app) ...
        ShowriseCheckBoxValueChanged(UIAxes,UIFigure,MyApp);
    % rise 2nd threshold
    MyApp.nd_threholdEditField.Callback = @(Axe,f,app) ...
        ShowriseCheckBoxValueChanged(UIAxes,UIFigure,MyApp);
    % accumulation threshold
    MyApp.accumu_thrEditField.Callback = @(Axe,f,app) ...
        ShowriseCheckBoxValueChanged(UIAxes,UIFigure,MyApp);    
    
    %Zoom on button
    MyApp.Zoomonbutton.Callback =@(Axe,f) ZoomonButtonValueChanged(UIAxes, UIFigure);
    %Zoom out button
    MyApp.Zoomoutbutton.Callback =@(Axe,f) ZoomoutButtonValueChanged(UIAxes, UIFigure);
    %Move button
    MyApp.movebutton.Callback = @(Axe,f) MoveButtonValueChanged(UIAxes, UIFigure);
    
    % manual adjust peak and rise
    MyApp.ManualCheckBox.Callback =@(Axe,f,app) ManualEditing(UIAxes, UIFigure,MyApp);
    % save    
    MyApp.SaveButton.Callback = @(Axe,f) SaveButtonPushed(UIAxes, UIFigure);
    
end

    
    %% callback smooth
    function SmoothwindowEditFieldValueChanged(UIFigure,UIAxes,MyApp)
    swindow = str2num(MyApp.SmoothwindowEditField.String);
    signal=getappdata(UIFigure,'signal');
    FrameRate=getappdata(UIFigure,'FrameRate');
    time=getappdata(UIFigure,'time');
    incre=getappdata(UIFigure,'incre');
    file=getappdata(UIAxes,'file');
    
    
    %smooth
    [smoothBC_signal]=BCandSmooth(signal,FrameRate,swindow);
    
    % store data in gui structure
    setappdata(UIFigure,'smoothBC_signal',smoothBC_signal);
    
    % Create plot
    plotPR(UIAxes,UIFigure,MyApp)
    end
   
    %% calculate peak
    function pks_thresholdEditFieldValueChanged(UIAxes,UIFigure,MyApp)
    %%
    smoothBC_signal=getappdata(UIFigure,'smoothBC_signal');
    time=getappdata(UIFigure,'time');
    incre=getappdata(UIFigure,'incre');
    file=getappdata(UIAxes,'file');
    pks_thr=str2num(MyApp.pks_thresholdEditField.String);
    pks_window=str2num(MyApp.pks_windowEditField.String);
    
    PKS=[];
    pksLOCS=[];
    for nfile=1:size(smoothBC_signal,3)
        for trace=1:size(smoothBC_signal,2)
            [pks{trace},locs{trace}]=findpeaks(smoothBC_signal(:,trace,nfile), 'MinPeakProminence', pks_thr, 'MinPeakDistance', pks_window);
        end
        PKS=cat(1,PKS,pks);
        pksLOCS=cat(1,pksLOCS,locs);
    end
    
    NanLOCS=cellfun(@(x) zeros(size(x)),pksLOCS,'uni',0);
    
    setappdata(UIFigure,'NanLOCS',NanLOCS);
    setappdata(UIFigure,'pks_thr',pks_thr);
    setappdata(UIFigure,'pks_window',pks_window);
    setappdata(UIFigure,'PKS',PKS);
    setappdata(UIFigure,'pksLOCS',pksLOCS);
    
    % recalculate rise
    ShowriseCheckBoxValueChanged(UIAxes,UIFigure,MyApp);
    
    
    end
    
    %% calculte rise
    function ShowriseCheckBoxValueChanged(UIAxes,UIFigure,MyApp)
    smoothBC_signal=getappdata(UIFigure,'smoothBC_signal');
    time=getappdata(UIFigure,'time');
    incre=getappdata(UIFigure,'incre');
    FrameRate=getappdata(UIFigure,'FrameRate');
    pksLOCS=getappdata(UIFigure,'pksLOCS');
    file=getappdata(UIAxes,'file');
    acc_thr=str2num(MyApp.nd_threholdEditField.String);
    lead=str2num(MyApp.rise_leadingEditField.String);
    vel_thr=str2num(MyApp.rise_thresholdEditField.String);
    accumu_thr=str2num(MyApp.accumu_thrEditField.String);
    interval=mean(diff(time));
    
    % find rise
    riseAMP=[];
    riseLOCS=[];
    upLOCS=[];
    vel=[];
    acc=[];
    for nfile=1:size(smoothBC_signal,3)
        DERIV=[];
        DERIV2nd=[];
        for trace=1:size(smoothBC_signal,2)
            %1st derivative
            deriv=derivate(smoothBC_signal(:,trace,nfile),1/FrameRate);
            deriv(deriv<vel_thr)=0; %1st thresholding
            
            %2nd derivative
            deriv2nd=derivate(deriv,1/FrameRate);
            deriv2nd(deriv2nd<0.001)=0; %1st thresholding
            
            % define the interval leading peaks
            rise_interval=round(lead./interval);% rise will be within this interval leading peaks
            IS_interval=diff(pksLOCS{nfile,trace});% inter spike interval
            IS_interval(IS_interval>rise_interval)=rise_interval;%replace inter spike interval by rise interval
            rise_intervalarray=[rise_interval;IS_interval];
            
            leadingIDX=arrayfun(@(x) pksLOCS{nfile,trace}(x)-fliplr([1:rise_intervalarray(x)]),1:length(rise_intervalarray),'uni',0);% filter out the idx outside of this range
            leadingIDX=cellfun(@(x) x(x>0),leadingIDX,'uni',0); %in case the rise happen before recording
            
            %find the top acc_thr(%) of peak
            MAXderiv2nd=arrayfun(@(x) leadingIDX{x}(deriv2nd(leadingIDX{x})>=acc_thr.*max(deriv2nd(leadingIDX{x}))),1:length(leadingIDX),'uni',0);
            
            %for those the 2nd derivative is too low find the valley
            %of Ca signal
            locs{trace}=arrayfun(@(x) MAXderiv2nd{x}(smoothBC_signal(MAXderiv2nd{x},trace,nfile)==min(smoothBC_signal(MAXderiv2nd{x},trace,nfile))),1:length(leadingIDX))';
            
            %label accumulated and non accumulated rise
            accumu{trace}=smoothBC_signal(locs{trace},trace,nfile)>accumu_thr;
            
            DERIV=cat(2,DERIV,deriv);
            DERIV2nd=cat(2,DERIV2nd,deriv2nd);
        end
        vel=cat(3,vel,DERIV);
        acc=cat(3,acc,DERIV2nd);
        
        riseLOCS=cat(1,riseLOCS,locs);
        upLOCS=cat(1,upLOCS,accumu);
        
        %set property
        setappdata(UIFigure,'riseLOCS',riseLOCS);
        setappdata(UIFigure,'vel',vel);
        setappdata(UIFigure,'acc',acc);
        setappdata(UIFigure,'acc_thr',acc_thr);
        setappdata(UIFigure,'lead',lead);
        setappdata(UIFigure,'vel_thr',vel_thr);
        setappdata(UIFigure,'upLOCS',upLOCS);
        setappdata(UIFigure,'accumu_thr',accumu_thr);
        
    end
    plotPR(UIAxes,UIFigure,MyApp)
    end
    
    %% Plot
    function plotPR(UIAxes,UIFigure,MyApp)
    smoothBC_signal=getappdata(UIFigure,'smoothBC_signal');
    time=getappdata(UIFigure,'time');
    incre=getappdata(UIFigure,'incre');
    ROIlabel=getappdata(UIFigure,'ROIlabel');
    riseLOCS=getappdata(UIFigure,'riseLOCS');
    file=getappdata(UIAxes,'file');
    vel=getappdata(UIFigure,'vel');
    acc=getappdata(UIFigure,'acc');
    PKS=getappdata(UIFigure,'PKS');
    pksLOCS=getappdata(UIFigure,'pksLOCS');
    upLOCS=getappdata(UIFigure,'upLOCS');
    NanLOCS=getappdata(UIFigure,'NanLOCS');
    
    peakCheckBox=MyApp.ShowpeaksCheckBox.Value;
    riseCheckBox=MyApp.ShowriseCheckBox.Value;
    NanCheckBox=MyApp.NanCheckBox.Value;
    
    file_ref=getappdata(UIAxes,'file');
    file=round(MyApp.Filepopupmenu.Value);
if file~=file_ref
    cla(UIAxes);
    MyGraph=plot(UIAxes,time,smoothBC_signal(:,:,file)+incre,'-','linewidth',2,'color',[.5 .5 .5]);
    UIAxes.YTick=incre;
    UIAxes.YTickLabel=ROIlabel;
    UIAxes.YLabel.String='ROI or cell';
    UIAxes.XLim = [0 time(end)];
    set(UIAxes, 'UserData', MyGraph);
    setappdata(UIAxes,'file',file);
end
    
    Deleteobj=get(MyApp.ax2, 'UserData');
    delete(Deleteobj);

    hold(UIAxes,'on');
    SpikeMarker=plot([]);
    
    %plot peak
    if peakCheckBox
        x=arrayfun(@(a) time(pksLOCS{file,a}),1:size(PKS,2),'uni',0);
        x=vertcat(x{:});
        y=arrayfun(@(a) PKS{file,a}+incre(a),1:size(PKS,2),'uni',0);
        y=vertcat(y{:});
        SpikeMarker(1)=plot(UIAxes,x,y,...
            'o','linewidth',2,'color',[0.9098 0.1451 0.3765]);
    end
    
    % plot rise
    if riseCheckBox
        %plot deriv and 2nd deriv
%         plot(UIAxes,time,vel(:,:,file)./50+incre-0.2,'b');%deriv
%         plot(UIAxes,time,acc(:,:,file)./1000+incre-0.4,'g');%2nd deriv
        
        % plot rise
        x=arrayfun(@(a) time(riseLOCS{file,a}),1:size(riseLOCS,2),'uni',0);
        x=vertcat(x{:});
        y=arrayfun(@(a) smoothBC_signal(riseLOCS{file,a},a,file)+incre(a),1:size(riseLOCS,2),'uni',0);
        y=vertcat(y{:});
        SpikeMarker(2)=plot(UIAxes,x,y,...
            'o','linewidth',2,'color',[0.5098 0.8824 0.7020]);
        x=arrayfun(@(a) time(riseLOCS{file,a}(upLOCS{file,a})),1:size(upLOCS,2),'uni',0);
        x=vertcat(x{:});
        y=arrayfun(@(a) smoothBC_signal(riseLOCS{file,a}(upLOCS{file,a}),a,file)+incre(a),1:size(upLOCS,2),'uni',0);
        y=vertcat(y{:});
        SpikeMarker(3)=plot(UIAxes,x,y,...
            'o','linewidth',2,'color',[0.3020 0.3020 1]);
    end
    
    if NanCheckBox
        % plot nan
        idx=arrayfun(@(a) riseLOCS{file,a}(logical(NanLOCS{file,a})),1:size(riseLOCS,2),'uni',0);
        x=arrayfun(@(a) time(idx{a}),1:size(riseLOCS,2),'uni',0);
        x=vertcat(x{:});
        y=arrayfun(@(a) smoothBC_signal(idx{a},a,file)+incre(a),1:size(riseLOCS,2),'uni',0);
        y=vertcat(y{:});
       if length(x)
        SpikeMarker(4)=plot(UIAxes,x,y,...
            'o','linewidth',2,'color',[0.5216 0.2667 0.2588]);
        end
    end
    
    %second asix for the 
    SpikeNum= arrayfun(@(a) length(pksLOCS{file,a}),1:size(PKS,2),'uni',0);
    MyApp.ax2.YTick=incre;
    MyApp.ax2.YTickLabel=cellfun(@num2str,SpikeNum,'uni',0);

    
    set(MyApp.ax2, 'UserData', SpikeMarker);
    hold(UIAxes,'off');


    end
    
    %% Zoom
    function ZoomonButtonValueChanged(UIAxes, UIFigure)
    drawnow
    zoom(UIAxes,'on')
    end
    
    function MoveButtonValueChanged(UIAxes, UIFigure)
    drawnow
    pan(UIAxes,'on')
    end
    
    function ZoomoutButtonValueChanged(UIAxes, UIFigure)
    time=getappdata(UIFigure,'time');
    pan(UIAxes,'off')
    UIAxes.XLim = [0 time(end)];
    UIAxes.YLimMode = 'auto';
    end
    
    %% Manual selection
    function ManualEditing(UIAxes, UIFigure,MyApp)
    % disable interface
    MyApp.Filepopupmenu.Enable='off';
    MyApp.SmoothwindowEditField.Enable='off';
    MyApp.ShowpeaksCheckBox.Enable='off';
    MyApp.ShowriseCheckBox.Enable='off';
    MyApp.NanCheckBox.Enable='off';
    MyApp.pks_thresholdEditField.Enable='off';
    MyApp.pks_windowEditField.Enable='off';
    MyApp.rise_thresholdEditField.Enable='off';
    MyApp.rise_leadingEditField.Enable='off';
    MyApp.nd_threholdEditField.Enable='off';
    MyApp.accumu_thrEditField.Enable='off';
    MyApp.ManualCheckBox.Enable='off';
    MyApp.SaveButton.Enable='off';
    
    %% load information
    smoothBC_signal=getappdata(UIFigure,'smoothBC_signal');
    time=getappdata(UIFigure,'time');
    incre=getappdata(UIFigure,'incre');
    file=getappdata(UIAxes,'file');
    vel=getappdata(UIFigure,'vel');
    acc=getappdata(UIFigure,'acc');
    ROIlabel=getappdata(UIFigure,'ROIlabel');
    NanLOCS=getappdata(UIFigure,'NanLOCS');
    
    
    riseLOCS=getappdata(UIFigure,'riseLOCS');
    PKS=getappdata(UIFigure,'PKS');
    pksLOCS=getappdata(UIFigure,'pksLOCS');
    upLOCS=getappdata(UIFigure,'upLOCS');
    
    accumu_thr=str2num(MyApp.accumu_thrEditField.String);
    
    BC_signal=smoothBC_signal(:,:,file);
    
    %% select points
    terminate_key = 'T';
    delete_prev_key = 'D';
    add_key = 'A';
    thatanan_key = 'N';
    % reanalysis_key = 'R';
    keystroke = 'G';
    outputdata=[];
    hold on;
    point_plot = [];
    title(sprintf('%s to add, %s to add NaN, %s to delete , %s to terminate',...
        add_key,thatanan_key,delete_prev_key, terminate_key),'HorizontalAlignment','Center');
    
    
    while ~strcmpi(keystroke, terminate_key)
        
        zoom on;
        pause()
        
        keystroke = upper(get(UIFigure, 'CurrentCharacter'));
        
        
        switch keystroke
            case add_key
                zoom off; % to escape the zoom mode
                rect = ginput(2);
                [~, b_idxtime] = min(abs(time - rect(1,1)));
                [~, b_idxroi] = min(abs((BC_signal(b_idxtime,:)+incre)-rect(1,2)));
                [~, e_idxtime] = min(abs(time - rect(2,1)));
                [~, e_idxroi] = min(abs((BC_signal(b_idxtime,:)+incre)-rect(2,2)));
                
                riseLOCS{file,b_idxroi}=[riseLOCS{file,b_idxroi};b_idxtime];
                PKS{file,e_idxroi}=[PKS{file,e_idxroi};BC_signal(e_idxtime,e_idxroi)];
                pksLOCS{file,e_idxroi}=[pksLOCS{file,e_idxroi};e_idxtime];
                NanLOCS{file,e_idxroi}=[NanLOCS{file,e_idxroi};0];
                upLOCS{file,b_idxroi}=[upLOCS{file,b_idxroi};BC_signal(b_idxtime,b_idxroi)>accumu_thr];
                
                %sorting the data
                [~,idx]=sort(riseLOCS{file,b_idxroi});
                riseLOCS{file,b_idxroi}=riseLOCS{file,b_idxroi}(idx);
                PKS{file,e_idxroi}=PKS{file,e_idxroi}(idx);
                pksLOCS{file,e_idxroi}=pksLOCS{file,e_idxroi}(idx);
                NanLOCS{file,e_idxroi}=NanLOCS{file,e_idxroi}(idx);
                upLOCS{file,b_idxroi}=upLOCS{file,b_idxroi}(idx);
                
            case thatanan_key
                zoom off; % to escape the zoom mode
                rect = ginput(1);
                [~, n_idxtime] = min(abs(time - rect(1)));
                [~, n_idxroi] = min(abs((BC_signal(n_idxtime,:)+incre)-rect(2)));
                
                riseLOCS{file,n_idxroi}=[riseLOCS{file,n_idxroi};n_idxtime];
                PKS{file,n_idxroi}=[PKS{file,n_idxroi};BC_signal(n_idxtime,n_idxroi)];
                pksLOCS{file,n_idxroi}=[pksLOCS{file,n_idxroi};n_idxtime];
                NanLOCS{file,n_idxroi}=[NanLOCS{file,n_idxroi};1];
                upLOCS{file,n_idxroi}=[upLOCS{file,n_idxroi};BC_signal(n_idxtime,n_idxroi)>accumu_thr];
                
                %sorting the data
                [~,idx]=sort(riseLOCS{file,n_idxroi});
                riseLOCS{file,n_idxroi}=riseLOCS{file,n_idxroi}(idx);
                PKS{file,n_idxroi}=PKS{file,n_idxroi}(idx);
                pksLOCS{file,n_idxroi}=pksLOCS{file,n_idxroi}(idx);
                NanLOCS{file,n_idxroi}=NanLOCS{file,n_idxroi}(idx);
                upLOCS{file,n_idxroi}=upLOCS{file,n_idxroi}(idx);
                
            case delete_prev_key
                zoom off; % to escape the zoom mode
                rect = ginput(1);
                [~, d_idxtime] = min(abs(time - rect(1)));
                [~, d_idxroi] = min(abs((BC_signal(d_idxtime,:)+incre)-rect(2)));
                
                diffmat=abs([riseLOCS{file,d_idxroi} pksLOCS{file,d_idxroi}]-d_idxtime);%diff between point and ginput
                minmat=min(min(diffmat));%find the minimum of diffmat
                [d_idx,~]=find(diffmat==minmat);%find the row of minimum of diffmat
                
                riseLOCS{file,d_idxroi}(d_idx)=[];
                PKS{file,d_idxroi}(d_idx)=[];
                pksLOCS{file,d_idxroi}(d_idx)=[];
                NanLOCS{file,d_idxroi}(d_idx)=[];
                upLOCS{file,d_idxroi}(d_idx)=[];
                        end
        
    setappdata(UIFigure,'riseLOCS',riseLOCS);
    setappdata(UIFigure,'upLOCS',upLOCS);
    setappdata(UIFigure,'NanLOCS',NanLOCS);
    setappdata(UIFigure,'PKS',PKS);
    setappdata(UIFigure,'pksLOCS',pksLOCS);
    
        plotPR(UIAxes,UIFigure,MyApp)
    end
    % readjust interface
    MyApp.ManualCheckBox.Value=0;
    UIAxes.YLimMode='auto';
    UIAxes.XLim = [0 time(end)];


    % enable interface
    MyApp.Filepopupmenu.Enable='on';
    MyApp.SmoothwindowEditField.Enable='on';
    MyApp.ShowpeaksCheckBox.Enable='on';
    MyApp.ShowriseCheckBox.Enable='on';
    MyApp.NanCheckBox.Enable='on';
    MyApp.pks_thresholdEditField.Enable='on';
    MyApp.pks_windowEditField.Enable='on';
    MyApp.rise_thresholdEditField.Enable='on';
    MyApp.rise_leadingEditField.Enable='on';
    MyApp.nd_threholdEditField.Enable='on';
    MyApp.accumu_thrEditField.Enable='on';
    MyApp.ManualCheckBox.Enable='on';
    MyApp.SaveButton.Enable='on';
    
    end
    %%   Button pushed function: OpenButton
    function [UIFigure]=Reanalysis(UIFigure)
    
    [FileName,FolderPath] = uigetfile({'*SpikeAna.mat'},'Open old data');
    load([FolderPath,FileName])
    
    % get data from gui structure
    setappdata(UIFigure,'signal',signal);
    setappdata(UIFigure,'smoothBC_signal',smoothBC_signal);
    setappdata(UIFigure,'FrameRate',FrameRate);
    setappdata(UIFigure,'FileName',FileName);
    setappdata(UIFigure,'time',time);
    setappdata(UIFigure,'swindow',swindow);
    setappdata(UIFigure,'pks_thr',pks_thr);
    setappdata(UIFigure,'pks_window',pks_window);
    setappdata(UIFigure,'PKS',PKS);
    setappdata(UIFigure,'pksLOCS',pksLOCS);
    setappdata(UIFigure,'acc_thr',acc_thr);
    setappdata(UIFigure,'lead',lead);
    setappdata(UIFigure,'vel_thr',vel_thr);
    setappdata(UIFigure,'riseLOCS',riseLOCS);
    setappdata(UIFigure,'upLOCS',upLOCS);
    setappdata(UIFigure,'stim',stim);
    setappdata(UIFigure,'NanLOCS',NanLOCS);
    setappdata(UIFigure,'accumu_thr',accumu_thr);
    setappdata(UIFigure,'vel',FirDeriv);
    setappdata(UIFigure,'acc',SecDeriv);
    
    end
    
    
    %% create a new file
    function [signal,n,FileName]=CreateNew(ROIgroup,ROIlabel)
    %% load ROI analysis data
    all_velocity=[];
    all_pks=[];
    signal=[];
    
    f=1;
    filesize=0;
    FN=cell(0);
    FP=cell(0);
    
    [FileName,FolderPath] = uigetfile({'*analysis.mat;*list.mat'},'Select an ROI file', 'Multiselect', 'on');
    if iscell(FileName)
        NewAddFile=size(FileName,2);
    elseif FileName~=0
        NewAddFile=1;
        if strfind(FileName,'list')
            load([FolderPath,FileName])
            NewAddFile=size(FileName,2);
        end
    else
        NewAddFile=0;
    end
    filesize=filesize+NewAddFile;
    
    for fnumber=1:NewAddFile
        if iscell(FileName)
            FN=cat(1,FN,FileName{fnumber});
        else
            FN=cat(1,FN,FileName);
        end
        FP=cat(1,FP,FolderPath);
        Import_data=load([FP{end},FN{end}]);
        signal=cat(3,signal,Import_data.activs);
    end
    
    FN
    
    
    if length(ROIgroup)
        %% read ROI size
        [ROIName,ROIPath] = uigetfile('*set.zip');
        [sROI] = ReadImageJROI([ROIPath,ROIName]);
        coords = cellfun(@(x) [x.mnCoordinates;x.mnCoordinates(1,:)], sROI, 'uni', 0);
        masks = cellfun(@(x) poly2mask(x(:,1), x(:,2), max(x(:)), max(x(:))), coords, 'uni', 0);
        weight=cell2mat(cellfun(@(x) sum(x(:)),masks, 'uni', 0));
        
        %% converge
        for group=1:length(ROIgroup)
            activ(:,group,:)=sum(weight(ROIgroup{group}).*signal(:,ROIgroup{group},:),2)./sum(weight(ROIgroup{group}),2);
        end
        signal=activ;
        n=1:length(ROIgroup);
    end
    
    end
    
    %%   Button pushed function: SaveButton
    function SaveButtonPushed(UIAxes, UIFigure)
    % get data from gui structure
    signal=getappdata(UIFigure,'signal');
    smoothBC_signal=getappdata(UIFigure,'smoothBC_signal');
    FrameRate=getappdata(UIFigure,'FrameRate');
    FileName=getappdata(UIFigure,'FileName');
    time=getappdata(UIFigure,'time');
    swindow=getappdata(UIFigure,'swindow');
    pks_thr=getappdata(UIFigure,'pks_thr');
    pks_window=getappdata(UIFigure,'pks_window');
    PKS=getappdata(UIFigure,'PKS');
    pksLOCS=getappdata(UIFigure,'pksLOCS');
    acc_thr=getappdata(UIFigure,'acc_thr');
    lead=getappdata(UIFigure,'lead');
    vel_thr=getappdata(UIFigure,'vel_thr');
    riseLOCS=getappdata(UIFigure,'riseLOCS');
    upLOCS=getappdata(UIFigure,'upLOCS');
    stim=getappdata(UIFigure,'stim');
    NanLOCS=getappdata(UIFigure,'NanLOCS');
    accumu_thr=getappdata(UIFigure,'accumu_thr');
    FirDeriv=getappdata(UIFigure,'vel');
    SecDeriv=getappdata(UIFigure,'acc');
    
    
    
    
    [file,path] = uiputfile('SpikeAna.mat','save spike data')
    if file~=0
        save([path file],'FileName','signal','smoothBC_signal','FrameRate','FileName','time','swindow',...
            'pks_thr','pks_window','PKS','pksLOCS','acc_thr','lead','vel_thr','riseLOCS','upLOCS','stim','NanLOCS','accumu_thr',...
            'FirDeriv','SecDeriv');
        
    end
    end


%% Background corrected and smooth
function [smoothBC_signal]=BCandSmooth(signal,FrameRate,swindow)
    
    BC_signal=[];
    smoothBC_signal=[];
    for nfile=1:size(signal,3)
        %background correction
        bc_signal=FBackCorr(signal(:,:,nfile),FrameRate);
        BC_signal=cat(3,BC_signal,bc_signal);
        
        %smooth
        smoothbc_signal=arrayfun(@(x) smooth(bc_signal(:,x),swindow),1:size(bc_signal,2),'uni',0);
        smoothBC_signal=cat(3,smoothBC_signal,horzcat(smoothbc_signal{:}));
    end
    end
