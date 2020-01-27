function [velocity,powerframe]=balltrackerestimation(varargin)
addpath('C:\Users\lab\Desktop\scripts');

velocity = [];
position=[];
powerframe=[];
PixelPerCell=120;
MergeImage=[];
Rowimage=[];

if nargin<1
    % Create a video file reader.
    [FolderName,FolderPath] = uigetfile('*.avi');
    obj = VideoReader([FolderPath,FolderName]);
    nframes=obj.NumberOfFrames;
    obj = VideoReader([FolderPath,FolderName]);
    for img=1:nframes
        videoFrame = readFrame(obj);
    if img >= 81 & img <=100;
        
        Vel_Estimation(nargout);
        if mod(img,5)==0
            MergeImage=[MergeImage;Rowimage];
            Rowimage=[];
        end
    end
    end
else
    videoFrame = varargin{1};
    for img=1:size(videoFrame,4)
        videoFrame = varargin{1}(:,:,:,img);
        Vel_Estimation(nargout);
    end
end



    function Vel_Estimation(nargout)
        %divide the image to n partial overlapped quaters;
        %        figure
        %        imshow(videoFrame);
        
        Q=videoFrame(:,:,1)<0.6*255;
        Q=bwareaopen(Q,200); % remove small particle
%         Q=Q-bwareaopen(Q,1500); % remove large particle
        Q = imclearborder(Q);
                Rowimage=[Rowimage Q];

        
    end
        figure('Position', [10 10 2000 2000])
        imshow(MergeImage);
end