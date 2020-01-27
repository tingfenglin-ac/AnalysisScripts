function [ Fc, scale, center ] = FtoFc( F, scale_window )
%FTOFC Normalizes by the 8th percentile in a sliding window and subtracts
%   the median to create the modified DFoF
if ~exist('scale_window','var'), scale_window = 1e3; end

scale = zeros(size(F));
parfor i=1:size(scale,1)
%     disp(i)
    scale(i,:) = quantile(F(max(i-scale_window,1):min(i+scale_window,size(F,1)),:),0.08);
end
Fc = F./scale;
center = median(Fc);
Fc = bsxfun(@minus,Fc,center);

end

