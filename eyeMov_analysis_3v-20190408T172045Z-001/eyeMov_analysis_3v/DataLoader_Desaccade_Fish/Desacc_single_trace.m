function [eyevel,index,time]=Desacc_single_trace(omega_r_filt,smpf,interp,k)
if nargin<3
   interp=1;
end
if nargin<4
k=0;
end
for z=1:2
    if (k==0)
        for i=1:min(size(omega_r_filt))
            figure(1000)
            plot(omega_r_filt(:,i))
            answer=questdlg('Are you interested in this eye channel','Channel select','Yes','No','No');
            if strcmp(answer,'Yes')
                k=i;close(1000)
                break;
            end
            close(1000)
        end
    end
    if (k==0)
       h=warndlg('I need to know what is the eye channel. I''ll ask it again once... then the program will fail!','Pay attention!') ;
       while ishandle(h)
         pause(2)
       end
    else
       break;
    end
end
if (k==0)
    return;
end


%answer=questdlg('Do you want to use automatic selected saccades?','Auto desaccading?','Yes','No','No');
omega_r_filt=omega_r_filt(:,k);
%if strcmp(answer,'Yes')
    [eyevel,time]=Interactive_desaccader(omega_r_filt,smpf,interp);
%     figure(1000)
%     plot(1/smpf:1/smpf:(length(omega_r_filt)/smpf), omega_r_filt,'r')
%     hold on
%     plot(time,eyevel)
%     answer='let me zoom';
%     while strcmp(answer,'let me zoom')
%     answer=questdlg('Are you satisfied with saccades removal?','Finishing desaccading?','Yes','No','let me zoom','No');
%     if strcmp(answer,'let me zoom')
%          set(gcf,'CurrentCharacter','c')
%          title('Zoom to the data, than hit a button to end zooming and go back to the question')
%          zoom on
%          while ~waitforbuttonpress
%          end
%          zoom off
%     end
%     end
%     close(1000)
%else
% if strcmp(answer,'No')
%     
%     %Manual correction
%     dstr.indices=prepare_data(cumsum(eyevel,1)/smpf,smpf,0,interp); 
%     [eyevel,time]=desacc_dataGB(eyevel,smpf,dstr.indices,0,interp);
%     close all
% end


if k==1
    index=3;%roll
elseif k==3
    index=1;%Yaw
else
    index=2;%Pitch
end