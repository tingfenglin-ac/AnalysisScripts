for i=1:length(library.data(:,1))
    currentFolder = pwd;
    
    figure
    load([currentFolder(1:19),library.data{i,3}(end-8:end),library.data{i,2}]);
    subplot(2,1,1);
%     plot(data.time_l/60,data.leye_raw);
%     hold on
%     plot(data.time_l(data.SaccExtremeIdxL)/60,data.leye_raw(data.SaccExtremeIdxL),'o');
    
    %velocity
    idx2=[data.SaccExtremeIdxL(2:end,1);length(data.time_l(:,1))];
    IDX=[data.SaccExtremeIdxL(:,2) idx2]
    [output]=velocity(data.leye_raw,data.time_l,IDX,1);
    plot(data.time_l(IDX(:,1))/60,output,'o');
    
    subplot(2,1,2);
%     plot(data.time_r/60,data.reye_raw);
%     hold on
%     plot(data.time_r(data.SaccExtremeIdxR)/60,data.reye_raw(data.SaccExtremeIdxR),'o');
    
     %velocity
     idx2=[data.SaccExtremeIdxL(2:end,1);length(data.time_l(:,1))];
    IDX=[data.SaccExtremeIdxL(:,2) idx2]
    [output]=velocity(data.reye_raw,data.time_r,IDX,1);
    plot(data.time_r(IDX(:,1))/60,output,'o');
end