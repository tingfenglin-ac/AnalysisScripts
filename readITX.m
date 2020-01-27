function readITX(file_name) 
% readITX(file_name)
% readITX({file_1, file_2})
% readITX(
if ~exist('file_name', 'var')
    [file_name, file_path] = uigetfile('.itx', 'MultiSelect', 'on'); 
    if ~ischar(file_name) && ~iscell(file_name)
        fprintf('No file was chosen. Nothing was read. \n');    
        return;
    end     
end 

if iscell(file_name)
    for fn = 1:length(file_name)
        readITX(file_name{fn}); 
    end
end

if ~contains(file_name, '.itx')
    error('Need and ITX file');
end

itx_file = fullfile(file_path, file_name); 

fid = fopen(itx_file,'r'); 
text_from_file = textscan(fid, '%s', 'delimiter', '\n');
text_from_file = text_from_file{1};

begin_indices = find(strcmp(text_from_file, 'BEGIN')); 
end_indices = find(strcmp(text_from_file, 'END')); 
if length(begin_indices) ~= length(end_indices)
    error('BEGIN and END number mismatch'); 
end
consec_begins = diff(begin_indices);
segment_durs = end_indices - begin_indices; 
if any(segment_durs(1:end-1) >= consec_begins)
    error('No nested BEGIN-END pairs allowed'); 
end 
num_segments = length(begin_indices); 
recordings = cell(num_segments, 1); 

% add on to find properties/metadata that Igor stupidly put at the end 
begin_indices = [begin_indices; length(text_from_file)]; 

fprintf('Beginning extraction of %s ... \n', itx_file); 
cur_tic = tic; 
for segment_ind = 1:num_segments
    begin_ind = begin_indices(segment_ind)+1; 
    end_ind = end_indices(segment_ind)-1; 
    
    % read the name after waves
    % this only accounts for anticipation of WAVES 
    % WAVES sb20190830_4_CFs_1_11_20_1p1
    segment_id = regexprep(text_from_file{begin_ind-2}, 'WAVES ', ''); 
    
    % read the data 
    read_data = cellfun(@str2double, text_from_file(begin_ind:end_ind), 'uni', 1);

    % only need the time axis, based on these 2. need to double check 
    % X SetScale/P x, 0.000000000E+00,  5.000000000E-05,"s", sb20190830_4_CFs_1_11_2_1p1
    % X SetAxis bottom,  0.000000000E+00,  1.000000000E+00; SetAxis left, -5.119843750E-09,  5.119843750E-09
    next_begin = begin_indices(segment_ind+1); 
    props = text_from_file(end_ind:next_begin); 
    find_SetScale = split(props(contains(props, 'SetScale/P x')), {',',';'});
    find_SetAxis = split(props(contains(props, 'SetAxis')), {',',';'});
    dt = str2double(find_SetScale{3}); 
    T = str2double(find_SetAxis{3}); 
    

    if abs(T/length(read_data) - dt) > eps
        error('Mismatch time!');
    end 
    
    recordings{segment_ind} = struct(...
        'id', segment_id, ...
        'dt', dt, ...
        'Fs', 1/dt, ...
        'T', T, ...
        'data', read_data);
    
    
end
fclose(fid); 
recordings = vertcat(recordings{:});

file_pref = regexprep(file_name, '.itx$', ''); 
file_save = fullfile(file_path, [file_pref '.mat']); 
save(file_save, 'recordings', 'itx_file'); 

fprintf('\t ... done. Saved as %s. \n\t ... Elapsed time = %.2f seconds.\n', file_save, toc(cur_tic)); 

end