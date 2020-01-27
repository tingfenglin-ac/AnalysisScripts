%adaptation and amplitude estimated by diffmedian
function [output]=adap_amp_freq(medata,okrtime,okantime);
for i=1:length(medata.diffmedian(:,1));
    mdokr=[];
    mdokan=[];
    for k=1:length(medata.diffmedian{i,1});
        
        if medata.time{i,1}(k,1)>okrtime && medata.time{i,1}(k,1)<okantime;
            mdokr=[mdokr medata.diffmedian{i,1}(k,1)];
        else if medata.time{i,1}(k,1)>okantime;
                mdokan=[mdokan medata.diffmedian{i,1}(k,1)];
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