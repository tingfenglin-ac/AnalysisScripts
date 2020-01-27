function CrossCorr_Ting(velocity,Tablenames,n)
cnames=Tablenames.Properties.VariableNames;
t=Tablenames.([cnames{1}])/15;
v=velocity(2:length(t)+1);
% v=Tablenames.([cnames{1}])/15; %to produce fake velocity data

figure
for i=1:length(n)
    signal_1=smooth(Tablenames.([cnames{3+(n(i)-1)*2}]));
    for j=1:length(n)
        signal_2=smooth(Tablenames.([cnames{3+(n(j)-1)*2}]));
        [c,lags] = xcorr(signal_1,signal_2','coeff');
        R = corrcoef(signal_1,signal_2);
        
        subplot(length(n),length(n)+1,(i-1)*(length(n)+1)+j);
        hold on
        plot(lags/15,c)
        ylim([0 1])
        title([num2str(n(i)),' to ',num2str(n(j)),' (R=',num2str(R(2,1)),')'])
        xlabel('Time (s)');
        set(gcf,'color',[1,1,1]);
    end
    isOK=isfinite(v) & isfinite(signal_1);   % both rows finite (neither NaN)
    [c,lags]=xcorr(v(isOK),signal_1(isOK),'coeff');
    R = corrcoef(v(isOK),signal_1(isOK));
    
    subplot(length(n),length(n)+1,i*(length(n)+1));
    hold on
    plot(lags/15,c)
    ylim([0 1])
    title(['Speed to ',num2str(n(i)),' (R=',num2str(R(2,1)),')'])
    xlabel('Time (s)');
    set(gcf,'color',[1,1,1]);
end