function [blink]=EyeBlinkEstimation(varargin)
addpath('C:\Users\lab\Desktop\scripts');
addpath('C:\Users\lab\Desktop\scripts\subroutine');

blink = [];

if nargin<1
    % Create a video file reader.
    [FolderName,FolderPath] = uigetfile('*.avi');
    obj = VideoReader([FolderPath,FolderName]);
    nframes=obj.NumberOfFrames;
    obj = VideoReader([FolderPath,FolderName]);
    for img = 1:nframes;
        videoFrame = readFrame(obj);
        if img==1
            figure
               imshow(videoFrame);
               rect = getrect;
               [rect]=RectAdjust(videoFrame,rect);
        end
        rect(find(rect<1))=1;
        videoFrame=videoFrame(1:rect(2)+rect(4),rect(1):rect(1)+rect(3),:,:);
%         figure; imshow(videoFrame);
        blink_Estimation(nargout);
    end
% else
%     videoFrame = varargin{1};
%     for img=1:size(videoFrame,4)
%         videoFrame = varargin{1}(:,:,:,img);
%         blink_Estimation(nargout);
%     end
end



    function blink_Estimation(nargout)
        %divide the image to n partial overlapped quaters;
               

        Q=videoFrame(:,:,1)>0.3*255;
        
        Q=bwareaopen(Q,300); % remove small particle
        Q = imfill(Q,'holes');
%         imshow(Q);
        blink = [blink;sum(sum(Q,2),1)];
    end
blink=blink(1:2:end);
% figure
% plot(blink,'r');

end