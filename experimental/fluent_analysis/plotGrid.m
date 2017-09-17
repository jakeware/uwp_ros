figure
hold on

plot3(reg_pos_xyz_free(:,1),reg_pos_xyz_free(:,2),reg_pos_xyz_free(:,3),'b*')
plot3(reg_pos_xyz_obs(:,1),reg_pos_xyz_obs(:,2),reg_pos_xyz_obs(:,3),'r*')

xlabel('X Position [m]')
ylabel('Y Position [m]')
title('Grid Positions Over 2D Domain')

hold off