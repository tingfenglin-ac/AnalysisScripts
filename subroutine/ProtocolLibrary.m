function [protocol,protocol_name,ProtoCat,ProtocolV]=ProtocolLibrary(ProtNumber);
if ProtNumber==0
    protocol=[0 5 25 30 50 60];
    protocol_name={'Dark' 'Stim' 'Dark' 'Stim' 'Dark'};
    ProtoCat={'d1' 'p1' 'n1' 'd2' 'p2' 'n2' 'd3'};
    [ProtocolV]=OsciStim(protocol);
end
if ProtNumber==1
    protocol=[0 5 25 30 50 60 80 85 105 115];
    protocol_name={'Dark' 'OKR' 'Dark' 'OKR' 'Dark' 'OKR' 'Dark' 'OKR' 'Dark'};
    ProtoCat=[];
    [ProtocolV]=OsciStim(protocol);
end
if ProtNumber==2
    protocol=[0 5 25 30 50 55 60];
    protocol_name={'Dark' 'Stim' 'Dark' 'Stim' 'Dark' 'Dark'};
    ProtoCat=[];
    [ProtocolV]=OsciStim(protocol);
end
if ProtNumber==3
    protocol=[0 5 25 30];
    protocol_name={'Dark' 'Stim' 'Dark'};
    ProtoCat=[];
    [ProtocolV]=UnidStim(protocol);
end
if ProtNumber==4
    protocol=[0 5 25 45];
    protocol_name={'Dark' 'OKN' 'Dark'};
    ProtoCat=[];
    [ProtocolV]=UnidStim(protocol);
end
