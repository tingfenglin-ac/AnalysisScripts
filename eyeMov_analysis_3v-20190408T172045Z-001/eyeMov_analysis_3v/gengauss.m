function x = gengauss(w,p,c)
%GENGAUSS  Generate a gaussian peak of unit height.
%
%      x = gengauss(w)  or   x = gengauss(w,p,c)
%
% where:
%
% w    is the distance from center to 2% of full height
% p    (optional) is the number of points x will contain
% c    (optional) is the point number for the peak center
%
% The peak will be centered in the vector unless p and c are specified.
%

% Copyright (c) 1989-92 by The MathWorks, Inc.

if nargin == 2, c = 0; end
if nargin == 1, c = 0; p = 0; end

if p < 1, points = round(3 * w);
   else points = round(p);
end

if c < 1, center = round(points/2);
   else center = round(c);
end

w = w/2;
if c < 0, center = center - c; end

for n = 1:points,

	x(n) = exp(-((n-center)/w)^2);
end

x = x';
