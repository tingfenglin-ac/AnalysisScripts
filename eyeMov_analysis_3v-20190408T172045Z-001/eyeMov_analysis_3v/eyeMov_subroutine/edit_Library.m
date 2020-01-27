

function []=OpenLibrary()
clc
answer = questdlg('Choose a Library', ...
    'Choose a library', ...
    'Open library','New library','Open library');
% Handle response
switch answer
    
    case 'Open library'
        [FolderName,FolderPath] = uigetfile('H:\TURN TABLE\library','*.mat');
        load([FolderPath,FolderName]);
        
        FolderInfo=[FolderPath,'\',char(FolderName)];
        
    case 'New library'
        [FolderName,FolderPath] = uiputfile('H:\TURN TABLE\library\*.mat');
        FolderInfo=[FolderPath,FolderName];
        
        library.index={'index','fileName','pathName','description'};
end

[library]=EditLibrary(library);
SaveLibrary(library,FolderInfo);
end

function [library]=EditLibrary(library)
if isfield(library,'data')
disp(library.data(:,1:2))
end

answer = questdlg('Edit', ...
    'Edit', ...
    'Add','Delete','none');
% Handle response
switch answer
    case 'Add'
        [fileName,pathName] = uigetfile('H:\TURN TABLE\library','*.mat');
        [StimDescrip] = EditDescrip;
        if isfield(library,'data')            
            library.data(end+1,:)={length(library.data(:,1))+1,fileName,pathName,char(StimDescrip)};
        else
            library.data(1,:)={1,fileName,pathName,char(StimDescrip)};
        end
        
    case 'Delete'
        prompt = {'Which row of data would be deleted:'};
        title = 'Delete';
        dims = [1 35];
        DeleteRow = inputdlg(prompt,title,dims);
        DeleteRow =str2num(DeleteRow{1});
        
        library.data(DeleteRow,:)=[];     
end
library.data = sortrows(library.data,2);
library.data(:,1)=num2cell(1:length(library.data(:,1)));
disp(library.data(:,1:2))

[library]=LoopingEdit(library);
end

function [library]=LoopingEdit(library)

answer = questdlg('continue?', ...
    'continue?', ...
    'Yes','No','none');
% Handle response
if strcmpi(answer,'yes')
[library]=EditLibrary(library);

end
end


function SaveLibrary(library,FolderInfo)

if exist(FolderInfo,'file');
    answer = questdlg('Do you want to overwrite the file', ...
        'Do you want to overwrite the file', ...
        'Yes','No','No');
    switch answer
        case 'Yes'
            save(FolderInfo,'library');
    end
else
    save(FolderInfo,'library');
end
end

function [StimDescrip] = EditDescrip
prompt = 'Write a description:';
prompt = [prompt newline 'V20V5:L or R'];
prompt = [prompt newline 'Cover or injury (seeing eye): L or R'];

        title = 'Write a description';
        dims = [1 40];
        StimDescrip = inputdlg(prompt,title,dims);
end