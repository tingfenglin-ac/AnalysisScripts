function Frame2AVI_2v
%%
addpath('C:\Users\lab\Desktop\scripts');
addpath('C:\Users\lab\Desktop\scripts\subroutine');

% get file name
currentFolder = pwd
[FolderName,FolderPath] = uigetfile(currentFolder, 'Multiselect', 'on');
DispFrameRate=309


if iscell(FolderName)
    filezize=size(FolderName,2);
else
    filezize=1;
end
for fnumber=1:filezize
    %                 if fnumber==2
    %                 n=1;
    %                 end
    if iscell(FolderName)
        FN=FolderName{fnumber};
    else
        FN=FolderName;
    end
    
    
    %% making ball tracker video
    MakingBallTrackingVideo=0;
    if MakingBallTrackingVideo
        load([FolderPath,FN(1:end-4),'_ball.mat']);
        v = VideoWriter([FolderPath,FN(1:end-4),'_ball.avi']);
        v.FrameRate = DispFrameRate;
        velocity_bar=0; %if the velocity bar will be included in video choose 1
        
        %adjust the location of markers
        Roll_data = imrotate(data,0,'bilinear','loose');
        if fnumber==1
            figure
            imshow(Roll_data(:,:,:,1));
            rect = getrect;
            close;
            [rect]=RectAdjust(Roll_data,rect);
        end
        
        
        Crop_data=Roll_data(rect(2):rect(2)+rect(4),rect(1):rect(1)+rect(3),:,:);
        
        %             figure
        %             imshow(Crop_data(:,:,:,1));
        %             axis on
        %%%%%%%%%%%
        
        
        % figure
        % imshow(Crop_data(:,:,:,1));
        % axis on
        
        % Th_data= Crop_data < 0.5*255;
        % figure
        % imshow(Th_data(:,:,:,1));
        % axis on
        
        
        % Bw_data = uint8(Th_data)*255;
        % figure
        % imshow(Bw_data(:,:,:,2));
        % axis on
        
        if velocity_bar==1;
            [velocity,powerframe]=balltrackerestimation_2v(Crop_data);
            videodata=uint8(powerframe);
        else
            videodata=Crop_data;
        end
        open(v);
        writeVideo(v,videodata);
        close(v);
    end
    
      %% making variation of ball tracker video
      VarBallTracker=1;
      if VarBallTracker
          load([FolderPath,FN(1:end-4),'_ball.mat']);
          
          variation=var(double(data),0,4);
          figure
          imagesc(variation)
      end
    
    %% making eye tracker video
    MakingBallTrackingVideo=0;
    if MakingBallTrackingVideo
        load([FolderPath,FN(1:end-4),'_eye.mat']);
        v = VideoWriter([FolderPath,FN(1:end-4),'_eye.avi']);
        v.FrameRate = DispFrameRate;       
        open(v);
        writeVideo(v,data);
        close(v);
    end
end






