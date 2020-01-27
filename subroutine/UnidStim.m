function [ProtocolV]=UnidStim(protocol);
prompt = {'Stimulus velocity:'};
        title = 'Stimulus velocity';
        dims = [1 35];
        definput = {'10'};
        StimV = inputdlg(prompt,title,dims,definput);
        StimV=str2num(StimV{1}); 

ProtocolT=protocol;
ProtocolT=[ProtocolT(1:end-1);ProtocolT(2:end)];

ProtocolV=[0 StimV 0];
ProtocolV=[ProtocolV;ProtocolV];
ProtocolV=[ProtocolT(1:end);ProtocolV(1:end)];
end