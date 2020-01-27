function [velocity,powerframe]=balltrackerestimation(varargin)
addpath('C:\Users\lab\Desktop\scripts');


powerframe=[];
PixelPerCell=120;
MarkerSet='ABCDEFGHIJKLMNOP';

if nargin<1
    % Create a video file reader.
    [FolderName,FolderPath] = uigetfile('*.avi');
    obj = VideoReader([FolderPath,FolderName]);
    nframes=obj.NumberOfFrames;
    for line=1:2 % how many lines of characters will be reconized
        obj = VideoReader([FolderPath,FolderName]);
        velocity = [];
        position=[];
        for img = 1:nframes;
            videoFrame_origin = readFrame(obj);
            
            MultiLineROI;videoFrame;rect;
            Vel_Estimation(nargout);
        end
        velocity_merge(:,line)=velocity;
        position_merge(:,line)=position;
        
    end
    figure
%         plot(velocity_merge./PixelPerCell)
%         hold on
%         plot(position_merge./PixelPerCell)
velocity=nanmedian(velocity_merge,2);
 plot(velocity./PixelPerCell)
else
    videoFrame_origin = varargin{1};
    for img=1:size(videoFrame_origin,4)
        videoFrame_origin = varargin{1}(:,:,:,img);
        
        for line=1:2 % how many lines of characters will be reconized
            MultiLineROI;videoFrame;rect;
            Vel_Estimation(nargout);
        end
    end
end

    function MultiLineROI
        if img==1 & line==1 % choose ROI of two different lines
            figure
            imshow(videoFrame_origin(:,:,:,1));
            title('choose the ROI for line 1 characters');
            rect(1,:) = getrect;
            title('choose the ROI for line 2 characters');
            rect(2,:) = getrect;
            close
            %if ROI id is too small
            rect(find(rect<1))=1;
            %if ROI id is too large
            OverSizeID=find((rect(:,2)+rect(:,4))>size(videoFrame_origin,1));
            LargestID=size(videoFrame_origin,1)-rect(:,2);
            rect(OverSizeID,4)=LargestID(OverSizeID);
            OverSizeID=find((rect(:,1)+rect(:,3))>size(videoFrame_origin,2));
            LargestID=size(videoFrame_origin,2)-rect(:,1);
            rect(OverSizeID,3)=LargestID(OverSizeID);
            
            videoFrame=videoFrame_origin(rect(line,2):rect(line,2)+rect(line,4),rect(line,1):rect(line,1)+rect(line,3),:,:);
        else
            videoFrame=videoFrame_origin(rect(line,2):rect(line,2)+rect(line,4),rect(line,1):rect(line,1)+rect(line,3),:,:);
        end
        
    end

    function Vel_Estimation(nargout)
        %divide the image to n partial overlapped quaters;
        %        figure
        %        imshow(videoFrame);
        
        Q=videoFrame(:,:,1)<0.6*255;
        Q=bwareaopen(Q,300); % remove small particle
%         Q=Q-bwareaopen(Q,1500); % remove large particle
        Q = imclearborder(Q);
        
        %        % Perform morphological reconstruction and show binarized image.
        % marker = imerode(Q, strel('line',50,0));
        % Iclean = imreconstruct(marker, Q);
        
%         figure
%         imshow(Q);
        
        results = ocr(Q,'CharacterSet',MarkerSet,'TextLayout','Block','Language','C:\Users\lab\Desktop\2pDataAnalysis\pattern recognition\myLang_test\tessdata\myLang_test.traineddata');
        % 
        WordConfidences=results.WordConfidences;
        WordBoundingBoxes=results.WordBoundingBoxes;
        
        % wierd situation is that results.WordConfidences is more than results.Text
        WordConfidences(find(WordConfidences==0),:)=[];
        WordBoundingBoxes(find(WordConfidences==0),:)=[];
        
        label=results.Text(isletter(results.Text));
        if length(label)==length(WordConfidences)
            label=label(WordConfidences>0.85);
        end
        WordBoundingBoxes=results.WordBoundingBoxes(WordConfidences>0.8,:);
        WordConfidences=WordConfidences(WordConfidences>0.8,:);
        
        if ~isempty(WordConfidences) & length(label)==length(WordConfidences)
%             Iocr = insertObjectAnnotation(uint8(Q)*255, 'rectangle', ...
%                 WordBoundingBoxes, ...
%                 WordConfidences);
            
            Iocr = insertText(uint8(Q)*255,WordBoundingBoxes(:,1:2),label);
%             figure; imshow(Iocr);
            Label=MarkerSet;
            label_p=[];
            for i=1:length(label)
                label_p(i) = strfind(Label,label(i)).*PixelPerCell-WordBoundingBoxes(i,2);
            end
            
            %in case the first alphabet and last alphabet exist in the
            %same frame
            if strfind(label,Label(1))
                if strfind(label,Label(end))
                    if find(min(abs(size(Q,1)./2-WordBoundingBoxes(:,2)))==abs(size(Q,1)./2-WordBoundingBoxes(:,2)))==1
                        label_p(1)=label_p(1)-16.*PixelPerCell;
                    else
                        label_p(2)=label_p(2)+16.*PixelPerCell;
                    end
                end
            end
            
            
        else
            label_p=nan;
%             figure; imshow(Q);
        end
        
        %position
        if length(label_p)>0
            position=[position;nanmean(label_p)];
        else
            position=[position;nan];
        end
        
        %velocity
        if size(position,1)>1
            if position(end)<position(end-1)
                v(1)=16*PixelPerCell+position(end)-position(end-1);
            else
                v(1)=position(end)-position(end-1);
            end
            
            v(2)=16*PixelPerCell-v(1);
            
            if v(1)<v(2)
                sign=1;
            else
                sign=-1;
            end
            
            if isempty(sign.*v(find(v==min(v))))
                velocity=[velocity;nan];
            else
                velocity=[velocity;sign.*v(find(v==min(v)))];
            end
        end
        
        %visulize activity on video
        if nargout > 1
            L=size(videoFrame,1);
            PowerBar=zeros(size(videoFrame,1),20,size(videoFrame,3));
            
            if ~isempty(velocity)
                if ~isnan(velocity(end)) & velocity(end)~=0
                    Vbar=0:velocity(end)/abs(velocity(end)):floor(velocity(end)./5);
                    PowerBar(floor(L./2)-Vbar,1:15,1)=1*255;
                end
            end
                powerframe(:,:,:,end+1)=[PowerBar videoFrame];
            
        end
        
    end
% figure
% plot(velocity./PixelPerCell,'r')
% hold on
% plot(position(2:end)./PixelPerCell,'b')
% velocity=[velocity./PixelPerCell position(2:end)./PixelPerCell];

end