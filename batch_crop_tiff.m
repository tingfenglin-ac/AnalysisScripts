nfiles = 10;
 
for i = 1:nfiles 
    common = '304'; 
    mat_file = load(sprintf('%s_000_%03d.mat', common, i-1));
    RPB = mat_file.info.recordsPerBuffer;
    crop_pos = [65,1,731,RPB];

    if mat_file.info.abort_bit
        continue; 
    end 
    
    tiff_out_pref = sprintf('%s_test%03d_Plain', common, i-1); 
    tiff_files = dir([tiff_out_pref, '*.tif']); 
    tiff_files = {tiff_files.name}; 
   
    crop_txt = [num2str(crop_pos(1)) '_' num2str(crop_pos(2)) ' - ' num2str(crop_pos(3)) '_' num2str(crop_pos(4))]; 
    for j = 1:length(tiff_files) 
        file_ij = tiff_files{j};    
        data_ij = load_tiffs_fast(file_ij); %load tiff into data        
        Cdata = data_ij(crop_pos(2):crop_pos(4), crop_pos(1): crop_pos(3),:);
        
        crop_ij = [file_ij(1:end-4) '_2Dcrop_' crop_txt '.tif']; 
        write_tiff_fast(crop_ij,Cdata);
        
        disp([crop_ij ' has been saved'])


    end
end