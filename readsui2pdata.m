addpath 'C:\Users\lab\Desktop\scripts\subroutine'

[FolderName,FolderPath] = uigetfile('Select data', 'Multiselect', 'on');

if iscell(FolderName)
    filezize=size(FolderName,2);
else
    filezize=1;
end

    
    F=readNPY([FolderPath,FolderName(1:11),'\suite2p\plane0\F.npy']);
    iscell = readNPY([FolderPath,FolderName(1:11),'\suite2p\plane0\iscell.npy']);
    spks=readNPY([FolderPath,FolderName(1:11),'\suite2p\plane0\spks.npy']);
    load([FolderPath,FolderName(1:11),'_ball.mat']);
    time=time(1:size(F,2))';

    

fsignal=F(find(iscell(:,1)),:);
spkssignal=spks(find(iscell(:,1)),:);
FBackCorr(fsignal(1,:),15);

for cellnumber=1:size(fsignal,1)
    figure
    [corrF]=FBackCorr(fsignal(cellnumber,:),15);
    plot(time,corrF+1);
    hold on
    plot(time,zscore(spkssignal(cellnumber,:))*0.2);
    
end
    
%% Air puff
ShowEvent; % if show stimulus
stim='Air puff';


%% figure
%single data

xlabel('Time (s)');
set(gcf,'color',[1,1,1]);
%    if StackOrOverlap==1
%    ylim([0 size(fsignal,1)+1]);
%     else
%        ylim([0 1]);
%    end
% yticks([1:size(all_signal,2)+2])
xlim([0 30])
    
