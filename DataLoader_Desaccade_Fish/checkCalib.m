function []=checkCalib(fg,type)

%close all
if nargin<1
   fg=1;
end
if nargin<2
    type=3; % 1--> Patients; 2--> HealthyBA060; 3--->HealthyAA060;  4-->HealthyBaseline; 5-->HealthyBA010; 6-->HealthyAA010
end

%Eyes order
%1st RightEye, 2nd LeftEye
%Led movements directions
%rightWard, leftWard


switch type
    case 1
        dataDir='../../Alcohol_GazeHolding_Data/Alcohol_Subjs/dataAlcoholSubjs_raw/BAC_010/';
        [labelMat,label]=deal('_BA');
        [chosen,List]=xlsread('alcoholSubjs_List_010.xls');
        chosen=find(chosen(:,1));
    case 2
        dataDir='../../Alcohol_GazeHolding_Data/Alcohol_Subjs/dataAlcoholSubjs_raw/BAC_010/';
        [labelMat,label]=deal('_AA');
        [chosen,List]=xlsread('alcoholSubjs_List_010.xls');
        chosen=find(chosen(:,2));
    case 3
                dataDir='../../../Alcohol_GazeHolding_Data/Alcohol_Subjs/dataAlcoholSubjs_raw/BAC_010/';
        [labelMat,label]=deal('_BA');
        [chosen,List]=xlsread('alcoholSubjs_List_010.xls');
        disp([num2cell(1:length(List))',List])
        
        chosen=input('Select Subject you would like to check trials, insert the number:');
end


for k=1:length(chosen)
    
    idx=chosen(k);
    slowPhaseDir=dir([dataDir,List{idx},'/z*',label,'*']);
    slowPhaseDir(not([slowPhaseDir.isdir]))=[]; slowPhaseDir=deblank(slowPhaseDir(end).name); %the most recent data are used
    figure(fg);
    plotData([dataDir,List{idx},'/',slowPhaseDir,'/slowmov_lefthemifield.mat'],{[List{idx},'_{',label(2:end),'}'];'Left-Hemifield'},[1,3]); 
    
    plotData([dataDir,List{idx},'/',slowPhaseDir,'/slowmov_righthemifield.mat'],{[List{idx},'_{',label(2:end),'}'];'Right-Hemifield'},[2,4]);    
    %msgbox(List{idx});
    %showRawEyemov([dataDir,List{idx},'/',slowPhaseDir],[1,3,2,4])
    %pause
   %close all
    
end


end
function plotData(pathData,titleF,fg)

if exist(pathData)~=0
    load(pathData);
    
    
    for k=1:length(data)
        subplot(2,2,fg(k));
        plot([data(k).leye_pos],'b');hold on, plot(data(k).reye_pos,'r');
        hline(-20,'--k');hline(-40,'-.k');hline(20,'--k');hline(40,'-.k');
        ylim([-45,45]);
    end
    subplot(2,2,fg(1)); title(titleF)
    
    figureScreenSize(gcf,1,1)
end
end