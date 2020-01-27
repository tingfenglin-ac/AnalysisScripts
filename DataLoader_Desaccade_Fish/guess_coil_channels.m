% Count binary channels.  Guess  which are coils or not.
% [chans] = guess_coil_chans(binfile_or_array)
%
function [chans ] = guess_coil_channels(binfile_or_matrix)

if isnumeric(binfile_or_matrix)
    data = binfile_or_matrix;
else
    [f e ] = stripextension(binfile_or_matrix);
    if( strcmp(e, '.bin'))
        data = readlv(f, 1,1);
    else
        data = readlv(binfile_or_matrix,1,1);
    end

end
%% max data length
% we do not need to analyze a huge, huge file.
max_data_length = 32*30*60*10000000000000000000000;

possible_channels = 32;
lng = length(data);
if(lng >max_data_length)
    data = data(1:max_data_length);
    lng =max_data_length;
end

% [rr,cc] = size(mtx);
% len = rr*cc/2;

cnt =1;
for(x = 1:possible_channels)
    if( ~rem(lng, x))
        ns = reshape(data, x, [])';
        thechans(cnt) = x;
        thestds= std(ns);
        sumstds(cnt) = sum(thestds)./x;
        cnt = cnt+1;
    end
end
[m mi] = min(sumstds);
chans = thechans(mi);


%% for the future:  determine which are coils; chair; hexapod; laser
% check if the first channel is the laser on/off.










