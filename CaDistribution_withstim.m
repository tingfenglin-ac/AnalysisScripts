%%
addpath('C:\Users\lab\Desktop\scripts');
addpath('C:\Users\lab\Desktop\scripts\subroutine');

%% configure
StackOrOverlap=1 %1=stack; 2=overlap
extend=[0.1 0.5]; %plot 'extend' second before and after the rising phase
heatmap_ext=0.4; %plot heatmap 'extend' second after the rising phase
n=[8]; %n = ROI number I would like to analyze
Fcaxis=[0, 2*10^4];
dFcaxis=[0,8];


%% signal
SelectedFile={};
FolderPath=1;

[FolderName,FolderPath] = uigetfile('*.csv','Select ca signal files', 'Multiselect', 'on');

if iscell(FolderName)
    filezize=size(FolderName,2);
else
    filezize=1;
end
for fnumber=1:filezize
    if iscell(FolderName)
        FN=FolderName{fnumber};
    else
        FN=FolderName;
    end
    Import_data=importdata([FolderPath,FN]);
    
    %% get time variables
    %% get time variables from file
    load([FolderPath,FN(1:11),'_eye.mat']);
    load([FolderPath,FN(1:11),'.mat']);
    step=round(size(time,1)./info.config.frames);
    time=time(1:step:step.*info.config.frames);
    
    % for concatenated data
    timestep=time;
    for ext_time=1:round(size(Import_data.data,1)/size(time,1))-1
        time=[time;time(end)+timestep];
    end

    
    %% align Ca signal
    signal=[];
    signal=Import_data.data(:,3+(n-1)*2);
    [signal]=FBackCorr(signal,15);
    
    % pick up peaks for analysis
    figure
    plot(1:length(signal),signal);
    hold on
    plot(1:length(signal),derivate(signal,1));% acceleration
    legend('Ca siganl','dy/dt');
    title('press any key, and choose begining of a spike');
    
    zoom on;
    pause() % you can zoom with your mouse and when your image is okay, you press any key
    zoom off; % to escape the zoom mode
    
    
    rect = ginput(1);
    rect=round(rect);
    close
    
    %stimulation
%     [Stim_signal]=ShowEvent_v2;
%     rect=find(Stim_signal>0);
%     rect=rect(1);
    
    
    % merge data
    if fnumber==1
        InterFrameInterval=nanmean(derivate(time,1)); %inter-sample interval
        ExtendIndex=round(extend./InterFrameInterval);
        heatmap_ext_idx=round(heatmap_ext/InterFrameInterval);
    end
    
    if rect(1)-ExtendIndex(1)>0 && rect(1)+ExtendIndex(2)<length(signal)
        idx=(rect(1)-ExtendIndex(1):rect(1)+ExtendIndex(2))'; %idx of ca signal
        heatmap_idx=rect(1):rect(1)+heatmap_ext_idx; %idx of ca signal which would generate heatmap
             
        figure
        %ploting F
        set(gcf,'Position',[680 200 600 200],'color',[1 1 1]);
        subplot(1,5,1);
        
        area(time(1:length(heatmap_idx)),3*ones(1,length(heatmap_idx))',...
            'EdgeColor','none',...
            'FaceColor',[1 0.5 0.5],...
            'Facealpha',0.5);
        hold on
        plot(time(1:length(signal))-time(rect(1)),signal,'color',[0.5 0.5 1]);
        ylim([-0.5 1])
        xlim(time(idx([1 end]))-time(rect(1)));
        signal=signal(idx);
        xlabel('Time (s)')
        ylabel('dF/F0');
        
        
        %plotting F image
        [BCim,im]=getim(FolderPath,FolderName,step); %get image file as matrix
        
        %load ROI
        ROI=dlmread([FolderPath,'916_000_021-026_OUT_MotCor ROI ',num2str(n),' XY.txt']);
        dim=[min(ROI(:,2))-1,max(ROI(:,2))+1,min(ROI(:,1))-1,max(ROI(:,1))+1];%position of heatmap [min(y) max(y) min(x) max(x)]
        bw = uint16(poly2mask([ROI(:,1);ROI(1,1)]-dim(3),[ROI(:,2);ROI(1,2)]-dim(1),dim(2)-dim(1)+1,dim(4)-dim(3)+1));
        subplot(1,5,[2 3]);
        imagesc(uint16(mean(im(dim(1):dim(2),dim(3):dim(4),heatmap_idx),3)).*bw);
        colorbar
        title('F')
        axis image;
        caxis(Fcaxis);
        hold on
        %draw ROI
        plot([ROI(:,1);ROI(1,1)]-dim(3),[ROI(:,2);ROI(1,2)]-dim(1),'r');
        set(gca, 'XTick', [],'YTick', []);
        
        %plotting dF/F0
        subplot(1,5,[4 5]);
        imagesc(uint16(mean(BCim(dim(1):dim(2),dim(3):dim(4),heatmap_idx),3)).*bw);
        colorbar
        title('dF/F0')
        axis image;
        caxis(dFcaxis);
        hold on
        %draw ROI
        plot([ROI(:,1);ROI(1,1)]-dim(3),[ROI(:,2);ROI(1,2)]-dim(1),'r');
        set(gca, 'XTick', [],'YTick', []);
        %draw local ROI
        %                         for roi=2:12
        %                             localROI{roi}=dlmread([FolderPath,FolderName(1:8),'023-030 manual ROI ',num2str(roi),' XY 20190830.txt']);
        %                         plot([localROI{roi}(:,1);localROI{roi}(1,1)]-dim(3),[localROI{roi}(:,2);localROI{roi}(1,2)]-dim(1),'r');
        %                         end
        
        
        %plotting time series F
        figure
            set(gcf,'Position',[680 200 1200 200],'color',[1 1 1]);
        for tf=1:5
        subplot(1,5,tf);
        imagesc(uint16(mean(im(dim(1):dim(2),dim(3):dim(4),min(heatmap_idx)-2+[tf*2 tf*2-1]),3)).*bw);
        
        colorbar
        title([num2str((tf-2)*InterFrameInterval,'%.2f'),' s'])
        axis image;
        caxis(Fcaxis);
        hold on
        %draw ROI
        plot([ROI(:,1);ROI(1,1)]-dim(3),[ROI(:,2);ROI(1,2)]-dim(1),'r');
        set(gca, 'XTick', [],'YTick', []);
        end
        
        
        
        %plotting time series dF/F0-1
        figure
            set(gcf,'Position',[680 200 1200 200],'color',[1 1 1]);
        for tf=1:5
        subplot(1,5,tf);
        imagesc(uint16(mean(BCim(dim(1):dim(2),dim(3):dim(4),min(heatmap_idx)-2+[tf*2 tf*2-1]),3)).*bw);
        
        colorbar
        title([num2str((tf-2)*InterFrameInterval,'%.2f'),' s'])
        axis image;
        caxis(dFcaxis);
        hold on
        %draw ROI
        plot([ROI(:,1);ROI(1,1)]-dim(3),[ROI(:,2);ROI(1,2)]-dim(1),'r');
        set(gca, 'XTick', [],'YTick', []);
        end
 
        SelectedFile=[SelectedFile;FN];
    end
    
end



%% get image
function [BCim,im]=getim(FolderPath,FolderName,step)
clear data3d
data=[];

Filename =[FolderPath,FolderName(1:end-17),'.tif'];

% T = Tiff(Filename);
% j = T.getTag('ImageDescription');
% k=strfind(j,'images=')+7;
% nframes=str2double(j((1:find(j(k:end)==newline,1))+k-1));
nframes=465;
im=load_tiffs_fast(Filename,'nframes',nframes);
% BCim=im;
framerate=15;
[BCim]=FBackCorr(im,framerate);
end
