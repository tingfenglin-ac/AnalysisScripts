[FolderName,FolderPath] = uigetfile('Select data', 'Multiselect', 'on');

if iscell(FolderName)
    filesize=size(FolderName,2);
else
    filesize=1;
end

for f=1:filesize
    fname=FolderName{f}(1:11);
    mkdir(fname);
end