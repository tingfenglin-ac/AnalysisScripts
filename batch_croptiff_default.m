function batch_croptiff_default(start_folder,crop_pos) 

if nargin == 0 
    start_folder = '.';
end 

if nargin < 2
    % this assumes width is always 796 pixels, and black margins ~64 pixels 
    % position #4 irrelevant (for now)
    % if not, please input desired `crop_pos`
    crop_pos = [65,1,731,NaN];
end
    
[tif_files, path_tif] = uigetfile(fullfile(start_folder, '*.tif'), 'Select tif files', 'Multiselect', 'on');
check_if_tif = cellfun(@(x) ~isempty(regexp(x,'.tif$', 'once')), tif_files, 'uni', 1);
if ~all(check_if_tif)
    error('At least one of the selected files did have not .TIF suffix');
end


for i = 1:length(tif_files)
    file_i = fullfile(path_tif, tif_files{i});
    data_i = load_tiffs_fast(file_i);
    nlines = size(data_i, 1); 
    
    crop_pos(4) = nlines; 
    Cdata = data_i(:, crop_pos(1): crop_pos(3),:);
    
    crop_txt = sprintf('%d_%d-%d_%d', crop_pos(1),crop_pos(2),crop_pos(3),crop_pos(4)); 
    
    crop_i = [file_i(1:end-4) '_2Dcrop_' crop_txt '.tif'];
    write_tiff_fast(crop_i,Cdata);
    
    disp([crop_i ' has been saved'])
end

end