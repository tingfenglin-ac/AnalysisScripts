%adaptation and amplitude estimated by median
function [output]=adap_amp(medata,okrtime,okantime);
for i=1:length(medata.median(:,1));
    mdokr=[];
    mdokan=[];
    for k=1:length(medata.median{i,1});
        
        if medata.time{i,1}(k,1)>okrtime && medata.time{i,1}(k,1)<okantime;
            mdokr=[mdokr medata.median{i,1}(k,1)];
        else if medata.time{i,1}(k,1)>okantime;
                mdokan=[mdokan medata.median{i,1}(k,1)];
        end
        end
    end
    output.okramp(i,1)=(mdokr(1)+mdokr(2))/2;
    output.okrdrop(i,1)=((mdokr(1)+mdokr(2))/2)-((mdokr(end)+mdokr(end-1)+mdokr(end-2)+mdokr(end-3))/4);
    output.okanamp(i,1)=-(mdokan(3)+mdokan(4))/2;
    
    output.normaladapt(i,1)=output.okrdrop(i,1)/(output.okramp(i,1));
    output.normalokanamp(i,1)=-(output.okanamp(i,1))/( output.okramp(i,1));
    
end
end