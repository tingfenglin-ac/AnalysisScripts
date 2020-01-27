function [data, fp]=rexload(fname, subsamp, start, endd)

%  [data,params] = rexload(fname, subsamp, start samp, end samp)
%
%  This is a convenience function that calls rexopena(),
% rexreada(), and fclose() for you, and returns data in
% a matrix.  It can be used to read in data all at once,
% when the flexibility of doing the rex...() calls
% seperately is not required.
%
%  You can enter anywhere from 1 to all of the parameters.
% The defaults are subsamp=1, start=1, end=inf.
%
%  The "params" return value is the structure returned from the
% call to rexopena().  See rexopena() for details.

fp=rexopena(fname);

if nargin == 1
	data = rexreada(fp, 1, inf);
elseif nargin == 2
	data = rexreada(fp, 1, inf, subsamp);
elseif nargin == 3
	data = rexreada(fp, start, inf, subsamp);
else
	data = rexreada(fp, start, endd, subsamp);
end

fclose(fp.handle);
