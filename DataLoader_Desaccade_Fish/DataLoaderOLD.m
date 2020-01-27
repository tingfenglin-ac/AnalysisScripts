function varargout = DataLoader(varargin)
% DATALOADER M-file for DataLoader.fig
%      DATALOADER, by itself, creates a new DATALOADER or raises the existing
%      singleton*.
%
%      H = DATALOADER returns the handle to a new DATALOADER or the handle to
%      the existing singleton*.
%
%      DATALOADER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATALOADER.M with the given input arguments.
%
%      DATALOADER('Property','Value',...) creates a new DATALOADER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DataLoader_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DataLoader_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DataLoader

% Last Modified by GUIDE v2.5 09-Nov-2015 12:36:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @DataLoader_OpeningFcn, ...
    'gui_OutputFcn',  @DataLoader_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before DataLoader is made visible.
function DataLoader_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DataLoader (see VARARGIN)

% Choose default command line output for DataLoader
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%set(hObject,'WindowStyle','modal')
% UIWAIT makes DataLoader wait for user response (see UIRESUME)
% uiwait(handles.figure1);
set(handles.outputMsg,'string',sprintf('Inzializing! \n Please wait...'))

% INITIALIZATIONS of variables and gui parts
%Variables
DataStruct=struct;
%String that contain the file to load
DataStruct(1).FileName='';
%String that contain the path where the file to load is
DataStruct(1).PathName='';
%String that contain the file where the fixation trial is
DataStruct(1).ReferenceFileName='';
%String that contain the path where the file with the fixation trial is
DataStruct(1).ReferencePathName='';
% String that contain the file where the coil gains are
DataStruct(1).GainFileName ='';
% String that contain the path where the file with the coil gains is
DataStruct(1).GainPathName ='';
% Flag that control tha save satuts
DataStruct(1).saveflag=[1 1];
% Notes to be saved within the mat files (subj name, etc..)
DataStruct(1).notes='';

% Flag for chair (1) or exapod (2)
DataStruct(1).machine=4; %default is eyeSeecam (edit: defalt is chair)

fgPrep=0;
if fgPrep
    %Sampling freq requested
    DataStruct(1).undersampling=100;
    %Cut of frequency chechbox_lpfilter
    DataStruct(1).filter=40;
    set(handles.edit_subSmpl,'Enable','on');
    set(handles.edit_lpFilter,'Enable','on');
else
    %Sampling freq requested
    DataStruct(1).undersampling=0;
    %Cut of frequency chechbox_lpfilter
    DataStruct(1).filter=0;
    set(handles.edit_subSmpl,'Enable','off');
    set(handles.edit_lpFilter,'Enable','off');
end

% Structure with the data
DataStruct(1).data=struct;

% Gui parts

set(handles.checkBox_subSmpl,'Value',fgPrep);
set(handles.chechBox_lpFilter,'Value',fgPrep);


set(handles.checkbox_multipleFiles,'Enable','Off');
set(handles.edit_fixTrial,'Enable','Off');
set(handles.browseB_fixTrail,'Enable','Off');
set(handles.pushB_loadFile,'Enable','Off');
set(handles.panel_multiFiles,'Visible','Off');
set(handles.edit1_multFiles,'Enable','Off');
set(handles.edit2_multFiles,'Enable','Off');
set(handles.edit3_multFiles,'Enable','Off');
set(handles.edit4_multFiles,'Enable','Off');
set(handles.edit5_multFiles,'Enable','Off');
set(handles.edit6_multFiles,'Enable','Off');
set(handles.edit7_multFiles,'Enable','Off');
set(handles.edit8_multFiles,'Enable','Off');
set(handles.edit9_multFiles,'Enable','Off');
set(handles.edit10_multFiles,'Enable','Off');
set(handles.edit11_multFiles,'Enable','Off');
set(handles.browseB1_multFiles,'Enable','Off');
set(handles.browseB2_multFiles,'Enable','Off');
set(handles.browseB3_multFiles,'Enable','Off');
set(handles.browseB4_multFiles,'Enable','Off');
set(handles.browseB5_multFiles,'Enable','Off');
set(handles.browseB6_multFiles,'Enable','Off');
set(handles.browseB7_multFiles,'Enable','Off');
set(handles.browseB8_multFiles,'Enable','Off');
set(handles.browseB9_multFiles,'Enable','Off');
set(handles.browseB10_multFiles,'Enable','Off');
set(handles.browseB11_multFiles,'Enable','Off');

set(handles.radioB1_3DT,'Value',0);
set(handles.radioB2_exapod,'Value',0);
set(handles.radioB3_hopC,'Value',0);
set(handles.radioB4_eyeCC,'Value',1);

set(handles.outputMsg,'string',sprintf('Ready! \n Waiting for user input'))
% Save Datastruct in the handles
set(handles.figure1,'UserData',DataStruct);



% --- Outputs from this function are returned to the command line.
function varargout = DataLoader_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;






%LOAD BUTTON
% --- Executes on button press in pushB_loadFile.
function pushB_loadFile_Callback(hObject, eventdata, handles)
% hObject    handle to pushB_loadFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DataStruct=get(handles.figure1,'UserData');
set(handles.outputMsg,'string',sprintf('Loading... \n Controlling the inputs'));
pause(0.01)
clear cellfilename
i=1;z=1;skipped=[];
while i<=length(DataStruct)
    if not(isempty(DataStruct(i).FileName)) && (strcmp(DataStruct(i).FileName(end-3:end),'.bin') || DataStruct(1).machine==3 || DataStruct(1).machine==4)  %Hopkins and Eyesee cam do not use bin
        cellfilename{z}=[DataStruct(i).PathName DataStruct(i).FileName];
        z=z+1;
    elseif not(isempty(DataStruct(i).FileName))
        question=sprintf('One of the file you are loading is not labview binary file. Load anyway?');
        answer=questdlg(question,'WARNING!','yes','no','yes');
        
        if strcmp(answer,'yes')
            err=errordlg('Sorry - Not implemented jet - The file will be skipped','Ooops');
            skipped=[skipped i];
            while ishandle(err)
                pause(2)
            end
        else
            pushbutton=[2 8 9 10 11 12 13 14 15 17 18 19];
            eval(sprints('pushbutton%d_Callback(hObject, eventdata, handles)',pushbutton(i)))
            DataStruct=get(handles.figure1,'UserData');
            if strcmp(DataStruct(i).FileName(end-3:end),'.bin') && not(isempty(DataStruct(i).FileName))
                cellfilename{z}=[DataStruct(i).PathName DataStrcut(i).FileName];
                z=z+1;
            else
                skipped=[skipped i];
            end
        end
    else
        skipped=[skipped i];
    end
    i=i+1;
    
end

if not(isempty(DataStruct(1).GainFileName))
    if not(isempty(cellfilename))
        set(handles.outputMsg,'string',sprintf('Loading... \n Please wait without closing me!'))
        pause(0.01)
        
        datacell= load_dataFR(cellfilename,[DataStruct(1).GainPathName DataStruct(1).GainFileName],[],[],DataStruct(1).machine,[DataStruct(1).ReferencePathName DataStruct(1).ReferenceFileName],DataStruct(1).undersampling,DataStruct(1).filter);
        %Clear previous data in datastruct
        for ii=1:length(DataStruct)
            DataStruct(ii).data={};
        end
        
        if length(datacell)==1
            DataStruct(1).data={};
            DataStruct(1).data=datacell;
        else
            z=1;
            skipped=[skipped NaN]; % Just to have a number that avoid "index exced mat dimensione" three row below..
            for i=1:length(datacell)+length(skipped)-1 %-1 take into account the added NaN
                if i==skipped(z)
                    z=z+1;
                    DataStruct(i).data={};
                else
                    DataStruct(i).data={};
                    DataStruct(i).data=datacell{i-z+1};
                end
            end
        end
        DataStruct(1).saveflag=[0 0];
    end
elseif DataStruct(1).machine==4
    if not(isempty(DataStruct(1).ReferenceFileName))
        if not(isempty(cellfilename))
            set(handles.outputMsg,'string',sprintf('Loading... \n Please wait without closing me!'))
            pause(0.01)
            if not(isempty(DataStruct(1).PathName))
                tempdir=cd;
                cd(DataStruct(1).PathName)
            end
            question=sprintf('Do you need chair movement files (Tönnies only)?');
            answer=questdlg(question,'WARNING!','yes','no','no');
            
            if strcmp(answer,'yes')
                count=0;
                while count<length(cellfilename)
                    loadtitle=sprintf('Select the %d corresponding bin file for the chair movement and, as last one, the calibration',length(cellfilename));
                    [Correspname,CorrespPath]=uigetfile({'*.bin;','Labview binary (*.bin)';'*.mat','Matlab data (*.mat)';'*.*','All files'} ,loadtitle,'MultiSelect', 'on');
                    
                    if Correspname==0&&CorrespPath==0
                        Correspname={};
                        CorrespPath={};
                        break
                    end
                    if not(iscell(Correspname))
                        Correspname={Correspname};
                    elseif correspname==0
                        break
                    end
                    count=length(Correspname);
                end
            else
                Correspname={};
                CorrespPath={};
            end
            if not(isempty(DataStruct(1).PathName))
                cd(tempdir)
            end
            
            datacell= load_dataFR(cellfilename,[DataStruct(1).GainPathName DataStruct(1).GainFileName],[],[],DataStruct(1).machine,[DataStruct(1).ReferencePathName DataStruct(1).ReferenceFileName],DataStruct(1).undersampling, DataStruct(1).filter,Correspname,CorrespPath);
            if length(datacell)==1
                DataStruct(1).data={};
                DataStruct(1).data=datacell;
            else
                z=1;
                skipped=[skipped NaN]; % Just to have a number that avoid "index exced mat dimensione" three row below..
                for i=1:length(datacell)+length(skipped)-1 %-1 take into account the added NaN
                    if i==skipped(z)
                        z=z+1;
                        DataStruct(i).data={};
                    else
                        DataStruct(i).data={};
                        DataStruct(i).data=datacell{i-z+1};
                    end
                end
            end
            DataStruct(1).saveflag=[0 0];
        end
    else
        question=sprintf('You forgot to set the fixation file. This is needed to calibrate Eyeseecam data. Load anyway?');
        answer=questdlg(question,'WARNING!','yes','no','no');
        if  strcmp(answer,'no')
            pushbutton3_Callback(hObject, eventdata, handles);
            DataStruct=get(handles.figure1,'UserData');
        else
            err=errordlg('Sorry - Not implemented jet' ,'Ooops');
            while ishandle(err)
                pause(2)
            end
        end
    end
    
else
    question=sprintf('You forgot to set the gain file. Load anyway?');
    answer=questdlg(question,'WARNING!','yes','no','no');
    if  strcmp(answer,'no')
        pushbutton4_Callback(hObject, eventdata, handles);
        DataStruct=get(handles.figure1,'UserData');
    else
        if not(isempty(cellfilename))
            set(handles.outputMsg,'string',sprintf('Loading... \n Please wait without closing me!'))
            pause(0.01)
            datacell= load_dataFR(cellfilename,[DataStruct(1).GainPathName DataStruct(1).GainFileName],[],[],DataStruct(1).machine,[DataStruct(1).ReferencePathName DataStruct(1).ReferenceFileName],DataStruct(1).undersampling, DataStruct(1).filter);
            if length(datacell)==1
                DataStruct(1).data={};
                DataStruct(1).data=datacell;
            else
                z=1;
                skipped=[skipped NaN]; % Just to have a number that avoid "index exced mat dimensione" three row below..
                for i=1:length(datacell)+length(skipped)-1 %-1 take into account the added NaN
                    if i==skipped(z)
                        z=z+1;
                        DataStruct(i).data={};
                    else
                        DataStruct(i).data={};
                        DataStruct(i).data=datacell{i-z+1};
                    end
                end
            end
            DataStruct(1).saveflag=[0 0];
        end
    end
    
end
set(handles.outputMsg,'string',sprintf('Ready! \n Waiting for user input'))
pause(0.01)
set(handles.figure1,'UserData',DataStruct);





% EDIT of the datafile that have to be loaded (LOAD STRING)
function edit_1stFile_Callback(hObject, eventdata, handles)
% hObject    handle to edit_1stFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Hints: get(hObject,'String') returns contents of edit_1stFile as text
%        str2double(get(hObject,'String')) returns contents of edit_1stFile as a double
DataStruct=get(handles.figure1,'UserData');
set(handles.outputMsg,'string',sprintf('Managing your request \n Checking inputs..'))
pause(0.01)
DataStruct(1).FileName = get(hObject,'String');
if isempty(DataStruct(1).FileName)
    DataStruct(1).FileName='';
end
if length(DataStruct(1).FileName)>3 && strcmp(DataStruct(1).FileName(2:3),':\')
    slashes=findstr(DataStruct(1).FileName, '\');
    DataStruct(1).PathName=DataStruct(1).FileName(1:slashes(end));
    DataStruct(1).FileName=DataStruct(1).FileName(slashes(end)+1:end);
else
    DataStruct(1).PathName=[cd '\'];
end
if isempty(DataStruct(1).FileName)
    DataStruct(1).PathName='';
end
if (length(DataStruct(1).FileName)<5 || (not(strcmp(DataStruct(1).FileName(end-3:end-3),'.')) ...
        && not(strcmp(DataStruct(1).FileName(end-2:end-2),'.')) ...
        && not(strcmp(DataStruct(1).FileName(end-1:end-1),'.'))))...
        && not(strcmp(DataStruct(1).FileName,''))
    
    DataStruct(1).FileName=[DataStruct(1).FileName '.bin'];
    set(handles.edit_1stFile,'String',DataStruct(1).FileName);
end
if isempty(dir([DataStruct(1).PathName DataStruct(1).FileName])) && not(strcmp(DataStruct(1).FileName,''))
    err=errordlg('File not found','File Error');
    while ishandle(err)
        pause(2)
    end
    pushbutton2_Callback(hObject, eventdata, handles)
    
    DataStruct=get(handles.figure1,'UserData');
elseif not(isempty(DataStruct(1).FileName))
    set(handles.outputMsg,'string',sprintf('Searching the correct gain file..'))
    pause(0.01)
    a = dir(DataStruct(1).PathName);
    for ax = 1:length(a)
        if(~isempty(regexp(a(ax).name, 'g*.m', 'once')) && ...
                strcmp(a(ax).name(end), 'm'))
            if strcmp(DataStruct(1).GainFileName,'')
                DataStruct(1).GainFileName = [char(a(ax).name)];
                DataStruct(1).GainPathName = DataStruct(1).PathName;
            elseif not(strcmp([DataStruct(1).GainPathName DataStruct(1).GainFileName],...
                    [DataStruct(1).GainPathName char(a(ax).name)]))
                question=sprintf('I have found another calibration file that is from the same folder of the data file. Do you want to use this or keep the current one?');
                answer=questdlg(question,'WARNING!','Use it','Keep mine','Use it');
                if strcmp(answer,'Use it')
                    DataStruct(1).GainFileName = [char(a(ax).name)];
                    DataStruct(1).GainPathName = DataStruct(1).PathName;
                end
            end
        end
    end
    clear a ax
    if strcmp(DataStruct(1).GainPathName,[cd '\'])
        set(handles.edit_CoilCal,'String',[DataStruct(1).GainFileName]);
    else
        set(handles.edit_CoilCal,'String',[DataStruct(1).GainPathName DataStruct(1).GainFileName]);
    end
end
if (strcmp(DataStruct(1).FileName,''))
    set(handles.pushB_loadFile,'Enable','Off');
else
    set(handles.pushB_loadFile,'Enable','On');
    set(handles.checkbox_multipleFiles,'Enable','On');
end

set(handles.outputMsg,'string',sprintf('Ready! \n Waiting for user input'))
pause(0.01)
set(handles.figure1,'UserData',DataStruct);



% --- Executes during object creation, after setting all properties.
function edit_1stFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_1stFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% Data file BROWSE BUTTON
function browseB_1stFile_Callback(hObject, eventdata, handles)
% hObject    handle to browseB_1stFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DataStruct=get(handles.figure1,'UserData');
set(handles.outputMsg,'string',sprintf('Loading the browsing windows...'))
pause(0.01)
Temp=struct;
Temp.FileName=DataStruct(1).FileName; Temp.PathName=DataStruct(1).PathName;
set(handles.outputMsg,'string',sprintf('Waiting your selection...'))
pause(0.01)
if DataStruct(1).machine==4
    [DataStruct(1).FileName,DataStruct(1).PathName] = uigetfile({'*.mat;','Matlab data (*.mat)';'*.bin','Labview binary (*.bin)';'*.*','All files'} ,'Select the data file', '..\..\..\..\Alcohol_GazeHolding_Data\');
else
    [DataStruct(1).FileName,DataStruct(1).PathName] = uigetfile({'*.bin;','Labview binary (*.bin)';'*.mat','Matlab data (*.mat)';'*.*','All files'} ,'Select the data file');
end
set(handles.outputMsg,'string',sprintf('Checking inputs..'))
pause(0.01)
if not(DataStruct(1).FileName==0)
    if strcmp(DataStruct(1).PathName,[cd '\'])
        set(handles.edit_1stFile,'String',DataStruct(1).FileName);
    else
        set(handles.edit_1stFile,'String',[DataStruct(1).PathName DataStruct(1).FileName]);
    end
    a = dir(DataStruct(1).PathName);
    for ax = 1:length(a)
        set(handles.outputMsg,'string',sprintf('Searching the correct gain file..'))
        pause(0.01)
        if(~isempty(regexp(a(ax).name, 'g*.m', 'once')) && ...
                strcmp(a(ax).name(end), 'm'))
            if strcmp(DataStruct(1).GainFileName,'')
                DataStruct(1).GainFileName = [char(a(ax).name)];
                DataStruct(1).GainPathName = DataStruct(1).PathName;
            elseif not(strcmp([DataStruct(1).GainPathName DataStruct(1).GainFileName],...
                    [DataStruct(1).GainPathName char(a(ax).name)]))
                question=sprintf('I have found another calibration file that is from the same folder of the data file. Do you want to use this or keep the current one?');
                answer=questdlg(question,'WARNING!','Use it','Keep mine','Use it');
                if strcmp(answer,'Use it')
                    DataStruct(1).GainFileName = [char(a(ax).name)];
                    DataStruct(1).GainPathName = DataStruct(1).PathName;
                end
            end
        end
    end
    clear a ax
    if strcmp(DataStruct(1).GainPathName,[cd '\'])
        set(handles.edit_CoilCal,'String',[DataStruct(1).GainFileName]);
    else
        set(handles.edit_CoilCal,'String',[DataStruct(1).GainPathName DataStruct(1).GainFileName]);
    end
    
else
    DataStruct(1).FileName=Temp.FileName; DataStruct(1).PathName=Temp.PathName;
    if strcmp(DataStruct(1).PathName,[cd '\'])
        set(handles.edit_1stFile,'String',DataStruct(1).FileName);
    else
        set(handles.edit_1stFile,'String',[DataStruct(1).PathName DataStruct(1).FileName]);
    end
end
clear Temp

if not(strcmp(DataStruct(1).FileName,''))
    set(handles.pushB_loadFile,'Enable','On');
    set(handles.checkbox_multipleFiles,'Enable','On');
else
    set(handles.pushB_loadFile,'Enable','Off');
end

set(handles.outputMsg,'string',sprintf('Ready! \n Waiting for user input'))
pause(0.01)
set(handles.figure1,'UserData',DataStruct);





% EDIT of the datafile that have contains fixation trial
function edit_fixTrial_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fixTrial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_fixTrial as text
%        str2double(get(hObject,'String')) returns contents of edit_fixTrial as a double
DataStruct=get(handles.figure1,'UserData');
set(handles.outputMsg,'string',sprintf('Managing your request \n Checking inputs..'))
pause(0.01)
DataStruct(1).ReferenceFileName = get(hObject,'String');
if isempty(DataStruct(1).ReferenceFileName)
    DataStruct(1).ReferenceFileName='';
end
if length(DataStruct(1).ReferenceFileName)>3 && strcmp(DataStruct(1).ReferenceFileName(2:3),':\')
    slashes=findstr(DataStruct(1).ReferenceFileName, '\');
    DataStruct(1).ReferencePathName=DataStruct(1).ReferenceFileName(1:slashes(end));
    DataStruct(1).ReferenceFileName=DataStruct(1).ReferenceFileName(slashes(end)+1:end);
else
    DataStruct(1).ReferencePathName=[cd '\'];
end
if isempty(DataStruct(1).ReferenceFileName)
    DataStruct(1).ReferencePathName='';
end


if (length(DataStruct(1).ReferenceFileName)<5 || (not(strcmp(DataStruct(1).FileName(end-3:end-3),'.')) ...
        && not(strcmp(DataStruct(1).FileName(end-2:end-2),'.')) ...
        && not(strcmp(DataStruct(1).FileName(end-1:end-1),'.'))))...
        && not(strcmp(DataStruct(1).FileName,''))
    
    DataStruct(1).ReferenceFileName=[DataStruct(1).ReferenceFileName '.bin'];
    set(handles.edit_fixTrial,'String',DataStruct(1).ReferenceFileName);
end
if isempty(dir([DataStruct(1).ReferencePathName DataStruct(1).ReferenceFileName]))...
        && not(strcmp(DataStruct(1).ReferenceFileName,''))
    
    err=errordlg('File not found','File Error');
    while ishandle(err)
        pause(2)
    end
    pushbutton3_Callback(hObject, eventdata, handles)
    DataStruct=get(handles.figure1,'UserData');
end
set(handles.outputMsg,'string',sprintf('Ready! \n Waiting for user input'))
pause(0.01)
set(handles.figure1,'UserData',DataStruct);




% --- Executes during object creation, after setting all properties.
function edit_fixTrial_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fixTrial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% BROWSE button for the fixation trial file
function browseB_fixTrail_Callback(hObject, eventdata, handles)
% hObject    handle to browseB_fixTrail (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DataStruct=get(handles.figure1,'UserData');
set(handles.outputMsg,'string',sprintf('Loading the browsing windows..'))
pause(0.01)
Temp=struct;
Temp.FileName=DataStruct(1).ReferenceFileName; Temp.PathName=DataStruct(1).ReferencePathName;
set(handles.outputMsg,'string',sprintf('Waiting your selection..'))
pause(0.01)
if not(isempty(DataStruct(1).PathName))
    tempdir=cd;
    cd(DataStruct(1).PathName)
end

if DataStruct(1).machine==4
    [DataStruct(1).ReferenceFileName,DataStruct(1).ReferencePathName] = uigetfile({'*.mat;','Labview binary (*.bin)';'*.mat','Matlab data (*.mat)';'*.*','All files'} ,'Select the data file with the fixation trial');
else
    [DataStruct(1).ReferenceFileName,DataStruct(1).ReferencePathName] = uigetfile({'*.bin;','Labview binary (*.bin)';'*.mat','Matlab data (*.mat)';'*.*','All files'} ,'Select the data file with the fixation trial');
end

if not(isempty(DataStruct(1).PathName))
    cd(tempdir)
end

set(handles.outputMsg,'string',sprintf('Checking inputs..'))
pause(0.01)
if strcmp(DataStruct(1).ReferencePathName,[cd '\'])
    set(handles.edit_fixTrial,'String',DataStruct(1).ReferenceFileName);
elseif not(DataStruct(1).ReferencePathName==0)
    set(handles.edit_fixTrial,'String',[DataStruct(1).ReferencePathName DataStruct(1).ReferenceFileName]);
end
if DataStruct(1).ReferenceFileName==0
    DataStruct(1).ReferenceFileName=Temp.FileName; DataStruct(1).ReferencePathName=Temp.PathName;
    if strcmp(DataStruct(1).ReferencePathName,[cd '\'])
        set(handles.edit_fixTrial,'String',DataStruct(1).ReferenceFileName);
    else
        set(handles.edit_fixTrial,'String',[DataStruct(1).ReferencePathName DataStruct(1).ReferenceFileName]);
    end
end
clear Temp
set(handles.outputMsg,'string',sprintf('Ready! \n Waiting for user input'))
pause(0.01)
set(handles.figure1,'UserData',DataStruct);

% CheckBox that control fixation trial edit
function checkbox_fixTrial_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_fixTrial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_fixTrial
DataStruct=get(handles.figure1,'UserData');
set(handles.outputMsg,'string',sprintf('Activating fixation trial dialog and button...'))
pause(0.01)
if get(hObject,'Value')
    set(handles.edit_fixTrial,'Enable','On');
    set(handles.browseB_fixTrail,'Enable','On')
else
    set(handles.edit_fixTrial,'Enable','Off');
    set(handles.browseB_fixTrail,'Enable','Off')
end
set(handles.outputMsg,'string',sprintf('Ready! \n Waiting for user input'))
pause(0.01)
set(handles.figure1,'UserData',DataStruct);


function edit_CoilCal_Callback(hObject, eventdata, handles)
% hObject    handle to edit_CoilCal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_CoilCal as text
%        str2double(get(hObject,'String')) returns contents of edit_CoilCal as a double
DataStruct=get(handles.figure1,'UserData');
set(handles.outputMsg,'string',sprintf('Managing your request \n Checking inputs...'))
pause(0.01)
DataStruct(1).GainFileName = get(hObject,'String');
if isempty(DataStruct(1).GainFileName)
    DataStruct(1).GainFileName='';
end
if length(DataStruct(1).GainFileName)>3 && strcmp(DataStruct(1).GainFileName(2:3),':\')
    slashes=findstr(DataStruct(1).GainFileName, '\');
    DataStruct(1).GainPathName=DataStruct(1).GainFileName(1:slashes(end));
    DataStruct(1).GainFileName=DataStruct(1).GainFileName(slashes(end)+1:end);
else
    DataStruct(1).GainPathName=[cd '\'];
end
if isempty(DataStruct(1).GainFileName)
    DataStruct(1).GainPathName='';
end

if (length(DataStruct(1).GainFileName)<3 ...
        || not(strcmp(DataStruct(1).GainFileName(end-1:end),'.m')))...
        && not(strcmp(DataStruct(1).GainFileName,''))
    
    DataStruct(1).GainFileName=[DataStruct(1).GainFileName '.m'];
    set(handles.edit_CoilCal,'String',DataStruct(1).GainFileName);
end
if isempty(dir([DataStruct(1).GainPathName DataStruct(1).GainFileName])) &&...
        not(strcmp(DataStruct(1).GainFileName,''))
    
    err=errordlg('File not found','File Error');
    while ishandle(err)
        pause(2)
    end
    pushbutton4_Callback(hObject, eventdata, handles)
    DataStruct=get(handles.figure1,'UserData');
elseif not(strcmp(DataStruct(1).GainFileName,''))
    set(handles.outputMsg,'string',sprintf('Searching if there are calib files in the selected file directory...'))
    pause(0.01)
    a = dir(DataStruct(1).PathName);
    for ax = 1:length(a)
        if(~isempty(regexp(a(ax).name, 'g*.m', 'once')) && ...
                strcmp(a(ax).name(end), 'm'))
            if strcmp(DataStruct(1).GainFileName,'')
                DataStruct(1).GainFileName = [char(a(ax).name)];
                DataStruct(1).GainPathName = DataStruct(1).PathName;
            elseif not(strcmp([DataStruct(1).GainPathName DataStruct(1).GainFileName],...
                    [DataStruct(1).GainPathName char(a(ax).name)]))
                question=sprintf('I have found another calibration file that is from the same folder of the data file. Do you want to use this or keep the current one?');
                answer=questdlg(question,'WARNING!','Use it','Keep mine','Use it');
                if strcmp(answer,'Use it')
                    DataStruct(1).GainFileName = [char(a(ax).name)];
                    DataStruct(1).GainPathName = DataStruct(1).PathName;
                end
            end
        end
    end
    clear a ax
    if strcmp(DataStruct(1).GainPathName,[cd '\'])
        set(handles.edit_CoilCal,'String',[DataStruct(1).GainFileName]);
    else
        set(handles.edit_CoilCal,'String',[DataStruct(1).GainPathName DataStruct(1).GainFileName]);
    end
end
set(handles.outputMsg,'string',sprintf('Ready! \n Waiting for user input'))
pause(0.01)
set(handles.figure1,'UserData',DataStruct);



% --- Executes during object creation, after setting all properties.
function edit_CoilCal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_CoilCal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- BROWSE for COIL CALIBRATION FILE
function browseB_CoilCal_Callback(hObject, eventdata, handles)
% hObject    handle to browseB_CoilCal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

DataStruct=get(handles.figure1,'UserData');
set(handles.outputMsg,'string',sprintf('Loading browsing windows...'))
pause(0.01)

Temp=struct;
Temp.FileName=DataStruct(1).GainFileName; Temp.PathName=DataStruct(1).GainPathName;
set(handles.outputMsg,'string',sprintf('Waiting for your selection...'))
pause(0.01)

if not(isempty(DataStruct(1).PathName))
    tempdir=cd;
    cd(DataStruct(1).PathName)
end


[DataStruct(1).GainFileName,DataStruct(1).GainPathName] = uigetfile({'*.m;','Matlab files (*.m)';} ,'Select the data file with the coil calibration data');
set(handles.outputMsg,'string',sprintf('Checking inputs..'))
if not(isempty(DataStruct(1).PathName))
    cd(tempdir)
end
pause(0.01)
if not(DataStruct(1).GainFileName==0)
    a = dir(DataStruct(1).PathName);
    for ax = 1:length(a)
        if(~isempty(regexp(a(ax).name, 'g*.m', 'once')) && ...
                strcmp(a(ax).name(end), 'm'))
            if strcmp(DataStruct(1).GainFileName,'')
                DataStruct(1).GainFileName = [char(a(ax).name)];
                DataStruct(1).GainPathName = DataStruct(1).PathName;
            elseif not(strcmp([DataStruct(1).GainPathName DataStruct(1).GainFileName],...
                    [DataStruct(1).GainPathName char(a(ax).name)]))
                question=sprintf('I have found another calibration file that is from the same folder of the data file. Do you want to use this or keep the current one?');
                answer=questdlg(question,'WARNING!','Use it','Keep mine','Use it');
                if strcmp(answer,'Use it')
                    DataStruct(1).GainFileName = [char(a(ax).name)];
                    DataStruct(1).GainPathName = DataStruct(1).PathName;
                end
            end
        end
    end
    clear a ax
    if strcmp(DataStruct(1).GainPathName,[cd '\'])
        set(handles.edit_CoilCal,'String',[DataStruct(1).GainFileName]);
    else
        set(handles.edit_CoilCal,'String',[DataStruct(1).GainPathName DataStruct(1).GainFileName]);
    end
else
    DataStruct(1).GainFileName=Temp.FileName; DataStruct(1).GainPathName=Temp.PathName;
    if strcmp(DataStruct(1).GainPathName,[cd '\'])
        set(handles.edit_CoilCal,'String',DataStruct(1).GainFileName);
    else
        set(handles.edit_CoilCal,'String',[DataStruct(1).GainPathName DataStruct(1).GainFileName]);
    end
end
clear Temp
set(handles.outputMsg,'string',sprintf('Ready! \n Waiting for user input'))
pause(0.01)
set(handles.figure1,'UserData',DataStruct);


% --- Executes on button press in pushB_manualSetCoil.
function pushB_manualSetCoil_Callback(hObject, eventdata, handles)
% hObject    handle to pushB_manualSetCoil (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

DataStruct=get(handles.figure1,'UserData');
err=errordlg('Sorry - Not implemented jet','Ooops');
while ishandle(err)
    pause(2)
end
set(handles.outputMsg,'string',sprintf('Ready! \n Waiting for user input'))
pause(0.01)
set(handles.figure1,'UserData',DataStruct);






function edit1_multFiles_Callback(hObject, eventdata, handles)
% hObject    handle to edit1_multFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1_multFiles as text
%        str2double(get(hObject,'String')) returns contents of edit1_multFiles as a double
DataStruct=get(handles.figure1,'UserData');
set(handles.outputMsg,'string',sprintf('Managing your request \n Checking inputs..'))
pause(0.01)
DataStruct(2).FileName = get(hObject,'String');
if isempty(DataStruct(2).FileName)
    DataStruct(2).FileName='';
end
if length(DataStruct(2).FileName)>3 && strcmp(DataStruct(2).FileName(2:3),':\')
    slashes=findstr(DataStruct(2).FileName, '\');
    DataStruct(2).PathName=DataStruct(2).FileName(1:slashes(end));
    DataStruct(2).FileName=DataStruct(2).FileName(slashes(end)+1:end);
else
    DataStruct(2).PathName=[cd '\'];
end
if isempty(DataStruct(2).FileName)
    DataStruct(2).PathName='';
end
if (length(DataStruct(2).FileName)<5 || (not(strcmp(DataStruct(2).FileName(end-3:end-3),'.')) ...
        && not(strcmp(DataStruct(2).FileName(end-2:end-2),'.')) ...
        && not(strcmp(DataStruct(2).FileName(end-1:end-1),'.'))))...
        && not(strcmp(DataStruct(2).FileName,''))
    
    DataStruct(2).FileName=[DataStruct(2).FileName '.bin'];
    set(handles.edit1_multFiles,'String',DataStruct(2).FileName);
end
if isempty(dir([DataStruct(2).PathName DataStruct(2).FileName])) && not(strcmp(DataStruct(2).FileName,''))
    err=errordlg('File not found','File Error');
    while ishandle(err)
        pause(2)
    end
    pushbutton8_Callback(hObject, eventdata, handles)
    
    DataStruct=get(handles.figure1,'UserData');
else
    set(handles.edit2_multFiles,'Enable','On');
    set(handles.browseB2_multFiles,'Enable','On');
end
set(handles.outputMsg,'string',sprintf('Ready! \n Waiting for user input'))
pause(0.01)
set(handles.figure1,'UserData',DataStruct);


% --- Executes during object creation, after setting all properties.
function edit1_multFiles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1_multFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browseB1_multFiles.
function browseB1_multFiles_Callback(hObject, eventdata, handles)
% hObject    handle to browseB1_multFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DataStruct=get(handles.figure1,'UserData');

set(handles.outputMsg,'string',sprintf('Loading browsing windows...'))
pause(0.01)
if length(DataStruct)<2
    DataStruct(2).FileName='';
end
Temp=struct;
Temp.FileName=DataStruct(2).FileName; Temp.PathName=DataStruct(2).PathName;
set(handles.outputMsg,'string',sprintf('Waiting for your selection...'))
pause(0.01)

if not(isempty(DataStruct(1).PathName))
    tempdir=cd;
    cd(DataStruct(1).PathName)
end
if DataStruct(1).machine==4
    [temp_FileName,temp_PathName,filtIdx] = uigetfile({'*.mat;','Matlab data (*.mat)';'*.bin','Labview binary (*.bin)';'*.*','All files'} ,'Select the data file','MultiSelect','on');
    
else
    [temp_FileName,temp_PathName,filtIdx] = uigetfile({'*.bin;','Labview binary (*.bin)';'*.mat','Matlab data (*.mat)';'*.*','All files'} ,'Select the data file');
end

set(handles.outputMsg,'string',sprintf('Checking inputs..'))

if not(isempty(DataStruct(1).PathName))
    cd(tempdir)
end
pause(0.01)
nMax=10; %maxium number of
if filtIdx~=0
    if ~iscell(temp_FileName)
        temp_FileName={temp_FileName};
    end
    dim=size(temp_FileName,2)* double(size(temp_FileName,2)<= nMax) + nMax*double(size(temp_FileName,2)> nMax);
    %DataStruct(2).FileName
    for k=1:dim
        
        if strcmp(temp_PathName,[cd '\'])
            set(handles.(['edit',num2str(k),'_multFiles']),'String',temp_FileName{k});
        else
            set(handles.(['edit',num2str(k),'_multFiles']),'String',[temp_PathName, temp_FileName{k}]);
        end
        set(handles.(['edit',num2str(k+1),'_multFiles']),'Enable','On');
        set(handles.(['browseB',num2str(k+1),'_multFiles']),'Enable','On');
        
        DataStruct(k+1).FileName=temp_FileName{k}; DataStruct(k+1).PathName=temp_PathName;
    end
    if size(temp_FileName,2)> nMax
        if strcmp(temp_PathName,[cd '\'])
            set(handles.(['edit',num2str(dim+1),'_multFiles']),'String',temp_FileName{dim+1});
        else
            set(handles.(['edit',num2str(dim+1),'_multFiles']),'String',[temp_PathName, temp_FileName{dim+1}]);
        end
    end
else
    DataStruct(2).FileName=Temp.FileName; DataStruct(2).PathName=Temp.PathName;
    if strcmp(DataStruct(2).PathName,[cd '\'])
        set(handles.edit1_multFiles,'String',DataStruct(2).FileName);
    else
        set(handles.edit1_multFiles,'String',[DataStruct(2).PathName DataStruct(2).FileName]);
    end
end
clear Temp
set(handles.outputMsg,'string',sprintf('Ready! \n Waiting for user input'))
pause(0.01)
set(handles.figure1,'UserData',DataStruct);

function edit2_multFiles_Callback(hObject, eventdata, handles)
% hObject    handle to edit2_multFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2_multFiles as text
%        str2double(get(hObject,'String')) returns contents of edit2_multFiles as a double
DataStruct=get(handles.figure1,'UserData');
set(handles.outputMsg,'string',sprintf('Managing your request \n Checking inputs..'))
pause(0.01)

DataStruct(3).FileName = get(hObject,'String');
if isempty(DataStruct(3).FileName)
    DataStruct(3).FileName='';
end
if length(DataStruct(3).FileName)>3 && strcmp(DataStruct(3).FileName(2:3),':\')
    slashes=findstr(DataStruct(3).FileName, '\');
    DataStruct(3).PathName=DataStruct(3).FileName(1:slashes(end));
    DataStruct(3).FileName=DataStruct(3).FileName(slashes(end)+1:end);
else
    DataStruct(3).PathName=[cd '\'];
end
if isempty(DataStruct(3).FileName)
    DataStruct(3).PathName='';
end
if (length(DataStruct(3).FileName)<5 || (not(strcmp(DataStruct(3).FileName(end-3:end-3),'.')) ...
        && not(strcmp(DataStruct(3).FileName(end-2:end-2),'.')) ...
        && not(strcmp(DataStruct(3).FileName(end-1:end-1),'.'))))...
        && not(strcmp(DataStruct(3).FileName,''))
    
    DataStruct(3).FileName=[DataStruct(3).FileName '.bin'];
    set(handles.edit2_multFiles,'String',DataStruct(3).FileName);
end
if isempty(dir([DataStruct(3).PathName DataStruct(3).FileName])) && not(strcmp(DataStruct(3).FileName,''))
    err=errordlg('File not found','File Error');
    while ishandle(err)
        pause(2)
    end
    pushbutton9_Callback(hObject, eventdata, handles)
    
    DataStruct=get(handles.figure1,'UserData');
else
    set(handles.edit3_multFiles,'Enable','On');
    set(handles.browseB3_multFiles,'Enable','On');
end
set(handles.outputMsg,'string',sprintf('Ready! \n Waiting for user input'))
pause(0.01)
set(handles.figure1,'UserData',DataStruct);

% --- Executes during object creation, after setting all properties.
function edit2_multFiles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2_multFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browseB2_multFiles.
function browseB2_multFiles_Callback(hObject, eventdata, handles)
% hObject    handle to browseB2_multFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

DataStruct=get(handles.figure1,'UserData');

set(handles.outputMsg,'string',sprintf('Loading browsing windows...'))
pause(0.01)
if length(DataStruct)<3
    DataStruct(3).FileName='';
end
Temp=struct;
Temp.FileName=DataStruct(3).FileName; Temp.PathName=DataStruct(3).PathName;
set(handles.outputMsg,'string',sprintf('Waiting for your selection...'))
pause(0.01)
if not(isempty(DataStruct(1).PathName))
    tempdir=cd;
    cd(DataStruct(1).PathName)
end

if DataStruct(1).machine==4
    [DataStruct(3).FileName,DataStruct(3).PathName] = uigetfile({'*.mat;','Matlab data (*.mat)';'*.bin','Labview binary (*.bin)';'*.*','All files'} ,'Select the data file');
else
    [DataStruct(3).FileName,DataStruct(3).PathName] = uigetfile({'*.bin;','Labview binary (*.bin)';'*.mat','Matlab data (*.mat)';'*.*','All files'} ,'Select the data file');
end

set(handles.outputMsg,'string',sprintf('Checking inputs..'))
pause(0.01)
if not(isempty(DataStruct(1).PathName))
    cd(tempdir)
end

if not(DataStruct(3).FileName==0)
    if strcmp(DataStruct(3).PathName,[cd '\'])
        set(handles.edit2_multFiles,'String',DataStruct(3).FileName);
    else
        set(handles.edit2_multFiles,'String',[DataStruct(3).PathName DataStruct(3).FileName]);
    end
    set(handles.edit3_multFiles,'Enable','On');
    set(handles.browseB3_multFiles,'Enable','On');
    
else
    DataStruct(3).FileName=Temp.FileName; DataStruct(3).PathName=Temp.PathName;
    if strcmp(DataStruct(3).PathName,[cd '\'])
        set(handles.edit2_multFiles,'String',DataStruct(3).FileName);
    else
        set(handles.edit2_multFiles,'String',[DataStruct(3).PathName DataStruct(3).FileName]);
    end
end
clear Temp
set(handles.outputMsg,'string',sprintf('Ready! \n Waiting for user input'))
pause(0.01)
set(handles.figure1,'UserData',DataStruct);

function edit3_multFiles_Callback(hObject, eventdata, handles)
% hObject    handle to edit3_multFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3_multFiles as text
%        str2double(get(hObject,'String')) returns contents of edit3_multFiles as a double
DataStruct=get(handles.figure1,'UserData');
set(handles.outputMsg,'string',sprintf('Managing your request \n Checking inputs..'))
pause(0.01)
DataStruct(4).FileName = get(hObject,'String');
if isempty(DataStruct(4).FileName)
    DataStruct(4).FileName='';
end
if length(DataStruct(4).FileName)>3 && strcmp(DataStruct(4).FileName(2:3),':\')
    slashes=findstr(DataStruct(4).FileName, '\');
    DataStruct(4).PathName=DataStruct(4).FileName(1:slashes(end));
    DataStruct(4).FileName=DataStruct(4).FileName(slashes(end)+1:end);
else
    DataStruct(4).PathName=[cd '\'];
end
if isempty(DataStruct(4).FileName)
    DataStruct(4).PathName='';
end
if (length(DataStruct(4).FileName)<5 || (not(strcmp(DataStruct(4).FileName(end-3:end-3),'.')) ...
        && not(strcmp(DataStruct(4).FileName(end-2:end-2),'.')) ...
        && not(strcmp(DataStruct(4).FileName(end-1:end-1),'.'))))...
        && not(strcmp(DataStruct(4).FileName,''))
    
    DataStruct(4).FileName=[DataStruct(4).FileName '.bin'];
    set(handles.edit3_multFiles,'String',DataStruct(4).FileName);
end
if isempty(dir([DataStruct(4).PathName DataStruct(4).FileName])) && not(strcmp(DataStruct(4).FileName,''))
    err=errordlg('File not found','File Error');
    while ishandle(err)
        pause(2)
    end
    pushbutton10_Callback(hObject, eventdata, handles)
    
    DataStruct=get(handles.figure1,'UserData');
else
    set(handles.edit4_multFiles,'Enable','On');
    set(handles.browseB4_multFiles,'Enable','On');
end
set(handles.outputMsg,'string',sprintf('Ready! \n Waiting for user input'))
pause(0.01)
set(handles.figure1,'UserData',DataStruct);

% --- Executes during object creation, after setting all properties.
function edit3_multFiles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3_multFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browseB3_multFiles.
function browseB3_multFiles_Callback(hObject, eventdata, handles)
% hObject    handle to browseB3_multFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DataStruct=get(handles.figure1,'UserData');

set(handles.outputMsg,'string',sprintf('Loading browsing windows...'))
pause(0.01)
if length(DataStruct)<4
    DataStruct(4).FileName='';
end
Temp=struct;
Temp.FileName=DataStruct(4).FileName; Temp.PathName=DataStruct(4).PathName;
set(handles.outputMsg,'string',sprintf('Waiting for your selection...'))
pause(0.01)

if not(isempty(DataStruct(1).PathName))
    tempdir=cd;
    cd(DataStruct(1).PathName)
end

if DataStruct(1).machine==4
    [DataStruct(4).FileName,DataStruct(4).PathName] = uigetfile({'*.mat;','Matlab data (*.mat)';'*.bin','Labview binary (*.bin)';'*.*','All files'} ,'Select the data file');
else
    [DataStruct(4).FileName,DataStruct(4).PathName] = uigetfile({'*.bin;','Labview binary (*.bin)';'*.mat','Matlab data (*.mat)';'*.*','All files'} ,'Select the data file');
end

set(handles.outputMsg,'string',sprintf('Checking inputs..'))
pause(0.01)

if not(isempty(DataStruct(1).PathName))
    cd(tempdir)
end

if not(DataStruct(4).FileName==0)
    if strcmp(DataStruct(4).PathName,[cd '\'])
        set(handles.edit3_multFiles,'String',DataStruct(4).FileName);
    else
        set(handles.edit3_multFiles,'String',[DataStruct(4).PathName DataStruct(4).FileName]);
    end
    set(handles.edit4_multFiles,'Enable','On');
    set(handles.browseB4_multFiles,'Enable','On');
    
else
    DataStruct(4).FileName=Temp.FileName; DataStruct(4).PathName=Temp.PathName;
    if strcmp(DataStruct(4).PathName,[cd '\'])
        set(handles.edit3_multFiles,'String',DataStruct(4).FileName);
    else
        set(handles.edit3_multFiles,'String',[DataStruct(4).PathName DataStruct(4).FileName]);
    end
end
clear Temp
set(handles.outputMsg,'string',sprintf('Ready! \n Waiting for user input'))
pause(0.01)
set(handles.figure1,'UserData',DataStruct);


function edit4_multFiles_Callback(hObject, eventdata, handles)
% hObject    handle to edit4_multFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4_multFiles as text
%        str2double(get(hObject,'String')) returns contents of edit4_multFiles as a double
DataStruct=get(handles.figure1,'UserData');
set(handles.outputMsg,'string',sprintf('Managing your request \n Checking inputs..'))
pause(0.01)

DataStruct(5).FileName = get(hObject,'String');
if isempty(DataStruct(5).FileName)
    DataStruct(5).FileName='';
end
if length(DataStruct(5).FileName)>3 && strcmp(DataStruct(5).FileName(2:3),':\')
    slashes=findstr(DataStruct(5).FileName, '\');
    DataStruct(5).PathName=DataStruct(5).FileName(1:slashes(end));
    DataStruct(5).FileName=DataStruct(5).FileName(slashes(end)+1:end);
else
    DataStruct(5).PathName=[cd '\'];
end
if isempty(DataStruct(5).FileName)
    DataStruct(5).PathName='';
end
if (length(DataStruct(5).FileName)<5 || (not(strcmp(DataStruct(5).FileName(end-3:end-3),'.')) ...
        && not(strcmp(DataStruct(5).FileName(end-2:end-2),'.')) ...
        && not(strcmp(DataStruct(5).FileName(end-1:end-1),'.'))))...
        && not(strcmp(DataStruct(5).FileName,''))
    
    DataStruct(5).FileName=[DataStruct(5).FileName '.bin'];
    set(handles.edit4_multFiles,'String',DataStruct(5).FileName);
end
if isempty(dir([DataStruct(5).PathName DataStruct(5).FileName])) && not(strcmp(DataStruct(5).FileName,''))
    err=errordlg('File not found','File Error');
    while ishandle(err)
        pause(2)
    end
    pushbutton11_Callback(hObject, eventdata, handles)
    
    DataStruct=get(handles.figure1,'UserData');
else
    set(handles.edit5_multFiles,'Enable','On');
    set(handles.browseB5_multFiles,'Enable','On');
end
set(handles.outputMsg,'string',sprintf('Ready! \n Waiting for user input'))
pause(0.01)
set(handles.figure1,'UserData',DataStruct);

% --- Executes during object creation, after setting all properties.
function edit4_multFiles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4_multFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browseB4_multFiles.
function browseB4_multFiles_Callback(hObject, eventdata, handles)
% hObject    handle to browseB4_multFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DataStruct=get(handles.figure1,'UserData');

set(handles.outputMsg,'string',sprintf('Loading browsing windows...'))
pause(0.01)
if length(DataStruct)<5
    DataStruct(5).FileName='';
end
Temp=struct;
Temp.FileName=DataStruct(5).FileName; Temp.PathName=DataStruct(5).PathName;
set(handles.outputMsg,'string',sprintf('Waiting for your selection...'))
pause(0.01)
if not(isempty(DataStruct(1).PathName))
    tempdir=cd;
    cd(DataStruct(1).PathName)
end

if DataStruct(1).machine==4
    [DataStruct(5).FileName,DataStruct(5).PathName] = uigetfile({'*.mat;','Matlab data (*.mat)';'*.bin','Labview binary (*.bin)';'*.*','All files'} ,'Select the data file');
else
    [DataStruct(5).FileName,DataStruct(5).PathName] = uigetfile({'*.bin;','Labview binary (*.bin)';'*.mat','Matlab data (*.mat)';'*.*','All files'} ,'Select the data file');
end

set(handles.outputMsg,'string',sprintf('Checking inputs..'))
pause(0.01)

if not(isempty(DataStruct(1).PathName))
    cd(tempdir)
end

if not(DataStruct(5).FileName==0)
    if strcmp(DataStruct(5).PathName,[cd '\'])
        set(handles.edit4_multFiles,'String',DataStruct(5).FileName);
    else
        set(handles.edit4_multFiles,'String',[DataStruct(5).PathName DataStruct(5).FileName]);
    end
    set(handles.edit5_multFiles,'Enable','On');
    set(handles.browseB5_multFiles,'Enable','On');
    
else
    DataStruct(5).FileName=Temp.FileName; DataStruct(5).PathName=Temp.PathName;
    if strcmp(DataStruct(5).PathName,[cd '\'])
        set(handles.edit4_multFiles,'String',DataStruct(5).FileName);
    else
        set(handles.edit4_multFiles,'String',[DataStruct(5).PathName DataStruct(5).FileName]);
    end
end
clear Temp
set(handles.outputMsg,'string',sprintf('Ready! \n Waiting for user input'))
pause(0.01)
set(handles.figure1,'UserData',DataStruct);


function edit5_multFiles_Callback(hObject, eventdata, handles)
% hObject    handle to edit5_multFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5_multFiles as text
%        str2double(get(hObject,'String')) returns contents of edit5_multFiles as a double
DataStruct=get(handles.figure1,'UserData');
set(handles.outputMsg,'string',sprintf('Managing your request \n Checking inputs..'))
pause(0.01)
DataStruct(6).FileName = get(hObject,'String');
if isempty(DataStruct(6).FileName)
    DataStruct(6).FileName='';
end
if length(DataStruct(6).FileName)>3 && strcmp(DataStruct(6).FileName(2:3),':\')
    slashes=findstr(DataStruct(6).FileName, '\');
    DataStruct(6).PathName=DataStruct(6).FileName(1:slashes(end));
    DataStruct(6).FileName=DataStruct(6).FileName(slashes(end)+1:end);
else
    DataStruct(6).PathName=[cd '\'];
end
if isempty(DataStruct(6).FileName)
    DataStruct(6).PathName='';
end
if (length(DataStruct(6).FileName)<5 || (not(strcmp(DataStruct(6).FileName(end-3:end-3),'.')) ...
        && not(strcmp(DataStruct(6).FileName(end-2:end-2),'.')) ...
        && not(strcmp(DataStruct(6).FileName(end-1:end-1),'.'))))...
        && not(strcmp(DataStruct(6).FileName,''))
    
    DataStruct(6).FileName=[DataStruct(6).FileName '.bin'];
    set(handles.edit5_multFiles,'String',DataStruct(6).FileName);
end
if isempty(dir([DataStruct(6).PathName DataStruct(6).FileName])) && not(strcmp(DataStruct(6).FileName,''))
    err=errordlg('File not found','File Error');
    while ishandle(err)
        pause(2)
    end
    pushbutton11_Callback(hObject, eventdata, handles)
    
    DataStruct=get(handles.figure1,'UserData');
else
    set(handles.edit6_multFiles,'Enable','On');
    set(handles.browseB6_multFiles,'Enable','On');
end
set(handles.outputMsg,'string',sprintf('Ready! \n Waiting for user input'))
pause(0.01)
set(handles.figure1,'UserData',DataStruct);

% --- Executes during object creation, after setting all properties.
function edit5_multFiles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5_multFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browseB5_multFiles.
function browseB5_multFiles_Callback(hObject, eventdata, handles)
% hObject    handle to browseB5_multFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DataStruct=get(handles.figure1,'UserData');

set(handles.outputMsg,'string',sprintf('Loading browsing windows...'))
pause(0.01)
if length(DataStruct)<6
    DataStruct(6).FileName='';
end
Temp=struct;
Temp.FileName=DataStruct(6).FileName; Temp.PathName=DataStruct(6).PathName;
set(handles.outputMsg,'string',sprintf('Waiting for your selection...'))
pause(0.01)

if not(isempty(DataStruct(1).PathName))
    tempdir=cd;
    cd(DataStruct(1).PathName)
end

if DataStruct(1).machine==4
    [DataStruct(6).FileName,DataStruct(6).PathName] = uigetfile({'*.mat;','Matlab data (*.mat)';'*.bin','Labview binary (*.bin)';'*.*','All files'} ,'Select the data file');
else
    [DataStruct(6).FileName,DataStruct(6).PathName] = uigetfile({'*.bin;','Labview binary (*.bin)';'*.mat','Matlab data (*.mat)';'*.*','All files'} ,'Select the data file');
end
set(handles.outputMsg,'string',sprintf('Checking inputs..'))
pause(0.01)

if not(isempty(DataStruct(1).PathName))
    cd(tempdir)
end

if not(DataStruct(6).FileName==0)
    if strcmp(DataStruct(6).PathName,[cd '\'])
        set(handles.edit5_multFiles,'String',DataStruct(6).FileName);
    else
        set(handles.edit5_multFiles,'String',[DataStruct(6).PathName DataStruct(6).FileName]);
    end
    set(handles.edit6_multFiles,'Enable','On');
    set(handles.browseB6_multFiles,'Enable','On');
    
else
    DataStruct(6).FileName=Temp.FileName; DataStruct(6).PathName=Temp.PathName;
    if strcmp(DataStruct(6).PathName,[cd '\'])
        set(handles.edit5_multFiles,'String',DataStruct(6).FileName);
    else
        set(handles.edit5_multFiles,'String',[DataStruct(6).PathName DataStruct(6).FileName]);
    end
end
clear Temp
set(handles.outputMsg,'string',sprintf('Ready! \n Waiting for user input'))
pause(0.01)
set(handles.figure1,'UserData',DataStruct);


function edit6_multFiles_Callback(hObject, eventdata, handles)
% hObject    handle to edit6_multFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6_multFiles as text
%        str2double(get(hObject,'String')) returns contents of edit6_multFiles as a double
DataStruct=get(handles.figure1,'UserData');
set(handles.outputMsg,'string',sprintf('Managing your request \n Checking inputs..'))
pause(0.01)
DataStruct(7).FileName = get(hObject,'String');
if isempty(DataStruct(7).FileName)
    DataStruct(7).FileName='';
end
if length(DataStruct(7).FileName)>3 && strcmp(DataStruct(7).FileName(2:3),':\')
    slashes=findstr(DataStruct(7).FileName, '\');
    DataStruct(7).PathName=DataStruct(7).FileName(1:slashes(end));
    DataStruct(7).FileName=DataStruct(7).FileName(slashes(end)+1:end);
else
    DataStruct(7).PathName=[cd '\'];
end
if isempty(DataStruct(7).FileName)
    DataStruct(7).PathName='';
end
if (length(DataStruct(7).FileName)<5 || (not(strcmp(DataStruct(7).FileName(end-3:end-3),'.')) ...
        && not(strcmp(DataStruct(7).FileName(end-2:end-2),'.')) ...
        && not(strcmp(DataStruct(7).FileName(end-1:end-1),'.'))))...
        && not(strcmp(DataStruct(7).FileName,''))
    
    DataStruct(7).FileName=[DataStruct(7).FileName '.bin'];
    set(handles.edit6_multFiles,'String',DataStruct(7).FileName);
end
if isempty(dir([DataStruct(7).PathName DataStruct(7).FileName])) && not(strcmp(DataStruct(7).FileName,''))
    err=errordlg('File not found','File Error');
    while ishandle(err)
        pause(2)
    end
    pushbutton13_Callback(hObject, eventdata, handles)
    
    DataStruct=get(handles.figure1,'UserData');
else
    set(handles.edit7_multFiles,'Enable','On');
    set(handles.browseB7_multFiles,'Enable','On');
end
set(handles.outputMsg,'string',sprintf('Ready! \n Waiting for user input'))
pause(0.01)
set(handles.figure1,'UserData',DataStruct);

% --- Executes during object creation, after setting all properties.
function edit6_multFiles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6_multFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browseB6_multFiles.
function browseB6_multFiles_Callback(hObject, eventdata, handles)
% hObject    handle to browseB6_multFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DataStruct=get(handles.figure1,'UserData');

set(handles.outputMsg,'string',sprintf('Loading browsing windows...'))
pause(0.01)
if length(DataStruct)<7
    DataStruct(7).FileName='';
end
Temp=struct;
Temp.FileName=DataStruct(7).FileName; Temp.PathName=DataStruct(7).PathName;
set(handles.outputMsg,'string',sprintf('Waiting for your selection...'))
pause(0.01)

if not(isempty(DataStruct(1).PathName))
    tempdir=cd;
    cd(DataStruct(1).PathName)
end

if DataStruct(1).machine==4
    [DataStruct(7).FileName,DataStruct(7).PathName] = uigetfile({'*.mat;','Matlab data (*.mat)';'*.bin','Labview binary (*.bin)';'*.*','All files'} ,'Select the data file');
else
    [DataStruct(7).FileName,DataStruct(7).PathName] = uigetfile({'*.bin;','Labview binary (*.bin)';'*.mat','Matlab data (*.mat)';'*.*','All files'} ,'Select the data file');
end

set(handles.outputMsg,'string',sprintf('Checking inputs..'))
pause(0.01)

if not(isempty(DataStruct(1).PathName))
    cd(tempdir)
end

if not(DataStruct(7).FileName==0)
    if strcmp(DataStruct(7).PathName,[cd '\'])
        set(handles.edit6_multFiles,'String',DataStruct(7).FileName);
    else
        set(handles.edit6_multFiles,'String',[DataStruct(7).PathName DataStruct(7).FileName]);
    end
    set(handles.edit7_multFiles,'Enable','On');
    set(handles.browseB7_multFiles,'Enable','On');
    
else
    DataStruct(7).FileName=Temp.FileName; DataStruct(7).PathName=Temp.PathName;
    if strcmp(DataStruct(7).PathName,[cd '\'])
        set(handles.edit6_multFiles,'String',DataStruct(7).FileName);
    else
        set(handles.edit6_multFiles,'String',[DataStruct(7).PathName DataStruct(7).FileName]);
    end
end
clear Temp
set(handles.outputMsg,'string',sprintf('Ready! \n Waiting for user input'))
pause(0.01)
set(handles.figure1,'UserData',DataStruct);


function edit7_multFiles_Callback(hObject, eventdata, handles)
% hObject    handle to edit7_multFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7_multFiles as text
%        str2double(get(hObject,'String')) returns contents of edit7_multFiles as a double
DataStruct=get(handles.figure1,'UserData');
set(handles.outputMsg,'string',sprintf('Managing your request \n Checking inputs..'))
pause(0.01)
DataStruct(8).FileName = get(hObject,'String');
if isempty(DataStruct(8).FileName)
    DataStruct(8).FileName='';
end
if length(DataStruct(8).FileName)>3 && strcmp(DataStruct(8).FileName(2:3),':\')
    slashes=findstr(DataStruct(8).FileName, '\');
    DataStruct(8).PathName=DataStruct(8).FileName(1:slashes(end));
    DataStruct(8).FileName=DataStruct(8).FileName(slashes(end)+1:end);
else
    DataStruct(8).PathName=[cd '\'];
end
if isempty(DataStruct(8).FileName)
    DataStruct(8).PathName='';
end
if (length(DataStruct(8).FileName)<5 || (not(strcmp(DataStruct(8).FileName(end-3:end-3),'.')) ...
        && not(strcmp(DataStruct(8).FileName(end-2:end-2),'.')) ...
        && not(strcmp(DataStruct(8).FileName(end-1:end-1),'.'))))...
        && not(strcmp(DataStruct(8).FileName,''))
    
    DataStruct(8).FileName=[DataStruct(8).FileName '.bin'];
    set(handles.edit7_multFiles,'String',DataStruct(8).FileName);
end
if isempty(dir([DataStruct(8).PathName DataStruct(8).FileName])) && not(strcmp(DataStruct(8).FileName,''))
    err=errordlg('File not found','File Error');
    while ishandle(err)
        pause(2)
    end
    pushbutton14_Callback(hObject, eventdata, handles)
    
    DataStruct=get(handles.figure1,'UserData');
else
    set(handles.edit8_multFiles,'Enable','On');
    set(handles.browseB8_multFiles,'Enable','On');
end
set(handles.outputMsg,'string',sprintf('Ready! \n Waiting for user input'))
pause(0.01)
set(handles.figure1,'UserData',DataStruct);

% --- Executes during object creation, after setting all properties.
function edit7_multFiles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7_multFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browseB7_multFiles.
function browseB7_multFiles_Callback(hObject, eventdata, handles)
% hObject    handle to browseB7_multFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DataStruct=get(handles.figure1,'UserData');

set(handles.outputMsg,'string',sprintf('Loading browsing windows...'))
pause(0.01)
if length(DataStruct)<8
    DataStruct(8).FileName='';
end
Temp=struct;
Temp.FileName=DataStruct(8).FileName; Temp.PathName=DataStruct(8).PathName;
set(handles.outputMsg,'string',sprintf('Waiting for your selection...'))
pause(0.01)

if not(isempty(DataStruct(1).PathName))
    tempdir=cd;
    cd(DataStruct(1).PathName)
end

if DataStruct(1).machine==4
    [DataStruct(8).FileName,DataStruct(8).PathName] = uigetfile({'*.mat;','Matlab data (*.mat)';'*.bin','Labview binary (*.bin)';'*.*','All files'} ,'Select the data file');
else
    [DataStruct(8).FileName,DataStruct(8).PathName] = uigetfile({'*.bin;','Labview binary (*.bin)';'*.mat','Matlab data (*.mat)';'*.*','All files'} ,'Select the data file');
end

set(handles.outputMsg,'string',sprintf('Checking inputs..'))
pause(0.01)

if not(isempty(DataStruct(1).PathName))
    cd(tempdir)
end

if not(DataStruct(8).FileName==0)
    if strcmp(DataStruct(8).PathName,[cd '\'])
        set(handles.edit7_multFiles,'String',DataStruct(8).FileName);
    else
        set(handles.edit7_multFiles,'String',[DataStruct(8).PathName DataStruct(8).FileName]);
    end
    set(handles.edit8_multFiles,'Enable','On');
    set(handles.browseB8_multFiles,'Enable','On');
    
else
    DataStruct(8).FileName=Temp.FileName; DataStruct(8).PathName=Temp.PathName;
    if strcmp(DataStruct(8).PathName,[cd '\'])
        set(handles.edit7_multFiles,'String',DataStruct(8).FileName);
    else
        set(handles.edit7_multFiles,'String',[DataStruct(8).PathName DataStruct(8).FileName]);
    end
end
clear Temp
set(handles.outputMsg,'string',sprintf('Ready! \n Waiting for user input'))
pause(0.01)
set(handles.figure1,'UserData',DataStruct);


function edit8_multFiles_Callback(hObject, eventdata, handles)
% hObject    handle to edit8_multFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8_multFiles as text
%        str2double(get(hObject,'String')) returns contents of edit8_multFiles as a double
DataStruct=get(handles.figure1,'UserData');
set(handles.outputMsg,'string',sprintf('Managing your request \n Checking inputs..'))
pause(0.01)
DataStruct(9).FileName = get(hObject,'String');
if isempty(DataStruct(9).FileName)
    DataStruct(9).FileName='';
end
if length(DataStruct(9).FileName)>3 && strcmp(DataStruct(9).FileName(2:3),':\')
    slashes=findstr(DataStruct(9).FileName, '\');
    DataStruct(9).PathName=DataStruct(9).FileName(1:slashes(end));
    DataStruct(9).FileName=DataStruct(9).FileName(slashes(end)+1:end);
else
    DataStruct(9).PathName=[cd '\'];
end
if isempty(DataStruct(9).FileName)
    DataStruct(9).PathName='';
end
if (length(DataStruct(9).FileName)<5 || (not(strcmp(DataStruct(9).FileName(end-3:end-3),'.')) ...
        && not(strcmp(DataStruct(9).FileName(end-2:end-2),'.')) ...
        && not(strcmp(DataStruct(9).FileName(end-1:end-1),'.'))))...
        && not(strcmp(DataStruct(9).FileName,''))
    
    DataStruct(9).FileName=[DataStruct(9).FileName '.bin'];
    set(handles.edit8_multFiles,'String',DataStruct(9).FileName);
end
if isempty(dir([DataStruct(9).PathName DataStruct(9).FileName])) && not(strcmp(DataStruct(9).FileName,''))
    err=errordlg('File not found','File Error');
    while ishandle(err)
        pause(2)
    end
    pushbutton15_Callback(hObject, eventdata, handles)
    
    DataStruct=get(handles.figure1,'UserData');
else
    set(handles.edit9_multFiles,'Enable','On');
    set(handles.browseB9_multFiles,'Enable','On');
end
set(handles.outputMsg,'string',sprintf('Ready! \n Waiting for user input'))
pause(0.01)
set(handles.figure1,'UserData',DataStruct);

% --- Executes during object creation, after setting all properties.
function edit8_multFiles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8_multFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browseB8_multFiles.
function browseB8_multFiles_Callback(hObject, eventdata, handles)
% hObject    handle to browseB8_multFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

DataStruct=get(handles.figure1,'UserData');

set(handles.outputMsg,'string',sprintf('Loading browsing windows...'))
pause(0.01)

if length(DataStruct)<9
    DataStruct(9).FileName='';
end
Temp=struct;
Temp.FileName=DataStruct(9).FileName; Temp.PathName=DataStruct(9).PathName;
set(handles.outputMsg,'string',sprintf('Waiting for your selection...'))
pause(0.01)

if not(isempty(DataStruct(1).PathName))
    tempdir=cd;
    cd(DataStruct(1).PathName)
end

if DataStruct(1).machine==4
    [DataStruct(9).FileName,DataStruct(9).PathName] = uigetfile({'*.mat;','Matlab data (*.mat)';'*.bin','Labview binary (*.bin)';'*.*','All files'} ,'Select the data file');
else
    [DataStruct(9).FileName,DataStruct(9).PathName] = uigetfile({'*.bin;','Labview binary (*.bin)';'*.mat','Matlab data (*.mat)';'*.*','All files'} ,'Select the data file');
end

set(handles.outputMsg,'string',sprintf('Checking inputs..'))
pause(0.01)

if not(isempty(DataStruct(1).PathName))
    cd(tempdir)
end

if not(DataStruct(9).FileName==0)
    if strcmp(DataStruct(9).PathName,[cd '\'])
        set(handles.edit8_multFiles,'String',DataStruct(9).FileName);
    else
        set(handles.edit8_multFiles,'String',[DataStruct(9).PathName DataStruct(9).FileName]);
    end
    set(handles.edit9_multFiles,'Enable','On');
    set(handles.browseB9_multFiles,'Enable','On');
    
else
    DataStruct(9).FileName=Temp.FileName; DataStruct(9).PathName=Temp.PathName;
    if strcmp(DataStruct(9).PathName,[cd '\'])
        set(handles.edit8_multFiles,'String',DataStruct(9).FileName);
    else
        set(handles.edit8_multFiles,'String',[DataStruct(9).PathName DataStruct(9).FileName]);
    end
end
clear Temp
set(handles.outputMsg,'string',sprintf('Ready! \n Waiting for user input'))
pause(0.01)
set(handles.figure1,'UserData',DataStruct);

function edit9_multFiles_Callback(hObject, eventdata, handles)
% hObject    handle to edit9_multFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9_multFiles as text
%        str2double(get(hObject,'String')) returns contents of edit9_multFiles as a double
DataStruct=get(handles.figure1,'UserData');
set(handles.outputMsg,'string',sprintf('Managing your request \n Checking inputs..'))
pause(0.01)
DataStruct(10).FileName = get(hObject,'String');
if isempty(DataStruct(10).FileName)
    DataStruct(10).FileName='';
end
if length(DataStruct(10).FileName)>3 && strcmp(DataStruct(10).FileName(2:3),':\')
    slashes=findstr(DataStruct(10).FileName, '\');
    DataStruct(10).PathName=DataStruct(10).FileName(1:slashes(end));
    DataStruct(10).FileName=DataStruct(10).FileName(slashes(end)+1:end);
else
    DataStruct(10).PathName=[cd '\'];
end
if isempty(DataStruct(10).FileName)
    DataStruct(10).PathName='';
end
if (length(DataStruct(10).FileName)<5 || (not(strcmp(DataStruct(10).FileName(end-3:end-3),'.')) ...
        && not(strcmp(DataStruct(10).FileName(end-2:end-2),'.')) ...
        && not(strcmp(DataStruct(10).FileName(end-1:end-1),'.'))))...
        && not(strcmp(DataStruct(10).FileName,''))
    
    DataStruct(10).FileName=[DataStruct(10).FileName '.bin'];
    set(handles.edit9_multFiles,'String',DataStruct(10).FileName);
end
if isempty(dir([DataStruct(10).PathName DataStruct(10).FileName])) && not(strcmp(DataStruct(10).FileName,''))
    err=errordlg('File not found','File Error');
    while ishandle(err)
        pause(2)
    end
    pushbutton17_Callback(hObject, eventdata, handles)
    
    DataStruct=get(handles.figure1,'UserData');
else
    set(handles.edit10_multFiles,'Enable','On');
    set(handles.browseB10_multFiles,'Enable','On');
end
set(handles.outputMsg,'string',sprintf('Ready! \n Waiting for user input'))
pause(0.01)
set(handles.figure1,'UserData',DataStruct);


% --- Executes during object creation, after setting all properties.
function edit9_multFiles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9_multFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_multFiles_Callback(hObject, eventdata, handles)
% hObject    handle to edit10_multFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10_multFiles as text
%        str2double(get(hObject,'String')) returns contents of edit10_multFiles as a double
DataStruct=get(handles.figure1,'UserData');
set(handles.outputMsg,'string',sprintf('Managing your request \n Checking inputs..'))
pause(0.01)
DataStruct(11).FileName = get(hObject,'String');
if isempty(DataStruct(11).FileName)
    DataStruct(11).FileName='';
end
if length(DataStruct(11).FileName)>3 && strcmp(DataStruct(11).FileName(2:3),':\')
    slashes=findstr(DataStruct(11).FileName, '\');
    DataStruct(11).PathName=DataStruct(11).FileName(1:slashes(end));
    DataStruct(11).FileName=DataStruct(11).FileName(slashes(end)+1:end);
else
    DataStruct(11).PathName=[cd '\'];
end
if isempty(DataStruct(11).FileName)
    DataStruct(11).PathName='';
end
if (length(DataStruct(11).FileName)<5 || (not(strcmp(DataStruct(11).FileName(end-3:end-3),'.')) ...
        && not(strcmp(DataStruct(11).FileName(end-2:end-2),'.')) ...
        && not(strcmp(DataStruct(11).FileName(end-1:end-1),'.'))))...
        && not(strcmp(DataStruct(11).FileName,''))
    
    DataStruct(11).FileName=[DataStruct(10).FileName '.bin'];
    set(handles.edit10_multFiles,'String',DataStruct(10).FileName);
end
if isempty(dir([DataStruct(11).PathName DataStruct(11).FileName])) && not(strcmp(DataStruct(11).FileName,''))
    err=errordlg('File not found','File Error');
    while ishandle(err)
        pause(2)
    end
    pushbutton18_Callback(hObject, eventdata, handles)
    
    DataStruct=get(handles.figure1,'UserData');
else
    set(handles.edit11_multFiles,'Enable','On');
    set(handles.browseB11_multFiles,'Enable','On');
end
set(handles.outputMsg,'string',sprintf('Ready! \n Waiting for user input'))
pause(0.01)
set(handles.figure1,'UserData',DataStruct);

% --- Executes during object creation, after setting all properties.
function edit10_multFiles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10_multFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_multFiles_Callback(hObject, eventdata, handles)
% hObject    handle to edit11_multFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11_multFiles as text
%        str2double(get(hObject,'String')) returns contents of edit11_multFiles as a double
DataStruct=get(handles.figure1,'UserData');
set(handles.outputMsg,'string',sprintf('Managing your request \n Checking inputs..'))
pause(0.01)
DataStruct(12).FileName = get(hObject,'String');
if isempty(DataStruct(12).FileName)
    DataStruct(12).FileName='';
end
if length(DataStruct(12).FileName)>3 && strcmp(DataStruct(12).FileName(2:3),':\')
    slashes=findstr(DataStruct(12).FileName, '\');
    DataStruct(12).PathName=DataStruct(12).FileName(1:slashes(end));
    DataStruct(12).FileName=DataStruct(12).FileName(slashes(end)+1:end);
else
    DataStruct(12).PathName=[cd '\'];
end
if isempty(DataStruct(12).FileName)
    DataStruct(12).PathName='';
end
if (length(DataStruct(12).FileName)<5 || (not(strcmp(DataStruct(12).FileName(end-3:end-3),'.')) ...
        && not(strcmp(DataStruct(12).FileName(end-2:end-2),'.')) ...
        && not(strcmp(DataStruct(12).FileName(end-1:end-1),'.'))))...
        && not(strcmp(DataStruct(12).FileName,''))
    
    DataStruct(12).FileName=[DataStruct(12).FileName '.bin'];
    set(handles.edit11_multFiles,'String',DataStruct(12).FileName);
end
if isempty(dir([DataStruct(12).PathName DataStruct(12).FileName])) && not(strcmp(DataStruct(12).FileName,''))
    err=errordlg('File not found','File Error');
    while ishandle(err)
        pause(2)
    end
    pushbutton19_Callback(hObject, eventdata, handles)
    
    DataStruct=get(handles.figure1,'UserData');
else
    %here will be eanbled a new line eventually added
end
set(handles.outputMsg,'string',sprintf('Ready! \n Waiting for user input'))
pause(0.01)
set(handles.figure1,'UserData',DataStruct);

% --- Executes during object creation, after setting all properties.
function edit11_multFiles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11_multFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browseB9_multFiles.
function browseB9_multFiles_Callback(hObject, eventdata, handles)
% hObject    handle to browseB9_multFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DataStruct=get(handles.figure1,'UserData');

set(handles.outputMsg,'string',sprintf('Loading browsing windows...'))
pause(0.01)

if length(DataStruct)<10
    DataStruct(10).FileName='';
end
Temp=struct;
Temp.FileName=DataStruct(10).FileName; Temp.PathName=DataStruct(10).PathName;
set(handles.outputMsg,'string',sprintf('Waiting for your selection...'))
pause(0.01)

if not(isempty(DataStruct(1).PathName))
    tempdir=cd;
    cd(DataStruct(1).PathName)
end

if DataStruct(1).machine==4
    [DataStruct(10).FileName,DataStruct(10).PathName] = uigetfile({'*.mat;','Matlab data (*.mat)';'*.bin','Labview binary (*.bin)';'*.*','All files'} ,'Select the data file');
else
    [DataStruct(10).FileName,DataStruct(10).PathName] = uigetfile({'*.bin;','Labview binary (*.bin)';'*.mat','Matlab data (*.mat)';'*.*','All files'} ,'Select the data file');
end

set(handles.outputMsg,'string',sprintf('Checking inputs..'))
pause(0.01)

if not(isempty(DataStruct(1).PathName))
    cd(tempdir)
end

if not(DataStruct(10).FileName==0)
    if strcmp(DataStruct(10).PathName,[cd '\'])
        set(handles.edit9_multFiles,'String',DataStruct(10).FileName);
    else
        set(handles.edit9_multFiles,'String',[DataStruct(10).PathName DataStruct(10).FileName]);
    end
    set(handles.edit10_multFiles,'Enable','On');
    set(handles.browseB10_multFiles,'Enable','On');
    
else
    DataStruct(10).FileName=Temp.FileName; DataStruct(10).PathName=Temp.PathName;
    if strcmp(DataStruct(10).PathName,[cd '\'])
        set(handles.edit9_multFiles,'String',DataStruct(10).FileName);
    else
        set(handles.edit9_multFiles,'String',[DataStruct(10).PathName DataStruct(10).FileName]);
    end
end
clear Temp
set(handles.outputMsg,'string',sprintf('Ready! \n Waiting for user input'))
pause(0.01)
set(handles.figure1,'UserData',DataStruct);

% --- Executes on button press in browseB10_multFiles.
function browseB10_multFiles_Callback(hObject, eventdata, handles)
% hObject    handle to browseB10_multFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DataStruct=get(handles.figure1,'UserData');

set(handles.outputMsg,'string',sprintf('Loading browsing windows...'))
pause(0.01)

if length(DataStruct)<11
    DataStruct(11).FileName='';
end
Temp=struct;
Temp.FileName=DataStruct(11).FileName; Temp.PathName=DataStruct(11).PathName;
set(handles.outputMsg,'string',sprintf('Waiting for your selection...'))
pause(0.01)

if not(isempty(DataStruct(1).PathName))
    tempdir=cd;
    cd(DataStruct(1).PathName)
end
if DataStruct(1).machine==4
    [DataStruct(11).FileName,DataStruct(11).PathName] = uigetfile({'*.mat;','Matlab data (*.mat)';'*.bin','Labview binary (*.bin)';'*.*','All files'} ,'Select the data file');
else
    [DataStruct(11).FileName,DataStruct(11).PathName] = uigetfile({'*.bin;','Labview binary (*.bin)';'*.mat','Matlab data (*.mat)';'*.*','All files'} ,'Select the data file');
end
set(handles.outputMsg,'string',sprintf('Checking inputs..'))
pause(0.01)

if not(isempty(DataStruct(1).PathName))
    cd(tempdir)
end

if not(DataStruct(11).FileName==0)
    if strcmp(DataStruct(11).PathName,[cd '\'])
        set(handles.edit10_multFiles,'String',DataStruct(11).FileName);
    else
        set(handles.edit10_multFiles,'String',[DataStruct(11).PathName DataStruct(11).FileName]);
    end
    set(handles.edit11_multFiles,'Enable','On');
    set(handles.browseB11_multFiles,'Enable','On');
    
else
    DataStruct(11).FileName=Temp.FileName; DataStruct(11).PathName=Temp.PathName;
    if strcmp(DataStruct(11).PathName,[cd '\'])
        set(handles.edit10_multFiles,'String',DataStruct(11).FileName);
    else
        set(handles.edit10_multFiles,'String',[DataStruct(11).PathName DataStruct(11).FileName]);
    end
end
clear Temp
set(handles.outputMsg,'string',sprintf('Ready! \n Waiting for user input'))
pause(0.01)
set(handles.figure1,'UserData',DataStruct);

% --- Executes on button press in browseB11_multFiles.
function browseB11_multFiles_Callback(hObject, eventdata, handles)
% hObject    handle to browseB11_multFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DataStruct=get(handles.figure1,'UserData');

set(handles.outputMsg,'string',sprintf('Loading browsing windows...'))
pause(0.01)

if length(DataStruct)<12
    DataStruct(12).FileName='';
end
Temp=struct;
Temp.FileName=DataStruct(12).FileName; Temp.PathName=DataStruct(12).PathName;
set(handles.outputMsg,'string',sprintf('Waiting for your selection...'))
pause(0.01)
if not(isempty(DataStruct(1).PathName))
    tempdir=cd;
    cd(DataStruct(1).PathName)
end
if DataStruct(1).machine==4
    [DataStruct(12).FileName,DataStruct(12).PathName] = uigetfile({'*.mat;','Matlab data (*.mat)';'*.bin','Labview binary (*.bin)';'*.*','All files'} ,'Select the data file');
else
    [DataStruct(12).FileName,DataStruct(12).PathName] = uigetfile({'*.bin;','Labview binary (*.bin)';'*.mat','Matlab data (*.mat)';'*.*','All files'} ,'Select the data file');
end
set(handles.outputMsg,'string',sprintf('Checking inputs..'))
pause(0.01)

if not(isempty(DataStruct(1).PathName))
    cd(tempdir)
end

if not(DataStruct(12).FileName==0)
    if strcmp(DataStruct(12).PathName,[cd '\'])
        set(handles.edit11_multFiles,'String',DataStruct(12).FileName);
    else
        set(handles.edit11_multFiles,'String',[DataStruct(12).PathName DataStruct(12).FileName]);
    end
    %space for the next line;
    
else
    DataStruct(12).FileName=Temp.FileName; DataStruct(12).PathName=Temp.PathName;
    if strcmp(DataStruct(12).PathName,[cd '\'])
        set(handles.edit11_multFiles,'String',DataStruct(12).FileName);
    else
        set(handles.edit11_multFiles,'String',[DataStruct(12).PathName DataStruct(12).FileName]);
    end
end
clear Temp
set(handles.outputMsg,'string',sprintf('Ready! \n Waiting for user input'))
pause(0.01)
set(handles.figure1,'UserData',DataStruct);



% EXIT BUTTON
% --- Executes on button press in pushB_exit.
function pushB_exit_Callback(hObject, eventdata, handles)
% hObject    handle to pushB_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DataStruct=get(handles.figure1,'UserData');
set(handles.outputMsg,'string',sprintf('Checking saving status...'))
pause(0.01)
if DataStruct(1).saveflag==[0 0];
    question=sprintf('WARNING!! Last loaded data not saved! Exit?');
    answer=questdlg(question,'Exit without saving','yes','no','save','no');
    if strcmp(answer,'yes')
        set(handles.outputMsg,'string',sprintf('Closing...'))
        pause(0.01)
        closereq
    elseif strcmp(answer,'save')
        pushbutton7_Callback(hObject, eventdata, handles);
        pushbutton6_Callback(hObject, eventdata, handles)
        
    else
        set(handles.figure1,'UserData',DataStruct);
    end
else
    set(handles.outputMsg,'string',sprintf('Closing...'))
    pause(0.01)
    closereq
end


% SAVE BUTTON
function pushB_saveMat_Callback(hObject, eventdata, handles)
% hObject    handle to pushB_saveMat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DataStruct=get(handles.figure1,'UserData');
set(handles.outputMsg,'string',sprintf('Preparing to save data...'))
pause(0.01)
question=sprintf('Do you want to add notes (es:subjname)?');
answer=questdlg(question,'Add notes','yes','no','yes');
if strcmp(answer,'yes')
    prompt = {'Enter a maximum of 10 lines of comments'};
    dlg_title = 'Input comments';
    num_lines = 10;
    DataStruct(1).notes= inputdlg(prompt,dlg_title,num_lines);
    comment=1;
else
    comment=0;
end
[savefile, savepath]=uiputfile('*.mat','Save file name',[DataStruct(1).PathName,'InsertName.mat']);
clear data
skip=0;
if not(savefile==0)
    for i=1:length(DataStruct)
        if isempty(DataStruct(i).data)
            skip=skip+1;
        else
            data(i-skip)=DataStruct(i).data;
        end
    end
    set(handles.outputMsg,'string',sprintf('SAVING... \n Please wait and don''t close the windows'))
    pause(0.01)
    save([savepath savefile],'data');
    if comment==1
        notes=DataStruct(1).notes;
        save([savepath savefile],'notes','-append');
    end
    DataStruct(1).saveflag=[1 0];
end
set(handles.outputMsg,'string',sprintf('Ready! \n Waiting for user input'))
pause(0.01)
set(handles.figure1,'UserData',DataStruct);


%Checkbox_multipleFiles loader
% --- Executes on button press in checkbox_multipleFiles.
function checkbox_multipleFiles_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_multipleFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_multipleFiles
DataStruct=get(handles.figure1,'UserData');
set(handles.outputMsg,'string',sprintf('Activating multiple files mode...'))
pause(0.01)
if get(hObject,'Value')
    set(handles.panel_multiFiles,'Visible','On');
    set(handles.edit1_multFiles,'Enable','On');
    set(handles.browseB1_multFiles,'Enable','On');
else
    set(handles.panel_multiFiles,'Visible','Off');
    set(handles.edit1_multFiles,'Enable','Off');
    set(handles.browseB1_multFiles,'Enable','Off');
end
set(handles.outputMsg,'string',sprintf('Ready! \n Waiting for user input'))
pause(0.01)
set(handles.figure1,'UserData',DataStruct);




% Information TEXT BOX
function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to outputMsg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of outputMsg as text
%        str2double(get(hObject,'String')) returns contents of outputMsg as a double


% Information text box
function outputMsg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outputMsg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% SAVE IN THE WORKSPACE
% --- Executes on button press in pushB_saveWSp.
function pushB_saveWSp_Callback(hObject, eventdata, handles)
% hObject    handle to pushB_saveWSp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DataStruct=get(handles.figure1,'UserData');
set(handles.outputMsg,'string',sprintf('Waiting for the variable name... \nDon''t be worry I''ll check \n if you are overwriting\n something. '))
pause(0.01)
nameok=0;
while not(nameok==1)
    prompt = {'Enter the name of the variable that will contains the data structure with the loaded data'};
    dlg_title = 'Variable name input';
    num_lines = 1;
    varname= inputdlg(prompt,dlg_title,num_lines);
    assignin('base','varname',varname);
    if evalin('base', 'exist(varname{1})')
        question=sprintf('The variable already exist in the base workspace. Do you want to overwrite it?');
        answer=questdlg(question,'Overwrite','yes','no','cancel','no');
        if strcmp(answer,'yes')
            nameok=1;
        elseif strcmp(answer,'cancel')
            set(handles.outputMsg,'string',sprintf('Nothing saved on the workspace!'))
            pause(2)
            set(handles.outputMsg,'string',sprintf('Ready! \n Waiting for user input'))
            return;
        end
    else
        nameok=1;
    end
end

set(handles.outputMsg,'string',sprintf('Saving data in the workspace... \n Please wait and don''t close me'))
pause(0.01)
skip=0;
for i=1:length(DataStruct)
    if isempty(DataStruct(i).data)
        skip=skip+1;
    else
        data(i-skip)=DataStruct(i).data;
    end
end
assignin('base',varname{1},data);
set(handles.outputMsg,'string',sprintf('Ready! \n Waiting for user input'))
pause(0.01)
set(handles.figure1,'UserData',DataStruct);




% CHECKBOX_SUBSMPL Checkbox and text for teh new smpl freq.
% --- Executes on button press in checkBox_subSmpl.
function checkBox_subSmpl_Callback(hObject, eventdata, handles)
% hObject    handle to checkBox_subSmpl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkBox_subSmpl
DataStruct=get(handles.figure1,'UserData');
if get(hObject,'Value')
    DataStruct(1).undersampling=str2double(get(handles.edit_subSmpl,'String'));
    set(handles.edit_subSmpl,'Enable','On');
else
    DataStruct(1).undersampling=0;% Means no undersampling!
    set(handles.edit_subSmpl,'string',sprintf('1000'))
    set(handles.edit_subSmpl,'Enable','Off');
end
set(handles.figure1,'UserData',DataStruct);

function edit_subSmpl_Callback(hObject, eventdata, handles)
% hObject    handle to edit_subSmpl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_subSmpl as text
%        str2double(get(hObject,'String')) returns contents of edit_subSmpl as a double
DataStruct=get(handles.figure1,'UserData');
DataStruct(1).undersampling=str2double(get(hObject,'String'));
set(handles.checkBox_subSmpl,'Value',1);
set(handles.figure1,'UserData',DataStruct);

% --- Executes during object creation, after setting all properties.
function edit_subSmpl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_subSmpl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in chechBox_lpFilter.
function chechBox_lpFilter_Callback(hObject, eventdata, handles)
% hObject    handle to chechBox_lpFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chechBox_lpFilter
DataStruct=get(handles.figure1,'UserData');
if get(hObject,'Value')
    set(handles.edit_lpFilter,'Enable','On');
    DataStruct(1).filter=str2double(get(handles.edit_lpFilter,'String'));
else
    DataStruct(1).filter=0;% Means no filtering!
    set(handles.edit_lpFilter,'Enable','Off');
end
set(handles.figure1,'UserData',DataStruct);


function edit_lpFilter_Callback(hObject, eventdata, handles)
% hObject    handle to edit_lpFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lpFilter as text
%        str2double(get(hObject,'String')) returns contents of edit_lpFilter as a double
DataStruct=get(handles.figure1,'UserData');
DataStruct(1).filter=str2double(get(handles.edit_lpFilter,'String'));
set(handles.chechBox_lpFilter,'Value',1);
set(handles.figure1,'UserData',DataStruct);

% --- Executes during object creation, after setting all properties.
function edit_lpFilter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_lpFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in radioB1_3DT.
function radioB1_3DT_Callback(hObject, eventdata, handles)
% hObject    handle to radioB1_3DT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radioB1_3DT
DataStruct=get(handles.figure1,'UserData');
if get(hObject,'Value')
    set(handles.radioB1_3DT,'Value',1);
    DataStruct(1).machine=1;
    set(handles.radioB2_exapod,'Value',0);
    set(handles.radioB3_hopC,'Value',0);
    set(handles.radioB4_eyeCC,'Value',0);
    set(handles.edit_CoilCal,'Enable','On');
    set(handles.browseB_CoilCal,'Enable','On');
    set(handles.pushB_manualSetCoil,'Enable','On');
    
else
    set(handles.radioB1_3DT,'Value',1);
    DataStruct(1).machine=1;
    set(handles.radioB2_exapod,'Value',0);
    set(handles.radioB3_hopC,'Value',0);
    set(handles.radioB4_eyeCC,'Value',0);
    set(handles.edit_CoilCal,'Enable','On');
    set(handles.browseB_CoilCal,'Enable','On');
    set(handles.pushB_manualSetCoil,'Enable','On');
end
set(handles.figure1,'UserData',DataStruct);

% --- Executes on button press in radioB2_exapod.
function radioB2_exapod_Callback(hObject, eventdata, handles)
% hObject    handle to radioB2_exapod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radioB2_exapod
DataStruct=get(handles.figure1,'UserData');
if get(hObject,'Value')
    set(handles.radioB2_exapod,'Value',1);
    DataStruct(1).machine=2;
    set(handles.radioB1_3DT,'Value',0);
    set(handles.radioB3_hopC,'Value',0);
    set(handles.radioB4_eyeCC,'Value',0);
    set(handles.edit_CoilCal,'Enable','On');
    set(handles.browseB_CoilCal,'Enable','On');
    set(handles.pushB_manualSetCoil,'Enable','On');
    
else
    set(handles.radioB2_exapod,'Value',1);
    DataStruct(1).machine=2;
    set(handles.radioB1_3DT,'Value',0);
    set(handles.radioB3_hopC,'Value',0);
    set(handles.radioB4_eyeCC,'Value',0);
    set(handles.edit_CoilCal,'Enable','On');
    set(handles.browseB_CoilCal,'Enable','On');
    set(handles.pushB_manualSetCoil,'Enable','On');
    
end
set(handles.figure1,'UserData',DataStruct);



% --- Executes on button press in radioB3_hopC.
function radioB3_hopC_Callback(hObject, eventdata, handles)
% hObject    handle to radioB3_hopC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radioB3_hopC
DataStruct=get(handles.figure1,'UserData');
if get(hObject,'Value')
    set(handles.radioB3_hopC,'Value',1);
    DataStruct(1).machine=3;
    set(handles.radioB1_3DT,'Value',0);
    set(handles.radioB2_exapod,'Value',0);
    set(handles.radioB4_eyeCC,'Value',0);
    set(handles.edit_CoilCal,'Enable','Off');
    set(handles.browseB_CoilCal,'Enable','Off');
    set(handles.pushB_manualSetCoil,'Enable','Off');
    
else
    set(handles.radioB3_hopC,'Value',1);
    DataStruct(1).machine=3;
    set(handles.radioB1_3DT,'Value',0);
    set(handles.radioB2_exapod,'Value',0);
    set(handles.radioB4_eyeCC,'Value',0);
    set(handles.edit_CoilCal,'Enable','Off');
    set(handles.browseB_CoilCal,'Enable','Off');
    set(handles.pushB_manualSetCoil,'Enable','Off');
end
set(handles.figure1,'UserData',DataStruct);


% --- Executes on button press in radioB4_eyeCC.
function radioB4_eyeCC_Callback(hObject, eventdata, handles)
% hObject    handle to radioB4_eyeCC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radioB4_eyeCC
DataStruct=get(handles.figure1,'UserData');
if get(hObject,'Value')
    set(handles.radioB4_eyeCC,'Value',1);
    DataStruct(1).machine=4;
    set(handles.radioB1_3DT,'Value',0);
    set(handles.radioB2_exapod,'Value',0);
    set(handles.radioB3_hopC,'Value',0);
    set(handles.edit_CoilCal,'Enable','Off');
    set(handles.browseB_CoilCal,'Enable','Off');
    set(handles.pushB_manualSetCoil,'Enable','Off');
    
else
    set(handles.radioB4_eyeCC,'Value',1);
    DataStruct(1).machine=4;
    set(handles.radioB1_3DT,'Value',0);
    set(handles.radioB2_exapod,'Value',0);
    set(handles.radioB3_hopC,'Value',0);
    set(handles.edit_CoilCal,'Enable','Off');
    set(handles.browseB_CoilCal,'Enable','Off');
    set(handles.pushB_manualSetCoil,'Enable','Off');
end
set(handles.figure1,'UserData',DataStruct);

