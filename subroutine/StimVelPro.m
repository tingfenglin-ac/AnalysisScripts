function StimVelPro(ProtNumber)
[protocol,protocol_name,ProtoCat,ProtocolV]=ProtocolLibrary(ProtNumber);

yyaxis right
plot(ProtocolV(1,:),ProtocolV(2,:),'Color',[0.5,0.5,0.5],'LineWidth',1.5);

ylabel({'Stimulus velocity' '(deg/min)'},'FontSize',12);

