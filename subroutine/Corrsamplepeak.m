function [Corrsamlepeak]=Corrsamplepeak(VelGOF,MergeDATA)
    lOKANpeak=[];
    rOKANpeak=[];
    duration=[];
    adapt=[];
for i=1:length(fieldnames(VelGOF))
    Fname=fieldnames(VelGOF);
    Corrsamlepeak.Duration(1,i)=str2num(Fname{i}(6:end));
    EstimatAdapt(1,i)=VelGOF.merge40.OKNL(5*60)-VelGOF.merge40.OKNL((Corrsamlepeak.Duration(1,i)+5)*60);
    EstimatAdapt(2,i)=VelGOF.merge40.OKNR(5*60)-VelGOF.merge40.OKNR((Corrsamlepeak.Duration(1,i)+5)*60);
    
      
    condition_lOKANpeak=[];
    condition_rOKANpeak=[];
    for d=1:length(MergeDATA.(Fname{i}))
        condition_lOKANpeak(d)=MergeDATA.(Fname{i})(d).lOKANpeak;
        condition_rOKANpeak(d)=MergeDATA.(Fname{i})(d).rOKANpeak;     
    end
    lOKANpeak=[lOKANpeak condition_lOKANpeak];
    rOKANpeak=[rOKANpeak condition_rOKANpeak]; 
    duration=[duration repmat(Corrsamlepeak.Duration(1,i),1,length(MergeDATA.(Fname{i})))];
    adapt=[adapt repmat(EstimatAdapt(:,i),1,length(MergeDATA.(Fname{i})))];
    
    Corrsamlepeak.OKANL_peak(:,i)=mean(abs(condition_lOKANpeak));
    Corrsamlepeak.OKANR_peak(:,i)=mean(abs(condition_rOKANpeak)); 
    
end

%plot value
Corrsamlepeak.plot(1,:)=duration;
Corrsamlepeak.plot(2:3,:)=adapt;
Corrsamlepeak.plot(4,:)=abs(lOKANpeak);
Corrsamlepeak.plot(5,:)=abs(rOKANpeak);





[Corrsamlepeak.rho_pval_l(1),Corrsamlepeak.rho_pval_l(2)] = corr(Corrsamlepeak.plot(2,:)',Corrsamlepeak.plot(4,:)');
[Corrsamlepeak.rho_pval_r(1),Corrsamlepeak.rho_pval_r(2)] = corr(Corrsamlepeak.plot(3,:)',Corrsamlepeak.plot(5,:)');
[Corrsamlepeak.meanrho_pval_l(1),Corrsamlepeak.meanrho_pval_l(2)] = corr(EstimatAdapt(1,:)',Corrsamlepeak.OKANL_peak');
[Corrsamlepeak.meanrho_pval_r(1),Corrsamlepeak.meanrho_pval_r(2)] = corr(EstimatAdapt(2,:)',Corrsamlepeak.OKANR_peak');


plot(EstimatAdapt(1,:),Corrsamlepeak.OKANL_peak,'o',...
    'MarkerEdgeColor','b',...
    'MarkerSize',10,...
    'LineWidth',2.5);

hold on
plot(EstimatAdapt(2,:),Corrsamlepeak.OKANR_peak,'o',...
    'MarkerEdgeColor','r',...
    'MarkerSize',10,...
    'LineWidth',2.5);

plot(Corrsamlepeak.plot(2,:),Corrsamlepeak.plot(4,:),'o',...
    'MarkerEdgeColor','b',...
    'MarkerSize',2,...
    'LineWidth',2.5);

hold on
plot(Corrsamlepeak.plot(3,:),Corrsamlepeak.plot(5,:),'o',...
    'MarkerEdgeColor','r',...
    'MarkerSize',2,...
    'LineWidth',2.5);


end

%peak correlate of every sample to estimate OKN adaptation


