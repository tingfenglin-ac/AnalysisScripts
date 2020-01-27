%% Write Normalized F (dF/F0)
addpath('..'); 

addpath('C:\Users\lab\Desktop\scripts'); 
 [fn,FolderPath] = uigetfile('*.tif','Multiselect', 'on');
% fn = '819_000_005_OUT_MotCor crop.tif'; 
T = Tiff(fn);
j = T.getTag('ImageDescription');
k=strfind(j,'images=')+7;
num_frames = str2double(j((1:find(j(k:end)==newline,1))+k-1));
scale=700./375.6070;

I = zeros([size(imread(fn, 1)), num_frames]); 
for i = 1:num_frames
    I(:,:,i) = imread(fn, i);
end

rng_int = [min(I(:)),max(I(:))]; 

I(I==0) = nan; 
time_series = squeeze(mean(I, 2, 'omitnan')); 
df_f0 = calculate_dFF0(time_series, 25:35); 
imwrite(df_f0, 'df_f0_withmasked.tif')
%% Plot Norm F over time %calibrate pixels to um
figure;
CalibratedScale=scale*size(df_f0);%calibrate pixels to um

%load time variables
    %% get time variables from file
    load([FolderPath,fn(1:11),'_eye.mat']);
    load([FolderPath,fn(1:11),'.mat']);
    step=round(size(time,1)./info.config.frames);
    time=time(1:step:step.*info.config.frames);

% for concatenated data
timestep=time;
for ext_time=1:round(size(df_f0,2)/size(time,1))-1
    time=[time;time(end)+timestep];
end



image([time(1) time(size(df_f0,2))],[1 CalibratedScale(1)],df_f0, 'cdatamapping', 'scaled');
hold on
[Stim_signal]=ShowEvent; % if show stimulus

% for concatenated data
Stim_signal=repmat(Stim_signal,round(size(time,1)/size(Stim_signal,1)),1);
step=round(length(time)/size(df_f0,2));
plot(time(p:step:step.*size(df_f0,2)),Stim_signal*2000,...
    'k','linewidth',1.5);

% plot([15 15],[0 CalibratedScale(1)],'k','linewidth',1.5);

set(gcf,'color',[1 1 1]);
xlabel('Time (s)');
ylabel('\mum');
colormap('jet')
%% Plot Correlations %calibrate pixels to um
frame_interval = 1:465; 
cm = corr(df_f0(:,frame_interval)'); 

figure; 
CalibratedScale=scale*size(cm);%calibrate pixels to um
image([1 CalibratedScale(1)],[1 CalibratedScale(1)],cm, 'cdatamapping', 'scaled'); 
colormap('jet')
set(gcf,'color',[1 1 1]);
xlabel('\mum');
ylabel('\mum');
axis square
caxis([-1,1]); 
%% Time binned correlations
% step_sz = 10; 
% n_frames = size(df_f0,2);
% n_bin = ceil(n_frames/step_sz); 
% sliding_corr = arrayfun(@(x) mean(corr(df_f0(:,max(x*step_sz,1):min(x*step_sz+step_sz,n_frames))'),1,'omitnan'), ...
%     0:(n_bin-1),'uni',0);
% sliding_corr = vertcat(sliding_corr{:}); 
% 
% figure; 
% image(sliding_corr', 'cdatamapping', 'scaled'); 
% colormap('jet')
% axis square
% % caxis([-1,1]); 
% %% Show Dendrite Image average pixel intensity
% figure; hold on;
% imshow(mean(I,3),'displayrange',rng_int);
% 
% %% Plot Dendrite and Norm F over time (here normalization is Fc from sheffield FtoFc script)
% meanI = mean(I,3,'omitnan'); 
% szI = size(I); 
% Fbyside = squeeze(mean(I,2,'omitnan')); 
% Fcbyside = FtoFc(Fbyside',100)';
% szF = size(Fbyside); 
% 
% ind_roi = 1:100; 
% 
% figure;
% subplot(1,5,1); hold on; 
% colormap(gca, 'bone'); 
% % imshow(meanI,'displayrange',rng_int)
% image(meanI(ind_roi,:), 'cdatamapping', 'scaled'); 
% set(gca, 'ydir', 'reverse'); 
% xlim([1,szI(2)]); 
% % ylim([1,szI(1)]); 
% ylim(ind_roi([1,end])); 
% % daspect([1,1,1]);
% 
% subplot(1,5,2:5); hold on; 
% colormap(gca, jet(2000)*0.8); 
% image(Fcbyside(ind_roi,:), 'cdatamapping', 'scaled'); 
% set(gca, 'ydir', 'reverse'); 
% % pbaspect([,1,1]);
% xlim([1,szF(2)]); 
% ylim(ind_roi([1,end])); 
% %% Plot Dendrite and Norm F over time (here normalization is Fc from sheffield FtoFc script)
% meanI = mean(I,3,'omitnan'); 
% szI = size(I); 
% Fbyside = squeeze(mean(I,2,'omitnan')); 
% Fcbyside = FtoFc(Fbyside',100)';
% szF = size(Fbyside); 
%% Plot raw and norm F profile over time for each spatial point on dendrite (here normalization is Fc from sheffield FtoFc script)
% figure; hold on; 
% for i = 1:100
% %     subplot(2,1,1); 
%     yyaxis left 
%     plot(Fbyside(i,:),'-b','linewidth',0.1); 
%     
%     smoothedFc = smooth(Fcbyside(i,:),20);
% %     subplot(2,1,2); 
% yyaxis right
%     plot(smoothedFc,'-r','linewidth',2)
%     title(['pix = ' num2str(i)]); 
%     xlim([1,szF(2)])
%     waitforbuttonpress
%     clf
% end
% 
