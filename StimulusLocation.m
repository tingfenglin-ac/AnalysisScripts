%% addpath
path = mfilename('fullpath');
addpath(path(1:end-17))
addpath([path(1:end-16),'subroutine'])

%% find file path and load file
currentFolder = pwd;
[FolderName,FolderPath] = uigetfile(currentFolder,'*.mat');
load([FolderPath,FolderName]);

%% Index of stimulus
NFrame = info.config.frames; %Amount of frames
Rise = info.frame(1:2:end); %rising edge of TTL signal
Fall = info.frame(2:2:end); %falling edge of TTL signal

if Fall(end)<Rise(end)
    Fall(end+1)=NFrame;
end

%% template
threshold=40;
imagedata=data(:,:,1,Rise(1):Fall(1));
pixelMap=imagedata(:,:,1,1);
BW=255*repmat(ones(size(pixelMap)),[1,1,3]);


meanMap=mean(imagedata,4);
im = mat2gray(meanMap);

 level = graythresh(im)

imhist(meanMap);

meanMap(meanMap>threshold)=255;
meanMap(meanMap<threshold)=0;
image(meanMap.*BW);


red=BW.*cat(3, ones(1),zeros(1), zeros(1));
hold on 
h = image(red); 
hold off 

stim_treshold=25
Varmap=var(double(imagedata),0,4);
Varmap(Varmap>stim_treshold)=255;
Varmap(Varmap<=stim_treshold)=0;

set(h, 'AlphaData', Varmap);


