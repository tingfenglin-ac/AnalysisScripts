function [] = tiff_player_shef( filepaths, varargin)
%TIFF_PLAYER Summary of this function goes here
%   Plays
warning off all;
Fr = [];mult = [];maxchunk = [];
ip = inputParser;
ip.addParameter('Fr',50);
ip.addParameter('mult',5);
ip.addParameter('maxchunk',500);
ip.addParameter('data_files',[]);
ip.parse(varargin{:});
for j=fields(ip.Results)'
    if isempty(strfind(j,'data_files'))==1
    eval([j{1} '=ip.Results.' j{1} ';']);
    else
        continue
    end
end
data_files = ip.Results.data_files;
clear ip;

[data,nframes] = load_tiffs_fast_shef(filepaths,'end_ind',1,'data_files',data_files);
tic;[data,nframes] = load_tiffs_fast_shef(filepaths,'end_ind',1,'nframes',nframes,'data_files',data_files);singftime = toc;tic;
lastframe = 1;
fig = figure;
h = imagesc(data,'tag','imj');
clims = caxis;
caxis(clims);

ttl = title(sprintf('Frame 1/%i',sum(nframes)),'Tag','ttl');

sld = uicontrol('Style', 'slider'...
    ,'Min',1,'Max',sum(nframes),'Value',1 ...
    ,'Units','Normalized'...
    ,'Position', [0.05 0.05 0.9 0.05]...
    ,'Tag','sld'...
    ,'SliderStep', [1/sum(nframes) , 10/sum(nframes)]...
    );

run_pushbutton = uicontrol('Style', 'pushbutton'...
    ,'Min',0,'Max',1,'Value',0 ...
    ,'Units','Normalized'...
    ,'Position', [0.05 0.15 0.05 0.05]...
    ,'Tag','run_pushbutton'...
    ,'String','play'...
    ,'interruptible','on'...
    ,'UserData',0 ...
    );

stop_pushbutton = uicontrol('Style', 'pushbutton'...
    ,'Min',0,'Max',1,'Value',0 ...
    ,'Units','Normalized'...
    ,'Position', [0.05 0.1 0.1 0.05]...
    ,'Tag','stop_pushbutton'...
    ,'String','stop'...
    );


handles = guihandles(fig);

set(sld,'Callback', @(a,b)sld_end_fun(a,b,handles));
addlistener(sld,'Value','PreSet',@(a,b)sld_cont_fun(a,b,handles));
set(run_pushbutton,'Callback',@(a,b)play_btn_fun(a,b,handles));
set(stop_pushbutton,'Callback',@(a,b)stop_btn_fun(a,b,handles));

    function [] = sld_cont_fun(hObject, eventdata,handles)
        if toc>1/30
            i = round(handles.sld.Value);
            drawframe([i,lastframe],hObject,handles);
            drawnow;
            tic;
        end
    end

    function [] = sld_end_fun(hObject, eventdata, handles)
        if toc>1/30
            i = round(handles.sld.Value);
            drawframe(i,hObject,handles)
            tic;
            guidata(hObject,handles);
            drawnow;
        end
    end

    function [] = drawframe(i,hObject,handles)
        handles.ttl.String = sprintf('Frame %i/%i',i(1),sum(nframes));
        
        lastframe = i(1);
        
        if ~isscalar(i)
            if abs(diff(i))>maxchunk, i(2) = i(1)+maxchunk*sign(diff(i));end
            j = max(i);
            i = min(i);
            handles.imj.CData = mean(load_tiffs_fast_shef(filepaths,'start_ind',i,'end_ind',j,'nframes',nframes,'data_files',data_files),3);
        else
            handles.imj.CData = load_tiffs_fast_shef(filepaths,'start_ind',i,'end_ind',i,'nframes',nframes,'data_files',data_files);
        end
        
        clims = [min(clims(1),min(handles.imj.CData(:))) max(clims(2),max(handles.imj.CData(:)))];
        caxis(clims);
    end

    function [] = play_btn_fun(hObject, eventdata,handles)
%         disp(get(handles.run_pushbutton,'UserData'));
        if get(handles.run_pushbutton,'UserData')==1, return; end
        set(handles.run_pushbutton,'UserData',1);
        start = tic;start_frame = round(get(handles.sld,'Value'));
        while (get(handles.run_pushbutton,'UserData') ~= 0)
            if start_frame + toc*Fr*mult>sum(nframes)
                handles.sld.Value = sum(end_frames);
                set(handles.run_pushbutton,'UserData',0)
            else
                handles.sld.Value=start_frame + toc(start)*Fr*mult;
                guidata(hObject,handles);
                drawnow;
            end
        end
    end

    function stop_btn_fun(hObject, eventdata, handles)
        set(handles.run_pushbutton,'UserData',0);
    end
end
