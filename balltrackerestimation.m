function [velocity,powerframe]=balltrackerestimation(varargin)
addpath('C:\Users\lab\Desktop\scripts');

velocity = [];
n=10;% how many pieces of partiallly overlapped quater size patch will be analyzed; high number is good
position=cell(n,1);
powerframe=[];

if nargin<1
    % Create a video file reader.
    [FolderName,FolderPath] = uigetfile('*.avi');
    obj = VideoReader([FolderPath,FolderName]);
    nframes=obj.NumberOfFrames;
     obj = VideoReader([FolderPath,FolderName]);
    for img = 1:nframes;
        videoFrame = readFrame(obj);
        Vel_Estimation(nargout);
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
%        figure
       
        for i=1:n 
            
            % which quater is selected
            x=mod(i+1,2)+1;
            y=ceil(i/2);
            
            %id of this quater
            xV=floor(size(videoFrame,2)./2)*(x-1)+(1:floor(size(videoFrame,2)./2));
            yV=floor(size(videoFrame,1)./(((n/2)-1)*2))*(y-1)+(1:floor(size(videoFrame,1)./2));
            
            Q=videoFrame(yV,xV)>0.5*255;
            Q=bwareaopen(Q,150); % remove small particle
%             subplot(5,2,i)
%             imshow(Q);
            
            % estimate velocity of 6 quaters
            if sum(sum(Q,1),2)>0
                stats = regionprops('struct',Q,'Centroid');
%                 RGB=uint8(Q)*255;
%                 RGB = insertObjectAnnotation(RGB,'rectangle',[stats.Centroid(1:2) 10 10],'here');
%                 figure
%                 imshow(RGB);
                if size(position{i},1)>0
                    % speed
                    if numel(stats.Centroid,1)==1
                        vel_pix = sqrt(sum((stats.Centroid(1:2)-position{i}(end,1:2)).^2,2));
%                         velocity
%                         vel_pix=vel_pix*sign(stats.Centroid(1)-position{i}(end,1));
                        position{i}=[position{i};stats.Centroid(1:2) vel_pix];
                    else
                        position{i}=[nan nan nan];
                    end
;
                else
                    if numel(stats.Centroid,1)==1
                    position{i}=[position{i};stats.Centroid(1:2) nan];
                    else
                        position{i}=[nan nan nan];
                    end
                end
                
            else
                position{i}=[position{i};nan nan nan];
            end
        end
        
        %velocity of pixel
        vel=[];
        for i=1:n
        vel=[vel position{i}(end,3)];
        end
        vel(isoutlier(vel))=[];
        velocity=[velocity;nanmedian(vel)];
        % velocity of metric system
        %         vel = vel_pix * frameRate * scale; % pixels/frame * frame/seconds * meter/pixels
        
        %visulize activity on video
        if nargout > 1
            if isempty(powerframe)
                PowerBar=255*ones(size(videoFrame,1),20);                    
                powerframe(:,:,:,1)=[PowerBar videoFrame];
            else
                PowerBar=255*ones(size(videoFrame,1),20);
                if ~isnan(velocity(end))
                PowerBar(1:floor(size(videoFrame,1)-velocity(end)),1:20)=0;
                end
                powerframe(:,:,:,end+1)=[PowerBar(1:size(videoFrame,1),1:20) videoFrame];
            end
        end

    end
figure
for i=1:n
plot(position{i}(:,3),'--')
hold on
end

figure
plot(velocity)
end