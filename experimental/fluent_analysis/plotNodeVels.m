%% Plot Node Velocities
figure
hold on

% plot node locations
scatter3(pos_xyz_raw(:,1),pos_xyz_raw(:,2),pos_xyz_raw(:,3),'r.')

% plot sorted velocity
quiver3(pos_xyz_raw(:,1),pos_xyz_raw(:,2),pos_xyz_raw(:,3),vel_xyz_raw(:,1),vel_xyz_raw(:,2),vel_xyz_raw(:,3),0.5,'b')

% plot unsorted velocity
quiver3(pos_xyz(:,1),pos_xyz(:,2),pos_xyz(:,3),vel_xyz(:,1),vel_xyz(:,2),vel_xyz(:,3),1,'r')

% axis([-150, 50, -50, 50, 55, 65])
hold off
