
addpath('C:\Users\lab\Desktop\scripts\subroutine');

%% configure
StackOrOverlap=1 %1=stack; 2=overlap
extend=5; %plot 'extend' second before and after the rising phase





%% signal
all_velocity=[];
IDX=[];
SelectedFile={};
    FolderPath=1;
    while FolderPath~=0
        [FolderName,FolderPath] = uigetfile('*velocity.mat','Select velocity files', 'Multiselect', 'on');
        if FolderPath~=0
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
                    load([FolderPath,FN(1:11),'_ball.mat']);
                    
                %% align velocity                
  
                    signal=[];
                    signal = medfilt1(Import_data,15,'omitnan','truncate'); %median filtering
                    signal=signal./180;%1 alphabet is around 60 pixel large and 1 image has around 3 alphabets

                    step=round(length(time)/length(signal));
                    fr=find(abs(time-1)==min(abs(time-1)))
%                     MINdata=min(signal);
%                     MAXdata=max(signal);
%                     signal=((signal-MINdata)./(MAXdata-MINdata)); %normalization
                    
                    figure
                        plot(1:length(signal),signal);
                        hold on
                        plot(1:length(signal),derivate(signal,1));% acceleration
                        xticks(1:fr*5:length(signal));
                        legend('velocity','acceleration');                       
                        title('choose begining and end of runing');
                        rect(1,:) = getrect;
                        rect=floor(rect);
                    close
                
                    % merge data
                    if fnumber==1
                    InterFrameInterval=nanmean(derivate(time,1)); %inter-sample interval
                    ExtendIndex=floor(extend/InterFrameInterval);
                    end
                    
                    if rect(1)-ExtendIndex>0 && rect(1)+ExtendIndex<length(signal)
                        idx=(rect(1)-ExtendIndex:rect(1)+ExtendIndex)';
                        signal=signal(idx);
                        hold on
                        plot(time(1:step:step.*length(signal)),signal,'color',[0.5 0.5 1]);
                        all_velocity=[all_velocity signal];
                        IDX=[IDX idx];
                        SelectedFile=[SelectedFile;FN];
                    end

            end
        end
    end
    plot(time(1:step:step.*size(all_velocity,1)),nanmean(all_velocity,2),'color',[0 0 1],'linewidth',1.5);
    [file,path] = uiputfile('_speed.mat');
    save([path,file],'all_velocity','IDX','SelectedFile');
    
    