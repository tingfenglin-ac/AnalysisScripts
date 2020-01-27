addpath('C:\Users\lab\Desktop\scripts\subroutine');

%% configure
paw_move=0; %%if the paw movement will be included in the figure choose 1, or choose others  
vel_ana=0; %if the motion activity will be included in the figure choose 1, or choose others  
blink_ana=0; %if the eye blink will be included in the figure choose 1, or choose others  
Air_puff=1; %if the air puff will be included in the figure choose 1, or choose others  
CrossCor=0; %if the cross correlation among signals will be analyzed choose 1
StackOrOverlap=2; %if the signals will be placed in stacks choose 1; if the signals will be placed overlapped choose 2
PlotMean=1; %if plot the mean of data
k=1; %figure number with individual trial
m=2; %figure number with shadow
cs=3;
n=[3]; %n = ROI number I would like to analyze



%% signal
for  j=1:1%how many plains
    plain_number=1; %if more than 1 plain, enter the 2
    if plain_number==2
        p=j;
    else
        p=1;
    end
    all_signal=[];
    
    f=1;
    FolderPath=1;
    while FolderPath~=0
        [FolderName,FolderPath] = uigetfile('*.csv',['Select an ROI file for plain' num2str(j)], 'Multiselect', 'on');
        if FolderPath~=0
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
                Import_data=importdata([FolderPath,FN]);
               
                
                % colorList=[0,0.5,0;255/255,69/255,0];
                % ,'color',colorList(1,:)
                hold on
                
                %% get time variables
                if 1
                    %% get time variables from file
                    % [FolderName,FolderPath] = uigetfile('*.mat');
                    load([FolderPath,FN(1:11),'_ball.mat']);
                    t=time;
                else
                    %% get time variables by using back calculaition
                    t=(1:length(Import_data.data(:,1)))./30;
                end
                
                %% analyze ROI
                clear Label
                
                
                for i=1:length(n)
                    signal=[];
                    signal=smooth(Import_data.data(:,3+(n(i)-1)*2),15,'lowess');
                    step=round(length(t)/length(signal));
                    MINdata=min(signal);
                    MAXdata=max(signal);
                    signal=((signal-MINdata)./(MAXdata-MINdata)); %normalization
%                     signal=signal(IDX(:,fnumber)); %align with movement
                    
                    figure(k);
                    hold on
                    if StackOrOverlap==1
                        plot(t(p:step:step.*length(signal)),signal+length(n)-i+2);
                    else
                        plot(t(p:step:step.*length(signal)),signal,'color',[1 0.5 0.5]);
                    end
                    % find peaks
                    [pks,locs] = findpeaks(signal,t(p:step:step.*length(signal)));
                    Clocs=locs(pks>2/3);
                    Slocs=locs(pks<2/3 & pks>1/3);
                    hold on
                    plot(repmat(Slocs,1,2)',[1;1.05].*ones(length(Slocs),2)','g','linewidth',1.5)
                    plot(repmat(Clocs,1,2)',[1.05;1.1].*ones(length(Clocs),2)','r','linewidth',1.5)
                    
     
                    
                    % get mean
                    if PlotMean==1
%                         frame_number=155; %speed alignment
                        frame_number=930;
                        all_signal=[all_signal signal(1:frame_number)];
                    end
                    
                    hold on
                    Label{i}=num2str(n(i));
                end
            end
        end
        f=f+1;
    end
    
    % plot mean
    if PlotMean==1
        signal=mean(all_signal,2);
        figure(k);
        plot(t(p:step:step.*frame_number),signal,'r','linewidth',1.5);
        hold on
        
        %         show err shadow
        
    end
end
%% plot area
if m
    figure(m);
    plot(t(p:step:step.*frame_number),signal,'r','linewidth',1.5);
    hold on
    signalStd=nanstd(all_signal,0,2);
    ErrArea_Smooth(t(p:step:step.*frame_number),signal,signalStd,...
        [1 0 0]);
end
%% paw signal
if paw_move==1;
    for j=1 %how many plains
        [FolderName,FolderPath] = uigetfile('*.csv');
        Import_data=importdata([FolderPath,FolderName]);
        figure(k);
        
        % colorList=[0,0.5,0;255/255,69/255,0];
        % ,'color',colorList(1,:)
        hold on
        
        %% get time variables
        if 1
            %% get time variables from file
            % [FolderName,FolderPath] = uigetfile('*.mat');
            load([FolderPath,FolderName(1:11),'_ball.mat']);
            t=time;
        else
            %% get time variables by using back calculaition
            t=(1:length(Import_data.data(:,1)))./30;
        end
        
        %% analyze ROI
        clear Label
        n=[1 3]; %n = ROI number I would like to analyze
        
        for i=1:length(n)
            signal=[]
            signal=smooth(Import_data.data(:,3+(n(i)-1)*2),15,'lowess');
            signal=signal(1:2:end);
            step=round(length(t)/length(signal));
            MINdata=min(signal);
            MAXdata=max(signal);
            if StackOrOverlap==1
                plot(t(j:step:step.*length(signal)),((signal-MINdata)./(MAXdata-MINdata))+length(n)-i);
            else
                plot(t(j:step:step.*length(signal)),((signal-MINdata)./(MAXdata-MINdata)));
            end
            hold on
            Label{i}=num2str(n(i));
        end
    end
end


%% motion activity
if vel_ana==1;
%% estimate velocity    
[velocity]=balltrackerestimation_2v;
%% draw velocity
v=smooth(velocity,15,'lowess');
normalv=v/max(v);
% plot(t,normalv);
figure(k);
area(t(1:length(normalv)),normalv,...
    'FaceColor',[0.5 0.5 0.5],...
    'EdgeColor','none',...
    'FaceAlpha',0.3);
stim='Speed';
end

%% eye blink
if blink_ana==1;
    [blink]=EyeBlinkEstimation;
blink=smooth(blink(1:600),15,'lowess');
normalb=blink/max(blink);
hold on
figure(k);
area(t(1:length(normalb)),1-normalb,...
    'FaceColor',[0.5 0.5 0.5],...
    'EdgeColor','none',...
    'FaceAlpha',0.3);
stim='Eye blink';
end

%% Air puff
if Air_puff==1;
    figure(k)
ShowEvent; % if show stimulus
stim='Air puff';

if m
    figure(m)
ShowEvent; % if show stimulus
stim='Air puff';
end
end

%% figure
%single data
figure(k)
xlabel('Time (s)');
set(gcf,'color',[1,1,1]);
   if StackOrOverlap==1
   ylim([0 5]);
    else
       ylim([0 1.1]);
   end

xlim([0 30])
% legend({'Distal dendrite 1','Distal dendrite 2', 'Proximal dendrite','Air puff'},'FontSize',14);

%shadow
if m
    figure(m)
xlabel('Time (s)');
set(gcf,'color',[1,1,1]);
   if StackOrOverlap==1
   ylim([0 5]);
    else
       ylim([0 1]);
   end

xlim([0 30])
legend({['Cell ' num2str(n) ' (n=' num2str(size(all_signal,2)) ')'],stim},'Orientation','horizontal','FontSize',14);
end

% legend([Label,'speed']);

%% cross correlation
if CrossCor==1
CrossCorr_Ting(velocity,Tablenames,n);
end