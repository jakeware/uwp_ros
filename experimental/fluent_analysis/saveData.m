if export_data
  %% Vector (mat)
  % save(strcat(data_path,'reg_pos_x'),'reg_pos_x');
  % save(strcat(data_path,'reg_pos_y'),'reg_pos_y');
  % save(strcat(data_path,'reg_pos_z'),'reg_pos_z');
  % save(strcat(data_path,'reg_mean_vel_x'),'reg_mean_vel_x');
  % save(strcat(data_path,'reg_mean_vel_y'),'reg_mean_vel_y');
  % save(strcat(data_path,'reg_mean_vel_z'),'reg_mean_vel_z');
  % 
  % if unsteady_flag
  %   save(strcat(data_path,'reg_cov_vel_x'),'reg_cov_vel_x');
  %   save(strcat(data_path,'reg_cov_vel_y'),'reg_cov_vel_y');
  %   save(strcat(data_path,'reg_cov_vel_z'),'reg_cov_vel_z');
  % end

  %% Vector (ascii)
  csvwrite(strcat(data_path,'grid_size.csv'),grid_size);
  csvwrite(strcat(data_path,'xy_step.csv'),xy_step);
  csvwrite(strcat(data_path,'z_samp.csv'),z_samp);
  csvwrite(strcat(data_path,'obs_mask.csv'),obs_mask);
  csvwrite(strcat(data_path,'reg_pos_x.csv'),reg_pos_x);
  csvwrite(strcat(data_path,'reg_pos_y.csv'),reg_pos_y);
  csvwrite(strcat(data_path,'reg_pos_z.csv'),reg_pos_z);
  csvwrite(strcat(data_path,'reg_mean_vel_x.csv'),reg_mean_vel_x);
  csvwrite(strcat(data_path,'reg_mean_vel_y.csv'),reg_mean_vel_y);
  csvwrite(strcat(data_path,'reg_mean_vel_z.csv'),reg_mean_vel_z);

  if strcmp(sol_type,'les') || strcmp(sol_type,'rsm')
    csvwrite(strcat(data_path,'reg_cov_vel_xx.csv'),reg_cov_vel_xx);
    csvwrite(strcat(data_path,'reg_cov_vel_xy.csv'),reg_cov_vel_xy);
    csvwrite(strcat(data_path,'reg_cov_vel_xz.csv'),reg_cov_vel_xz);
    csvwrite(strcat(data_path,'reg_cov_vel_yx.csv'),reg_cov_vel_yx);
    csvwrite(strcat(data_path,'reg_cov_vel_yy.csv'),reg_cov_vel_yy);
    csvwrite(strcat(data_path,'reg_cov_vel_yz.csv'),reg_cov_vel_yz);
    csvwrite(strcat(data_path,'reg_cov_vel_zx.csv'),reg_cov_vel_zx);
    csvwrite(strcat(data_path,'reg_cov_vel_zy.csv'),reg_cov_vel_zy);
    csvwrite(strcat(data_path,'reg_cov_vel_zz.csv'),reg_cov_vel_zz);
  end

  %% Array (mat)
  % save(strcat(data_path,'reg_pos_x_array'),'reg_pos_x_array');
  % save(strcat(data_path,'reg_pos_y_array'),'reg_pos_y_array');
  % save(strcat(data_path,'reg_pos_z_array'),'reg_pos_z_array');
  % save(strcat(data_path,'reg_mean_vel_x_array'),'reg_mean_vel_x_array');
  % save(strcat(data_path,'reg_mean_vel_y_array'),'reg_mean_vel_y_array');
  % save(strcat(data_path,'reg_mean_vel_z_array'),'reg_mean_vel_z_array');
  % 
  % if unsteady_flag
  %   save(strcat(data_path,'reg_cov_vel_xyz_tot_array'),'reg_cov_vel_xyz_tot_array');
  % end
end