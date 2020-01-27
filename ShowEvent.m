function [Stim_signal]=ShowEvent(varargin)
p = mfilename('fullpath');
addpath([p(1:end-9),'subroutine'])

%% varagin
if length(varargin)==0
    Train_N=1; %train number 
end
if length(varargin)==2
    Train_N=varargin{1}; %train number
    Pulse_N=varargin{2}; %pulse number
end
    
%% find file path and load file
    currentFolder = pwd;
    [FolderName,FolderPath] = uigetfile(currentFolder,'*.mat');
    load([FolderPath,FolderName(1:11),'.mat']);

%% load time stamps corresponding to frames
% load([FolderPath,FolderName(1:end-4),'_ball.mat']);


%% Index of stimulus
NFrame = info.config.frames; %Amount of frames
Rise = info.frame(1:2:end); %rising edge of TTL signal
Fall = info.frame(2:2:end)+1; %falling edge of TTL signal


if Fall(end)<Rise(end)
    Fall(end+1)=NFrame;
end

[Stim_signal,Stim_idx]=Edge2Signal(NFrame,Rise,Fall);

%% plot
%fill colors for different stimulation fields
if Train_N>1
    
    color=[0 0 1;0 1 1;0 1 0;1 245/255 104/255;242/255 108/255 79/255];
    if Train_N>5
    color=vertcat(color,rand(Train_N-5,3));
    end
    
    for t=1:Train_N
        NCycle=floor(length(Rise)/(Pulse_N*Train_N)); %number of complete cycles
        NTrain=floor(length(Rise)/Pulse_N); %number of complete train
        Train{t}.Rise=[];
        Train{t}.Fall=[];
        
        for i=1:NCycle %complete cycles; i=cycle
        Train{t}.Rise=vertcat(Train{t}.Rise,...
            Rise((i-1)*(Pulse_N*Train_N)+(t-1)*Pulse_N+(1:Pulse_N)));
        Train{t}.Fall=vertcat(Train{t}.Fall,...
            Fall((i-1)*(Pulse_N*Train_N)+(t-1)*Pulse_N+(1:Pulse_N)));
        end
        
        if NTrain-NCycle*Train_N>=t %uncomplete cycles while complete train
            Train{t}.Rise=vertcat(Train{t}.Rise,...
                Rise(NCycle*(Pulse_N*Train_N)+(t-1)*Pulse_N+(1:Pulse_N)));
            Train{t}.Fall=vertcat(Train{t}.Fall,...
                Fall(NCycle*(Pulse_N*Train_N)+(t-1)*Pulse_N+(1:Pulse_N)));
        end
        
        if ceil(length(Rise)/Pulse_N)~=floor(length(Rise)/Pulse_N) &...
                ceil(length(Rise)/Pulse_N)-NCycle*Train_N==t % uncomplish train
            
            Train{t}.Rise=vertcat(Train{t}.Rise,...
                Rise(NCycle*(Pulse_N*Train_N)+(t-1)*Pulse_N+1:end));
            Train{t}.Fall=vertcat(Train{t}.Fall,...
                Fall(NCycle*(Pulse_N*Train_N)+(t-1)*Pulse_N+1:end));
        end
        
        [signal,idx]=Edge2Signal(NFrame,Train{t}.Rise,Train{t}.Fall);

    end
end
  
    


    