function datbuf = rexreada(fparms, start, numsamps, subsamp, chanvect)

%  datbuf = rexreada(fparms, startsamp, numsamps, subsamp, chanvect)
%
%  fparms is a structure of values obtained from a previous rexopena()
% call.  datbuf() returns a column matrix of data, where the columns
% are the data channels and the rows are the samples.  If startsamp
% is a vector, returns numsamps of data points from each of the
% startsamp positions, all contatenated in the data columns.
%
%  The optional subsamp parameter allows you to load every other
% sample, every third sample, etc.  A subsamp of 1 (the default)
% loads all samples, 2 loads every other, etc.  The optional
% chanvect parameter is a vector of channel numbers.  This allows
% you to load a subset of channels.

%  The 5 values in the fparms[] vector are:
%
% fid - file ID, from an fopen() call
% headlen - length of header string
% nchan - # of data channels
% samprate - samples per second
% totsamps - total number of samples in file

%  Put parameter references directly into equations.

% fp = fparms(1);
% headlen = fparms(2);
% nchan = fparms(3);
% totsamps = fparms(5);

datbuf = [];

if(nargin < 4)
	for i = 1:length(start)
		fseek(fparms.handle, fparms.headerlen + start(i)*2*fparms.nchans, 'bof');
		datbuf = [datbuf ; fread(fparms.handle, [fparms.nchans numsamps], 'short')'];
	end
	return;
end

if(nargin < 5)
	chanvect = 1:fparms.nchans;
end

if(nargin < 4)
	subsamp = 1;
end

if(subsamp > 1024)
	disp 'ERROR:  subsamp must be <= 1024';
	return;
end

if(max(chanvect) > fparms.nchans)
	disp 'ERROR:  one or more elements of chanvect exceed # of chans';
	return;
end

if(min(chanvect) < 1)
	disp 'ERROR:  one or more elements of chanvect is < 1';
	return;
end

for i = 1:length(start)

if 0
	fseek(fparms(1), fparms(2) + start(i)*2*fparms(3), 'bof');
	nsamp = min((fparms(5)-start(i)+1)/subsamp, numsamps);
	datbuf = [datbuf zeros(length(chanvect), nsamp/subsamp)];
	for idx1 = 1:nsamp
if(rem(idx1,100) == 0)
	fprintf('%8d\n', idx1);
end
		tmpbuf = fread(fparms(1), [fparms(3) subsamp], 'short');
		datbuf(:,idx1) = tmpbuf(chanvect,1);
	end
end

if 1
	fseek(fparms.handle, fparms.headerlen + start(i)*2*fparms.nchans, 'bof');
	nsamp = min((fparms.nsamples-start(i)+1)/subsamp, numsamps) * subsamp;
	datbuf = [datbuf zeros(length(chanvect), floor(nsamp/subsamp))];
	startsmp = 1;
	idx1 = 1;
	while nsamp > 0
		tmpbuf = fread(fparms.handle, [fparms.nchans min(nsamp,1024)], 'short');
		smpvect = startsmp:subsamp:size(tmpbuf,2);
		idx2 = idx1 + length(smpvect) - 1;
		datbuf(:,idx1:idx2) = tmpbuf(chanvect, smpvect);
		idx1 = idx2 + 1;
		nsamp = nsamp - 1024;
		startsmp = rem(max(smpvect)+subsamp-1, 1024)+1;
	end
end

end

datbuf = datbuf';

%get rid of last point at the end of the file

if numsamps == inf
   datbuf = datbuf(1:end-1,:);
end

