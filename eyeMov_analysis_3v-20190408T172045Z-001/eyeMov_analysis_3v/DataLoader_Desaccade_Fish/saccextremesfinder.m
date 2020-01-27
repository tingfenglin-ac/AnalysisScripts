function dstr=saccextremesfinder(S)
a=find(S(:,1)>0);
b=diff(a);
c=find(b>1);
dstr= zeros(size(c,1),2);
dstr(1,1)=a(1,1);
for i=1:size(c,1)-1
    dstr(i,2)=a(c(i),1);
    if c(i)+1==c(i+1)
        dstr(i+1,1)=a(c(i)+1,1)-1;  
    else
        dstr(i+1,1)=a(c(i)+1,1);  
    end
end
dstr(end,2)=a(c(end)); %Complete with end of second last saccade (i.e. compenase for the fact the the cicle is size(c)-1

% Add last saccade manually: 
% Since the program only look at S>1 (i.e. saccades) and
% look at differences, it will cause the last saccade to be the "end of
% search" and therefore will be skipped (nothing occurs after). Vector c is
% inded difference>1 between saccades points. Therfore the last saccade
% will only be listed as intial point and lost (all is point have distance
% of 1 since the saccade is continuous... and after there is no further
% saccade... i.e nothing
dstr(end+1,1)=a(c(end)+1); %
dstr(end,2)=a(end);

% Controlling Dstr
delta=dstr(:,2)-dstr(:,1);
index=find(delta<=0);
for i=1:size(index,1)
    dstr=[dstr(1:index(i)-(i-1)-1,:);dstr(index(i)-(i-1)+1:end,:)]; % Il "-(i-1)" serve perchè ad ogni elemento eliminato tutti 
                                                                  %le righe successive scendono di 1 quindi dopo aver eliminato 
                                                                  %la prima(cioè alla 2nd) bisogna togliere 1 (cioè i-1)
end
