function DataStruct=channel_select(DataStruct,channel)


index=DataStruct.LeftEyeChannels>=channel;
DataStruct.LeftEyeChannels=DataStruct.LeftEyeChannels+index;
index=DataStruct.RightEyeChannels>=channel;
DataStruct.RightEyeChannels=DataStruct.RightEyeChannels+index;
index=DataStruct.ChairChannels>=channel;
DataStruct.ChairChannels=DataStruct.ChairChannels+index;
index=DataStruct.LaserChannels>=channel;
DataStruct.LaserChannels=DataStruct.LaserChannels+index;

