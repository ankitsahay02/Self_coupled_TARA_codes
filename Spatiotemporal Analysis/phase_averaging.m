function[phase_avgd_chemi_reshaped, phase_avgd_pq_reshaped] ...
    = phase_averaging(phase_index, Image_data_folder, Chemiimgname,...
    tot_matrix_size, mean_chemi, std_chemi, pf_near_skip_norm, row_image, col_image)

Chemi_double_reshaped = zeros(tot_matrix_size, length(phase_index));

for counter = 1:length(phase_index)
    
    k = phase_index(counter);
    
    FileStr              = sprintf('%06d.tif', k);
    dataname_coupled     = strcat(Image_data_folder,...
        Chemiimgname, FileStr);
    Chemi_file_coupled   = importdata(dataname_coupled);
    Chemi_double_coupled = double(Chemi_file_coupled);
    
    % Mask bluff body region
    Chemi_double_coupled(319:421,1:185)   = 0;
    Chemi_double_coupled(216:529,185:262) = 0;
    Chemi_double_coupled(:,765:end)       = [];
    
    % Crop the outer boundaries
    Chemi_double_coupled(1:73,:)       = [];
    Chemi_double_coupled(end-72:end,:) = [];
    
    Chemi_double_reshaped(:,counter) ...
        = reshape(Chemi_double_coupled,tot_matrix_size,1);
end

chemi_fluc_matrix = (Chemi_double_reshaped - mean_chemi)...
    ./std_chemi;
inst_pq_matrix    = chemi_fluc_matrix .* pf_near_skip_norm(phase_index)';
phase_avgd_chemi  = mean(chemi_fluc_matrix,2);
phase_avgd_pq     = mean(inst_pq_matrix,2);

phase_avgd_chemi_reshaped = reshape(phase_avgd_chemi,...
        row_image,col_image);
phase_avgd_pq_reshaped    = reshape(phase_avgd_pq,...
        row_image,col_image);
    
end