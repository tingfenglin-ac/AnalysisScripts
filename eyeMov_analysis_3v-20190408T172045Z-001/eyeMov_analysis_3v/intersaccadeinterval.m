for g=1:2;
    if g==1;
        temp.time=data.time_l
        temp.SaccExtremeIdx=data.SaccExtremeIdxL;
        temp.eye_raw=data.leye_raw;
    end
    if g==2;
        temp.time=data.time_r
        temp.SaccExtremeIdx=data.SaccExtremeIdxR;
        temp.eye_raw=data.reye_raw;
    end
    figure %trace overlap position calibration
    cc=jet(length(temp.SaccExtremeIdx(:,1))-1)
    SaccExtremeIdx=[];
        for i=1:length(temp.SaccExtremeIdx(:,1))-1;
            if temp.time(temp.SaccExtremeIdx(i,2))/60>5 & temp.time(temp.SaccExtremeIdx(i+1,1))/60<15
               SaccExtremeIdx(end+1,:)=[temp.SaccExtremeIdx(i,2) temp.SaccExtremeIdx(i+1,1)]
            end
        end
       scatter(temp.time(SaccExtremeIdx(:,1)),temp.time(SaccExtremeIdx(:,2))-temp.time(SaccExtremeIdx(:,1)));

end
        
                