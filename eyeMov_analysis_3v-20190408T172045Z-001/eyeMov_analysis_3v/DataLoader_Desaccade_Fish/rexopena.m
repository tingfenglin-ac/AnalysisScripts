function params = rexopena(file)

%  fparms = openrexa(file)
%
%  Open a REX .A file and return a structure of parameters that is
% used by subsequent readrex() calls.
%
%  The values in the fparms structure are:
%
% handle - file ID, from an fopen() call
% filename - base file name, minus any extension
% headerlen - length of header string, including terminating 0 byte
% header - the entire header string, excluding the terminating 0 byte
% nchans - # of data channels
% samprate - samples per second
% msecsamp - 1000/samprate
% nsamples - total number of samples in file
% chan_names - an array of strings with the name of each channel
% chan_numbers - an array of integers with the hardware channel numbers (i.e., the
%                number of the A/D input channel on the REX system that collected
%                the data).
% coil_chans - an array of exactly 18 numbers with the 6 channel numbers for each of
%              the Right, Left and Head coils.  Any coils that were not present in the
%              data file have 0's in the corresponding positions.  The order of the
%              channels is in the standard Righthand Rule order: X (front/back) field
%              signal, Y (left/right) field signal, Z (up/down) field signal, for the
%              direction, then the torsion coil.
% comment - any lines in the header starting with "% " will be accumulated into this
%           character array.

fp = fopen([file '.a'], 'rb');
if fp == -1
	fprintf('Could not open file %s.A\n', file);
	return
end

%  Find end of header string, terminated by a 0 byte.
% Keep reading until we find it.
header = [];
while 1
	header = [header char(abs(fread(fp, 1000, 'char')'))];
	pos = find(header == 0);
	if ~isempty(pos)
		headlen = pos(1);
		break;
	end

	% This should never happen.
	if feof(fp)
		error('Error in .A file.  Cannot find end of header string.');
	end
end

% Chop off the header string at headlen.
header(headlen:end) = [];

%  Extract info from header (# chans and sample interval).  Convert
% sample interval, given in milliseconds, to sample rate by dividing
% it into 1000.
nchan = sscanf(findline(header,'achan'), ' %d', 1);
samprate = sscanf(findline(header,'msecstp'), ' %d', 1);
samprate = 1000/samprate;

%  Get file length in samples.
fseek(fp, 0, 'eof');
totsamps = (ftell(fp) - headlen) / (nchan*2);

%  Return all of the info to the caller.
params = struct('handle',fp, 'filename', file, 	'header', header, 'headerlen',headlen, ...
				'nchans',nchan, ...
				'samprate',samprate, 'nsamples',totsamps, ...
				'msecsamp',1000/samprate);

% Get all comment strings together into one.
h = header;
params.comment = '';
idx = findstr(header, [10 '%']);
for i=idx
	params.comment = [params.comment findline(header(i:end), [10 '%']) 10];
end
% Get rid of trailing newline.
if length(params.comment > 1)
	params.comment(end) = [];
end

% Get the mapping information from the header, if present.
params.chan_names = [];
params.chan_numbers = [];
params.coil_chans = [];

% Make sure mapping information is there before trying to parse it.
if ~isempty(findline(header,'chan_numbers'))
	% Get chan_numbers from header.
	params.chan_numbers = sscanf(findline(header,'chan_numbers'), ' %d ');
end

if ~isempty(findline(header, 'chan_names'))

	% Get chan_names from header.
	n = findline(header, 'chan_names');

	% Make sure there is a space before the first name.
	if n(1) ~= ' '
		n = [' ' n];
	end

	% Find the spaces between the channel names.
	sp = findstr(n,' ');
	% Add a space after the last name, to simplify the for() loop.
	n(end+1) = ' ';
	sp = [sp length(n)];

	% Extract each channel name and put them all into a cell array.
	params.chan_names = {};
	for i=1:(length(sp)-1)
		params.chan_names{end+1} = n((sp(i)+1):(sp(i+1)-1));
	end

	% Make it a single column instead of a single row.
	params.chan_names = params.chan_names';
end

% Get any coil channel mapping info out of the header.  Note, a .MAP file may override
% the .A file header, so we reassign the variables to whatever rexmap() finds.

[params.coil_chans, params.chan_names, params.chan_numbers] = rexmap(params);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find a header line containing the matching string.
function line = findline(headerstr, matchstr)

pos = findstr(headerstr, matchstr);
line = [];
if isempty(pos)
	return;
end

% Get past the matchstr and trailing space.
pos = pos + length(matchstr) + 1;

% Find the newline character.
endpos = findstr(headerstr(pos:end),10);
endpos = endpos(1);

% Return the matching line, minus the matchstr and newline.
line = headerstr(pos:(pos+endpos-2));
