reg_mean_vel_xyz = zeros(size(reg_vel_xyz,2),3);
reg_cov_vel_xyz = zeros(size(reg_vel_xyz,2),3,3);
for i=1:size(reg_vel_xyz,2)
  % mark occupied regions as nan
  if ~obs_mask(i)
    % mean
    reg_mean_vel_xyz(i,1) = mean(reg_vel_xyz(:,i,1));
    reg_mean_vel_xyz(i,2) = mean(reg_vel_xyz(:,i,2));
    reg_mean_vel_xyz(i,3) = mean(reg_vel_xyz(:,i,3));

    % covariance
    if strcmp(sol_type,'les')
      reg_cov_vel_xyz(i,:,:) = cov(squeeze(reg_vel_xyz(:,i,:)));
    elseif strcmp(sol_type,'rsm')
      reg_cov_vel_xyz(:,1,1) = reg_rs_uu;
      reg_cov_vel_xyz(:,2,2) = reg_rs_vv;
      reg_cov_vel_xyz(:,3,3) = reg_rs_ww;
      reg_cov_vel_xyz(:,1,2) = reg_rs_uv;
      reg_cov_vel_xyz(:,2,3) = reg_rs_vw;
      reg_cov_vel_xyz(:,1,3) = reg_rs_uw;
      reg_cov_vel_xyz(:,2,1) = reg_rs_uv;
      reg_cov_vel_xyz(:,3,2) = reg_rs_vw;
      reg_cov_vel_xyz(:,3,1) = reg_rs_uw;
    end
  else
    % mean
    reg_mean_vel_xyz(i,1) = 0;
    reg_mean_vel_xyz(i,2) = 0;
    reg_mean_vel_xyz(i,3) = 0;

    % covariance
    if strcmp(sol_type,'les') || strcmp(sol_type,'rsm')
      reg_cov_vel_xyz(i,:,:) = zeros(3,3);
    end
  end
end