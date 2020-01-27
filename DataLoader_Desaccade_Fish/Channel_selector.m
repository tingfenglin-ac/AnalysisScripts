function varargout = Channel_selector(varargin)
% CHANNEL_SELECTOR M-file for Channel_selector.fig
%      CHANNEL_SELECTOR, by itself, creates a new CHANNEL_SELECTOR or raises the existing
%      singleton*.
%
%      H = CHANNEL_SELECTOR returns the handle to a new CHANNEL_SELECTOR or the handle to
%      the existing singleton*.
%
%      CHANNEL_SELECTOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHANNEL_SELECTOR.M with the given input arguments.
%
%      CHANNEL_SELECTOR('Property','Value',...) creates a new CHANNEL_SELECTOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Channel_selector_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Channel_selector_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Channel_selector

% Last Modified by GUIDE v2.5 22-Oct-2008 17:38:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Channel_selector_OpeningFcn, ...
                   'gui_OutputFcn',  @Channel_selector_OutputFcn, ...
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


% --- Executes just before Channel_selector is made visible.
function Channel_selector_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Channel_selector (see VARARGIN)

% Choose default command line output for Channel_selector
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set(hObject,'WindowStyle','modal')
% UIWAIT makes Channel_selector wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% INITIALIZATIONS of variables and gui parts
%Variables
DataStruct=struct;

%Left eye channels
DataStruct.LeftEyeChannels=[];
%Right eye channels
DataStruct.RightEyeChannels=[];
%Chair channels
DataStruct.LaserChannels=[];
%Laser channels
DataStruct.ChairChannels=[];


% Gui parts
set(handles.edit1,'String',cell2mat(varargin(1)));

% Set the default channels numbers
% Left eye
set(handles.edit26,'String',8);
set(handles.edit27,'String',9);
set(handles.edit28,'String',10);
set(handles.edit29,'String',11);
set(handles.edit30,'String',12);
set(handles.edit31,'String',13);

% Right eye
set(handles.edit20,'String',2);
set(handles.edit21,'String',3);
set(handles.edit22,'String',4);
set(handles.edit23,'String',5);
set(handles.edit24,'String',6);
set(handles.edit25,'String',7);

% Chair
set(handles.edit14,'String',1);
set(handles.edit15,'String',14);
set(handles.edit16,'String',15);


% Laser
set(handles.edit17,'String',16);
set(handles.edit18,'String',17);
set(handles.edit19,'String',18);


% Save Datastruct in the handles
set(handles.figure1,'UserData',DataStruct);



% --- Outputs from this function are returned to the command line.
function varargout = Channel_selector_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;







% LEFT EYE BEGIN HERE

% --- Executes on button press in radiobutton17.
function radiobutton17_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton17
DataStruct=get(handles.figure1,'UserData');
if get(hObject,'Value')
    set(handles.edit26,'Style','text');
    set(handles.edit1,'String',str2num(get(handles.edit1,'String'))-1);
    DataStruct=channel_select(DataStruct,str2num(get(handles.edit26,'String')));
    DataStruct.LeftEyeChannels=[DataStruct.LeftEyeChannels str2num(get(handles.edit26,'String'))];
    DataStruct.LeftEyeChannels=sort(DataStruct.LeftEyeChannels);
else
    set(handles.edit26,'Style','edit');
    set(handles.edit1,'String',str2num(get(handles.edit1,'String'))+1);
    DataStruct=channel_deselect(DataStruct,str2num(get(handles.edit26,'String')))
end
set(handles.figure1,'UserData',DataStruct);



% --- Executes on button press in radiobutton18.
function radiobutton18_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton18
DataStruct=get(handles.figure1,'UserData');
if get(hObject,'Value')
    set(handles.edit27,'Style','text');
    set(handles.edit1,'String',str2num(get(handles.edit1,'String'))-1);
    DataStruct=channel_select(DataStruct,str2num(get(handles.edit27,'String')));
    DataStruct.LeftEyeChannels=[DataStruct.LeftEyeChannels str2num(get(handles.edit27,'String'))];
    DataStruct.LeftEyeChannels=sort(DataStruct.LeftEyeChannels);
else
    set(handles.edit27,'Style','edit');
    set(handles.edit1,'String',str2num(get(handles.edit1,'String'))+1);
    DataStruct=channel_deselect(DataStruct,str2num(get(handles.edit27,'String')))
end
set(handles.figure1,'UserData',DataStruct);


% --- Executes on button press in radiobutton19.
function radiobutton19_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton19
DataStruct=get(handles.figure1,'UserData');
if get(hObject,'Value')
    set(handles.edit28,'Style','text');
    set(handles.edit1,'String',str2num(get(handles.edit1,'String'))-1);
    DataStruct=channel_select(DataStruct,str2num(get(handles.edit28,'String')));
    DataStruct.LeftEyeChannels=[DataStruct.LeftEyeChannels str2num(get(handles.edit28,'String'))];
    DataStruct.LeftEyeChannels=sort(DataStruct.LeftEyeChannels);
else
    set(handles.edit28,'Style','edit');
    set(handles.edit1,'String',str2num(get(handles.edit1,'String'))+1);
    DataStruct=channel_deselect(DataStruct,str2num(get(handles.edit28,'String')))
end
set(handles.figure1,'UserData',DataStruct);

% --- Executes on button press in radiobutton20.
function radiobutton20_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton20
DataStruct=get(handles.figure1,'UserData');
if get(hObject,'Value')
    set(handles.edit29,'Style','text');
    set(handles.edit1,'String',str2num(get(handles.edit1,'String'))-1);
    DataStruct=channel_select(DataStruct,str2num(get(handles.edit29,'String')));
    DataStruct.LeftEyeChannels=[DataStruct.LeftEyeChannels str2num(get(handles.edit29,'String'))];
    DataStruct.LeftEyeChannels=sort(DataStruct.LeftEyeChannels);
else
    set(handles.edit29,'Style','edit');
    set(handles.edit1,'String',str2num(get(handles.edit1,'String'))+1);
   DataStruct=channel_deselect(DataStruct,str2num(get(handles.edit29,'String')))
end
set(handles.figure1,'UserData',DataStruct);

% --- Executes on button press in radiobutton21.
function radiobutton21_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton21
DataStruct=get(handles.figure1,'UserData');
if get(hObject,'Value')
    set(handles.edit30,'Style','text');
    set(handles.edit1,'String',str2num(get(handles.edit1,'String'))-1);
    DataStruct=channel_select(DataStruct,str2num(get(handles.edit30,'String')));
    DataStruct.LeftEyeChannels=[DataStruct.LeftEyeChannels str2num(get(handles.edit30,'String'))];
    DataStruct.LeftEyeChannels=sort(DataStruct.LeftEyeChannels);
else
    set(handles.edit30,'Style','edit');
    set(handles.edit1,'String',str2num(get(handles.edit1,'String'))+1);
    DataStruct=channel_deselect(DataStruct,str2num(get(handles.edit30,'String')))
end
set(handles.figure1,'UserData',DataStruct);


% --- Executes on button press in radiobutton22.
function radiobutton22_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton22
DataStruct=get(handles.figure1,'UserData');
if get(hObject,'Value')
    set(handles.edit31,'Style','text');
    set(handles.edit1,'String',str2num(get(handles.edit1,'String'))-1);
    DataStruct=channel_select(DataStruct,str2num(get(handles.edit31,'String')));
    DataStruct.LeftEyeChannels=[DataStruct.LeftEyeChannels str2num(get(handles.edit31,'String'))];
    DataStruct.LeftEyeChannels=sort(DataStruct.LeftEyeChannels);
else
    set(handles.edit31,'Style','edit');
    set(handles.edit1,'String',str2num(get(handles.edit1,'String'))+1);
    DataStruct=channel_deselect(DataStruct,str2num(get(handles.edit31,'String')))
end
set(handles.figure1,'UserData',DataStruct);


function edit26_Callback(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit26 as text
%        str2double(get(hObject,'String')) returns contents of edit26 as a double


% --- Executes during object creation, after setting all properties.
function edit26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit27_Callback(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit27 as text
%        str2double(get(hObject,'String')) returns contents of edit27 as a double


% --- Executes during object creation, after setting all properties.
function edit27_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit28_Callback(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit28 as text
%        str2double(get(hObject,'String')) returns contents of edit28 as a double


% --- Executes during object creation, after setting all properties.
function edit28_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit29_Callback(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit29 as text
%        str2double(get(hObject,'String')) returns contents of edit29 as a double


% --- Executes during object creation, after setting all properties.
function edit29_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit30_Callback(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit30 as text
%        str2double(get(hObject,'String')) returns contents of edit30 as a double


% --- Executes during object creation, after setting all properties.
function edit30_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit31_Callback(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit31 as text
%        str2double(get(hObject,'String')) returns contents of edit31 as a double


% --- Executes during object creation, after setting all properties.
function edit31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% END OF LEFT EYE










% RIGHT EYE BEGIN HERE

% --- Executes on button press in radiobutton12.
function radiobutton12_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton12
DataStruct=get(handles.figure1,'UserData');
if get(hObject,'Value')
    set(handles.edit20,'Style','text');
    set(handles.edit1,'String',str2num(get(handles.edit1,'String'))-1);
    DataStruct=channel_select(DataStruct,str2num(get(handles.edit20,'String')));
    DataStruct.RightEyeChannels=[DataStruct.RightEyeChannels str2num(get(handles.edit20,'String'))];
    DataStruct.RightEyeChannels=sort(DataStruct.RightEyeChannels);
else
    set(handles.edit20,'Style','edit');
    set(handles.edit1,'String',str2num(get(handles.edit1,'String'))+1);
    DataStruct=channel_deselect(DataStruct,str2num(get(handles.edit20,'String')))
end
set(handles.figure1,'UserData',DataStruct);

% --- Executes on button press in radiobutton13.
function radiobutton13_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton13
DataStruct=get(handles.figure1,'UserData');
if get(hObject,'Value')
    set(handles.edit21,'Style','text');
    set(handles.edit1,'String',str2num(get(handles.edit1,'String'))-1);
    DataStruct=channel_select(DataStruct,str2num(get(handles.edit21,'String')));
    DataStruct.RightEyeChannels=[DataStruct.RightEyeChannels str2num(get(handles.edit21,'String'))];
    DataStruct.RightEyeChannels=sort(DataStruct.RightEyeChannels);
else
    set(handles.edit21,'Style','edit');
    set(handles.edit1,'String',str2num(get(handles.edit1,'String'))+1);
    DataStruct=channel_deselect(DataStruct,str2num(get(handles.edit21,'String')))
end
set(handles.figure1,'UserData',DataStruct);

% --- Executes on button press in radiobutton14.
function radiobutton14_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton14
DataStruct=get(handles.figure1,'UserData');
if get(hObject,'Value')
    set(handles.edit22,'Style','text');
    set(handles.edit1,'String',str2num(get(handles.edit1,'String'))-1);
    DataStruct=channel_select(DataStruct,str2num(get(handles.edit22,'String')));
    DataStruct.RightEyeChannels=[DataStruct.RightEyeChannels str2num(get(handles.edit22,'String'))];
    DataStruct.RightEyeChannels=sort(DataStruct.RightEyeChannels);
else
    set(handles.edit22,'Style','edit');
    set(handles.edit1,'String',str2num(get(handles.edit1,'String'))+1);
    DataStruct=channel_deselect(DataStruct,str2num(get(handles.edit22,'String')))
end
set(handles.figure1,'UserData',DataStruct);

% --- Executes on button press in radiobutton15.
function radiobutton15_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton15
DataStruct=get(handles.figure1,'UserData');
if get(hObject,'Value')
    set(handles.edit23,'Style','text');
    set(handles.edit1,'String',str2num(get(handles.edit1,'String'))-1);
    DataStruct=channel_select(DataStruct,str2num(get(handles.edit23,'String')));
    DataStruct.RightEyeChannels=[DataStruct.RightEyeChannels str2num(get(handles.edit23,'String'))];
    DataStruct.RightEyeChannels=sort(DataStruct.RightEyeChannels);
else
    set(handles.edit23,'Style','edit');
    set(handles.edit1,'String',str2num(get(handles.edit1,'String'))+1);
    DataStruct=channel_deselect(DataStruct,str2num(get(handles.edit23,'String')))
end
set(handles.figure1,'UserData',DataStruct);

% --- Executes on button press in radiobutton16.
function radiobutton16_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton16
DataStruct=get(handles.figure1,'UserData');
if get(hObject,'Value')
    set(handles.edit24,'Style','text');
    set(handles.edit1,'String',str2num(get(handles.edit1,'String'))-1);
    DataStruct=channel_select(DataStruct,str2num(get(handles.edit24,'String')));
    DataStruct.RightEyeChannels=[DataStruct.RightEyeChannels str2num(get(handles.edit24,'String'))];
    DataStruct.RightEyeChannels=sort(DataStruct.RightEyeChannels);
else
    set(handles.edit24,'Style','edit');
    set(handles.edit1,'String',str2num(get(handles.edit1,'String'))+1);
    DataStruct=channel_deselect(DataStruct,str2num(get(handles.edit24,'String')))
end
set(handles.figure1,'UserData',DataStruct);

% --- Executes on button press in radiobutton23.
function radiobutton23_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton23
DataStruct=get(handles.figure1,'UserData');
if get(hObject,'Value')
    set(handles.edit25,'Style','text');
    set(handles.edit1,'String',str2num(get(handles.edit1,'String'))-1);
    DataStruct=channel_select(DataStruct,str2num(get(handles.edit25,'String')));
    DataStruct.RightEyeChannels=[DataStruct.RightEyeChannels str2num(get(handles.edit25,'String'))];
    DataStruct.RightEyeChannels=sort(DataStruct.RightEyeChannels);
else
    set(handles.edit25,'Style','edit');
    set(handles.edit1,'String',str2num(get(handles.edit1,'String'))+1);
    DataStruct=channel_deselect(DataStruct,str2num(get(handles.edit25,'String')))
end
set(handles.figure1,'UserData',DataStruct);

function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit24_Callback(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit24 as text
%        str2double(get(hObject,'String')) returns contents of edit24 as a double


% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit25_Callback(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit25 as text
%        str2double(get(hObject,'String')) returns contents of edit25 as a double


% --- Executes during object creation, after setting all properties.
function edit25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% RIGHT EYE END HERE






% CHAIR START HERE

% --- Executes on button press in radiobutton9.
function radiobutton9_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton9
DataStruct=get(handles.figure1,'UserData');
if get(hObject,'Value')
    set(handles.edit14,'Style','text');
    DataStruct=channel_select(DataStruct,str2num(get(handles.edit14,'String')));
    set(handles.edit1,'String',str2num(get(handles.edit1,'String'))-1);
    DataStruct.ChairChannels=[DataStruct.ChairChannels str2num(get(handles.edit14,'String'))];
    DataStruct.ChairChannels=sort(DataStruct.ChairChannels);
else
    set(handles.edit14,'Style','edit');
    set(handles.edit1,'String',str2num(get(handles.edit1,'String'))+1);
    DataStruct=channel_deselect(DataStruct,str2num(get(handles.edit14,'String')))
end
set(handles.figure1,'UserData',DataStruct);


% --- Executes on button press in radiobutton10.
function radiobutton10_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton10


DataStruct=get(handles.figure1,'UserData');
if get(hObject,'Value')
    set(handles.edit15,'Style','text');
    set(handles.edit1,'String',str2num(get(handles.edit1,'String'))-1);
    DataStruct=channel_select(DataStruct,str2num(get(handles.edit15,'String')));
    DataStruct.ChairChannels=[DataStruct.ChairChannels str2num(get(handles.edit15,'String'))];
    DataStruct.ChairChannels=sort(DataStruct.ChairChannels);
else
    set(handles.edit15,'Style','edit');
    set(handles.edit1,'String',str2num(get(handles.edit1,'String'))+1);
    DataStruct=channel_deselect(DataStruct,str2num(get(handles.edit15,'String')))
end
set(handles.figure1,'UserData',DataStruct);


% --- Executes on button press in radiobutton11.
function radiobutton11_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton11

DataStruct=get(handles.figure1,'UserData');
if get(hObject,'Value')
    set(handles.edit16,'Style','text');
    set(handles.edit1,'String',str2num(get(handles.edit1,'String'))-1);
    DataStruct=channel_select(DataStruct,str2num(get(handles.edit16,'String')));
    DataStruct.ChairChannels=[DataStruct.ChairChannels str2num(get(handles.edit16,'String'))];
    DataStruct.ChairChannels=sort(DataStruct.ChairChannels);
else
    set(handles.edit16,'Style','edit');
    set(handles.edit1,'String',str2num(get(handles.edit1,'String'))+1);
    DataStruct=channel_deselect(DataStruct,str2num(get(handles.edit16,'String')))
end
set(handles.figure1,'UserData',DataStruct);


function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%CHAIR END HERE







%LASER START HERE

% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6

DataStruct=get(handles.figure1,'UserData');
if get(hObject,'Value')
    set(handles.edit17,'Style','text');
    DataStruct=channel_select(DataStruct,str2num(get(handles.edit17,'String')));
    set(handles.edit1,'String',str2num(get(handles.edit1,'String'))-1);
    DataStruct.LaserChannels=[DataStruct.LaserChannels str2num(get(handles.edit17,'String'))];
    DataStruct.LaserChannels=sort(DataStruct.ChairChannels);
else
    set(handles.edit17,'Style','edit');
    set(handles.edit1,'String',str2num(get(handles.edit1,'String'))+1);
    DataStruct=channel_deselect(DataStruct,str2num(get(handles.edit17,'String')))
end
set(handles.figure1,'UserData',DataStruct);


% --- Executes on button press in radiobutton7.
function radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton7
DataStruct=get(handles.figure1,'UserData');
if get(hObject,'Value')
    set(handles.edit18,'Style','text');
    DataStruct=channel_select(DataStruct,str2num(get(handles.edit18,'String')));
    set(handles.edit1,'String',str2num(get(handles.edit1,'String'))-1);
    DataStruct.LaserChannels=[DataStruct.LaserChannels str2num(get(handles.edit18,'String'))];
    DataStruct.LaserChannels=sort(DataStruct.ChairChannels);
else
    set(handles.edit18,'Style','edit');
    set(handles.edit1,'String',str2num(get(handles.edit1,'String'))+1);
    DataStruct=channel_deselect(DataStruct,str2num(get(handles.edit18,'String')))
end
set(handles.figure1,'UserData',DataStruct);

% --- Executes on button press in radiobutton8.
function radiobutton8_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton8

DataStruct=get(handles.figure1,'UserData');
if get(hObject,'Value')
    set(handles.edit19,'Style','text');
    DataStruct=channel_select(DataStruct,str2num(get(handles.edit19,'String')));
    set(handles.edit1,'String',str2num(get(handles.edit1,'String'))-1);
    DataStruct.LaserChannels=[DataStruct.LaserChannels str2num(get(handles.edit19,'String'))];
    DataStruct.LaserChannels=sort(DataStruct.ChairChannels);
else
    set(handles.edit19,'Style','edit');
    set(handles.edit1,'String',str2num(get(handles.edit1,'String'))+1);
    DataStruct=channel_deselect(DataStruct,str2num(get(handles.edit19,'String')))
end
set(handles.figure1,'UserData',DataStruct);

function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%LASER END HERE







% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called




% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.figure1,'WindowStyle','normal')
