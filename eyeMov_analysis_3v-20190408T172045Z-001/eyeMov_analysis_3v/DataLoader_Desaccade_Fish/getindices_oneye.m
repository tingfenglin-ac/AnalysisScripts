function out=getindices(eyevel,stimonidx,guess)
%getindices(rev,lev,vertical,stimonidx,guess)  Interactive selection of saccades
%SR 2002
if nargin < 2
    stimonidx=0;
end
if nargin <3
    guess=findsacc(eyevel,20);%[1,length(eyevel)]
end
for i =1:1% 1 for Only one eye or 2 to get both    %Right and left eye separately
    figh=figure;
    but='n';
    if i==1 
        plot(eyevel,'r')
        hold on;
        legend('REV')
        %plot(rev,'m');
        if stimonidx>0
            plot([stimonidx;stimonidx],[eyevel(stimonidx)-3;eyevel(stimonidx)+3],'r') %Stimulus onset
            %*Plot saccade indices*%
        end
        plot(guess(1),eyevel(guess(1)),'k+') %Use beginning and end of trial
        plot(guess(end),eyevel(guess(end)),'k+')
        yax=eyevel;
    end
    indexes=guess([1 3]);
    title('Select beginning and end of saccades. <a> moves cursor left <s> moves cursor right <x> exits');
    obj={};
    todel=0;
    while(lower(but)~='x' & but ~= 3)
        [xx,yy,but]=ginput(1);
        xx=fix(xx);
        %Retrieve marker handles from the figure
        obj={findobj(figh,'Marker','+'), get(findobj(figh,'Marker','+'),'XData')};%Cell array of marker objects handles and xdata
        if todel==0
            todel=2;
        end
        % left button - add a point
        if(but==1) %Left mouse click: move a marker t where I clicked
            dist=abs(indexes-xx);	%Distances of the click from the previous indices
            todel=find(dist==min(dist));	%Get the closest mark (using indices)
            %obj={findobj(figh,'Marker','+'), get(findobj(figh,'Marker','+'),'XData')};%Cell array of marker objects handles and xdata
            for j=1:size(obj{1},1) %First element is the hndl
                if obj{2}{j}==(indexes(todel)) %Find the object to delete by comparing the XData field
                    delete(obj{1}(j));
                end
            end
            indexes(todel)=xx;
        elseif (lower(but)=='a')  %Move to left
            for j=1:size(obj{1},1)
                if obj{2}{j}==(indexes(todel)) %Find the object to delete
                    delete(obj{1}(j));
                end
            end
            xx=indexes(todel)-10;
            indexes(todel)=xx;
        elseif (lower(but)=='s')  %Move to right
            for j=1:size(obj{1},1)
                if obj{2}{j}==(indexes(todel)) %Find the object to delete
                    delete(obj{1}(j));
                end
            end
            xx=indexes(todel)+10;
            %plot(xx,yax(xx),'k+');
            indexes(todel)=xx;
        end
        plot(xx,yax(xx),'k+');
    end
        out.sacidxs(1)=indexes(1);
        out.sacidxs(2)=indexes(2);
    close(figh)
end
