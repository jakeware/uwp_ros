figure
hold on

% plot mean velocity
contourf(reg_pos_x_array,reg_pos_y_array,vert_dists_array,20,'LineColor','None')

% plot buildings
for i=1:length(obs_mask)
  if obs_mask(i)
    rectangle('position',[reg_pos_xyz(i,1)-xy_step/2, reg_pos_xyz(i,2)-xy_step/2, xy_step, xy_step],'FaceColor','w','EdgeColor','none');
  end
end

xlabel('X Position [m]')
ylabel('Y Position [m]')
title('Nearest Neighbor Distances Over Domain')
c = colorbar;
c.Label.String = 'Mean Velocity [m/s]';

hold off