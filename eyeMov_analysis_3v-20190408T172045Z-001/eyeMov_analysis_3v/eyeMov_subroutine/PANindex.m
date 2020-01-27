
function [temp]=PANindex(temp,dele);


for i=1:length(temp.SaccExtremeIdx);

if temp.time(max(temp.SaccExtremeIdx(:,2)))<=dele.e2;
    temp.SaccExtremeIdx(end+1,:)=[length(temp.time) length(temp.time)];
end
    
    
            dele.T1=temp.time(temp.SaccExtremeIdx(i,1));%make the floowing function shorter
            dele.T2=temp.time(temp.SaccExtremeIdx(i,2));%make the floowing function shorter
            % first 5 minutes of dark
            if dele.T2+1.5 < dele.b1 %if dele.T2 is 1.5 second before the stimulus
                if temp.time(temp.SaccExtremeIdx(i+1,1))>dele.b1;
                    temp.SphIdx_d1(end+1,:)=[temp.SaccExtremeIdx(i,2),max(find(temp.time<dele.b1))];
                else
                temp.SphIdx_d1(end+1,:)=[temp.SaccExtremeIdx(i,2),temp.SaccExtremeIdx(i+1,1)];
                end
            end

            % second 5 minutes of dark
            if dele.T2>dele.e1 & dele.T2+1.5<dele.b2  %if dele.T2 is 1.5 second before the second stimulus
                    if temp.time(temp.SaccExtremeIdx(i+1,1))>dele.b2;
                        temp.SphIdx_d2(end+1,:)=[temp.SaccExtremeIdx(i,2),max(find(temp.time<dele.b2))];
                    else
                    temp.SphIdx_d2(end+1,:)=[temp.SaccExtremeIdx(i,2),temp.SaccExtremeIdx(i+1,1)];
                    end
            end

            % third 5 minutes of dark
            if dele.T2>dele.e2 %if dele.T2 is after the previous stimulus
                if i==length(temp.SaccExtremeIdx(:,1));
                    temp.SphIdx_d3(end+1,:)=[temp.SaccExtremeIdx(i,2),length(temp.time)];
                else
                temp.SphIdx_d3(end+1,:)=[temp.SaccExtremeIdx(i,2),temp.SaccExtremeIdx(i+1,1)];
                end
            end


            %%first 20minute of positive
            if dele.T1>dele.b1 & dele.T2<dele.e1;
                    if mod(ceil((dele.T1-dele.b1)/dele.dur),2)==1; %dele.T1 is in positive stimuli (/dele.dur=odd number)
                        if and((dele.T1-dele.b1)-floor((dele.T1-dele.b1)/dele.dur)*dele.dur>=2,temp.time(temp.SaccExtremeIdx(i-1,2))-dele.b1<floor((dele.T1-dele.b1)/dele.dur)*dele.dur); % if dele.T1 is 2 second after the beggining of pos stimuli & the previous dele.T2<dele.b1 or previous dele.T2 is dele.during neg stimuli
                            temp.SphIdx_p1(end+1,:)=[find(temp.time>(floor((dele.T1-dele.b1)/dele.dur)*dele.dur+dele.b1+1),1),temp.SaccExtremeIdx(i,1)];
                        end
                    end
                    if mod(ceil((dele.T2-dele.b1)/dele.dur),2)==1; %dele.T2 is in positive stimuili (/dele.dur=odd number)
                        if and(ceil((dele.T2-dele.b1)/dele.dur)*dele.dur-(dele.T2-dele.b1)>=1.5,temp.time(temp.SaccExtremeIdx(i+1,1))-dele.b1>ceil((dele.T2-dele.b1)/dele.dur)*dele.dur);% if dele.T1 is 1.5 second before the end of pos stimuli & if the next dele.T1>dele.e1 or next dele.T1 is dele.during neg stimuli
                            temp.SphIdx_p1(end+1,:)=[temp.SaccExtremeIdx(i,2),max(find(temp.time<(ceil((dele.T2-dele.b1)/dele.dur)*dele.dur+dele.b1-0.5)))];
                        end
                        if and((dele.T2-dele.b1)>=floor((dele.T2-dele.b1)/dele.dur)*dele.dur,temp.time(temp.SaccExtremeIdx(i+1,1))-dele.b1<=ceil((dele.T2-dele.b1)/dele.dur)*dele.dur);% if dele.T2 and next dele.T1 are both in the same pos stimulus phaase
                            temp.SphIdx_p1(end+1,:)=[temp.SaccExtremeIdx(i,2),temp.SaccExtremeIdx(i+1,1)];
                        end
                    end
                    if mod(ceil((dele.T2-dele.b1)/dele.dur),2)==0 & temp.time(temp.SaccExtremeIdx(i+1,1))-dele.b1>(ceil((dele.T2-dele.b1)/dele.dur)+1)*dele.dur & dele.T2<(dele.e1-dele.dur); %dele.T2 is in neg stimuili (/dele.dur=even number) & end of dele.T2 slow phase is greater than next neg stimuli
                        temp.SphIdx_p1(end+1,:)=[find(temp.time>(ceil((dele.T2-dele.b1)/dele.dur)*dele.dur+dele.b1+1),1),max(find(temp.time<(ceil((dele.T2-dele.b1)/dele.dur+1)*dele.dur+dele.b1-1)))];
                    end
        %first 20minute of negative
                if mod(ceil((dele.T1-dele.b1)/dele.dur),2)==0; %dele.T1 is in negtive stimuli (/dele.dur=even number)
                    if and((dele.T1-dele.b1)-floor((dele.T1-dele.b1)/dele.dur)*dele.dur>=2,temp.time(temp.SaccExtremeIdx(i-1,2))-dele.b1<floor((dele.T1-dele.b1)/dele.dur)*dele.dur); % if dele.T1 is 2 second after the beggining of pos stimuli & the previous dele.T2<dele.b1 or previous dele.T2 is dele.during neg stimuli
                        temp.SphIdx_n1(end+1,:)=[find(temp.time>(floor((dele.T1-dele.b1)/dele.dur)*dele.dur+dele.b1+1),1),temp.SaccExtremeIdx(i,1)];
                    end
                end
                if mod(ceil((dele.T2-dele.b1)/dele.dur),2)==0; %dele.T2 is in negative stimuili (/dele.dur=even number)
                    if and(ceil((dele.T2-dele.b1)/dele.dur)*dele.dur-(dele.T2-dele.b1)>=1.5,temp.time(temp.SaccExtremeIdx(i+1,1))-dele.b1>ceil((dele.T2-dele.b1)/dele.dur)*dele.dur);% if dele.T1 is 1.5 second before the end of pos stimuli & if the next dele.T1>dele.e1 or next dele.T1 is dele.during neg stimuli
                        temp.SphIdx_n1(end+1,:)=[temp.SaccExtremeIdx(i,2),max(find(temp.time<(ceil((dele.T2-dele.b1)/dele.dur)*dele.dur+dele.b1-0.5)))];
                    end
                    if and((dele.T2-dele.b1)>=floor((dele.T2-dele.b1)/dele.dur)*dele.dur,temp.time(temp.SaccExtremeIdx(i+1,1))-dele.b1<=ceil((dele.T2-dele.b1)/dele.dur)*dele.dur);% if dele.T2 and next dele.T1 are both in the same pos stimulus phaase
                        temp.SphIdx_n1(end+1,:)=[temp.SaccExtremeIdx(i,2),temp.SaccExtremeIdx(i+1,1)];
                    end
                end
                if mod(ceil((dele.T2-dele.b1)/dele.dur),2)==1 & temp.time(temp.SaccExtremeIdx(i+1,1))-dele.b1>(ceil((dele.T2-dele.b1)/dele.dur)+1)*dele.dur & dele.T2<(dele.e1-dele.dur); %dele.T2 is in pos stimuili (/dele.dur=even number) & end of dele.T2 slow phase is greater than next pos stimuli
                    temp.SphIdx_n1(end+1,:)=[find(temp.time>(ceil((dele.T2-dele.b1)/dele.dur)*dele.dur+dele.b1+1),1),max(find(temp.time<(ceil((dele.T2-dele.b1)/dele.dur+1)*dele.dur+dele.b1-1)))];
                end        
            end

        %p2 and n2
            %%first 20minute of positive
            if dele.T1>dele.b2 & dele.T2<dele.e2; 
                if mod(ceil((dele.T1-dele.b2)/dele.dur),2)==1; %dele.T1 is in positive stimuli (/dele.dur=odd number)
                    if and((dele.T1-dele.b2)-floor((dele.T1-dele.b2)/dele.dur)*dele.dur>=2,temp.time(temp.SaccExtremeIdx(i-1,2))-dele.b2<floor((dele.T1-dele.b2)/dele.dur)*dele.dur); % if dele.T1 is 2 second after the beggining of pos stimuli & the previous dele.T2<dele.b2 or previous dele.T2 is dele.during neg stimuli
                        temp.SphIdx_p2(end+1,:)=[find(temp.time>(floor((dele.T1-dele.b2)/dele.dur)*dele.dur+dele.b2+1),1),temp.SaccExtremeIdx(i,1)];
                    end
                end
                if mod(ceil((dele.T2-dele.b2)/dele.dur),2)==1; %dele.T2 is in positive stimuili (/dele.dur=odd number)
                    if and(ceil((dele.T2-dele.b2)/dele.dur)*dele.dur-(dele.T2-dele.b2)>=1.5,temp.time(temp.SaccExtremeIdx(i+1,1))-dele.b2>ceil((dele.T2-dele.b2)/dele.dur)*dele.dur);% if dele.T1 is 1.5 second before the end of pos stimuli & if the next dele.T1>dele.e1 or next dele.T1 is dele.during neg stimuli
                        temp.SphIdx_p2(end+1,:)=[temp.SaccExtremeIdx(i,2),max(find(temp.time<(ceil((dele.T2-dele.b2)/dele.dur)*dele.dur+dele.b2-0.5)))];
                    end
                    if and((dele.T2-dele.b2)>=floor((dele.T2-dele.b2)/dele.dur)*dele.dur,temp.time(temp.SaccExtremeIdx(i+1,1))-dele.b2<=ceil((dele.T2-dele.b2)/dele.dur)*dele.dur);% if dele.T2 and next dele.T1 are both in the same pos stimulus phaase
                        temp.SphIdx_p2(end+1,:)=[temp.SaccExtremeIdx(i,2),temp.SaccExtremeIdx(i+1,1)];
                    end
                end
                if mod(ceil((dele.T2-dele.b2)/dele.dur),2)==0 & temp.time(temp.SaccExtremeIdx(i+1,1))-dele.b2>(ceil((dele.T2-dele.b2)/dele.dur)+1)*dele.dur & dele.T2<(dele.e1-dele.dur); %dele.T2 is in neg stimuili (/dele.dur=even number) & end of dele.T2 slow phase is greater than next neg stimuli
                    temp.SphIdx_p2(end+1,:)=[find(temp.time>(ceil((dele.T2-dele.b2)/dele.dur)*dele.dur+dele.b2+1),1),max(find(temp.time<(ceil((dele.T2-dele.b2)/dele.dur+1)*dele.dur+dele.b2-1)))];
                end        


        %%first 20minute of negative
                if mod(ceil((dele.T1-dele.b2)/dele.dur),2)==0; %dele.T1 is in negtive stimuli (/dele.dur=even number)
                    if and((dele.T1-dele.b2)-floor((dele.T1-dele.b2)/dele.dur)*dele.dur>=2,temp.time(temp.SaccExtremeIdx(i-1,2))-dele.b2<floor((dele.T1-dele.b2)/dele.dur)*dele.dur); % if dele.T1 is 2 second after the beggining of pos stimuli & the previous dele.T2<dele.b2 or previous dele.T2 is dele.during neg stimuli
                        temp.SphIdx_n2(end+1,:)=[find(temp.time>(floor((dele.T1-dele.b2)/dele.dur)*dele.dur+dele.b2+1),1),temp.SaccExtremeIdx(i,1)];
                    end
                end
                if mod(ceil((dele.T2-dele.b2)/dele.dur),2)==0; %dele.T2 is in negative stimuili (/dele.dur=even number)
                    if and(ceil((dele.T2-dele.b2)/dele.dur)*dele.dur-(dele.T2-dele.b2)>=1.5,temp.time(temp.SaccExtremeIdx(i+1,1))-dele.b2>ceil((dele.T2-dele.b2)/dele.dur)*dele.dur);% if dele.T1 is 1.5 second before the end of pos stimuli & if the next dele.T1>dele.e1 or next dele.T1 is dele.during neg stimuli
                        temp.SphIdx_n2(end+1,:)=[temp.SaccExtremeIdx(i,2),max(find(temp.time<(ceil((dele.T2-dele.b2)/dele.dur)*dele.dur+dele.b2-0.5)))];
                    end
                    if and((dele.T2-dele.b2)>=floor((dele.T2-dele.b2)/dele.dur)*dele.dur,temp.time(temp.SaccExtremeIdx(i+1,1))-dele.b2<=ceil((dele.T2-dele.b2)/dele.dur)*dele.dur);% if dele.T2 and next dele.T1 are both in the same pos stimulus phaase
                        temp.SphIdx_n2(end+1,:)=[temp.SaccExtremeIdx(i,2),temp.SaccExtremeIdx(i+1,1)];
                    end
                end
                if mod(ceil((dele.T2-dele.b2)/dele.dur),2)==1 & temp.time(temp.SaccExtremeIdx(i+1,1))-dele.b2>(ceil((dele.T2-dele.b2)/dele.dur)+1)*dele.dur & dele.T2<(dele.e1-dele.dur); %dele.T2 is in neg stimuili (/dele.dur=even number) & end of dele.T2 slow phase is greater than next neg stimuli
                    temp.SphIdx_n2(end+1,:)=[find(temp.time>(ceil((dele.T2-dele.b2)/dele.dur)*dele.dur+dele.b2+1),1),max(find(temp.time<(ceil((dele.T2-dele.b2)/dele.dur+1)*dele.dur+dele.b2-1)))];
                end        
            end
%     end        
end

  