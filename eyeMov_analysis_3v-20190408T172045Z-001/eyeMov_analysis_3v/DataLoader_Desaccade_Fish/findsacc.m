function [sacidx]=findsacc(eyevel,thr)
%Simple saccade finder
%SR 2002
%SR 2004 modified if found peak is sooner than 50th sample or closer to the
%end than 50 samples

i=fpeak(eyevel,20,thr,0,0);
if ~isempty(i) 
   pkidx=i(1);
else
   pkidx=1;
   sacidx=[];
   return
end
pkidx=round(pkidx);
svel=sgolayfilt(eyevel,3,21); %Smooth velocity with savitsky-golay

srchint=ceil(min([pkidx-1,50,size(eyevel,1)-pkidx-1])); %Search interval
k=fpeak(eyevel(pkidx-srchint:pkidx),5,2,0,0);
j=fpeak(eyevel(pkidx:pkidx+srchint),5,2,0,0);

if ~isempty(k)
    startidx=pkidx-srchint-1+k(end);
else
    preslope=abs(mean(svel(pkidx-8:pkidx-3))); %mean slope before peak
    startarr=find(abs(svel(1:pkidx))<(preslope/2)); %Get the last valid before peak
    if ~isempty(startarr)
        startidx=startarr(end);
    else 
        startidx=1;
    end
end

if ~isempty(j)
    endidx=pkidx+j(1)-1;
else
    postslope=abs(mean(svel(pkidx+3:pkidx+8))); %mean slope after peak
    endarr=find(abs(svel(pkidx:end))<(postslope/2)); %Get the first valid after peak
    if ~isempty(endarr)
        endidx=pkidx+endarr(1)+1;
    else 
        endidx=1;
    end
end


sacidx=[startidx,pkidx,endidx]; %Return values
