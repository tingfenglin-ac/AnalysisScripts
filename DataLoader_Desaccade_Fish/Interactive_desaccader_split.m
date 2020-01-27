function varargout = Interactive_desaccader(varargin)
% INTERACTIVE_DESACCADER M-file for Interactive_desaccader.fig
%      INTERACTIVE_DESACCADER, by itself, creates a new INTERACTIVE_DESACCADER or raises the existing
%      singleton*.
%
%      H = INTERACTIVE_DESACCADER returns the handle to a new INTERACTIVE_DESACCADER or the handle to
%      the existing singleton*.
%
%      INTERACTIVE_DESACCADER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERACTIVE_DESACCADER.M with the given input arguments.
%
%      INTERACTIVE_DESACCADER('Property','Value',...) creates a new INTERACTIVE_DESACCADER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Interactive_desaccader_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Interactive_desaccader_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Interactive_desaccader

% Last Modified by GUIDE v2.5 17-Dec-2009 10:42:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Interactive_desaccader_OpeningFcn, ...
                   'gui_OutputFcn',  @Interactive_desaccader_OutputFcn, ...
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


% --- Executes just before Interactive_desaccader is made visible.
function Interactive_desaccader_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Interactive_desaccader (see VARARGIN)

% Choose default command line output for Interactive_desaccader
handles.output = hObject;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Interactive_desaccader wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%Inizalization of the datastruct
DataStruct=struct; %stucture to be use to move data
DataStruct.omega_r=varargin{1};%import Velocity from outside
DataStruct.smpf=varargin{2};%import sampling freq from outside
DataStruct.zoomon=0; %Zoom start from off
DataStruct.pan=0; %pan start off
DataStruct.desaccadedvel=0; % Handles to the previous desaccaded vel plot
%Default value for desaccading
DataStruct.maxvel=300; %Extreems of histogram (pos and neg equal)
DataStruct.sampl=1; %hytogram bin size
DataStruct.velth=10; %threshold to detec saccades
DataStruct.timewin=0.3*DataStruct.smpf; %Time windows to analize
if nargin>2
DataStruct.interp=varargin{3}; %Import interp flag from outside
else
DataStruct.interp=1; %default is to interpolate
end
DataStruct.eyevel=0; %default out 1
DataStruct.time=1; %default out 2

DataStruct.splitpoint=

% Set visual stuffs
set(handles.pushbutton3,'Visible','Off');
set(handles.pushbutton1,'String','Zoom on');
set(handles.pushbutton4,'String','Scroll on');
set(handles.edit2,'String',sprintf('%d',DataStruct.maxvel))
set(handles.edit3,'String',sprintf('%d',DataStruct.sampl))
set(handles.edit4,'String',sprintf('%d',DataStruct.velth))
set(handles.edit5,'String',sprintf('%.2f',(DataStruct.timewin/DataStruct.smpf)))
set(handles.checkbox1,'Value',DataStruct.interp)

% Plot the raw data
plot(handles.axes1,1/DataStruct.smpf:1/DataStruct.smpf:(length(DataStruct.omega_r)/DataStruct.smpf), DataStruct.omega_r,'r')
hold on
xlabel('Time [s]')
ylabel('Eye Velocity [deg/s]')


set(handles.figure1,'UserData',DataStruct);
 uiwait(hObject);

% --- Outputs from this function are returned to the command line.
function varargout = Interactive_desaccader_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
DataStruct=get(handles.figure1,'UserData');
varargout{1}=DataStruct.eyevel;
varargout{2}=DataStruct.time;
delete(hObject)




% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on button press in pushbutton1. ZOOM ON
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DataStruct=get(handles.figure1,'UserData');
if DataStruct.zoomon==0
DataStruct.zoom=zoom;
set(DataStruct.zoom,'Enable', 'on')
set(DataStruct.zoom,'Direction', 'in')
set(handles.pushbutton1,'String','Zoom off');
set(handles.pushbutton3,'Visible','On');
DataStruct.zoomon=1;
else
    zoom off;
    set(DataStruct.zoom,'Enable', 'off')
    set(handles.pushbutton1,'String','Zoom on');
    set(handles.pushbutton3,'Visible','Off');
    DataStruct.zoomon=0;
end
    
set(handles.figure1,'UserData',DataStruct);


% --- Executes on button press in pushbutton3. ZOOM IN/OUT
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

DataStruct=get(handles.figure1,'UserData');
if strcmp(get(DataStruct.zoom,'Direction'), 'in')
    set(DataStruct.zoom,'Enable', 'on')
    set(DataStruct.zoom,'Direction', 'out');
    set(handles.pushbutton3,'String','Zoom in');
else
    set(DataStruct.zoom,'Enable', 'on')
    set(DataStruct.zoom,'Direction', 'in');
    set(handles.pushbutton3,'String','Zoom out');    
end
    
set(handles.figure1,'UserData',DataStruct);


% --- Executes on button press in pushbutton4. PAN On (scroll)
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DataStruct=get(handles.figure1,'UserData');
if DataStruct.pan==0
pan on;
set(handles.pushbutton4,'String','Scroll off');
set(handles.pushbutton3,'Visible','On');
DataStruct.pan=1;
else
    pan off;
    set(handles.pushbutton4,'String','Scroll on');
    DataStruct.pan=0;
end
    
set(handles.figure1,'UserData',DataStruct);


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DataStruct=get(handles.figure1,'UserData');
zoom out;
set(DataStruct.zoom,'Enable', 'off');
pan off;
set(handles.pushbutton1,'String','Zoom on');
set(handles.pushbutton4,'String','Scroll on');
set(handles.pushbutton3,'Visible','Off');
set(handles.figure1,'UserData',DataStruct);



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
DataStruct=get(handles.figure1,'UserData');
DataStruct.maxvel=str2double(get(hObject,'String'));
set(handles.figure1,'UserData',DataStruct);

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
DataStruct=get(handles.figure1,'UserData');
DataStruct.sampl=str2double(get(hObject,'String'));
set(handles.figure1,'UserData',DataStruct);

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
DataStruct=get(handles.figure1,'UserData');
DataStruct.velth=str2double(get(hObject,'String'));
set(handles.figure1,'UserData',DataStruct);

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
DataStruct=get(handles.figure1,'UserData');
DataStruct.timewin=str2double(get(hObject,'String'))*DataStruct.smpf;
set(handles.figure1,'UserData',DataStruct);

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DataStruct=get(handles.figure1,'UserData');
set(handles.pushbutton6,'Enable','off')
set(handles.pushbutton5,'Enable','off')
set(handles.pushbutton4,'Enable','off')
set(handles.pushbutton3,'Enable','off')
set(handles.pushbutton1,'Enable','off')
set(handles.pushbutton7,'Enable','off')
set(handles.edit2,'Enable','off')
set(handles.edit3,'Enable','off')
set(handles.edit4,'Enable','off')
set(handles.edit5,'Enable','off')

pause(0.1)
[S] = JL_desaccader_modif(DataStruct.omega_r,-DataStruct.maxvel:DataStruct.sampl:DataStruct.maxvel,DataStruct.velth,DataStruct.timewin);
dstr.indices=saccextremesfinder(S);
[eyevel,time]=desacc_dataGB(DataStruct.omega_r,DataStruct.smpf,dstr.indices,0,DataStruct.interp);
if not(DataStruct.desaccadedvel==0)
    delete(DataStruct.desaccadedvel);
end
if DataStruct.interp==1
    DataStruct.desaccadedvel=plot(handles.axes1,time,eyevel);
    pause(0.1)
else
    DataStruct.desaccadedvel=plot(handles.axes1,time,eyevel,'b.');
    pause(0.1)
end
DataStruct.eyevel=eyevel;
DataStruct.time=time;
set(handles.pushbutton6,'Enable','on')
set(handles.pushbutton5,'Enable','on')
set(handles.pushbutton4,'Enable','on')
set(handles.pushbutton3,'Enable','on')
set(handles.pushbutton1,'Enable','on')
set(handles.pushbutton7,'Enable','on')
set(handles.edit2,'Enable','on')
set(handles.edit3,'Enable','on')
set(handles.edit4,'Enable','on')
set(handles.edit5,'Enable','on')

set(handles.figure1,'UserData',DataStruct);


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Interactive_desaccader_OutputFcn(handles.figure1, eventdata,handles);
uiresume(handles.figure1);


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DataStruct=get(handles.figure1,'UserData');
DataStruct.interp=get(hObject,'Value');
set(handles.figure1,'UserData',DataStruct);
if not(DataStruct.desaccadedvel==0)
    pushbutton6_Callback(hObject, eventdata, handles)
end

% Hint: get(hObject,'Value') returns toggle state of checkbox1


