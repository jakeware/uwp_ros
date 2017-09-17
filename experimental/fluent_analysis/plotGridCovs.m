%% X Variance
figure
hold on

% plot velocity variance
contourf(reg_pos_x_array,reg_pos_y_array,reg_cov_vel_xx_array,1000,'LineColor','None')

% plot buildings
for i=1:length(obs_mask)
  if obs_mask(i)
    rectangle('position',[reg_pos_xyz(i,1)-xy_step/2, reg_pos_xyz(i,2)-xy_step/2, xy_step, xy_step],'FaceColor','k','EdgeColor','none');
  end
end

xlabel('X Position [m]')
ylabel('Y Position [m]')
title('Wind Field X Variance Over Domain')
c = colorbar;
% caxis([0 3])
% c.Label.String = 'Variance [(m/s)^2]';

if export_figs
  saveas(gcf,strcat(figure_path,'xx_var.png'),'png')
end

hold off

%% Y Variance
figure
hold on

% plot velocity variance
contourf(reg_pos_x_array,reg_pos_y_array,reg_cov_vel_yy_array,1000,'LineColor','None')

% plot buildings
for i=1:length(obs_mask)
  if obs_mask(i)
    rectangle('position',[reg_pos_xyz(i,1)-xy_step/2, reg_pos_xyz(i,2)-xy_step/2, xy_step, xy_step],'FaceColor','k','EdgeColor','none');
  end
end

xlabel('X Position [m]')
ylabel('Y Position [m]')
title('Wind Field Y Variance Over Domain')
c = colorbar;
% caxis([0 3])
% c.Label.String = 'Variance [(m/s)^2]';

if export_figs
  saveas(gcf,strcat(figure_path,'yy_var.png'),'png')
end

hold off

%% Z Variance
figure
hold on

% plot velocity variance
contourf(reg_pos_x_array,reg_pos_y_array,reg_cov_vel_zz_array,1000,'LineColor','None')

% plot buildings
for i=1:length(obs_mask)
  if obs_mask(i)
    rectangle('position',[reg_pos_xyz(i,1)-xy_step/2, reg_pos_xyz(i,2)-xy_step/2, xy_step, xy_step],'FaceColor','k','EdgeColor','none');
  end
end

xlabel('X Position [m]')
ylabel('Y Position [m]')
title('Wind Field Z Variance Over Domain')
c = colorbar;
% caxis([0 3])
% c.Label.String = 'Variance [(m/s)^2]';

if export_figs
  saveas(gcf,strcat(figure_path,'zz_var.png'),'png')
end

hold off