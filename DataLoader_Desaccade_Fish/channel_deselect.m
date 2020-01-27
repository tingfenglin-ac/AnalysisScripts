function DataStruct=channel_deselect(DataStruct,channel)

if not(isempty(find(DataStruct.LeftEyeChannels>channel)))
    index=find(DataStruct.LeftEyeChannels==channel);
    DataStruct.LeftEyeChannels=[DataStruct.LeftEyeChannels(1:index-1) DataStruct.LeftEyeChannels(index+1:end)];
end
if not(isempty(find(DataStruct.RightEyeChannels>channel)))
    index=find(DataStruct.RightEyeChannels==channel);
    DataStruct.RightEyeChannels=[DataStruct.RightEyeChannels(1:index-1) DataStruct.RightEyeChannels(index+1:end)];
end
if not(isempty(find(DataStruct.ChairChannels>channel)))
    index=find(DataStruct.ChairChannels==channel);
    DataStruct.ChairChannels=[DataStruct.ChairChannels(1:index-1) DataStruct.ChairChannels(index+1:end)];
end
if not(isempty(find(DataStruct.LaserChannels>channel)))
    index=find(DataStruct.LaserChannels==channel);
    DataStruct.LaserChannels=[DataStruct.LaserChannels(1:index-1) DataStruct.LaserChannels(index+1:end)];
end
index=DataStruct.LeftEyeChannels>=channel;
DataStruct.LeftEyeChannels=DataStruct.LeftEyeChannels-index;
index=DataStruct.RightEyeChannels>=channel;
DataStruct.RightEyeChannels=DataStruct.RightEyeChannels-index;
index=DataStruct.ChairChannels>=channel;
DataStruct.ChairChannels=DataStruct.ChairChannels-index;
index=DataStruct.LaserChannels>=channel;
DataStruct.LaserChannels=DataStruct.LaserChannels-index