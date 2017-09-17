%% Regularize Grid
% get bounds
x_min = min(pos_xyz(:,1));
x_max = max(pos_xyz(:,1));
grid_x_samp = x_min:xy_step:x_max;

y_min = min(pos_xyz(:,2));
y_max = max(pos_xyz(:,2));
grid_y_samp = y_min:xy_step:y_max;

z_min = min(pos_xyz(:,3));
z_max = max(pos_xyz(:,3));
% grid_z_samp = z_min:z_step:z_max;
grid_z_samp = z_samp;

% get size
grid_size = [length(grid_x_samp),length(grid_y_samp),length(grid_z_samp)]';

% get points
[reg_pos_x_array, reg_pos_y_array, reg_pos_z_array] = meshgrid(grid_x_samp, grid_y_samp, grid_z_samp);
reg_pos_x = reshape(reg_pos_x_array,[size(reg_pos_x_array,1)*size(reg_pos_x_array,2)*size(reg_pos_x_array,3),1]);
reg_pos_y = reshape(reg_pos_y_array,[size(reg_pos_y_array,1)*size(reg_pos_y_array,2)*size(reg_pos_y_array,3),1]);
reg_pos_z = reshape(reg_pos_z_array,[size(reg_pos_z_array,1)*size(reg_pos_z_array,2)*size(reg_pos_z_array,3),1]);
reg_pos_xyz = [reg_pos_x,reg_pos_y,reg_pos_z];

% remove points in obstacle region
obs_mask = zeros(size(reg_pos_xyz,1),1);
delta_obs = 0.01;
for i=1:size(obs_max_xyz,1)
  % find points in obstacle region
  c1 = reg_pos_xyz(:,1) <= obs_max_xyz(i,1) + delta_obs;
  c2 = reg_pos_xyz(:,1) >= obs_min_xyz(i,1) - delta_obs;
  c3 = reg_pos_xyz(:,2) <= obs_max_xyz(i,2) + delta_obs;
  c4 = reg_pos_xyz(:,2) >= obs_min_xyz(i,2) - delta_obs;
  c5 = reg_pos_xyz(:,3) <= obs_max_xyz(i,3) + delta_obs;
  c6 = reg_pos_xyz(:,3) >= obs_min_xyz(i,3) - delta_obs;
  
  % get points for debugging
  obs_points = reg_pos_xyz(c1 & c2 & c3 & c4 & c5 & c6,:);

  % add to obstacle mask
  obs_mask = obs_mask | (c1 & c2 & c3 & c4 & c5 & c6);
  obs_mask_array = reshape(obs_mask,size(reg_pos_x_array));
  obs_mask_array_nan = zeros(size(obs_mask_array));
  obs_mask_array_nan(obs_mask_array) = nan;
end

% remove points
reg_pos_xyz_free = reg_pos_xyz(~obs_mask,:);
reg_pos_xyz_obs = reg_pos_xyz(obs_mask,:);