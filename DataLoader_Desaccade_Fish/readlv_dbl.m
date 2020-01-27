%READLV_DBL	Read labview binary file with or without header.
%
%	Call: out = readlv_dbl(file, total_chans, chans, onset, offset, skip, labview_header)
%	Eg:   out = readlv_dbl('data1', 6, [4 5 6 1 2 3], 1, 10000, 5);
%
%	Input: file ........ binary file of type double
%		total_chans ... number of channels read
%		chans ......... designation of channels (starting with "1"!)
%				If a chair-position is sampled as the first channel, then we have
%				pos 2: dir x
%				pos 3: dir y
%				pos 4: dir z
%				pos 5: tor x
%				pos 6: tor y
%				pos 7: tor z
%	[ from here on the arguments are optional ]
%		onset ......... first sample
%		offset ........ last sample
%		skip .......... number of samples not to read after each read sample
%				"0" = sample all
%				"1" = sample every second
%				etc.
%		labview_header ... 'on' or 'off'. Default = 'on'.
%
%	Output:	out ... output matrix, in column form
%           header ...   the size (NxM) of the first block of data that is
%           streamed to disk.  The number of rows is therefore useless, but
%           the number of columns is potentially useful for debugging.
%
%	CJB, Sept-2006

function [out header] = readlv_dbl(file, total_chans, chans, onset, offset, skip, ...
  header_flag)



%check arguments
if nargin == 0
  % Get the default-directories:
  info_file = which('mat_inf');
  data_dir = extract(info_file, 'data_dir', '= ');
  % Set the in-file:
  cur_dir = pwd;
  eval(['cd ' data_dir]);
  [file, f_path] = uigetfile('*.bin', 'Test file:');
  if file == 0; return; end
  filename = [f_path file];

  total_chans = num_chan(filename);
  chans = 1:total_chans;
else
  if isempty(findstr(file,'.bin'))
    filename = [file '.bin'];
  else
    filename = file;
  end
end


if nargin < 7
  header_flag = 'off';
end;
if nargin < 6
  skip = 0;
end;
if nargin < 5
  offset = 1e15;
end;
if nargin < 4
  onset = 1;
end;

%default values
type = 'double';

fp = fopen(filename, 'r' , 'b');

if strcmp(header_flag, 'on')
  % the header contains the size of the first block of data that is
  % streamed to disk.  The number of rows is therefore useless, but
  % the number of columns is potentially useful for debugging.
  [header] = fread(fp, 2, 'int32');
end


[ mtx message ] = fread(fp, inf, type);

if total_chans ~=1
  rs = reshape(mtx,total_chans, [])';
  sel = rs(:,chans);
else
  sel = mtx;
end

if ~skip
  out = sel;
  fclose(fp);
  return
end

if size(sel,2)> 1
  out = sel(1:(skip+1):end,:);
else
  out = sel(1:(skip+1):end);
end
 fclose(fp);
