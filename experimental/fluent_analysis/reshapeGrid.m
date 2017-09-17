%% Reshape Grid Values
% mean
reg_mean_vel_x = reg_mean_vel_xyz(:,1);
reg_mean_vel_y = reg_mean_vel_xyz(:,2);
reg_mean_vel_z = reg_mean_vel_xyz(:,3);
reg_mean_vel_x_array = reshape(reg_mean_vel_xyz(:,1),size(reg_pos_x_array));
reg_mean_vel_y_array = reshape(reg_mean_vel_xyz(:,2),size(reg_pos_y_array));
reg_mean_vel_z_array = reshape(reg_mean_vel_xyz(:,3),size(reg_pos_z_array));

% variance
if strcmp(sol_type,'les') || strcmp(sol_type,'rsm')
  reg_cov_vel_xx = reg_cov_vel_xyz(:,1,1);
  reg_cov_vel_xy = reg_cov_vel_xyz(:,1,2);
  reg_cov_vel_xz = reg_cov_vel_xyz(:,1,3);
  reg_cov_vel_yx = reg_cov_vel_xyz(:,2,1);
  reg_cov_vel_yy = reg_cov_vel_xyz(:,2,2);
  reg_cov_vel_yz = reg_cov_vel_xyz(:,2,3);
  reg_cov_vel_zx = reg_cov_vel_xyz(:,3,1);
  reg_cov_vel_zy = reg_cov_vel_xyz(:,3,2);
  reg_cov_vel_zz = reg_cov_vel_xyz(:,3,3);
  reg_cov_vel_xx_array = reshape(reg_cov_vel_xyz(:,1,1),size(reg_pos_x_array));
  reg_cov_vel_yy_array = reshape(reg_cov_vel_xyz(:,2,2),size(reg_pos_x_array));
  reg_cov_vel_zz_array = reshape(reg_cov_vel_xyz(:,3,3),size(reg_pos_x_array));
end