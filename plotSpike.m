function plotSpike
% insert the roi would like to analyze to n
% mark spike timing of different ROI from one file-20200123
% output structure: spike initiation idx, spike amp, spike peak idx, spike peak amp, nan (1=nan,0 is not) 
clear
addpath(genpath('C:\Users\teamo\Google Drive\UChicago\Hansel lab\databackup'));


%% configure
paw_move=0; %%if the paw movement will be included in the figure choose 1, or choose others  
vel_ana=0; %if the motion activity will be included in the figure choose 1, or choose others  
blink_ana=0; %if the eye blink will be included in the figure choose 1, or choose others  
Air_puff=0; %if the air puff will be included in the figure choose 1, or choose others  
CrossCor=0; %if the cross correlation among signals will be analyzed choose 1
StackOrOverlap=0; %if the signals will be placed in stacks choose 1; if the signals will be placed overlapped choose 2
PlotMean=0; %if plot the mean of data
plotArea=1; %if plot the mean with shaded area as sdv


%n = ROI number I would like to analyze
% n=[1:65];
ROIgroup=[{1:23} num2cell([1:21 23])];
ROIlabel=['global' cellfun(@num2str,num2cell([1:21 23]),'uni',0)];

increvalue=1;
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
    
    %% stim condition
%     load('D:\2pdata\Ting\20200312\003\003_012_001.mat')
%     stim=info.frame;
    
    %% get time variables
%     load('D:\2pdata\Ting\time variables\011_026_008_ball');
time=1:size(signal,1)';
load('C:\Users\teamo\Google Drive\UChicago\Hansel lab\databackup\scripts\time variables\011_026_010_ball.mat');

    time=time(1:size(signal,1));
    FramePerFile=size(signal,1);
    FrameRate=1./mean(diff(time));
    
    %% Background corrected and smooth
    swindow=5;
    [smoothBC_signal]=BCandSmooth(signal,FrameRate,swindow);
    for nfile=1:size(signal,3)
        incre=increvalue.*(1:size(signal,2));
    end

    %% defaut value config
    pks_thr=0.09;
    pks_window=5;
    vel_thr=1;%1st derivative threshold
    acc_thr=0.3;%2nd derivative threshold
    lead=0.234;%time of rise leading peak
    accumu_thr=0.08;%threhold to show accumulated signal

    %% create properties
    UIFigure=uifigure('Position',[100 100 808 602])
    
    % store data in gui structure
    setappdata(UIFigure,'signal',signal);
    setappdata(UIFigure,'smoothBC_signal',smoothBC_signal);
    setappdata(UIFigure,'FrameRate',FrameRate);
    setappdata(UIFigure,'FileName',FileName);
    setappdata(UIFigure,'time',time);
    setappdata(UIFigure,'incre',incre);
    setappdata(UIFigure,'swindow',swindow);
    setappdata(UIFigure,'pks_thr',pks_thr);
    setappdata(UIFigure,'pks_window',pks_window);    
    setappdata(UIFigure,'acc_thr',acc_thr);
    setappdata(UIFigure,'lead',lead);
    setappdata(UIFigure,'vel_thr',vel_thr);
    setappdata(UIFigure,'accumu_thr',accumu_thr);
%     setappdata(UIFigure,'stim',stim);

    
    % Create UIAxes
    UIAxes = uiaxes(UIFigure);
    title(UIAxes, 'Ca signals')
%     xlabel(UIAxes, 'X')
    ylabel(UIAxes, 'Y')
    UIAxes.Position = [10 121 728 462];
    UIAxes.YTick=incre;
    UIAxes.YTickLabel=ROIlabel;
    UIAxes.YLabel.String='ROI or cell';
    UIAxes.XLim = [0 time(end)];
    TracePlot=plot(UIAxes,time,smoothBC_signal(:,:,1)+incre,'linewidth',2,'color',[.5 .5 .5]);
    %set defaut plot info
    setappdata(UIAxes,'file',1);

    % file number and name label
    FileSliderValueLabel = uilabel(UIFigure);
    FileSliderValueLabel.Position = [84 90 150 22];
    FileSliderValueLabel.Text =['1-' FileName{1}(1:11)];  
    % file slider label
    FileSliderLabel = uilabel(UIFigure);
    FileSliderLabel.HorizontalAlignment = 'right';
    FileSliderLabel.Position = [38 69 25 22];
    FileSliderLabel.Text = 'File';   
    % File Slider
    FileSlider = uislider(UIFigure);
    FileSlider.Position = [84 78 150 3];
    FileSlider.Limits=[1 size(signal,3)];
    FileSlider.MajorTicks=[1:size(signal,3)];
    FileSlider.MinorTicks=[];
        
    % smooth window label
    SmoothwindowEditFieldLabel = uilabel(UIFigure);
    SmoothwindowEditFieldLabel.HorizontalAlignment = 'right';
    SmoothwindowEditFieldLabel.Position = [87 16 90 22];
    SmoothwindowEditFieldLabel.Text = 'Smooth window';    
    % Edit smooth window
    SmoothwindowEditField = uieditfield(UIFigure, 'numeric');
    SmoothwindowEditField.Position = [192 16 42 22];
    SmoothwindowEditField.Value = swindow;
    
    % Create property: peak
    % show peak box
    ShowpeaksCheckBox = uicheckbox(UIFigure);
    ShowpeaksCheckBox.Text = 'Show peaks';
    ShowpeaksCheckBox.Position = [281 91 87 22];
    
    % pks threshold label
    pks_thresholdEditFieldLabel = uilabel(UIFigure);
    pks_thresholdEditFieldLabel.HorizontalAlignment = 'right';
    pks_thresholdEditFieldLabel.Position = [285 67 45 22];
    pks_thresholdEditFieldLabel.Text = 'pks_thr';
    % Edit pks threhold
    pks_thresholdEditField = uieditfield(UIFigure, 'numeric');
    pks_thresholdEditField.Position = [345 67 42 22];
    pks_thresholdEditField.Value = pks_thr;
    
    % pks window label
    pks_windowEditFieldLabel = uilabel(UIFigure);
    pks_windowEditFieldLabel.HorizontalAlignment = 'right';
    pks_windowEditFieldLabel.Position = [260 37 71 22];
    pks_windowEditFieldLabel.Text = 'pks_window';
    % Edit pks window
    pks_windowEditField = uieditfield(UIFigure, 'numeric');
    pks_windowEditField.Position = [345 37 42 22];
    pks_windowEditField.Value = pks_window;
    
    % Create property: rise
    % Show rise checkbox
    ShowriseCheckBox = uicheckbox(UIFigure);
    ShowriseCheckBox.Text = 'Show rise';
    ShowriseCheckBox.Position = [451 91 75 22];  
    
    % rise 1st threold label
    rise_thresholdEditFieldLabel = uilabel(UIFigure);
    rise_thresholdEditFieldLabel.HorizontalAlignment = 'right';
    rise_thresholdEditFieldLabel.Position = [423 37 45 22];
    rise_thresholdEditFieldLabel.Text = '1st_thr'; 
    % Edit 1st acc threshold
    rise_thresholdEditField = uieditfield(UIFigure, 'numeric');
    rise_thresholdEditField.Position = [484 37 42 22];
    rise_thresholdEditField.Value = vel_thr;
    
    % rise leading label
    rise_leadingEditFieldLabel = uilabel(UIFigure);
    rise_leadingEditFieldLabel.HorizontalAlignment = 'right';
    rise_leadingEditFieldLabel.Position = [398 7 70 22];
    rise_leadingEditFieldLabel.Text = 'rise_leading';
    % Edit rise leading time
    rise_leadingEditField = uieditfield(UIFigure, 'numeric');
    rise_leadingEditField.Position = [483 7 42 22];
    rise_leadingEditField.Value = lead; 
    
    % Create nd_threholdEditFieldLabel
    nd_threholdEditFieldLabel = uilabel(UIFigure);
    nd_threholdEditFieldLabel.HorizontalAlignment = 'right';
    nd_threholdEditFieldLabel.Position = [423 67 46 22];
    nd_threholdEditFieldLabel.Text = '2nd_th';
    % Create nd_threholdEditField
    nd_threholdEditField = uieditfield(UIFigure, 'numeric');
    nd_threholdEditField.Position = [484 67 42 22];
    nd_threholdEditField.Value = acc_thr;
    
    % accumu_thrEditFieldLabel
    accumu_thrEditFieldLabel = uilabel(UIFigure);
    accumu_thrEditFieldLabel.HorizontalAlignment = 'right';
    accumu_thrEditFieldLabel.Position = [542 69 68 22];
    accumu_thrEditFieldLabel.Text = 'accumu_thr';
    % Edit accumu_thrEditField
    accumu_thrEditField = uieditfield(UIFigure, 'numeric');
    accumu_thrEditField.Position = [625 69 42 22];
    accumu_thrEditField.Value = accumu_thr;
    
    % Create ManualCheckBox
%     ManualCheckBox = uicheckbox(UIFigure);
%     ManualCheckBox.Text = 'Manual';
%     ManualCheckBox.Position = [575 91 61 22];
    % Create ButtonGroup
    AddButton = uibutton(UIFigure,'Push','Position',[737 364 65 22],'Text','Add');
%     AddButton = uicontrol(UIFigure,'Style','pushbutton','Position',[10 4 41 22],'Text','Add');
%     d=AddButton.KeyPressFcn;
    DeleteButton = uibutton(UIFigure,'Push','Position',[737 333 65 22],'Text','Delete');
    NaNButton = uibutton(UIFigure,'Push','Position',[737 303 65 22],'Text','NaN');

    
    % Create ZoomonButton
    ZoomonButton = uibutton(UIFigure, 'push');
    ZoomonButton.Text = 'Zoom on';
    ZoomonButton.Position = [737 511 63 23];
    
    % Create ZoomoutButton
    ZoomoutButton = uibutton(UIFigure, 'push');
    ZoomoutButton.Text = 'Zoom out';
    ZoomoutButton.Position = [736 479 66 23];
    
    % Create MoveButton
    MoveButton = uibutton(UIFigure, 'push');
    MoveButton.Text = 'Move';
    MoveButton.Position = [736 448 66 23];
    
    % SaveButton
    SaveButton = uibutton(UIFigure, 'push');
    SaveButton.Position = [755 27 35 22];
    SaveButton.Text = 'Save';
    
    % call back
    % slider
    FileSlider.ValueChangedFcn = @(FileS,Axe,f,Label) ...
        ChangeFile(FileSlider,UIAxes,UIFigure,FileSliderValueLabel);
    % smoth window
    SmoothwindowEditField.ValueChangedFcn = @(FileS,Axe,f,smoothwin) ...
        SmoothwindowEditFieldValueChanged(FileSlider,UIAxes,UIFigure,SmoothwindowEditField);
    % peak check box
    ShowpeaksCheckBox.ValueChangedFcn = @(Axe,f,checkbox,pks_thr,pks_window) ...
        pks_thresholdEditFieldValueChanged(UIAxes,UIFigure,ShowpeaksCheckBox,pks_thresholdEditField,pks_windowEditField);
    % peak threshold
    pks_thresholdEditField.ValueChangedFcn = @(Axe,f,checkbox,pks_thr,pks_window) ...
        pks_thresholdEditFieldValueChanged(UIAxes,UIFigure,ShowpeaksCheckBox,pks_thresholdEditField,pks_windowEditField);
    % peak window
    pks_windowEditField.ValueChangedFcn = @(Axe,f,checkbox,pks_thr,pks_window) ...
        pks_thresholdEditFieldValueChanged(UIAxes,UIFigure,ShowpeaksCheckBox,pks_thresholdEditField,pks_windowEditField);
    % rise check box
    ShowriseCheckBox.ValueChangedFcn = @(Axe,f,checkbox,...
        FirstD,rise_lead,SecondD,accu) ...
        ShowriseCheckBoxValueChanged(UIAxes,UIFigure,ShowriseCheckBox,...
        rise_thresholdEditField,rise_leadingEditField,nd_threholdEditField,accumu_thrEditField);
    % rise 1st threshold
    rise_thresholdEditField.ValueChangedFcn = @(Axe,f,checkbox,...
        FirstD,rise_lead,SecondD,accu) ...
        ShowriseCheckBoxValueChanged(UIAxes,UIFigure,ShowriseCheckBox,...
        rise_thresholdEditField,rise_leadingEditField,nd_threholdEditField,accumu_thrEditField);
    % rise time interval leading peak
    rise_leadingEditField.ValueChangedFcn = @(Axe,f,checkbox,...
        FirstD,rise_lead,SecondD,accu) ...
        ShowriseCheckBoxValueChanged(UIAxes,UIFigure,ShowriseCheckBox,...
        rise_thresholdEditField,rise_leadingEditField,nd_threholdEditField,accumu_thrEditField);
    % rise 2nd threshold
    nd_threholdEditField.ValueChangedFcn = @(Axe,f,checkbox,...
        FirstD,rise_lead,SecondD,accu) ...
        ShowriseCheckBoxValueChanged(UIAxes,UIFigure,ShowriseCheckBox,...
        rise_thresholdEditField,rise_leadingEditField,nd_threholdEditField,accumu_thrEditField);
    % accumulation threshold
    accumu_thrEditField.ValueChangedFcn = @(Axe,f,checkbox,...
        FirstD,rise_lead,SecondD,accu) ...
        ShowriseCheckBoxValueChanged(UIAxes,UIFigure,ShowriseCheckBox,...
        rise_thresholdEditField,rise_leadingEditField,nd_threholdEditField,accumu_thrEditField);
    
    % manual
%     Addmunu = uimenu(UIFigure,'Text','Add(a)','Accelerator','a');
%     Addmunu.MenuSelectedFcn = @(Axe,f,t) MenuSelected(UIAxes, UIFigure,'t');
% 
%     Deletemunu = uimenu(UIFigure,'Text','Delete');
%     NaNmunu = uimenu(UIFigure,'Text','Nan');
% Addmunu.Accelerator = 'T';

    AddButton.ButtonPushedFcn = @(Axe,f) ManualEditing(UIAxes, UIFigure,AddButton);
    DeleteButton.ButtonPushedFcn = @(Axe,f) ManualEditing(UIAxes, UIFigure,DeleteButton);
    NaNButton.ButtonPushedFcn = @(Axe,f) ManualEditing(UIAxes, UIFigure,NaNButton);

    % Zoom
    ZoomonButton.ButtonPushedFcn = @(Axe,f) ZoomonButtonValueChanged(UIAxes, UIFigure);
    ZoomoutButton.ButtonPushedFcn = @(Axe,f) ZoomoutButtonValueChanged(UIAxes, UIFigure);
    MoveButton.ButtonPushedFcn = @(Axe,f) MoveButtonValueChanged(UIAxes, UIFigure);
    
    % save    
    SaveButton.ButtonPushedFcn = @(Axe,f) SaveButtonPushed(UIAxes, UIFigure);
    
end


    %% Value changed function: FileSlider
    function ChangeFile(FileSlider,UIAxes,UIFigure,FileSliderValueLabel)
    smoothBC_signal=getappdata(UIFigure,'smoothBC_signal');
    FileName=getappdata(UIFigure,'FileName');
    time=getappdata(UIFigure,'time');
    incre=getappdata(UIFigure,'incre');
    
    file=round(FileSlider.Value);
    setappdata(UIAxes,'file',file);
    FileSlider.Value=file;
    FileSliderValueLabel.Text = [num2str(file) ' : ' FileName{file}(1:11)];
    
    plotPR(UIAxes,UIFigure)
    end
    
    %% callback smooth
    function SmoothwindowEditFieldValueChanged(FileSlider,UIAxes,UIFigure,SmoothwindowEditField)
    swindow = SmoothwindowEditField.Value;
    signal=getappdata(UIFigure,'signal');
    FrameRate=getappdata(UIFigure,'FrameRate');
    time=getappdata(UIFigure,'time');
    incre=getappdata(UIFigure,'incre');
    file=FileSlider.Value;
    
    
    %smooth
    [smoothBC_signal]=BCandSmooth(signal,FrameRate,swindow);
    
    % Create plot
    TracePlot=plot(UIAxes,time,smoothBC_signal(:,:,file)+incre,'linewidth',2,'color',[.5 .5 .5]);
    
    % store data in gui structure
    setappdata(UIFigure,'smoothBC_signal',smoothBC_signal);
    end
   
    %% calculate peak 
    function pks_thresholdEditFieldValueChanged(UIAxes,UIFigure,ShowpeaksCheckBox,pks_thresholdEditField,pks_windowEditField)
    %%
    smoothBC_signal=getappdata(UIFigure,'smoothBC_signal');
    time=getappdata(UIFigure,'time');
    incre=getappdata(UIFigure,'incre');
    file=getappdata(UIAxes,'file');
    pks_thr=pks_thresholdEditField.Value;
    pks_window=pks_windowEditField.Value;
        
    PKS=[];
    pksLOCS=[];
    for nfile=1:size(smoothBC_signal,3)
        for trace=1:size(smoothBC_signal,2)
            [pks{trace},locs{trace}]=findpeaks(smoothBC_signal(:,trace,nfile), 'MinPeakProminence', pks_thr, 'MinPeakDistance', pks_window);
        end
        PKS=cat(1,PKS,pks);
        pksLOCS=cat(1,pksLOCS,locs);
    end
    
    setappdata(UIFigure,'pks_thr',pks_thr);
    setappdata(UIFigure,'pks_window',pks_window);
    setappdata(UIFigure,'PKS',PKS);
    setappdata(UIFigure,'pksLOCS',pksLOCS);
    setappdata(UIFigure,'peakCheckBox',ShowpeaksCheckBox.Value);
    
    %replot
    plotPR(UIAxes,UIFigure)
    

    end
    
    %% calculte rise
    function ShowriseCheckBoxValueChanged(UIAxes,UIFigure,ShowriseCheckBox,rise_thresholdEditField,rise_leadingEditField,nd_threholdEditField,accumu_thrEditField)
    smoothBC_signal=getappdata(UIFigure,'smoothBC_signal');
    time=getappdata(UIFigure,'time');
    incre=getappdata(UIFigure,'incre');
    FrameRate=getappdata(UIFigure,'FrameRate');
    pksLOCS=getappdata(UIFigure,'pksLOCS');
    file=getappdata(UIAxes,'file');
    acc_thr=nd_threholdEditField.Value;
    lead=rise_leadingEditField.Value;
    vel_thr=rise_thresholdEditField.Value;
    accumu_thr=accumu_thrEditField.Value;
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
                 accumu=arrayfun(@(x) MAXderiv2nd{x}(smoothBC_signal(MAXderiv2nd{x},trace,nfile)>accumu_thr),1:length(leadingIDX),'uni',0)';
                 accumu=horzcat(accumu{:});
                 up{trace}=accumu(ismember(accumu,locs{trace}));

                 
                 DERIV=cat(2,DERIV,deriv);
                 DERIV2nd=cat(2,DERIV2nd,deriv2nd);
             end
             vel=cat(3,vel,DERIV);
             acc=cat(3,acc,DERIV2nd);
             
             riseLOCS=cat(1,riseLOCS,locs);
             upLOCS=cat(1,upLOCS,up);
             
             %set property
             setappdata(UIFigure,'riseLOCS',riseLOCS);
             setappdata(UIFigure,'riseCheckBox',ShowriseCheckBox.Value);
             setappdata(UIFigure,'vel',vel);
             setappdata(UIFigure,'acc',acc);
             setappdata(UIFigure,'acc_thr',acc_thr);
             setappdata(UIFigure,'lead',lead);
             setappdata(UIFigure,'vel_thr',vel_thr);
             setappdata(UIFigure,'upLOCS',upLOCS);
             setappdata(UIFigure,'accumu_thr',accumu_thr);

         end
     plotPR(UIAxes,UIFigure)
    end
    
    %%
    function plotPR(UIAxes,UIFigure)
    smoothBC_signal=getappdata(UIFigure,'smoothBC_signal');
    time=getappdata(UIFigure,'time');
    incre=getappdata(UIFigure,'incre');
    riseLOCS=getappdata(UIFigure,'riseLOCS');
    file=getappdata(UIAxes,'file');
    vel=getappdata(UIFigure,'vel');
    acc=getappdata(UIFigure,'acc');
    PKS=getappdata(UIFigure,'PKS');
    pksLOCS=getappdata(UIFigure,'pksLOCS');
    upLOCS=getappdata(UIFigure,'upLOCS');

    
    peakCheckBox=getappdata(UIFigure,'peakCheckBox');
    riseCheckBox=getappdata(UIFigure,'riseCheckBox');
    
    cla(UIAxes);
    TracePlot=plot(UIAxes,time,smoothBC_signal(:,:,file)+incre,'linewidth',2,'color',[.5 .5 .5]);
    
    hold(UIAxes,'on');
    
    %plot peak
    if peakCheckBox
    x=arrayfun(@(a) time(pksLOCS{file,a}),1:size(PKS,2),'uni',0);
    x=vertcat(x{:});
    y=arrayfun(@(a) PKS{file,a}+incre(a),1:size(PKS,2),'uni',0);
    y=vertcat(y{:});
    PeakPlot=plot(UIAxes,x,y,...
            'o','linewidth',2,'color',[0.9098 0.1451 0.3765]);
    end

    % plot rise
    if riseCheckBox
    %plot deriv and 2nd deriv
    plot(UIAxes,time,vel(:,:,file)./50+incre-0.2,'b');%deriv
    plot(UIAxes,time,acc(:,:,file)./1000+incre-0.4,'g');%2nd deriv
    
    % plot rise
    x=arrayfun(@(a) time(riseLOCS{file,a}),1:size(riseLOCS,2),'uni',0);
    x=vertcat(x{:});
    y=arrayfun(@(a) smoothBC_signal(riseLOCS{file,a},a,file)+incre(a),1:size(riseLOCS,2),'uni',0);
    y=vertcat(y{:});
    RisePlot=plot(UIAxes,x,y,...
        'o','linewidth',2,'color',[0.5098 0.8824 0.7020]);
    x=arrayfun(@(a) time(upLOCS{file,a}),1:size(upLOCS,2),'uni',0);
    x=vertcat(x{:});
    y=arrayfun(@(a) smoothBC_signal(upLOCS{file,a},a,file)+incre(a),1:size(upLOCS,2),'uni',0);
    y=vertcat(y{:});
    RisePlot=plot(UIAxes,x,y,...
        'o','linewidth',2,'color',[0.3020 0.3020 1]);
    end
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
%     UIAxes.XLimMode = 'auto';
    UIAxes.XLim = [0 time(end)];
    UIAxes.YLimMode = 'auto';
end
    
%% Manual selection
function ManualEditing(UIAxes, UIFigure,buttonselect);
%%
keystroke=buttonselect.Text;
smoothBC_signal=getappdata(UIFigure,'smoothBC_signal');
time=getappdata(UIFigure,'time');
incre=getappdata(UIFigure,'incre');
file=getappdata(UIAxes,'file');
vel=getappdata(UIFigure,'vel');
acc=getappdata(UIFigure,'acc');

MriseLOCS=getappdata(UIFigure,'riseLOCS');
MPKS=getappdata(UIFigure,'PKS');
MpksLOCS=getappdata(UIFigure,'pksLOCS');
MupLOCS=getappdata(UIFigure,'upLOCS');

add_key='Add';
thatanan_key='Nan';
delete_prev_key='Delete;

BC_signal=smoothBC_signal(:,:,file);

    if 0
    switch keystroke
        case add_key
            zoom off; % to escape the zoom mode
            rect = ginput(2);            
            
     

            [~, b_idxtime] = min(abs(time - rect(1,1)));
            [~, b_idxroi] = min(abs((BC_signal(b_idxtime,:)+incre)-rect(1,2)));
            [~, e_idxtime] = min(abs(time - rect(2,1)));
            [~, e_idxroi] = min(abs((BC_signal(b_idxtime,:)+incre)-rect(2,2)));
            
            MriseLOCS{file,b_idxroi}=
            
            outputdata=[outputdata;time(b_idxtime) BC_signal(b_idxtime,b_idxroi)+incre(b_idxroi),...
                time(e_idxtime) BC_signal(e_idxtime,e_idxroi)+incre(e_idxroi),...
                b_idxroi 0];
        case thatanan_key
            zoom off; % to escape the zoom mode
            rect = ginput(1);
            [~, n_idxtime] = min(abs(time - rect(1)));
            [~, n_idxroi] = min(abs((BC_signal(n_idxtime,:)+incre)-rect(2)));
            
            outputdata=[outputdata;time(n_idxtime) BC_signal(n_idxtime,n_idxroi)+incre(n_idxroi),...
                time(n_idxtime) BC_signal(n_idxtime,n_idxroi)+incre(n_idxroi),...
                n_idxroi 1];
        case terminate_key
            choice = questdlg('Would you like to terminate?', ...
                'Safeguard early termination', ...
                'Yes','No','No');
            if strcmpi(choice, 'No'), keystroke = 'C'; end
        case delete_prev_key
            zoom off; % to escape the zoom mode
            rect = ginput(1);
            [~, d_idxtime] = min(abs(time - rect(1)));
            [~, d_idxroi] = min(abs((BC_signal(d_idxtime,:)+incre)-rect(2)));
            
            d_roi=find(outputdata(:,5)==d_idxroi);
            [~,d_idx]=min(abs(mean(outputdata(d_roi,[1 3]),2)-d_idxtime));
            
            outputdata(d_roi(d_idx),:) = [];     
    end
    end
    
%     end
    
     
    cla(UIAxes);
    TracePlot=plot(UIAxes,time,smoothBC_signal(:,:,file)+incre,'linewidth',2,'color',[.5 .5 .5]);
    
    hold(UIAxes,'on');
    %plot peak
    x=arrayfun(@(a) time(MpksLOCS{file,a}),1:size(MPKS,2),'uni',0);
    x=vertcat(x{:});
    y=arrayfun(@(a) MPKS{file,a}+incre(a),1:size(MPKS,2),'uni',0);
    y=vertcat(y{:});
    PeakPlot=plot(UIAxes,x,y,...
            'o','linewidth',2,'color',[0.9098 0.1451 0.3765]);

    % plot rise
    %plot deriv and 2nd deriv
    plot(UIAxes,time,vel(:,:,file)./50+incre-0.2,'b');%deriv
    plot(UIAxes,time,acc(:,:,file)./1000+incre-0.4,'g');%2nd deriv
    
    % plot rise
    x=arrayfun(@(a) time(MriseLOCS{file,a}),1:size(MriseLOCS,2),'uni',0);
    x=vertcat(x{:});
    y=arrayfun(@(a) smoothBC_signal(MriseLOCS{file,a},a,file)+incre(a),1:size(MriseLOCS,2),'uni',0);
    y=vertcat(y{:});
    RisePlot=plot(UIAxes,x,y,...
        'o','linewidth',2,'color',[0.5098 0.8824 0.7020]);
    x=arrayfun(@(a) time(MupLOCS{file,a}),1:size(MupLOCS,2),'uni',0);
    x=vertcat(x{:});
    y=arrayfun(@(a) smoothBC_signal(MupLOCS{file,a},a,file)+incre(a),1:size(MupLOCS,2),'uni',0);
    y=vertcat(y{:});
    RisePlot=plot(UIAxes,x,y,...
        'o','linewidth',2,'color',[0.3020 0.3020 1]);
    hold(UIAxes,'off');


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

    
    [file,path] = uiputfile('SpikeAna.mat','save spike data')
    if file~=0
        save([path file],'FileName','signal','smoothBC_signal','FrameRate','FileName','time','swindow',...
            'pks_thr','pks_window','PKS','pksLOCS','acc_thr','lead','vel_thr','riseLOCS','upLOCS','stim');
        
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

    