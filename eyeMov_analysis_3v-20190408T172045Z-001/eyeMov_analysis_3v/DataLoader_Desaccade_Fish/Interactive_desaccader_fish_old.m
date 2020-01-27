function varargout = Interactive_desaccader_fish(varargin)
% INTERACTIVE_DESACCADER_FISH M-file for Interactive_desaccader_fish.fig
%      INTERACTIVE_DESACCADER_FISH, by itself, creates a new INTERACTIVE_DESACCADER_FISH or raises the existing
%      singleton*.
%
%      H = INTERACTIVE_DESACCADER_FISH returns the handle to a new INTERACTIVE_DESACCADER_FISH or the handle to
%      the existing singleton*.
%
%      INTERACTIVE_DESACCADER_FISH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERACTIVE_DESACCADER_FISH.M with the given input arguments.
%
%      INTERACTIVE_DESACCADER_FISH('Property','Value',...) creates a new INTERACTIVE_DESACCADER_FISH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Interactive_desaccader_fish_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Interactive_desaccader_fish_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Interactive_desaccader_fish

% Last Modified by GUIDE v2.5 08-Jul-2016 12:55:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Interactive_desaccader_fish_OpeningFcn, ...
    'gui_OutputFcn',  @Interactive_desaccader_fish_OutputFcn, ...
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


% --- Executes just before Interactive_desaccader_fish is made visible.
function Interactive_desaccader_fish_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Interactive_desaccader_fish (see VARARGIN)

% Choose default command line output for Interactive_desaccader_fish
handles.output = hObject;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Interactive_desaccader_fish wait for user response (see UIRESUME)
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
%second argin %time or smpf
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

%third argin eyeposition
if length(varargin)>2 && ~isempty(varargin{3})
    DataStruct.eyepos=varargin{3};%Import eyepos from outside
    DataStruct.realpos=1;
else
    DataStruct.eyepos=cumsum(DataStruct.omega_r)/DataStruct.smpf;
    DataStruct.realpos=0;
    set(handles.cBox_subBang,'Enable','off');
end

%forth argin body pos
if length(varargin)>3
    DataStruct.bodyP=varargin{4};
    DataStruct.av_bodyP=1;
    
else 
    DataStruct.av_bodyP=0;
    DataStruct.bodyP=[];
end
%fifth argin gui parameters
if length(varargin)>4
    DataStruct.stimVel=varargin{4};
else
    DataStruct.stimVel=NaN;
end


%sixth argin gui parameters
if length(varargin)>5
    DataStruct.minSacc=varargin{4}(1);
    DataStruct.minVelSacc=varargin{4}(2);
    DataStruct.timeSP=varargin{4}(3);
    DataStruct.N_f3db=varargin{4}(1); %3db lowpass cutoff
else
    DataStruct.minSacc=1;
    DataStruct.minVelSacc=50;
    DataStruct.timeSP=5;
    DataStruct.N_f3db=2; %3db lowpass cutoff
end

DataStruct.rawtimeOld=DataStruct.rawtime;

DataStruct.resampleData=1;
DataStruct.zoomon=0; %Zoom start from off
DataStruct.pan=0; %pan start off
DataStruct.desaccadedvel=0; % Handles to the previous desaccaded vel plot
DataStruct.saccadeHandles=0; %handles to the previous saccades plot
%Default value for desaccading
DataStruct.maxvel=500; %Extreems of histogram (pos and neg equal)
DataStruct.sampl=1; %hytogram bin size
DataStruct.velth=20; %threshold to detec saccades

DataStruct.timewin=1*DataStruct.smpf; %Time windows to analize
DataStruct.eyevel=0; %default out 1
DataStruct.time=1; %default out 2
DataStruct.method=1;DataStruct.interp=0;
%first set of temporal var
DataStruct.eyepos_nofilt=DataStruct.eyepos;
DataStruct.omega_r_nofilt=DataStruct.omega_r;
%second set of temporal var
DataStruct.originalPos=DataStruct.eyepos_nofilt;
DataStruct.originalVel=DataStruct.omega_r_nofilt;

% Set visual stuffs
set(handles.pButton_zoomOut,'Visible','Off');
set(handles.pButton_zoomOn,'String','Zoom on');
set(handles.pButton_Scroll,'String','Scroll on');
set(handles.edit_VelMax,'String',sprintf('%d',DataStruct.maxvel))
set(handles.edit_VelSmpl,'String',sprintf('%d',DataStruct.sampl))
set(handles.edit_VelThres,'String',sprintf('%d',DataStruct.velth))
set(handles.edit_TimeSize,'String',sprintf('%.2f',(DataStruct.timewin/DataStruct.smpf)))
set(handles.edit_LPcutoff,'String',sprintf('%d',(DataStruct.N_f3db)))


set(handles.edit_minSacc,'String',sprintf('%d',(DataStruct.minSacc)))
set(handles.edit_minVelSacc,'String',sprintf('%d',(DataStruct.minVelSacc)))
set(handles.edit_timeSP,'String',sprintf('%d',(DataStruct.timeSP)))


set(handles.cBox_procSacc,'Enable','off');
set(handles.cBox_procSlowP,'Enable','off');

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

if   DataStruct.av_bodyP
    DataStruct.handlesFigBA=figure('Name','BodyAngle');
    DataStruct.handlesBA=axes;
    plot( DataStruct.handlesBA,DataStruct.rawtime, DataStruct.eyepos,'r');
    set(DataStruct.handlesBA,'nextplot','add');
    plot( DataStruct.handlesBA,DataStruct.rawtime, DataStruct.bodyP,'--k');
else
    DataStruct.handlesBA=[];
end
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
function varargout = Interactive_desaccader_fish_OutputFcn(hObject, eventdata, handles)
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
    if DataStruct.av_bodyP
        close(DataStruct.handlesFigBA);
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
    
    close(gcf);
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
    if DataStruct.av_bodyP
        set(DataStruct.zoom,'ActionPostCallback',{@mypostcallback,DataStruct.handlesBA});
    end
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


function mypostcallback(obj,evd,hndBA)
newLim = get(evd.Axes,'XLim');
set(hndBA,'xlim',[newLim(1)-5,newLim(2)+5]);



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
    DataStruct.pan=pan;
    if DataStruct.av_bodyP
        set(DataStruct.pan,'ActionPostCallback',{@mypostcallback,DataStruct.handlesBA});
    end
    set(DataStruct.pan,'Enable', 'on')
    
    
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


DataStruct.eyepos=DataStruct.eyepos_nofilt; %restore data
DataStruct.omega_r=DataStruct.omega_r_nofilt;    


pause(0.1)
[S] = JL_desaccader_modif(DataStruct.omega_r,-DataStruct.maxvel:DataStruct.sampl:DataStruct.maxvel,DataStruct.velth,DataStruct.timewin,DataStruct.method);
%find(S==0) conteins the indices of desaccade samples
dstr.indices=saccextremesfinder(S);
[eyevel,time,index]=desacc_dataGB(DataStruct.omega_r,DataStruct.rawtime',dstr.indices,0,DataStruct.interp);
eyepos=DataStruct.eyepos(index);
% eyepos=DataStruct.eyepos(round(time*DataStruct.smpf));
if DataStruct.desaccadedvel~=0
    delete(DataStruct.desaccadedvel);
    delete(DataStruct.saccadeHandles);
end

DataStruct.desaccadedvel(1)=plot(handles.vel_Axes,time,eyevel,'b.');
DataStruct.saccadeHandles(1)=plot(handles.vel_Axes,DataStruct.rawtime(dstr.indices(:,1)),DataStruct.omega_r(dstr.indices(:,1)),'ro');
DataStruct.saccadeHandles(2)=plot(handles.vel_Axes,DataStruct.rawtime(dstr.indices(:,2)),DataStruct.omega_r(dstr.indices(:,2)),'mo');
pause(0.1)
DataStruct.desaccadedvel(2)=plot(handles.pos_Axes,time,eyepos,'b.');
DataStruct.saccadeHandles(3)=plot(handles.pos_Axes,DataStruct.rawtime(dstr.indices(:,1)),DataStruct.eyepos(dstr.indices(:,1)),'ro');
DataStruct.saccadeHandles(4)=plot(handles.pos_Axes,DataStruct.rawtime(dstr.indices(:,2)),DataStruct.eyepos(dstr.indices(:,2)),'mo');
pause(0.1)


DataStruct.eyevel=eyevel;
DataStruct.time=time;
DataStruct.index=index;
DataStruct.saccExtremeIdx=dstr.indices;
DataStruct.saccExtremeIdxRaw=dstr.indices;

%%%%%
DataStruct.spExtremeIdxRaw=SPextremesfinder(DataStruct.saccExtremeIdx,DataStruct.index); 
DataStruct.spExtremeIdx=DataStruct.spExtremeIdxRaw; 
%%%%%%

set(handles.pButton_desacc,'Enable','on')
set(handles.pButton_Restore,'Enable','on')
set(handles.pButton_Scroll,'Enable','on')
set(handles.pButton_zoomOut,'Enable','on')
set(handles.pButton_zoomOn,'Enable','on')
set(handles.pButton_exit,'Enable','on')
set(handles.edit_VelThres,'Enable','on')
set(handles.edit_TimeSize,'Enable','on')
set(handles.pButton_nextSacc,'Enable','on')
set(handles.pButton_prevSacc,'Enable','on')

set(handles.cBox_procSacc,'Enable','on')
set(handles.cBox_procSlowP,'Enable','off')
set(handles.pButton_adjSacc,'Enable','off')


set(handles.cBox_procSacc,'Value',0)
set(handles.cBox_procSlowP,'Value',0)

set(handles.figure1,'UserData',DataStruct);
set(handles.error,'String',{''});


%-->%Exit and discart%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in pButton_exit.
function pButton_exit_Callback(hObject, eventdata, handles)
% hObject    handle to pButton_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Interactive_desaccader_fish_OutputFcn(handles.figure1, eventdata,handles);
uiresume(handles.figure1);



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




%-->%Sep RemoveDes%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in pButton_remDesacc.
function pButton_remDesacc_Callback(hObject, eventdata, handles)
% hObject    handle to pButton_remDesacc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DataStruct=get(handles.figure1,'UserData');
if 0%DataStruct.desaccadedvel~=0
    [x,~]=ginput(2); %time instants
    onindex=find(DataStruct.time<=x(1),1,'last'); %
    endindex=find(DataStruct.time>=x(2),1,'first');
        
    %remove the selected part 
    DataStruct.eyevel(onindex:endindex)=[];
    DataStruct.time(onindex:endindex)=[]; 
    DataStruct.index(onindex:endindex)=[];
    
    if DataStruct.desaccadedvel~=0
        delete(DataStruct.desaccadedvel);
    end

    DataStruct.desaccadedvel(1)=plot(handles.vel_Axes,DataStruct.time,DataStruct.eyevel,'b.');pause(0.1)
    DataStruct.desaccadedvel(2)=plot(handles.pos_Axes,DataStruct.time,DataStruct.eyepos(DataStruct.index),'b.');pause(0.1)

    set(handles.figure1,'UserData',DataStruct);
else
    set(handles.error,'String',{'Not implemented yet!'});
    set(handles.error,'ForegroundColor','Red');
end

%-->%Processing Saccades%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in cBox_procSacc.
function cBox_procSacc_Callback(hObject, eventdata, handles)
% hObject    handle to cBox_procSacc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cBox_procSacc
DataStruct=get(handles.figure1,'UserData');
minAngle=str2double(get(handles.edit_minSacc,'String'));
minVelSacc=str2double(get(handles.edit_minVelSacc,'String'));

  

if DataStruct.desaccadedvel~=0
    DataStruct.eyepos=DataStruct.eyepos_nofilt; %restore data
    DataStruct.omega_r=DataStruct.omega_r_nofilt;  
    
    if any(ishandle(DataStruct.saccadeHandles))
        delete(DataStruct.saccadeHandles);    
    else   
        DataStruct.saccadeHandles=0;
    end
    if get(hObject,'Value')
        
        DataStruct.saccExtremeIdx=DataStruct.saccExtremeIdxRaw; %restore data
        %check min angle dispacement saccade
        idxOut=abs(DataStruct.eyepos_nofilt(DataStruct.saccExtremeIdx(:,1))-DataStruct.eyepos_nofilt(DataStruct.saccExtremeIdx(:,2)))<minAngle;
        
        for k=1:length(DataStruct.saccExtremeIdx(:,1))
            idxOut(k)=idxOut(k)|(max(abs(DataStruct.omega_r_nofilt(DataStruct.saccExtremeIdx(k,1):DataStruct.saccExtremeIdx(k,2))))<minVelSacc);
        end
        
        DataStruct.saccExtremeIdx(idxOut,:)=[];
        
        DataStruct.minAngleSacc=minAngle;
        DataStruct.minVelSacc=minVelSacc;
        pause(0.1);
        set(handles.pButton_adjSacc,'Enable','on')
        set(handles.cBox_procSlowP,'Enable','on')
    else
        DataStruct.saccExtremeIdx=DataStruct.saccExtremeIdxRaw; %restore data
        set(handles.cBox_procSlowP,'Enable','off')
        set(handles.pButton_adjSacc,'Enable','off')
        DataStruct.minAngleSacc=0;
        DataStruct.minVelSacc=0;
    end
    
    if ~isempty(DataStruct.saccExtremeIdx)
        delete(DataStruct.desaccadedvel);
        
        [DataStruct.eyevel,DataStruct.time,DataStruct.index]=desacc_dataGB(DataStruct.omega_r,DataStruct.rawtime',DataStruct.saccExtremeIdx,0,DataStruct.interp);
        DataStruct.spExtremeIdxRaw=SPextremesfinder(DataStruct.saccExtremeIdx,DataStruct.index);  %recompute slowphase eyemov
        
        DataStruct.spExtremeIdx=DataStruct.spExtremeIdxRaw;
        
        DataStruct.desaccadedvel(1)=plot(handles.vel_Axes,DataStruct.time,DataStruct.eyevel,'b.');
        DataStruct.saccadeHandles(1)=plot(handles.vel_Axes,DataStruct.rawtime(DataStruct.saccExtremeIdx(:,1)),DataStruct.omega_r(DataStruct.saccExtremeIdx(:,1)),'ro','MarkerFaceColor','r','MarkerSize',6);
        DataStruct.saccadeHandles(2)=plot(handles.vel_Axes,DataStruct.rawtime(DataStruct.saccExtremeIdx(:,2)),DataStruct.omega_r(DataStruct.saccExtremeIdx(:,2)),'mo','MarkerFaceColor','m','MarkerSize',6);
        pause(0.1)
         DataStruct.desaccadedvel(2)=plot(handles.pos_Axes,DataStruct.time,DataStruct.eyepos(DataStruct.index),'b.');
        DataStruct.saccadeHandles(3)=plot(handles.pos_Axes,DataStruct.rawtime(DataStruct.saccExtremeIdx(:,1)),DataStruct.eyepos(DataStruct.saccExtremeIdx(:,1)),'ro','MarkerFaceColor','r','MarkerSize',6);
        DataStruct.saccadeHandles(4)=plot(handles.pos_Axes,DataStruct.rawtime(DataStruct.saccExtremeIdx(:,2)),DataStruct.eyepos(DataStruct.saccExtremeIdx(:,2)),'mo','MarkerFaceColor','m','MarkerSize',6);
        pause(0.1)
    else
        set(handles.cBox_procSlowP,'Enable','off')
    end
    

else
    set(handles.error,'String',{'Please fist desaccade whole signal!'});
    set(handles.error,'ForegroundColor','Red');
end
set(handles.figure1,'UserData',DataStruct);


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


%-->%Adjust Sccade%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in pButton_adjSacc.
function pButton_adjSacc_Callback(hObject, eventdata, handles)
% hObject    handle to pButton_adjSacc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DataStruct=get(handles.figure1,'UserData');

if DataStruct.desaccadedvel~=0
    set(handles.error,'String',{'Adjust or remove saccades indices!'; '1) Select the saccade with one mouse left clik';'2) Select the time point where replaces the saccade with another left clik or any key to remove the selected saccades'});
    set(handles.error,'ForegroundColor','Black');
    
    timeSacc=DataStruct.rawtime(DataStruct.saccExtremeIdx);
    [timeUser,~]=ginput(1); %time instants
    timeDiff=abs(timeSacc-timeUser);[~,idx]=min(timeDiff(:));  [idx(1),idx(2)]=ind2sub(size(timeSacc),idx);
    
    [timeUser,~,button]=ginput(1); %time instants
    if button==1
        newIDX=find(DataStruct.rawtime<timeUser,1,'last'); %
        DataStruct.saccExtremeIdx(idx(1),idx(2))=newIDX;
    else %remove selected saccade
        DataStruct.saccExtremeIdx(idx(1),:)=[];
    end
    
    if ~isempty(DataStruct.saccExtremeIdx)
        [DataStruct.eyevel,DataStruct.time,DataStruct.index]=desacc_dataGB(DataStruct.omega_r,DataStruct.rawtime',DataStruct.saccExtremeIdx,0,DataStruct.interp);
        %DataStruct.eyepos=DataStruct.eyepos_nofilt(DataStruct.index);
        
        if DataStruct.desaccadedvel~=0
            delete(DataStruct.desaccadedvel);
            delete(DataStruct.saccadeHandles);
        end     
        DataStruct.spExtremeIdx=SPextremesfinder(DataStruct.saccExtremeIdx,DataStruct.index);  %recompute slowphase eyemov
        DataStruct.spExtremeIdxRaw=DataStruct.spExtremeIdx;
        
        DataStruct.desaccadedvel(1)=plot(handles.vel_Axes,DataStruct.time,DataStruct.eyevel,'b.');
        DataStruct.saccadeHandles(1)=plot(handles.vel_Axes,DataStruct.rawtime(DataStruct.saccExtremeIdx(:,1)),DataStruct.omega_r(DataStruct.saccExtremeIdx(:,1)),'ro','MarkerFaceColor','r','MarkerSize',6);
        DataStruct.saccadeHandles(2)=plot(handles.vel_Axes,DataStruct.rawtime(DataStruct.saccExtremeIdx(:,2)),DataStruct.omega_r(DataStruct.saccExtremeIdx(:,2)),'mo','MarkerFaceColor','m','MarkerSize',6);
        pause(0.1)
        DataStruct.desaccadedvel(2)=plot(handles.pos_Axes,DataStruct.time,DataStruct.eyepos(DataStruct.index),'b.');
        DataStruct.saccadeHandles(3)=plot(handles.pos_Axes,DataStruct.rawtime(DataStruct.saccExtremeIdx(:,1)),DataStruct.eyepos(DataStruct.saccExtremeIdx(:,1)),'ro','MarkerFaceColor','r','MarkerSize',6);
        DataStruct.saccadeHandles(4)=plot(handles.pos_Axes,DataStruct.rawtime(DataStruct.saccExtremeIdx(:,2)),DataStruct.eyepos(DataStruct.saccExtremeIdx(:,2)),'mo','MarkerFaceColor','m','MarkerSize',6);
        pause(0.1)
    else
        
        DataStruct.spExtremeIdx=DataStruct.spExtremeIdxRaw;
        [DataStruct.eyevel,DataStruct.time,DataStruct.index]=desacc_dataGB(DataStruct.omega_r,DataStruct.rawtime',DataStruct.saccExtremeIdx,0,DataStruct.interp);
        DataStruct.eyepos=DataStruct.eyepos_nofilt(index);
    
        
        set(handles.cBox_procSlowP,'Enable','off')
    end
    set(handles.error,'String',{''});
   
else
    set(handles.error,'String',{'Please fist desaccade whole signal!'});
    set(handles.error,'ForegroundColor','Red');
end
set(handles.figure1,'UserData',DataStruct);


%-->%Separate LPfilter%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in cBox_procSlowP.
function cBox_procSlowP_Callback(hObject, eventdata, handles)
% hObject    handle to cBox_procSlowP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cBox_procSlowP
% hObject    handle to cBox_medianFilt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DataStruct=get(handles.figure1,'UserData');
if get(hObject,'Value')
    if DataStruct.desaccadedvel~=0
        DataStruct.eyepos=DataStruct.eyepos_nofilt; %restore data
        DataStruct.omega_r=DataStruct.omega_r_nofilt;
        
        DataStruct.N_f3db= str2double(get(handles.edit_LPcutoff,'String'));%check cutoff frequency
        if DataStruct.N_f3db>DataStruct.smpf/2
            DataStruct.N_f3db=(DataStruct.smpf/2)-1;
            set(handles.edit_LPcutoff,'String',num2str(DataStruct.smpf/2-1));
        end
        DataStruct.filter=1;
        DataStruct.minTimeSP= str2double(get(handles.edit_timeSP,'String'));
        
        DataStruct.spExtremeIdx=DataStruct.spExtremeIdxRaw;
        %
        idxOut= DataStruct.rawtime(DataStruct.spExtremeIdx(:,2))-DataStruct.rawtime(DataStruct.spExtremeIdx(:,1))<DataStruct.minTimeSP;%%%%%%%%%%%%%%
        DataStruct.spExtremeIdx(idxOut,:)=[];
        
        [DataStruct.timeSP,DataStruct.eyeposSP,DataStruct.eyevelSP]=deal([]);
        for k=1:length(DataStruct.spExtremeIdx(:,1))
            idx=DataStruct.spExtremeIdx(k,1):DataStruct.spExtremeIdx(k,2);
            
            DataStruct.timeSP=[DataStruct.timeSP;DataStruct.rawtime(idx)];
            DataStruct.eyeposSP= [DataStruct.eyeposSP;butterFilterNaN(DataStruct.eyepos_nofilt(idx),DataStruct.smpf,DataStruct.N_f3db)];
            DataStruct.eyevelSP=[DataStruct.eyevelSP;butterFilterNaN( DataStruct.omega_r_nofilt(idx),DataStruct.smpf,DataStruct.N_f3db)];
        end
        
        delete(DataStruct.desaccadedvel)
        DataStruct.desaccadedvel(1)=plot(handles.vel_Axes,DataStruct.timeSP, DataStruct.eyevelSP,'.b');
        DataStruct.desaccadedvel(2)=plot(handles.pos_Axes,DataStruct.timeSP, DataStruct.eyeposSP,'.b');
        
        set(handles.error,'String',{''});
    else
        set(handles.error,'String',{'Please fist desaccade whole signal!'});
        set(handles.error,'ForegroundColor','Red');
    end
      
else
    DataStruct.filter=0;
    DataStruct.eyepos=DataStruct.eyepos_nofilt;
    DataStruct.omega_r=DataStruct.omega_r_nofilt;
    
    delete(DataStruct.desaccadedvel)
    
    DataStruct.desaccadedvel(1)=plot(handles.vel_Axes,DataStruct.time,DataStruct.eyevel,'b.');
    pause(0.1)
    DataStruct.desaccadedvel(2)=plot(handles.pos_Axes,DataStruct.time,DataStruct.eyepos(DataStruct.index),'b.');
    pause(0.1)
    
    delete(DataStruct.saccadeHandles)
    DataStruct.saccadeHandles(1)=plot(handles.vel_Axes,DataStruct.rawtime(DataStruct.saccExtremeIdx(:,1)),DataStruct.omega_r(DataStruct.saccExtremeIdx(:,1)),'ro','MarkerFaceColor','r','MarkerSize',6);
    DataStruct.saccadeHandles(2)=plot(handles.vel_Axes,DataStruct.rawtime(DataStruct.saccExtremeIdx(:,2)),DataStruct.omega_r(DataStruct.saccExtremeIdx(:,2)),'mo','MarkerFaceColor','m','MarkerSize',6);
    pause(0.1)
    DataStruct.saccadeHandles(3)=plot(handles.pos_Axes,DataStruct.rawtime(DataStruct.saccExtremeIdx(:,1)),DataStruct.eyepos(DataStruct.saccExtremeIdx(:,1)),'ro','MarkerFaceColor','r','MarkerSize',6);
    DataStruct.saccadeHandles(4)=plot(handles.pos_Axes,DataStruct.rawtime(DataStruct.saccExtremeIdx(:,2)),DataStruct.eyepos(DataStruct.saccExtremeIdx(:,2)),'mo','MarkerFaceColor','m','MarkerSize',6);
    pause(0.1)
    
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

set(handles.cBox_procSlowP,'Value',false);
set(handles.figure1,'UserData',DataStruct);


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

%-->%Offset removal%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in cBox_subBang.
function cBox_subBang_Callback(hObject, eventdata, handles)
% hObject    handle to cBox_subBang (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of cBox_subBang
DataStruct=get(handles.figure1,'UserData');
if get(hObject,'Value')
    
    DataStruct.eyepos=DataStruct.eyepos-DataStruct.bodyP;
    DataStruct.omega_r=derivata(DataStruct.eyepos,1./DataStruct.smpf);
    
        
    DataStruct.eyepos_nofilt=DataStruct.eyepos;
    DataStruct.omega_r_nofilt=DataStruct.omega_r;
    
    DataStruct.desaccadedvel=0;
    DataStruct.saccadeHandles=0;
    
    cla(handles.vel_Axes)
    plot(handles.vel_Axes,DataStruct.rawtime, DataStruct.omega_r,'r')  
    set(handles.vel_Axes,'nextplot','add');ylabel('Eye Velocity [deg/s]')
    
    cla(handles.pos_Axes)
    plot(handles.pos_Axes,DataStruct.rawtime, DataStruct.eyepos,'r')
    set(handles.pos_Axes,'nextplot','add');ylabel('Eye Position [deg]');xlabel('Time [s]');
    
    cla(DataStruct.handlesBA);
    plot( DataStruct.handlesBA,DataStruct.rawtime, DataStruct.eyepos,'r');
    set(handles.pos_Axes,'nextplot','add');
    plot( DataStruct.handlesBA,DataStruct.rawtime, DataStruct.bodyP,'--k');
    
else
    DataStruct.eyepos_nofilt=DataStruct.originalPos;
    DataStruct.omega_r_nofilt=DataStruct.originalVel;
    
    DataStruct.rawtime=DataStruct.rawtimeOld;
    DataStruct.eyepos=DataStruct.eyepos_nofilt;
    DataStruct.omega_r=DataStruct.omega_r_nofilt;
      
    DataStruct.desaccadedvel=0;
    DataStruct.saccadeHandles=0;
    
    cla(handles.vel_Axes)
    plot(handles.vel_Axes,DataStruct.rawtime, DataStruct.omega_r,'r')  
    set(handles.vel_Axes,'nextplot','add');ylabel('Eye Velocity [deg/s]')
    
    cla(handles.pos_Axes)
    plot(handles.pos_Axes,DataStruct.rawtime, DataStruct.eyepos,'r')
    set(handles.pos_Axes,'nextplot','add');ylabel('Eye Position [deg]');xlabel('Time [s]');
    
    cla(DataStruct.handlesBA);
    plot( DataStruct.handlesBA,DataStruct.rawtime, DataStruct.eyepos,'r');
    set(handles.pos_Axes,'nextplot','add');
    plot( DataStruct.handlesBA,DataStruct.rawtime, DataStruct.bodyP,'--k');

    
      set(handles.cBox_procSacc,'Enable','off')
    set(handles.cBox_procSlowP,'Enable','off')
    set(handles.pButton_adjSacc,'Enable','off')
    
    
    
    set(handles.cBox_subAv,'Value',0)
    set(handles.cBox_procSacc,'Value',0)
    set(handles.cBox_procSlowP,'Value',0)
end
set(handles.figure1,'UserData',DataStruct);






% --- Executes on button press in cBox_subAv.
function cBox_subAv_Callback(hObject, eventdata, handles)
% hObject    handle to cBox_subAv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

DataStruct=get(handles.figure1,'UserData');
if get(hObject,'Value')
    if isnan(DataStruct.stimVel)
        DataStruct.eyepos=DataStruct.eyepos-nanmean( DataStruct.eyepos);
    else
        time2use=300; %in seconds
        idxT= find(DataStruct.rawtime<=time2use,1,'last');
        DataStruct.eyepos=DataStruct.eyepos-nanmedian( DataStruct.eyepos(1:idxT));
        
    end
        DataStruct.omega_r=derivata(DataStruct.eyepos,1./DataStruct.smpf);
        
        DataStruct.eyepos_nofilt=DataStruct.eyepos;
        DataStruct.omega_r_nofilt=DataStruct.omega_r;
        
        DataStruct.desaccadedvel=0;
        DataStruct.saccadeHandles=0;
        
        cla(handles.vel_Axes)
        plot(handles.vel_Axes,DataStruct.rawtime, DataStruct.omega_r,'r')
        set(handles.vel_Axes,'nextplot','add');ylabel('Eye Velocity [deg/s]')
        
        cla(handles.pos_Axes)
        plot(handles.pos_Axes,DataStruct.rawtime, DataStruct.eyepos,'r')
        set(handles.pos_Axes,'nextplot','add');ylabel('Eye Position [deg]');xlabel('Time [s]');
  
    if DataStruct.av_bodyP
        cla(DataStruct.handlesBA);
        plot( DataStruct.handlesBA,DataStruct.rawtime, DataStruct.eyepos,'r');
        set(handles.pos_Axes,'nextplot','add');
        plot( DataStruct.handlesBA,DataStruct.rawtime, DataStruct.bodyP,'--k');
    end
    
    
else
    
    DataStruct.eyepos_nofilt=DataStruct.originalPos;
    DataStruct.omega_r_nofilt=DataStruct.originalVel;
    
    DataStruct.rawtime=DataStruct.rawtimeOld;
    DataStruct.eyepos=DataStruct.eyepos_nofilt;
    DataStruct.omega_r=DataStruct.omega_r_nofilt;
    
    DataStruct.desaccadedvel=0;
    DataStruct.saccadeHandles=0;
    
    cla(handles.vel_Axes)
    plot(handles.vel_Axes,DataStruct.rawtime, DataStruct.omega_r,'r')  
    set(handles.vel_Axes,'nextplot','add');ylabel('Eye Velocity [deg/s]')
    
    cla(handles.pos_Axes)
    plot(handles.pos_Axes,DataStruct.rawtime, DataStruct.eyepos,'r')
    set(handles.pos_Axes,'nextplot','add');ylabel('Eye Position [deg]');xlabel('Time [s]');
    if DataStruct.av_bodyP
        cla(DataStruct.handlesBA);
        plot( DataStruct.handlesBA,DataStruct.rawtime, DataStruct.eyepos,'r');
        set(handles.pos_Axes,'nextplot','add');
        plot( DataStruct.handlesBA,DataStruct.rawtime, DataStruct.bodyP,'--k');
    end
    set(handles.cBox_procSacc,'Enable','off')
    set(handles.cBox_procSlowP,'Enable','off')
    set(handles.pButton_adjSacc,'Enable','off')
    
    
    
    set(handles.cBox_procSacc,'Value',0)
    set(handles.cBox_procSlowP,'Value',0)
    set(handles.cBox_subBang,'Value',0)
end
set(handles.figure1,'UserData',DataStruct);


% --- Executes on button press in pButton_prevSacc.
function pButton_prevSacc_Callback(hObject, eventdata, handles)
% hObject    handle to pButton_prevSacc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DataStruct=get(handles.figure1,'UserData');
if DataStruct.desaccadedvel~=0
    lim = get(handles.pos_Axes,'XLim');
    limC=median(lim);
    dist=median(abs([limC-lim]));
    
    timeSacc=DataStruct.rawtime(DataStruct.saccExtremeIdx);
    timeDiff=abs(limC-timeSacc);[~,idx]=min(timeDiff(:));  [idx(1),idx(2)]=ind2sub(size(timeSacc),idx);
    
    newLim=[median(timeSacc(idx(1)-1,:),2)-dist,median(timeSacc(idx(1)-1,:),2)+dist];
    
    set(handles.pos_Axes,'XLim',newLim)
    ylim(handles.pos_Axes,'auto')
   ylim(handles.vel_Axes,'auto')
    if DataStruct.av_bodyP
        set(DataStruct.handlesBA,'xlim',[newLim(1)-5,newLim(2)+5]);      
    end
   

else
    set(handles.error,'String',{'Please fist desaccade whole signal!'});
    set(handles.error,'ForegroundColor','Red');
    set(handles.pButton_nextSacc,'Enable','off')
    set(handles.pButton_nextPrev,'Enable','off')
end
set(handles.figure1,'UserData',DataStruct);

% --- Executes on button press in pButton_nextSacc.
function pButton_nextSacc_Callback(hObject, eventdata, handles)
% hObject    handle to pButton_nextSacc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DataStruct=get(handles.figure1,'UserData');
if DataStruct.desaccadedvel~=0
    lim = get(handles.pos_Axes,'XLim');
    limC=median(lim);
    dist=median(abs([limC-lim]));
    
    timeSacc=DataStruct.rawtime(DataStruct.saccExtremeIdx);
    timeDiff=abs(limC-timeSacc);[~,idx]=min(timeDiff(:));  [idx(1),idx(2)]=ind2sub(size(timeSacc),idx);
    
    newLim=[median(timeSacc(idx(1)+1,:),2)-dist,median(timeSacc(idx(1)+1,:),2)+dist];
    
    set(handles.pos_Axes,'XLim',newLim)
    ylim(handles.pos_Axes,'auto')
    ylim(handles.vel_Axes,'auto')
   
    if DataStruct.av_bodyP
        set(DataStruct.handlesBA,'xlim',[newLim(1)-5,newLim(2)+5]);      
    end
   

else
    set(handles.error,'String',{'Please fist desaccade whole signal!'});
    set(handles.error,'ForegroundColor','Red');
    set(handles.pButton_nextSacc,'Enable','off')
    set(handles.pButton_nextPrev,'Enable','off')
end
set(handles.figure1,'UserData',DataStruct);

 
