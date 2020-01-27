%% 
addpath('C:\Users\lab\Desktop\scripts'); 
addpath('C:\Users\lab\Desktop\scripts\subroutine'); 

% get file name
currentFolder = pwd
[FolderName,FolderPath] = uigetfile(currentFolder,'*.mat');
DispFrameRate=15

%% making ball tracker video
load([FolderPath,FolderName(1:end-4),'_ball.mat']);
v = VideoWriter([FolderPath,FolderName(1:end-4),'_ball.avi']);
v.FrameRate = DispFrameRate;
velocity_bar=0; %if the velocity bar will be included in video choose 1

%adjust the location of markers
Roll_data = imrotate(data,180,'bilinear','loose');
figure
imshow(Roll_data(:,:,:,1));
rect = getrect;
close;
[rect]=RectAdjust(Roll_data,rect);

Crop_data=Roll_data(rect(2):rect(2)+rect(4),rect(1):rect(1)+rect(3),:,:);

figure
imshow(Crop_data(:,:,:,1));
axis on
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

%% making eye tracker video
load([FolderPath,FolderName(1:end-4),'_eye.mat']);
v = VideoWriter([FolderPath,FolderName(1:end-4),'_eye.avi']);
v.FrameRate = DispFrameRate*2;
open(v);
writeVideo(v,data);
close(v);

%% making paw video
load([FolderPath,FolderName(1:end-4),'_eye.mat']);
v = VideoWriter([FolderPath,FolderName(1:end-4),'_paw.avi']);
v.FrameRate = DispFrameRate*2;

figure
imshow(data(:,:,:,1));
rect = getrect;
close;
[rect]=RectAdjust(data,rect);

Crop_data=data(rect(2):rect(2)+rect(4),rect(1):rect(1)+rect(3),:,:);


% figure
% % imshow(Crop_data(:,:,:,1));
% cont_data = imadjust(gray_data);%increase contrast
% 
% % Th_data= Crop_data > 0.2*255;
% 
% Bw_data = uint8(Th_data)*255;



open(v);
writeVideo(v,Crop_data);
close(v);


%% making signal video
clear data3d
data=[];

Filename =[FolderPath,FolderName(1:end-4),'_OUT_crop 3D.tif'];

T = Tiff(Filename);
j = T.getTag('ImageDescription');
k=strfind(j,'images=')+7;
nframes=str2double(j((1:find(j(k:end)==newline,1))+k-1));

data3d=load_tiffs_fast(Filename,'nframes',nframes);
data3d = uint8(data3d / 255);

scale=round(83.5502);
for n=1:nframes
%     data3d(:,:,n)=imadjust(data3d(:,:,n));
data3d(end-20:end-10,101:100+scale,n);
    data(:,:,1,n)=data3d(:,:,n);
end

v = VideoWriter([Filename(1:end-4),'.avi']);
v.FrameRate = DispFrameRate;
open(v);
writeVideo(v,data);
close(v);

%% making combined video
data_cell=data;
nframes=1000;

load([FolderPath,FolderName(1:end-4),'_eye.mat']);
Filename =[FolderPath,FolderName(1:end-4),'_OUT.avi'];
data_eye=data(:,:,:,1:2:2*nframes);
% figure
% imshow(data_eye(:,:,1,1))
data_merge=data_eye;


%merge ball image
% figure
% imshow(Roll_data(:,:,:,1));
% rect = getrect;
% close;
% 
% %if ROI id is too small
% rect(find(rect<1))=1;
% %if ROI id is too large
% OverSizeID=find((rect(:,2)+rect(:,4))>size(Roll_data,1));
% LargestID=size(Roll_data,1)-rect(:,2);
% rect(OverSizeID,4)=LargestID(OverSizeID);
% OverSizeID=find((rect(:,1)+rect(:,3))>size(Roll_data,2));
% LargestID=size(Roll_data,2)-rect(:,1);
% rect(OverSizeID,3)=LargestID(OverSizeID);
% Crop_data=Roll_data(rect(2):rect(2)+rect(4),rect(1):rect(1)+rect(3),:,:);
% data_merge(1:size(Crop_data,1),1:size(Crop_data,2),1,:)=Crop_data;



%merge cell image
% figure
% imshow(data_cell(:,:,:,1));
% axis on
% cell_vs=250;
% cell_ve=491;
% cell_hs=300;
% cell_he=400;
% % figure
% % imshow(data_cell([cell_vs:cell_ve],[cell_hs:cell_he],1,1))
% % axis on
% % merge at right side
% % data_merge((ball_ve-ball_vs)+1+(1:(cell_ve-cell_vs)+1),[end-(cell_he-cell_hs):end],1,:)=...
% %     data_cell([cell_vs:cell_ve],[cell_hs:cell_he],1,:);
% % merge at left side
% data_merge((ball_ve-ball_vs)+1+(1:(cell_ve-cell_vs)+1),[1:(cell_he-cell_hs)+1],:,:)=...
%     data_cell([cell_vs:cell_ve],[cell_hs:cell_he],1,:);




% insert stim shape
imshow(data_merge(:,:,:,1));
axis on
[Stim_signal]=ShowEvent();
RGBdata_merge=repmat(data_merge,1,1,3,1);
AirPuffFrames=find(Stim_signal);
for i=1:nframes
RGBdata_merge(:,:,:,i) = insertShape(RGBdata_merge(:,:,:,i),'circle',[1 1 0],'LineWidth',5,'Color','white');
if Stim_signal(i);
RGBdata_merge(:,:,:,i) = insertShape(RGBdata_merge(:,:,:,i),'circle',[460 170 35],'LineWidth',5);
end
end

% label cell color
% colorList=[0,1,0;255/255,69/255,0];
% colorList=[0,0,1;255/255,69/255,0];
% cell1=imread([FolderPath,FolderName(1:end-4),'_OUT_MotCor_cell1.tif']);
% Th=zeros(size(RGBdata_merge,1),size(RGBdata_merge,2));
% Th((ball_ve-ball_vs)+1+(1:(cell_ve-cell_vs)+1),[1:(cell_he-cell_hs)+1])=...
%     cell1([cell_vs:cell_ve],[cell_hs:cell_he]);
% L1=ones(size(Th));
% L1(Th>0)=colorList(1,1);
% L2=ones(size(Th));
% L2(Th>0)=colorList(1,2);
% L3=ones(size(Th));
% L3(Th>0)=colorList(1,3);
% Co=cat(3,L1,L2,L3);
% Co=repmat(Co,1,1,1,nframes);
% Co=uint8(Co);
% RGBdata_merge=RGBdata_merge.*Co;


% cell1=imread([FolderPath,FolderName(1:end-4),'_OUT_MotCor_merge.tif']);
Th=zeros(size(RGBdata_merge,1),size(RGBdata_merge,2));
% Th((ball_ve-ball_vs)+1+(1:(cell_ve-cell_vs)+1),[1:(cell_he-cell_hs)+1])=...
%     cell1([cell_vs:cell_ve],[cell_hs:cell_he]);
L1=ones(size(Th));
L1(Th>0)=1;
L2=ones(size(Th));
L2(Th>0)=1;
L3=ones(size(Th));
L3(Th>0)=1;
Co=cat(3,L1,L2,L3);
Co=repmat(Co,1,1,1,nframes);
Co=uint8(Co);
RGBdata_merge=RGBdata_merge.*Co;

imshow(RGBdata_merge(:,:,:,19))
axis on

v = VideoWriter([Filename,'_merge.avi']);
v.FrameRate = DispFrameRate;
open(v);
writeVideo(v,RGBdata_merge);
close(v);



% v = VideoWriter([Filename,'_merge.avi']);
% v.FrameRate = DispFrameRate;
% open(v);
% writeVideo(v,data_merge);
% close(v);

