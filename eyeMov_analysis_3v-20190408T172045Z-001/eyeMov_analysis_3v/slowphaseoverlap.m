% data=ans;
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
    
    temp.eye_dydt = derivate(temp.eye_raw,1/40);
    [slop]=slop_v(temp.time,temp.eye_raw,temp.SaccExtremeIdx,1);
    figure %trace overlap position calibration
    
    subplot(3,1,1)
    plot(temp.time/60,temp.eye_raw,'k');
    xlim([5 15]);
    subplot(3,2,3)
    plot(temp.time/60,temp.eye_raw,'k');
    xlim([5 5.5]);
    subplot(3,2,4)
    plot(temp.time/60,temp.eye_raw,'k');
    xlim([14.5 15]);
    
    
    
    
    
    
    
    SaccExtremeIdx=[];
    
    
    
    
    cc=jet(length(temp.SaccExtremeIdx(:,1))-1);
        for i=length(temp.SaccExtremeIdx(:,1))-1:-1:1;
            
           
            if temp.time(temp.SaccExtremeIdx(i,2))/60>5 & temp.time(temp.SaccExtremeIdx(i+1,1))/60<15;
                subplot(3,1,1);
                hold on
                plot((temp.time(temp.SaccExtremeIdx(i,2):temp.SaccExtremeIdx(i+1,1)))/60,temp.eye_raw(temp.SaccExtremeIdx(i,2):temp.SaccExtremeIdx(i+1,1)),'color',cc(i,:));
                if g==1
                    title('left eye position');
                else
                    title('right eye position');
                end
                xlim([5 15]);
                
                subplot(3,2,3);
                hold on
                plot((temp.time(temp.SaccExtremeIdx(i,2):temp.SaccExtremeIdx(i+1,1)))/60,temp.eye_raw(temp.SaccExtremeIdx(i,2):temp.SaccExtremeIdx(i+1,1)),'color',cc(i,:));
                xlim([5 5.5]);
                   
                subplot(3,2,4);
                hold on
                plot((temp.time(temp.SaccExtremeIdx(i,2):temp.SaccExtremeIdx(i+1,1)))/60,temp.eye_raw(temp.SaccExtremeIdx(i,2):temp.SaccExtremeIdx(i+1,1)),'color',cc(i,:));
                xlim([14.5 15]);
                   
                
                
                subplot(3,3,7);
                hold on
                plot((temp.time(temp.SaccExtremeIdx(i,2):temp.SaccExtremeIdx(i+1,1)))-temp.time(temp.SaccExtremeIdx(i,2)-1),temp.eye_raw(temp.SaccExtremeIdx(i,2):temp.SaccExtremeIdx(i+1,1)),'color',cc(i,:));
                
                
                
                subplot(3,3,8);
                hold on
                plot((temp.time(temp.SaccExtremeIdx(i,2):temp.SaccExtremeIdx(i+1,1)))-temp.time(temp.SaccExtremeIdx(i,2)-1),(temp.eye_raw(temp.SaccExtremeIdx(i,2):temp.SaccExtremeIdx(i+1,1)))-min(temp.eye_raw(temp.SaccExtremeIdx(i,2):temp.SaccExtremeIdx(i+1,1))),'color',cc(i,:));
                if g==1
                    title('left eye position alignment');
                else
                    title('right eye position alignment');
                end
                
                
                subplot(3,3,9);
                hold on
                plot((temp.time(temp.SaccExtremeIdx(i,2):temp.SaccExtremeIdx(i+1,1)))-temp.time(temp.SaccExtremeIdx(i,2)-1),temp.eye_dydt(temp.SaccExtremeIdx(i,2):temp.SaccExtremeIdx(i+1,1)),'color',cc(i,:));
                if g==1
                    title('left eye velocity');
                else
                    title('right eye velocity');
                end
                
            end
        end

for n=7:9;
    subplot(3,3,n);
    limit=max(xlim);
    xlim([-1 limit+1]);
end
        
figure
% interIdx=temp.time(temp.SaccExtremeIdx(:,2))/60>5 & temp.time(temp.SaccExtremeIdx(:,1))/60<15;
% scatter(temp.time(temp.SaccExtremeIdx(interIdx,2)),100/(temp.time(SaccExtremeIdx(end,2))-temp.time(SaccExtremeIdx(end,1))),'k');

inter_slop=[];
for i=1:length(temp.SaccExtremeIdx(:,1))-1;
    if temp.time(temp.SaccExtremeIdx(i,2))/60>5 & temp.time(temp.SaccExtremeIdx(i+1,1))/60<15;
        SaccExtremeIdx(end+1,:)=[temp.SaccExtremeIdx(i,2) temp.SaccExtremeIdx(i+1,1)];
        inter_slop(end+1)=slop(i);
    end
end
freq=1./(temp.time(SaccExtremeIdx(:,2))-temp.time(SaccExtremeIdx(:,1)));
scatter(temp.time(SaccExtremeIdx(:,1)),freq./freq(1),'k');
hold on;
scatter(temp.time(SaccExtremeIdx(:,1)),inter_slop./inter_slop(1),'r');
%              scatter(slop(i),1/(temp.time(SaccExtremeIdx(end,2))-temp.time(SaccExtremeIdx(end,1))),36,cc(i,:));
legend('normalized frequency','normalized velocity');
if g==1
    title('left eye inter fast phase interval');
else
    title('right eye inter fast phase interval');
end
end
        

                
                