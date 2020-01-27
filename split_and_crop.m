function [ varargout ] = split_and_crop( data, varargin)
%SPLIT_AND_CROP Splits and crops a 3D matrix
%
% INPUT: data - The matrix to be split/cropped
%
% OUTPUT: varargout - The split matrices
%
% OPTIONAL PARAMETERS
%   nsplits (1) - The number of ways to split the matrix (alternates
%       frames)
%   crop ([0 0 0 0]) - The number of pixels from the top, bottom, left and
%       right of the matrix to crop off.
%
% Updated 12-1-2016 by Dr. Jason R. Climer
%% Parse inputs
% keyboard
ip = inputParser;
ip.addParameter('nsplits',1);
ip.addParameter('crop',[]);
ip.parse(varargin{:});
for j=fields(ip.Results)'
    eval([j{1} '=ip.Results.' j{1} ';']);
end

% Format crop
if isempty(crop), crop = zeros(nsplits,4); 
elseif numel(crop)==4, crop = repmat(crop(:)',[nsplits 1]); end

% Crop and output
varargout = arrayfun(@(i)data(1+crop(i,1):end-crop(i,2),1+crop(i,3):end-crop(i,4),i:nsplits:size(data,3)),1:nsplits,'UniformOutput',false);


end

