function [ProtocolV]=OsciStim(protocol);
prompt = {'first Stimulus velocity:','second Stimulus velocity:'};
        title = 'Stimulus velocity';
        dims = [1 35];
        StimV = inputdlg(prompt,title,dims);
        StimV=[str2num(StimV{1}) str2num(StimV{2})];

        

ProtocolT=[0];
ProtocolV=[0];

for i=1:length(protocol)/2-1
    ProtocolT=[ProtocolT protocol(i*2):15/60:protocol(i*2+1)];
    ProtocolV=[ProtocolV repmat([StimV(1) StimV(2)],1,(protocol(i*2+1)-protocol(i*2))*60/30) 0];
end

ProtocolT=[ProtocolT protocol(end)];



ProtocolT=[ProtocolT(1:end-1);ProtocolT(2:end)];
ProtocolV=[ProtocolV;ProtocolV];
ProtocolV=[ProtocolT(1:end);ProtocolV(1:end)];
end