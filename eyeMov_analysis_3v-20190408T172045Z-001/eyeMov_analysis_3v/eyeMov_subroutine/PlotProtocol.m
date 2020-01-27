function PlotProtocol(grating_frq,ProtNumber,Yposition,LabelName)
%if LabelName==1, label the protocol_name on the top of protocol
LINEWIDTH=15;

[protocol,protocol_name,ProtoCat]=ProtocolLibrary(ProtNumber);

width_grating=0;
t=(protocol(1):protocol(end));
plot([t(1) t(end)],[Yposition+width_grating Yposition+width_grating],'k-',...
    'LineWidth',LINEWIDTH+1);
hold on

for k=2:length(protocol)
    if mod(k,2)==0;
        plot([protocol(k-1) protocol(k)],[Yposition Yposition],'k-',...
            'LineWidth',LINEWIDTH);
    else
        t_grating=protocol(k-1):1/grating_frq:protocol(k);
        scatter(t_grating,Yposition*ones(1,length(t_grating)),LINEWIDTH*36/7,'w','filled','s');
    end
    
    
    if LabelName==1;
        Xshift=2;
        NamePosition=median([protocol(1:end-1);protocol(2:end)],1)-Xshift;
        text_high=Yposition+1.5;
        text(NamePosition,text_high*ones(1,length(NamePosition)),protocol_name,'FontSize',22);
    end
end