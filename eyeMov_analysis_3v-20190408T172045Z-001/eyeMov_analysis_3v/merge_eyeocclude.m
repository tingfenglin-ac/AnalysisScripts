clear data i g k n del temp occlu_side
% left eye occlusion=1; right eye occlusion=2
occlu_side=2;
% If need to merge new data, put 1, to make picture only put any number
del.merge=0;

% [fileName,pathName] = uigetfile('*.mat');
% load([pathName,fileName]);
if del.merge==1
simuPAN;
end


% 
% occlu_eye=[];
% occlu_eye.occlu=[];
% occlu_eye.health=[];



for g=1:2
    if g==1;
        if del.merge==1
            if occlu_side==1
            temp=PAN.leye;
            else
            temp=PAN.reye;
            temp.eye_raw=-temp.eye_raw;
            end
            
        occlu_eye.occlu=[occlu_eye.occlu;{[fileName]},{temp.eye_raw},{temp.time},{temp.SaccExtremeIdx},{temp.SphIdx_d1},{temp.SphIdx_d2},{temp.SphIdx_d3},{temp.SphIdx_p1},{temp.SphIdx_n1},{temp.SphIdx_p2},{temp.SphIdx_n2},];
        end
            
        temp=occlu_eye.occlu;
    else
        if del.merge==1
            if occlu_side==1
            temp=PAN.reye;
            else
            temp=PAN.leye;
            temp.eye_raw=-temp.eye_raw;
            end
        
        occlu_eye.health=[occlu_eye.health;{[fileName]},{temp.eye_raw},{temp.time},...
            {temp.SaccExtremeIdx},{temp.SphIdx_d1},{temp.SphIdx_d2},{temp.SphIdx_d3},{temp.SphIdx_p1},{temp.SphIdx_n1},{temp.SphIdx_p2},{temp.SphIdx_n2},];
            
        end

        temp=occlu_eye.health;
    end
        
        
        
        
        
        
        
        
        n=length(temp(:,1));
        FigHandle = figure('Position', [0, 0, 1000, 4000]);
        for i=1:n
        subplot(n,3,3*i-2);
        plot(temp{i,3},temp{i,2});
        
        subplot(n,3,3*i-1);
        plot(temp{i,3},derivate(temp{i,2},1/40));
        
        [del.vel_d1]=velocity(temp{i,2},temp{i,3},temp{i,5},1);
        [del.vel_d2]=velocity(temp{i,2},temp{i,3},temp{i,6},1);
        [del.vel_d3]=velocity(temp{i,2},temp{i,3},temp{i,7},1);
        [del.vel_p1]=velocity(temp{i,2},temp{i,3},temp{i,8},1);
        [del.vel_n1]=velocity(temp{i,2},temp{i,3},temp{i,9},1);
        [del.vel_p2]=velocity(temp{i,2},temp{i,3},temp{i,10},1);
        [del.vel_n2]=velocity(temp{i,2},temp{i,3},temp{i,11},1);
        
        subplot(n,3,3*i);
        
        col=[5,6,7,8,9,10,11];
        proto={'d1','d2','d3','p1','n1','p2','n2'};
        idx=cell(1,length(col));
        for k=1:length(col);
            if ~isempty(temp{i,col(k)})  ;
                idx{k}=1;
            end
            vel=del.(['vel_',proto{k}]);
            idx_neg=vel<0;
            SphIdx=temp{i,col(k)};
            hold on
            scatter(temp{i,3}(SphIdx(~idx_neg,1))/60,abs(vel(~idx_neg)),'b');
            scatter(temp{i,3}(SphIdx(idx_neg,1))/60,abs(vel(idx_neg)),'r');
            
        end
        
        dele.ylebel=median(abs(del.vel_p1))+10;
protocol=[0,5,6,7,8,9,10,11];

for i=2:length(protocol)
if mod(i,2)==0;
    plot([protocol(i-1) protocol(i)],[dele.ylebel dele.ylebel],'k');
else
    plot([protocol(i-1) protocol(i)],[dele.ylebel dele.ylebel],'k:');
end
end
        
%         if median(del.vel_p1)>0;
%             scatter(temp{i,3}(temp{i,5}(:,idx{1}))/60,abs(del.vel_d1),'k');
%             hold on
%             scatter(temp{i,3}(temp{i,6}(:,idx{2}))/60,abs(del.vel_d2),'k');
%             scatter(temp{i,3}(temp{i,7}(:,idx{3}))/60,abs(del.vel_d3),'k');
%             scatter(temp{i,3}(temp{i,8}(:,idx{4}))/60,abs(del.vel_p1),'B');
%             scatter(temp{i,3}(temp{i,9}(:,idx{5}))/60,abs(del.vel_n1),'r');
%             scatter(temp{i,3}(temp{i,10}(:,idx{6}))/60,abs(del.vel_p2),'B');
%             scatter(temp{i,3}(temp{i,11}(:,idx{7}))/60,abs(del.vel_n2),'r');
%             
%         else
%            scatter(temp{i,3}(temp{i,5}(:,idx{1}))/60,abs(del.vel_d1),'k');
%             hold on
%             scatter(temp{i,3}(temp{i,6}(:,idx{2}))/60,abs(del.vel_d2),'k');
%             scatter(temp{i,3}(temp{i,7}(:,idx{3}))/60,abs(del.vel_d3),'k');
%             scatter(temp{i,3}(temp{i,8}(:,idx{4}))/60,abs(del.vel_p1),'r');
%             scatter(temp{i,3}(temp{i,9}(:,idx{5}))/60,abs(del.vel_n1),'b');
%             scatter(temp{i,3}(temp{i,10}(:,idx{6}))/60,abs(del.vel_p2),'r');
%             scatter(temp{i,3}(temp{i,11}(:,idx{7}))/60,abs(del.vel_n2),'b');
%         end
%         
%         test={'p1','n1','p2','n2','d1','d2','d3'};
% idx=cell(1,length(test));
% for k=1:length(test);
%     vel=temp.(['vel_',test{k}]);
%     SphIdx=temp.(['SphIdx_',test{k}]);
%     if ~isempty(vel)  ;
%         idx{k}=1;
%     end
%     hold on
%     idx_neg=vel<0
%     scatter(temp.time(SphIdx(idx_neg,idx{k}))/60,abs(vel(idx_neg)),'r');
%     scatter(temp.time(SphIdx(~idx_neg,idx{k}))/60,abs(vel(~idx_neg)),'b');
%     clear vel SphIdx
% end


            
            
            
        
        end
        

        

end

clear i g k n del temp occlu_side