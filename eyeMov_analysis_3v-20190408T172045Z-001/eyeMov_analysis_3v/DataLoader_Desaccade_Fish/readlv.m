%READLV	Read labview binary file with or without header.
%
%	Call: out = readlv(file, total_chans, chans, onset, offset, skip, labview_header)
%	Eg:   out = readlv('data1', 6, [4 5 6 1 2 3], 1, 10000, 5);
%	or:	out = readlv();
%	or: 	out = readlv('data1');
%
%	Input: file ........ binary file, omit extension (is .bin)
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
%		labview_header ... 'on' or 'off'
%
%	Output:	out ... output matrix, in column form
%
%	DS & ThH, Jan-2000
%	Ver 1.3
% ********************************************************************
%Program Structure:
%\dom\readlv.m
%	\others\seidman\bin.m
%	\startup\extract.m
%	\th\data_eval\num_chan.m
%*****************************************************************

function out = readlv(file, total_chans, chans, onset, offset, skip, header_flag)

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
  offset = 1e7;%offset=offset*10000;
end;
if nargin < 4
  onset = 1;
end;

%default values
type = 'uchar';

% get the size of the header

fp = fopen(filename, 'rb');
if fp < 0 
	error(['Could not open ' filename]);
end
if strcmp(header_flag, 'on')
  HeaderLength.bin = fread(fp, 4, 'uchar');
  HeaderLength.val = 0;
  for ii = 1:4
    HeaderLength.val = HeaderLength.val + 2^(8*(4-ii))*HeaderLength.bin(ii);
  end   
  head_bytes = HeaderLength.val + 4; % 4 is from the value itself, the rest is the length of the header
else
  head_bytes = 0;
end

%job
fseek(fp, 0, 'bof');
start_byte = ftell(fp);
fseek(fp, 0, 'eof');
end_byte   = ftell(fp);
byte_no = end_byte-start_byte;
fseek(fp, 0, 'bof');

data_bytes = byte_no;
sample_max = floor((data_bytes-head_bytes) / (total_chans * 2));

if onset < 1
  disp('Onset must be greater than 0...');
  return;
end;
if offset > sample_max
  offset = sample_max;
end;

if offset < onset
  disp('Offset smaller than onset...');
  return;
end;

sample_no = offset - onset + 1;

start = head_bytes;

fseek(fp, start + (total_chans * 2 * (onset - 1)), 'bof');	% each datapoint consists of 2 'uchar'
if skip == 0
  mtx = fread(fp, [total_chans*2 sample_no], type);
else
  read_no = floor(sample_no ./ (skip + 1));
  mtx = zeros(total_chans*2, read_no);
  for i = 1:read_no
    tmp = fread(fp, [total_chans*2 (skip + 1)], type);
    mtx(:,i) = tmp(:,1);
  end;
end;
if isempty(mtx)
  disp('Empty input matrix. Skip probably too large.');
  return;
end;

fclose(fp);

[rr,cc] = size(mtx);
len = rr*cc/2;				% # of data

% matrix with 2 rows (m1,m2), #-data columns
mtx = reshape(mtx,2,len);

% if m1 >= 128: m1 = m1 - 256
index = find(mtx(1,:) >= 128);
mtx(1,index) = mtx(1,index)-256;
clear index

% value = m1*2^8 + m2
mtx = reshape(mtx(1,:) * 2^8 + mtx(2,:), total_chans, size(mtx,2)/total_chans);
out = mtx(chans,:)';		% return the required columns, in row-form
clear mtx;
return

