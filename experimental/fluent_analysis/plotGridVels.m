%% Velocity Quiver
figure;
hold on

% plot mean velocity
quiver3(reg_pos_xyz(~obs_mask,1),reg_pos_xyz(~obs_mask,2),reg_pos_xyz(~obs_mask,3),reg_mean_vel_xyz(~obs_mask,1),reg_mean_vel_xyz(~obs_mask,2),reg_mean_vel_xyz(~obs_mask,3),'r');

% plot buildings
for i=1:length(obs_mask)
  if obs_mask(i)
    rectangle('position',[reg_pos_xyz(i,1)-xy_step/2, reg_pos_xyz(i,2)-xy_step/2, xy_step, xy_step],'FaceColor','k','EdgeColor','none');
  end
end

xlabel('X Position [m]')
ylabel('Y Position [m]')
title('2D Wind Velocity Over Domain')
axis([x_min,x_max,y_min,y_max])

if export_figs
  saveas(gcf,strcat(figure_path,'quiver.png'),'png')
end

hold off

%% X Velocity
figure
hold on

% plot mean velocity
% quiver3(reg_pos_xyz(~obs_mask,1),reg_pos_xyz(~obs_mask,2),reg_pos_xyz(~obs_mask,3),reg_mean_vel_xyz(~obs_mask,1),reg_mean_vel_xyz(~obs_mask,2),reg_mean_vel_xyz(~obs_mask,3),'r');
contourf(reg_pos_x_array,reg_pos_y_array,reg_mean_vel_x_array,1000,'LineColor','None')

% plot buildings
for i=1:length(obs_mask)
  if obs_mask(i)
    rectangle('position',[reg_pos_xyz(i,1)-xy_step/2, reg_pos_xyz(i,2)-xy_step/2, xy_step, xy_step],'FaceColor','k','EdgeColor','none');
  end
end

xlabel('X Position [m]')
ylabel('Y Position [m]')
title('Wind Field X Velocity Over Domain')
c = colorbar;
caxis([-5 5])
c.Label.String = 'Mean Velocity [m/s]';

if export_figs
  saveas(gcf,strcat(figure_path,'x_vel.png'),'png')
end

hold off

%% Y Velocity
figure
hold on

% plot mean velocity
% quiver3(reg_pos_xyz(~obs_mask,1),reg_pos_xyz(~obs_mask,2),reg_pos_xyz(~obs_mask,3),reg_mean_vel_xyz(~obs_mask,1),reg_mean_vel_xyz(~obs_mask,2),reg_mean_vel_xyz(~obs_mask,3),'r');
contourf(reg_pos_x_array,reg_pos_y_array,reg_mean_vel_y_array,1000,'LineColor','None')

% plot buildings
for i=1:length(obs_mask)
  if obs_mask(i)
    rectangle('position',[reg_pos_xyz(i,1)-xy_step/2, reg_pos_xyz(i,2)-xy_step/2, xy_step, xy_step],'FaceColor','k','EdgeColor','none');
  end
end

xlabel('X Position [m]')
ylabel('Y Position [m]')
title('Wind Field Y Velocity Over Domain')
c = colorbar;
caxis([-2 2])
c.Label.String = 'Mean Velocity [m/s]';

if export_figs
  saveas(gcf,strcat(figure_path,'y_vel.png'),'png')
end

hold off

%% Z Velocity
figure
hold on

% plot mean velocity
% quiver3(reg_pos_xyz(~obs_mask,1),reg_pos_xyz(~obs_mask,2),reg_pos_xyz(~obs_mask,3),reg_mean_vel_xyz(~obs_mask,1),reg_mean_vel_xyz(~obs_mask,2),reg_mean_vel_xyz(~obs_mask,3),'r');
contourf(reg_pos_x_array,reg_pos_y_array,reg_mean_vel_z_array,1000,'LineColor','None')

% plot buildings
for i=1:length(obs_mask)
  if obs_mask(i)
    rectangle('position',[reg_pos_xyz(i,1)-xy_step/2, reg_pos_xyz(i,2)-xy_step/2, xy_step, xy_step],'FaceColor','k','EdgeColor','none');
  end
end

xlabel('X Position [m]')
ylabel('Y Position [m]')
title('Wind Field Z Velocity Over Domain')
c = colorbar;
caxis([-3 1])
c.Label.String = 'Mean Velocity [m/s]';

if export_figs
  saveas(gcf,strcat(figure_path,'z_vel.png'),'png')
end

hold off