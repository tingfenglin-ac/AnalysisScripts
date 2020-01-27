function [coil_map, chan_names, hardware_nums]=rexmap(params)
%
%  NOTE:  This function is provided for backwards
%         compatibility with old programs.  New
%         programs should not call REXMAP directly.
%         The mapping information is all returned by
%         rexopena(), rexload(), etc.
%
% [coil_map chan_names hardware_nums] = rexmap(params)
%
% params - Optional parameter: returned from rexopena().
%          Intended for use only by rexopena().
%
% coil_map - channel numbers of coil channels.
% chan_names - cell array of names of all channels in the file.
% hardware_nums - the A/D input channel numbers from the REX
%                 system that created the data file.
%
%  rexmap() returns a map of the channels in a REX .A file.
% It is passed the "params" returned from rexopena().  It will
% scan the .A file header to extract the channel mapping
% information.  For backwards compatibility, if no "params" is
% given, it will read in the channel map from a "chanmap" file.
%
%  rexmap() will look in the following order for the mapping
% information:
%
% - Look for a file with same base name as .A file, with .MAP
%   extension.  This allows overriding chanmap and the mapping
%   info in the .A file.  This is skipped if no "params" is passed.
% - Look in the .A file header.  This is skipped if no "params"
%   is passed.
% - Look for a file named "chanmap".
%
% The order of the returned channels in "coil_map" is RDX, RDY,
% RDZ, RTX, RTY, RTZ, LDX LDY, LDZ, LTX, LTY, LTZ, HDX HDY, HDZ,
% HTX, HTY, HTZ.  This vector can be used directly to reorder the
% raw data channels into proper right-hand coordinate system order.
% Any coils not present in the data file have 0's in the corresponding
% positions.  "coil_map" will always have exactly 18 numbers.
%
% "chan_names" contains a cell array with the names of each channel.
%
% "hardware_nums" contains the A/D input channel numbers of the
% REX system that created the data file.  This is only present
% if the information was present in the .A file header.

% The first step is to search the 3 places in order for the names of all
% of the channels.  After we have that, then we extract the coil channel
% information.  We check <filename>.MAP file, .A file header, CHANMAP
% file.

coil_map = [];
chan_names = [];
hardware_nums = [];

if nargin == 1

	hardware_nums = params.chan_numbers;

	% Look in .MAP file.
	chan_names = read_map_file([params.filename '.map']);

	% If not found, look in .A file.
	if isempty(chan_names)
		chan_names = params.chan_names;
	end

end % nargin==1

% If chan_names wasn't filled in above, look for the chanmap file.
if isempty(chan_names)
	chan_names = read_map_file('chanmap');
end

% If called from rexopena(), initialize channel names to "unknown".
if (nargin >= 1) & isempty(chan_names)
	chan_names = {};
	[chan_names{1:params.nchans}] = deal('unknown');
end

% Find all of the coil channels and make the coil_map.
coil_map = make_coil_map(chan_names);

return;


%%%%%%%  IGNORE error checking below.

% We now always return exactly 18 numbers in coil_map[].  Any coil
% channels not specified are set to 0.

% If all 12 channels are filled, great.  Just return.
if min(map(1:12)) > 0
	return;
end

% If there are missing entries in both right and left eye,
% there is an error somewhere.
if min(map(1:6)) < 1 & min(map(7:12)) < 1
	error('Not enough coil channels specified in CHANMAP file');
end

% If the right eye is completely missing, that's okay.  We
% return just the 6 channels for the left eye.
if max(map(1:6)) == 0 & min(map(7:12)) > 0
	map = map(7:12);
	return;
end

% If the left eye is completely missing, that's okay. We
% return just the 6 channels for the right eye.
if max(map(7:12)) == 0 & min(map(1:6)) > 0
	map = map(1:6);
	return;
end

% If all is well, we should not get here.  If we are here, then
% there is some error in the CHANMAP file.
error('CHANMAP file must give exactly 6, 12, or 18 channels');

return;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Split out the coil map computation.  It used to be embedded in the
% code that read in the chanmap file.  chan_names{} should be a cell
% array of character strings with the names of all of the .A file
% channels, in order.  "map" will be an array of 18 numbers, with the
% channel numbers for the 6 right eye coil channels, the 6 left eye
% coil channels, and the 6 head coil channels.  The order of the
% channels will always be DX DY DZ TX TY TZ (where D is "direction
% coil", T is "torsion coil", and X, Y, and Z are the three fields).
%
function map = make_coil_map(chan_names)

map=zeros(1,18);

for channum = 1:length(chan_names)
	iscoil = 1;
	chname = chan_names{channum};

	if length(chname) < 8
		iscoil = 0;
	elseif ~strcmp(chname(1:5), 'coil_') | length(chname) ~= 8 ...
			| ~(chname(6) == 'R' | chname(6) == 'L' | chname(6) == 'H') ...
			| ~(chname(7) == 'D' | chname(7) == 'T') ...
			| ~(chname(8) == 'X' | chname(8) == 'Y' | chname(8) == 'Z')

		iscoil = 0;
	end

	if iscoil ~= 0
		% Using the three coil letters (i.e. RDX, LTY, etc.) calculate
		% the position in the map vector of the channel.
		mapnum = 1;
		if chname(6) == 'L'
			mapnum = mapnum + 6;
		elseif chname(6) == 'H'
			mapnum = mapnum + 12;
		end

		if chname(7) == 'T'
			mapnum = mapnum + 3;
		end

		if chname(8) == 'Y'
			mapnum = mapnum + 1;
		elseif chname(8) == 'Z'
			mapnum = mapnum + 2;
		end

		map(mapnum) = channum;

	end   % if iscoil
end % for

return;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Read in a chanmap file.
function chan_names = read_map_file(filename)

chan_names = [];

%fprintf('reading map file "%s"\n', filename);

fp=fopen(filename, 'r');

% Don't throw error() if called from rexopena().
if fp == -1
	if nargin < 1
		error(sprintf('No "%s" file found.  Cannot load data.', filename));
	else
		return
	end
end

curline = 1;

while 1
	% Get line from file
	str = fgetl(fp);
	if ~isempty(str) & str == -1
		break;
	end
	curpos = 1;

%fprintf('len %2d, Line: "%s"\n', length(str), str);

	% Must break this up because if length(str) is == 0, then we
	% get an error doing the str(1) tests.
	if length(str) ~= 0
	if str(1) ~= '#' & str(1) ~= '%'

		% Get first token from line; should be "chan??"
		[tok curpos] = gettok(str, curpos);
		if ~strcmp(tok(1:4), 'chan')
			fclose(fp);
			error(sprintf('Error line %d: "%s"', curline, str));
		end
		channum = str2num(tok(5:length(tok)));

		% Get second token; should be "="
		[tok curpos] = gettok(str, curpos);
		if ~strcmp(tok, '=')
			error(sprintf('Missing "=" line %d: "%s"', curline, str));
		end

		% Third token; should be "coil_???"
		[tok curpos] = gettok(str, curpos);

		chan_names{channum} = tok;
	end; end;

	% Increment line counter for error reporting.
	curline = curline + 1;
end %while 1

fclose(fp);
