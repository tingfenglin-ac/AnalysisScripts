function df_f0 = calculate_dFF0(F, baseline_range)
F0 = mean(F(:,baseline_range),2);
F0_mat = repmat(F0, [1, size(F,2)]);
df_f0 = (F - F0_mat) ./ F0_mat;
end