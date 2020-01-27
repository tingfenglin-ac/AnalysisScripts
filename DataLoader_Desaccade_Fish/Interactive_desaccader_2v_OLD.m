function varargout = Interactive_desaccader_2v(varargin)
% INTERACTIVE_DESACCADER_2V M-file for Interactive_desaccader_2v.fig
%      INTERACTIVE_DESACCADER_2V, by itself, creates a new INTERACTIVE_DESACCADER_2V or raises the existing
%      singleton*.
%
%      H = INTERACTIVE_DESACCADER_2V returns the handle to a new INTERACTIVE_DESACCADER_2V or the handle to
%      the existing singleton*.
%
%      INTERACTIVE_DESACCADER_2V('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERACTIVE_DESACCADER_2V.M with the given input arguments.
%
%      INTERACTIVE_DESACCADER_2V('Property','Value',...) creates a new INTERACTIVE_DESACCADER_2V or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Interactive_desaccader_2v_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Interactive_desaccader_2v_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Interactive_desaccader_2v

% Last Modified by GUIDE v2.5 27-Jun-2016 15:18:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Interactive_desaccader_2v_OpeningFcn, ...
    'gui_OutputFcn',  @Interactive_desaccader_2v_OutputFcn, ...
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


% --- Executes just before Interactive_desaccader_2v is made visible.
function Interactive_desaccader_2v_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Interactive_desaccader_2v (see VARARGIN)

% Choose default command line output for Interactive_desaccader_2v
handles.output = hObject;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Interactive_desaccader_2v wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%Inizalization of the datastruct
DataStruct=struct; %stucture to be use to move data
if isempty(varargin)
    
    
    set(handles.error,'String',{'INCORRECT NUMBER OF INPUT!'; 'Please insert EyeVelocity and SamplingFrequency or EyeVelocity and TimeVector!';'Simulated data are plot!'});
    set(handles.error,'ForegroundColor','Red');
    varargin{1}=[zeros(600,1);[1:50:200]';fliplr(1:50:200)';ones(600,1);fliplr([-200:25:1])';[-200:25:1]'; ones(400,1)];
    
    varargin{2}=40;
end



DataStruct.omega_r=varargin{1};%import Velocity from outside
if length(varargin{2})==1
    DataStruct.smpf=varargin{2};%import sampling freq from outside
    %DataStruct.rawtime=[0:1/DataStruct.smpf:(length(DataStruct.omega_r)-1)/DataStruct.smpf]';
    DataStruct.rawtime=buildtime(DataStruct.omega_r,DataStruct.smpf);
else
    rawTime=varargin{2};%import time from outside
    if rawTime(1)~=0
        rawTime=rawTime-rawTime(1);
    end
    DataStruct.rawtime=rawTime;
    DataStruct.smpf=round(1/median(diff(DataStruct.rawtime)));
end


if length(varargin)>2 && ~isempty(varargin{3})
    DataStruct.eyepos=varargin{3};%Import eyepos from outside
    if length(DataStruct.eyepos)~=length(DataStruct.rawtime)
        [~,DataStruct.eyepos]=resampleData(DataStruct.rawtime,DataStruct.eyepos,DataStruct.smpf); % resample Data at same freq
    end
    DataStruct.realpos=1;
    if length(varargin)>3
        DataStruct.interp=varargin{4};
    else
        DataStruct.interp=0; %default is no interpolate
    end
else
    DataStruct.eyepos=cumsum(DataStruct.omega_r)/DataStruct.smpf;
    DataStruct.realpos=0;
    DataStruct.interp=0; %default is no interpolate
end

DataStruct.rawtimeOld=DataStruct.rawtime;

DataStruct.resampleData=1;
DataStruct.zoomon=0; %Zoom start from off
DataStruct.pan=0; %pan start off
DataStruct.desaccadedvel=0; % Handles to the previous desaccaded vel plot
%Default value for desaccading
DataStruct.maxvel=500; %Extreems of histogram (pos and neg equal)
DataStruct.sampl=1; %hytogram bin size
DataStruct.velth=20; %threshold to detec saccades
DataStruct.N_filt=10; %median filter length
DataStruct.N_f3db=50; %3db lowpass cutoff
DataStruct.timewin=1*DataStruct.smpf; %Time windows to analize
DataStruct.eyevel=0; %default out 1
DataStruct.time=1; %default out 2
DataStruct.method=1;

DataStruct.eyepos_nofilt=DataStruct.eyepos;
DataStruct.omega_r_nofilt=DataStruct.omega_r;

% Set visual stuffs
set(handles.pButton_zoomOut,'Visible','Off');
set(handles.pButton_zoomOn,'String','Zoom on');
set(handles.pButton_Scroll,'String','Scroll on');
set(handles.edit_VelMax,'String',sprintf('%d',DataStruct.maxvel))
set(handles.edit_VelSmpl,'String',sprintf('%d',DataStruct.sampl))
set(handles.edit_VelThres,'String',sprintf('%d',DataStruct.velth))
set(handles.edit_TimeSize,'String',sprintf('%.2f',(DataStruct.timewin/DataStruct.smpf)))
set(handles.edit_LPcutoff,'String',sprintf('%d',(DataStruct.N_f3db)))
%set(handles.edit_Nsamples,'String',sprintf('%d',(DataStruct.N_filt)))
%set(handles.cBox_interp,'Value',DataStruct.interp)
%set(handles.radiobutton2,'Value',1)
%set(handles.radiobutton3,'Value',0)

% Plot the raw data
if isfield(DataStruct,'rawtime')
    plot(handles.vel_Axes,DataStruct.rawtime, DataStruct.omega_r,'r')
else
    plot(handles.vel_Axes,0:1/DataStruct.smpf:(length(DataStruct.omega_r)-1)/DataStruct.smpf, DataStruct.omega_r,'r')
end
% uiwait(hObject);
set(handles.vel_Axes,'nextplot','add');ylabel('Eye Velocity [deg/s]')
% uiwait(hObject);
%
if isfield(DataStruct,'rawtime')
    plot(handles.pos_Axes,DataStruct.rawtime, DataStruct.eyepos,'r')
else
    plot(handles.pos_Axes,0:1/DataStruct.smpf:(length(DataStruct.eyepos)-1)/DataStruct.smpf, DataStruct.eyepos,'r')
end
% uiwait(hObject);
set(handles.pos_Axes,'nextplot','add');ylabel('Eye Position [deg]');xlabel('Time [s]');
% uiwait(hObject);

%link axes
linkaxes( [handles.vel_Axes,handles.pos_Axes],'x');


set(handles.figure1,'UserData',DataStruct);
if length(varargin)>4
    if varargin{5}==1
        pushbutton6_Callback(hObject, eventdata, handles);
        
    else
        uiwait(hObject)
    end
else
    uiwait(hObject)
end


% --- Outputs from this function are returned to the command line.
function varargout = Interactive_desaccader_2v_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if ~isempty(handles)
    DataStruct=get(handles.figure1,'UserData');
    if DataStruct.desaccadedvel~=0
        switch nargout
            case 1
                varargout{1}=DataStruct;
            case 2
                varargout{1}=DataStruct.eyevel;
                varargout{2}=DataStruct.time;
            case 3
                varargout{1}=DataStruct.eyevel;
                varargout{2}=DataStruct.time;
                varargout{3}=DataStruct.index;
            case 4
                varargout{1}=DataStruct.eyevel;
                varargout{2}=DataStruct.time;
                varargout{3}=DataStruct.index;
                varargout{4}=DataStruct.saccExtremeIdx;
            case 5
                varargout{1}=DataStruct.eyevel;
                varargout{2}=DataStruct.time;
                varargout{3}=DataStruct.index;
                varargout{4}=DataStruct.saccExtremeIdx;
                varargout{5}=DataStruct.desaccadedvel;
            case 6
                varargout{1}=DataStruct.eyevel;
                varargout{2}=DataStruct.time;
                varargout{3}=DataStruct.index;
                varargout{4}=DataStruct.saccExtremeIdx;
                varargout{5}=DataStruct.desaccadedvel;
                varargout{6}=DataStruct.eyepos(DataStruct.index);
        end
    else
        switch nargout
            case {5,6}
                for i=1:4
                    varargout{i}=NaN;
                end
                varargout{5}=0;
                varargout{6}=NaN;
            otherwise
                for i=1:nargout
                    varargout{i}=NaN;
                end
        end
        
    end
    delete(hObject)
else
    switch nargout
        case {5,6}
            for i=1:4
                varargout{i}=NaN;
            end
            varargout{5}=0;
            varargout{6}=NaN;
        otherwise
            for i=1:nargout
                varargout{i}=NaN;
            end
    end
end




% --- Executes during object creation, after setting all properties.
function vel_Axes_CreateFcn(~, eventdata, handles)
% hObject    handle to vel_Axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate vel_Axes


% --- Executes on button press in pButton_zoomOn. ZOOM ON
function pButton_zoomOn_Callback(hObject, eventdata, handles)
% hObject    handle to pButton_zoomOn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DataStruct=get(handles.figure1,'UserData');
if DataStruct.zoomon==0
    DataStruct.zoom=zoom;
    set(DataStruct.zoom,'Enable', 'on')
    set(DataStruct.zoom,'Direction', 'in')
    set(handles.pButton_zoomOn,'String','Zoom off');
    set(handles.pButton_zoomOut,'Visible','On');
    DataStruct.zoomon=1;
else
    zoom off;
    set(DataStruct.zoom,'Enable', 'off')
    set(handles.pButton_zoomOn,'String','Zoom on');
    set(handles.pButton_zoomOut,'Visible','Off');
    DataStruct.zoomon=0;
end

set(handles.figure1,'UserData',DataStruct);


% --- Executes on button press in pButton_zoomOut. ZOOM IN/OUT
function pButton_zoomOut_Callback(hObject, eventdata, handles)
% hObject    handle to pButton_zoomOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

DataStruct=get(handles.figure1,'UserData');
if strcmp(get(DataStruct.zoom,'Direction'), 'in')
    set(DataStruct.zoom,'Enable', 'on')
    set(DataStruct.zoom,'Direction', 'out');
    set(handles.pButton_zoomOut,'String','Zoom in');
else
    set(DataStruct.zoom,'Enable', 'on')
    set(DataStruct.zoom,'Direction', 'in');
    set(handles.pButton_zoomOut,'String','Zoom out');
end

set(handles.figure1,'UserData',DataStruct);


% --- Executes on button press in pButton_Scroll. PAN On (scroll)
function pButton_Scroll_Callback(hObject, eventdata, handles)
% hObject    handle to pButton_Scroll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DataStruct=get(handles.figure1,'UserData');
if DataStruct.pan==0
    pan on;
    set(handles.pButton_Scroll,'String','Scroll off');
    set(handles.pButton_zoomOut,'Visible','On');
    DataStruct.pan=1;
else
    pan off;
    set(handles.pButton_Scroll,'String','Scroll on');
    DataStruct.pan=0;
end

set(handles.figure1,'UserData',DataStruct);


% --- Executes on button press in pButton_Restore.
function pButton_Restore_Callback(hObject, eventdata, handles)
% hObject    handle to pButton_Restore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DataStruct=get(handles.figure1,'UserData');
zoom out;
if isfield(DataStruct,'zoom')
    set(DataStruct.zoom,'Enable', 'off');
    pan off;
    set(handles.pButton_zoomOn,'String','Zoom on');
    set(handles.pButton_Scroll,'String','Scroll on');
    set(handles.pButton_zoomOut,'Visible','Off');
    set(handles.figure1,'UserData',DataStruct);
end


function edit_VelMax_Callback(hObject, eventdata, handles)
% hObject    handle to edit_VelMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_VelMax as text
%        str2double(get(hObject,'String')) returns contents of edit_VelMax as a double
DataStruct=get(handles.figure1,'UserData');
DataStruct.maxvel=str2double(get(hObject,'String'));
set(handles.figure1,'UserData',DataStruct);

% --- Executes during object creation, after setting all properties.
function edit_VelMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_VelMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_VelSmpl_Callback(hObject, eventdata, handles)
% hObject    handle to edit_VelSmpl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_VelSmpl as text
%        str2double(get(hObject,'String')) returns contents of edit_VelSmpl as a double
DataStruct=get(handles.figure1,'UserData');
DataStruct.sampl=str2double(get(hObject,'String'));
set(handles.figure1,'UserData',DataStruct);

% --- Executes during object creation, after setting all properties.
function edit_VelSmpl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_VelSmpl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_VelThres_Callback(hObject, eventdata, handles)
% hObject    handle to edit_VelThres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_VelThres as text
%        str2double(get(hObject,'String')) returns contents of edit_VelThres as a double
DataStruct=get(handles.figure1,'UserData');
DataStruct.velth=str2double(get(hObject,'String'));
set(handles.figure1,'UserData',DataStruct);

% --- Executes during object creation, after setting all properties.
function edit_VelThres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_VelThres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_TimeSize_Callback(hObject, eventdata, handles)
% hObject    handle to edit_TimeSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_TimeSize as text
%        str2double(get(hObject,'String')) returns contents of edit_TimeSize as a double
DataStruct=get(handles.figure1,'UserData');
DataStruct.timewin=str2double(get(hObject,'String'))*DataStruct.smpf;
set(handles.figure1,'UserData',DataStruct);

% --- Executes during object creation, after setting all properties.
function edit_TimeSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_TimeSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%-->%Desaccade Signal%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in pButton_desacc.
function pButton_desacc_Callback(hObject, eventdata, handles)
% hObject    handle to pButton_desacc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DataStruct=get(handles.figure1,'UserData');
set(handles.pButton_desacc,'Enable','off')
set(handles.pButton_Restore,'Enable','off')
set(handles.pButton_Scroll,'Enable','off')
set(handles.pButton_zoomOut,'Enable','off')
set(handles.pButton_zoomOn,'Enable','off')
set(handles.pButton_exit,'Enable','off')
set(handles.edit_VelMax,'Enable','off')
set(handles.edit_VelSmpl,'Enable','off')
set(handles.edit_VelThres,'Enable','off')
set(handles.edit_TimeSize,'Enable','off')

pause(0.1)
[S] = JL_desaccader_modif(DataStruct.omega_r,-DataStruct.maxvel:DataStruct.sampl:DataStruct.maxvel,DataStruct.velth,DataStruct.timewin,DataStruct.method);
%find(S==0) conteins the indices of desaccade samples
dstr.indices=saccextremesfinder(S);
[eyevel,time,index]=desacc_dataGB(DataStruct.omega_r,DataStruct.rawtime',dstr.indices,0,DataStruct.interp);
eyepos=DataStruct.eyepos(index);
% eyepos=DataStruct.eyepos(round(time*DataStruct.smpf));
if DataStruct.desaccadedvel~=0
    delete(DataStruct.desaccadedvel);
end
if DataStruct.interp==1
    DataStruct.desaccadedvel(1)=plot(handles.vel_Axes,time,eyevel);
    pause(0.1)
    DataStruct.desaccadedvel(2)=plot(handles.pos_Axes,time(index),eyepos,'b.');
    pause(0.1)
else
    DataStruct.desaccadedvel(1)=plot(handles.vel_Axes,time,eyevel,'b.');
    pause(0.1)
    DataStruct.desaccadedvel(2)=plot(handles.pos_Axes,time,eyepos,'b.');
    pause(0.1)
end
DataStruct.eyevel=eyevel;
DataStruct.time=time;
DataStruct.index=index;
DataStruct.saccExtremeIdx=dstr.indices;
set(handles.pButton_desacc,'Enable','on')
set(handles.pButton_Restore,'Enable','on')
set(handles.pButton_Scroll,'Enable','on')
set(handles.pButton_zoomOut,'Enable','on')
set(handles.pButton_zoomOn,'Enable','on')
set(handles.pButton_exit,'Enable','on')
set(handles.edit_VelThres,'Enable','on')
set(handles.edit_TimeSize,'Enable','on')

set(handles.figure1,'UserData',DataStruct);
set(handles.error,'String',{''});


%-->%Exit and discart%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in pButton_exit.
function pButton_exit_Callback(hObject, eventdata, handles)
% hObject    handle to pButton_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Interactive_desaccader_2v_OutputFcn(handles.figure1, eventdata,handles);
uiresume(handles.figure1);


% --- Executes on button press in cBox_interp.
function cBox_interp_Callback(hObject, eventdata, handles)
% hObject    handle to cBox_interp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DataStruct=get(handles.figure1,'UserData');
DataStruct.interp=get(hObject,'Value');


if DataStruct.desaccadedvel~=0
    %pushbutton6_Callback(hObject, eventdata, handles)
    delete(DataStruct.desaccadedvel)
    DataStruct.desaccadedvel=0;
end
set(handles.figure1,'UserData',DataStruct);

% Hint: get(hObject,'Value') returns toggle state of cBox_interp


%-->%Separate Desaccading%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in pButton_sepDesacc.
function pButton_sepDesacc_Callback(hObject, eventdata, handles)
% hObject    handle to pButton_sepDesacc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DataStruct=get(handles.figure1,'UserData');


if 0%DataStruct.desaccadedvel~=0
    [x,~]=ginput(2);
    onindex=find(DataStruct.rawtime<x(1),1,'last');
    endindex=find(DataStruct.rawtime>x(2),1,'first');
    %To get the index in the raw data is simple: get the time value and
    %multiply it for the smpf
    onindexcut=DataStruct.rawtime(onindex)*DataStruct.smpf;
    endindexcut=DataStruct.rawtime(endindex)*DataStruct.smpf;
    
    [temp.eyevel,temp.time,temp.index]=Interactive_desaccader_2v(DataStruct.omega_r(onindexcut:endindexcut),DataStruct.rawtime(onindexcut:endindexcut),[],DataStruct.interp);
    
    
    %replace the old part with the new part, indexing give by time because it
    %might be that there are missing point if interp=0
    DataStruct.eyevel=[DataStruct.eyevel(1:onindex-1); temp.eyevel; DataStruct.eyevel(endindex+1:end)];
    DataStruct.time=[DataStruct.time(1:onindex-1); temp.time+DataStruct.time(onindex); DataStruct.time(endindex+1:end)];
    
    idx(1)=find(DataStruct.index<=(onindex),1,'last');
    idx(2)=find(DataStruct.index>=(endindex),1,'first');
    DataStruct.index=[DataStruct.index(1:idx(1)); temp.index+DataStruct.index(idx(1)); DataStruct.index( idx(2):end)];
    %redo the plot with the new part
    if DataStruct.desaccadedvel~=0
        delete(DataStruct.desaccadedvel);
    end
    
    if DataStruct.interp==1
        DataStruct.desaccadedvel(1)=plot(handles.vel_Axes,DataStruct.time,DataStruct.eyevel);
        pause(0.1)
        DataStruct.desaccadedvel(2)=plot(handles.pos_Axes,DataStruct.time(DataStruct.index),DataStruct.eyepos(DataStruct.index),'b.');
        pause(0.1)
    else
        DataStruct.desaccadedvel(1)=plot(handles.vel_Axes,DataStruct.time,DataStruct.eyevel,'b.');
        pause(0.1)
        DataStruct.desaccadedvel(2)=plot(handles.pos_Axes,DataStruct.time(DataStruct.index),DataStruct.eyepos(DataStruct.index),'b.');
        pause(0.1)
    end
    
    
    set(handles.figure1,'UserData',DataStruct);
else
    set(handles.error,'String',{'Please fist desaccade whole signal!'});
    set(handles.error,'ForegroundColor','Red');
end


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
DataStruct=get(handles.figure1,'UserData');

set(handles.figure1,'UserData',DataStruct);


% --- Executes during object creation, after setting all properties.
function parameterT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to parameterT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3
DataStruct=get(handles.figure1,'UserData');
DataStruct.method=2;
set(handles.radiobutton3,'Value',1)
set(handles.radiobutton2,'Value',0)

set(handles.figure1,'UserData',DataStruct);

% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
DataStruct=get(handles.figure1,'UserData');
DataStruct.method=1;
set(handles.radiobutton2,'Value',1)
set(handles.radiobutton3,'Value',0)


set(handles.figure1,'UserData',DataStruct);


% --- Executes on button press in cBox_medianFilt.
function cBox_medianFilt_Callback(hObject, eventdata, handles)
% hObject    handle to cBox_medianFilt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DataStruct=get(handles.figure1,'UserData');
if get(hObject,'Value')
    DataStruct.eyepos=DataStruct.eyepos_nofilt;
    DataStruct.omega_r=DataStruct.omega_r_nofilt;
    
    set(handles.cBox_LPfilter,'Value',false);
    DataStruct.filter=1;
    DataStruct.N_filt= str2double(get(handles.edit_Nsamples,'String'));
    if DataStruct.N_filt> length(DataStruct.omega_r)/2
        DataStruct.N_f3db=round(length(DataStruct.omega_r)/2);
        set(hObject,'String',num2str(DataStruct.N_f3db));
    end
    
    if DataStruct.resampleData
        [DataStruct.rawtime,DataStruct.eyepos]=resampleData(DataStruct.rawtimeOld,DataStruct.eyepos,DataStruct.smpf); % resample Data at same freq     
        [DataStruct.rawtime,DataStruct.omega_r]=resampleData(DataStruct.rawtimeOld,DataStruct.omega_r,DataStruct.smpf); % resample Data at same freq
    end

   
    
    DataStruct.omega_r=medfilt1(DataStruct.omega_r,DataStruct.N_filt);
    DataStruct.eyepos=medfilt1(DataStruct.eyepos,DataStruct.N_filt);
    %DataStruct.eyepos=cumsum(DataStruct.omega_r)/DataStruct.smpf;
    DataStruct.desaccadedvel=0;
    cla(handles.vel_Axes)
    if isfield(DataStruct,'rawtime')
        plot(handles.vel_Axes,DataStruct.rawtime, DataStruct.omega_r,'r')
    else
        plot(handles.vel_Axes,0:1/DataStruct.smpf:(length(DataStruct.omega_r)-1)/DataStruct.smpf, DataStruct.omega_r,'r')
    end
    
    set(handles.vel_Axes,'nextplot','add');ylabel('Eye Velocity [deg/s]')
    
    cla(handles.pos_Axes)
    if isfield(DataStruct,'rawtime')
        plot(handles.pos_Axes,DataStruct.rawtime, DataStruct.eyepos,'r')
    else
        plot(handles.pos_Axes,0:1/DataStruct.smpf:(length(DataStruct.eyepos)-1)/DataStruct.smpf, DataStruct.eyepos,'r')
    end
    
    set(handles.pos_Axes,'nextplot','add');ylabel('Eye Position [deg]');xlabel('Time [s]');
    %DataStruct.eyepos=DataStruct.eyepos_nofilt;
else
    DataStruct.filter=0;
    DataStruct.rawtime=DataStruct.rawtimeOld;
    DataStruct.eyepos=DataStruct.eyepos_nofilt;
    DataStruct.omega_r=DataStruct.omega_r_nofilt;
    DataStruct.desaccadedvel=0;cla(handles.vel_Axes)
    if isfield(DataStruct,'rawtime')
        plot(handles.vel_Axes,DataStruct.rawtime, DataStruct.omega_r,'r')
    else
        plot(handles.vel_Axes,0:1/DataStruct.smpf:(length(DataStruct.omega_r)-1)/DataStruct.smpf, DataStruct.omega_r,'r')
    end
    
    set(handles.vel_Axes,'nextplot','add');ylabel('Eye Velocity [deg/s]')
    
    cla(handles.pos_Axes)
    if isfield(DataStruct,'rawtime')
        plot(handles.pos_Axes,DataStruct.rawtime, DataStruct.eyepos,'r')
    else
        plot(handles.pos_Axes,0:1/DataStruct.smpf:(length(DataStruct.eyepos)-1)/DataStruct.smpf, DataStruct.eyepos,'r')
    end
    
    set(handles.pos_Axes,'nextplot','add');ylabel('Eye Position [deg]');xlabel('Time [s]');
    
end

set(handles.figure1,'UserData',DataStruct);
%pushbutton6_Callback(hObject, eventdata, handles)

% Hint: get(hObject,'Value') returns toggle state of cBox_medianFilt



function edit_Nsamples_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Nsamples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Nsamples as text
%        str2double(get(hObject,'String')) returns contents of edit_Nsamples as a double

DataStruct=get(handles.figure1,'UserData');
DataStruct.N_filt=str2double(get(hObject,'String'));
if DataStruct.N_filt> length(DataStruct.omega_r)/2
    DataStruct.N_f3db=round(length(DataStruct.omega_r)/2);
    set(hObject,'String',num2str(DataStruct.N_f3db));
end
set(handles.cBox_medianFilt,'Value',false);

set(handles.figure1,'UserData',DataStruct);
cBox_medianFilt_Callback(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit_Nsamples_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Nsamples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-->%Separate LPfilter%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in cBox_LPfilter.
function cBox_LPfilter_Callback(hObject, eventdata, handles)
% hObject    handle to cBox_LPfilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cBox_LPfilter
% hObject    handle to cBox_medianFilt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DataStruct=get(handles.figure1,'UserData');
if get(hObject,'Value')
    set(handles.cBox_medianFilt,'Value',false);
    DataStruct.eyepos=DataStruct.eyepos_nofilt; %restore data
    DataStruct.omega_r=DataStruct.omega_r_nofilt;
    DataStruct.filter=1;
    DataStruct.N_f3db= str2double(get(handles.edit_LPcutoff,'String'));%check cutoff frequency
    
    if DataStruct.N_f3db>DataStruct.smpf/2
        DataStruct.N_f3db=(DataStruct.smpf/2)-1;
        set(handles.edit_LPcutoff,'String',num2str(DataStruct.smpf/2-1));
    end
    
    if DataStruct.resampleData
        [DataStruct.rawtime,DataStruct.eyepos]=resampleData(DataStruct.rawtimeOld,DataStruct.eyepos,DataStruct.smpf); % resample Data at same freq     
        [DataStruct.rawtime,DataStruct.omega_r]=resampleData(DataStruct.rawtimeOld,DataStruct.omega_r,DataStruct.smpf); % resample Data at same freq
    end

    DataStruct.omega_r = butterFilterNaN( DataStruct.omega_r,DataStruct.smpf,DataStruct.N_f3db);
    %DataStruct.eyepos=cumsum(DataStruct.omega_r)/DataStruct.smpf; 
    DataStruct.eyepos = butterFilterNaN( DataStruct.eyepos,DataStruct.smpf,DataStruct.N_f3db);
    
    
    
    DataStruct.desaccadedvel=0;
    cla(handles.vel_Axes)
    if isfield(DataStruct,'rawtime')
        plot(handles.vel_Axes,DataStruct.rawtime, DataStruct.omega_r,'r')
    else
        plot(handles.vel_Axes,0:1/DataStruct.smpf:(length(DataStruct.omega_r)-1)/DataStruct.smpf, DataStruct.omega_r,'r')
    end
    
    set(handles.vel_Axes,'nextplot','add');ylabel('Eye Velocity [deg/s]')
    
    cla(handles.pos_Axes)
    if isfield(DataStruct,'rawtime')
        plot(handles.pos_Axes,DataStruct.rawtime, DataStruct.eyepos,'r')
    else
        plot(handles.pos_Axes,0:1/DataStruct.smpf:(length(DataStruct.eyepos)-1)/DataStruct.smpf, DataStruct.eyepos,'r')
    end
    
    set(handles.pos_Axes,'nextplot','add');ylabel('Eye Position [deg]');xlabel('Time [s]');
    %DataStruct.eyepos=DataStruct.eyepos_nofilt;
else
    DataStruct.filter=0;
    DataStruct.eyepos=DataStruct.eyepos_nofilt;
    DataStruct.omega_r=DataStruct.omega_r_nofilt;
    DataStruct.rawtime=DataStruct.rawtimeOld;
    DataStruct.desaccadedvel=0;cla(handles.vel_Axes)
    if isfield(DataStruct,'rawtime')
        plot(handles.vel_Axes,DataStruct.rawtime, DataStruct.omega_r,'r')
    else
        plot(handles.vel_Axes,0:1/DataStruct.smpf:(length(DataStruct.omega_r)-1)/DataStruct.smpf, DataStruct.omega_r,'r')
    end
    
    set(handles.vel_Axes,'nextplot','add');ylabel('Eye Velocity [deg/s]')
    
    cla(handles.pos_Axes)
    if isfield(DataStruct,'rawtime')
        plot(handles.pos_Axes,DataStruct.rawtime, DataStruct.eyepos,'r')
    else
        plot(handles.pos_Axes,0:1/DataStruct.smpf:(length(DataStruct.eyepos)-1)/DataStruct.smpf, DataStruct.eyepos,'r')
    end
    
    set(handles.pos_Axes,'nextplot','add');ylabel('Eye Position [deg]');xlabel('Time [s]');
end

set(handles.figure1,'UserData',DataStruct);


function edit_LPcutoff_Callback(hObject, eventdata, handles)
% hObject    handle to edit_LPcutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_LPcutoff as text
%        str2double(get(hObject,'String')) returns contents of edit_LPcutoff as a double

DataStruct=get(handles.figure1,'UserData');
f3db=str2double(get(hObject,'String'));
if f3db>DataStruct.smpf/2
    DataStruct.N_f3db=DataStruct.smpf/2-1;
    set(hObject,'String',num2str(DataStruct.smpf/2-1));
else
    DataStruct.N_f3db=f3db;
end

set(handles.cBox_LPfilter,'Value',false);
set(handles.figure1,'UserData',DataStruct);
cBox_LPfilter_Callback(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function edit_LPcutoff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_LPcutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pButton_remDesacc.
function pButton_remDesacc_Callback(hObject, eventdata, handles)
% hObject    handle to pButton_remDesacc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DataStruct=get(handles.figure1,'UserData');
if DataStruct.desaccadedvel~=0
    [x,~]=ginput(2); %time instants
    onindex=find(DataStruct.time<x(1),1,'last'); %
    endindex=find(DataStruct.time>x(2),1,'first');
        
    %remove the selected part 
    DataStruct.eyevel(onindex:endindex)=[];
    DataStruct.time(onindex:endindex)=[]; 
    DataStruct.index(onindex:endindex)=[];
    
    if DataStruct.desaccadedvel~=0
        delete(DataStruct.desaccadedvel);
    end
    if DataStruct.interp==1 %to check
        DataStruct.desaccadedvel(1)=plot(handles.vel_Axes,DataStruct.time,DataStruct.eyevel);
        pause(0.1)
        DataStruct.desaccadedvel(2)=plot(handles.pos_Axes,DataStruct.time,DataStruct.eyepos(DataStruct.index),'b.');
        pause(0.1)
    else
        DataStruct.desaccadedvel(1)=plot(handles.vel_Axes,DataStruct.time,DataStruct.eyevel,'b.');
        pause(0.1)
        DataStruct.desaccadedvel(2)=plot(handles.pos_Axes,DataStruct.time,DataStruct.eyepos(DataStruct.index),'b.');
        pause(0.1)
    end
    
    
    set(handles.figure1,'UserData',DataStruct);
else
    set(handles.error,'String',{'Please fist desaccade whole signal!'});
    set(handles.error,'ForegroundColor','Red');
end


% --- Executes on button press in cBox_minSacc.
function cBox_minSacc_Callback(hObject, eventdata, handles)
% hObject    handle to cBox_minSacc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cBox_minSacc



function edit_minSacc_Callback(hObject, eventdata, handles)
% hObject    handle to edit_minSacc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_minSacc as text
%        str2double(get(hObject,'String')) returns contents of edit_minSacc as a double


% --- Executes during object creation, after setting all properties.
function edit_minSacc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_minSacc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cBox_timeSP.
function cBox_timeSP_Callback(hObject, eventdata, handles)
% hObject    handle to cBox_timeSP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cBox_timeSP



function edit_timeSP_Callback(hObject, eventdata, handles)
% hObject    handle to edit_timeSP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_timeSP as text
%        str2double(get(hObject,'String')) returns contents of edit_timeSP as a double


% --- Executes during object creation, after setting all properties.
function edit_timeSP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_timeSP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cBox_minVelSacc.
function cBox_minVelSacc_Callback(hObject, eventdata, handles)
% hObject    handle to cBox_minVelSacc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cBox_minVelSacc



function edit_minVelSacc_Callback(hObject, eventdata, handles)
% hObject    handle to edit_minVelSacc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_minVelSacc as text
%        str2double(get(hObject,'String')) returns contents of edit_minVelSacc as a double


% --- Executes during object creation, after setting all properties.
function edit_minVelSacc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_minVelSacc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
