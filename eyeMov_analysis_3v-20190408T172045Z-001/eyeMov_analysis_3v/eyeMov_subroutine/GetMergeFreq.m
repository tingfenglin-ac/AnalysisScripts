function [MergeDATA,time]=GetMergeFreq(MergeDATA,bin)
lr='lr';
for j=1:2
    for d=1:length(MergeDATA);
        eye_raw=MergeDATA(d).([lr(j),'eye_raw']);
        IDX=MergeDATA(d).(['SaccExtremeIdx',upper(lr(j))]);
        TIME=MergeDATA(d).(['time_',lr(j)]);
        
        EyeDirect=eye_raw(IDX(:,2))-eye_raw(IDX(:,1));%direction of saccades
        
        lowBound=0:bin:bin*floor(TIME(end)/bin);
        highBound=0+bin:bin:bin*ceil(TIME(end)/bin);
        lowBoundmat=repmat(lowBound,length(IDX),1);
        highBoundmat=repmat(highBound,length(IDX),1);
        
        TIME=TIME(IDX(:,2));
        TIMEmat=repmat(TIME,1,length(lowBound));
        EyeDirectmat=repmat(EyeDirect,1,length(lowBound));
        
        EyeDirectmat(TIMEmat<lowBoundmat)=nan;
        EyeDirectmat(TIMEmat>highBoundmat)=nan;
        
        
        PosFreq=nansum(EyeDirectmat>0)';
        NegFreq=nansum(EyeDirectmat<0)';
        DiffFreq=NegFreq-PosFreq;
       
        time=lowBound'+0.5*bin;
        
        
        
        
        
        
        
        
        
        
%         Freq=1./(TIME(IDX(2:end,2))-TIME(IDX(1:end-1,2)));
%         
%         PosFreq=Freq(EyeDirect(2:end)>0);
%         NegFreq=Freq(EyeDirect(2:end)<0);
        
%         idx=IDX(2:end,2);
%         PosFreqIDX=idx(EyeDirect(2:end)>0);
%         NegFreqIDX=idx(EyeDirect(2:end)<0);
% %         plot(TIME(PosFreqIDX),PosFreq,'ro')
% %         hold on
% %         plot(TIME(NegFreqIDX),NegFreq,'bo')
%         
        MergeDATA(d).([lr(j),'PosFreq'])=PosFreq;
        MergeDATA(d).([lr(j),'NegFreq'])=NegFreq;
        MergeDATA(d).([lr(j),'DiffFreq'])=DiffFreq;
%         MergeDATA(d).([lr(j),'NegFreqIDX'])=NegFreqIDX;
    end
end
end