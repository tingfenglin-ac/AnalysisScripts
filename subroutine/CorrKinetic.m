function [CorrKi]=CorrKinetic(VelGOF)
for i=1:length(fieldnames(VelGOF))
    Fname=fieldnames(VelGOF);
    CorrKi.Duration(1,i)=str2num(Fname{i}(6:end));
    
    %function for 2exp fit:
    %OKN
    %ft=fittype(['a*exp(-(x-' num2str(TraceStart*60) ')/b) + c*exp(-(x-' num2str(TraceStart*60) ')/d)+e']);
    %OKAN
    %ft=fittype(['a*exp(-(x-' num2str(TraceStart*60) ')/b) + c*exp(-(x-' num2str(TraceStart*60) ')/d)']);
    CorrKi.OKNL_Tm(:,i)=coeffvalues(VelGOF.(Fname{i}).OKNL)/60;%time constant unit=second is changed to minute
    CorrKi.OKNR_Tm(:,i)=coeffvalues(VelGOF.(Fname{i}).OKNR)/60;
    
    %function for 1exp fit:
    %OKN:
    %ft=fittype(['a*exp(-(x-' num2str(TraceStart*60) ')/b)+c']);
    %PKAN
    %ft=fittype(['a*exp(-(x-' num2str(TraceStart*60) ')/b)']);
    CorrKi.OKANL_Tm(:,i)=coeffvalues(VelGOF.(Fname{i}).OKANL)/60; %time constant unit=second is changed to minute
    CorrKi.OKANR_Tm(:,i)=coeffvalues(VelGOF.(Fname{i}).OKANR)/60;
    
    
end
[CorrKi.rho_pval_l(1),CorrKi.rho_pval_l(2)] = corr(CorrKi.Duration',CorrKi.OKANL_Tm(2,:)');
[CorrKi.rho_pval_r(1),CorrKi.rho_pval_r(2)] = corr(CorrKi.Duration',CorrKi.OKANR_Tm(2,:)');

plot(CorrKi.Duration,CorrKi.OKANL_Tm(2,:),'o',...
    'MarkerEdgeColor','b',...
    'MarkerSize',10,...
    'LineWidth',2.5);
hold on
plot(CorrKi.Duration,CorrKi.OKANR_Tm(2,:),'o',...
    'MarkerEdgeColor','r',...
    'MarkerSize',10,...
    'LineWidth',2.5);










end