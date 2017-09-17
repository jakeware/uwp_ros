clear all
close all
clc

%% Setup
% end point parameters
rad = 2;  % action radius [m]
phi_delta = pi/8;  % angle step along action circle [rad]
phi_min = -pi/2;
phi_max = pi/2;
phi_range = phi_max - phi_min;
phi_vals = phi_min:phi_delta:phi_max;
speed_max = 8.5;
speeds = 0.5:0.5:speed_max;  % [m/s]

% quad parameters
m = 2; % kg

% simulation parameters
dt = .005;

%% Calculate Start and End Points
% iterate over final heading
for i=1:length(phi_vals)
  % iterate over delta velocity
  for j=1:(length(speeds)-1)
    % calculate final x value
    x0(:,i,j) = zeros(4,1);
    xf(:,i,j) = [rad*cos(phi_vals(i)) rad*sin(phi_vals(i)) 0 0]';
    xf(4,i,j) = atan2(xf(2,i,j),xf(1,i,j));
    
    % Initial and final derivatives
    xd0(:,i,j) = [speeds(j) 0 0 0]';
    xdf(:,i,j) = [speeds(j+1)*cos(phi_vals(i)) speeds(j+1)*sin(phi_vals(i)) 0 0]';

    % Initial and final accelerations
    xdd0(:,i,j) = [0 0 0 0]';
    xddf(:,i,j) = [0 0 0 0]';

    % Initial and final jerk
    xddd0(:,i,j) = [0 0 0 0]';
    xdddf(:,i,j) = [0 0 0 0]';

    % Initial and final snap
    xdddd0(:,i,j) = [0 0 0 0]';
    xddddf(:,i,j) = [0 0 0 0]';
    
    % time duration and vector
    tf(i,j) = rad/mean(speeds(j:j+1));
    t_temp = 0:dt:tf(i,j);
    t_size(i,j) = length(t_temp);
    t(1:t_size(i,j),i,j) = t_temp;
  end
end

%% Generate Trajectories
% iterate over final heading
for i=1:length(phi_vals)
  % iterate over delta velocity
  for j=1:(length(speeds)-1)
    [traj_temp,trajd_temp,trajdd_temp,trajddd_temp,trajdddd_temp] = generate_trajectory(tf(i,j), t(1:t_size(i,j),i,j)', x0(:,i,j), xd0(:,i,j), xdd0(:,i,j), xddd0(:,i,j), xdddd0(:,i,j), xf(:,i,j), xdf(:,i,j), xddf(:,i,j), xdddf(:,i,j), xddddf(:,i,j));
    
    for k=1:4
      traj(k,1:t_size(i,j),i,j) = traj_temp{k};
      trajd(k,1:t_size(i,j),i,j) = trajd_temp{k};
      trajdd(k,1:t_size(i,j),i,j) = trajdd_temp{k};
      trajddd(k,1:t_size(i,j),i,j) = trajddd_temp{k};
      trajdddd(k,1:t_size(i,j),i,j) = trajdddd_temp{k};
    end
    
    xt(:,1:t_size(i,j),i,j) = traj(1:3,1:t_size(i,j),i,j);
    xdt(:,1:t_size(i,j),i,j) = trajd(1:3,1:t_size(i,j),i,j);
    a(:,1:t_size(i,j),i,j) = trajdd(1:3,1:t_size(i,j),i,j);
    adot(:,1:t_size(i,j),i,j) = trajddd(1:3,1:t_size(i,j),i,j);
    addot(:,1:t_size(i,j),i,j) = trajdddd(1:3,1:t_size(i,j),i,j);
  
    %% Compute Orientations
    [xBt(:,1:t_size(i,j),i,j),yBt(:,1:t_size(i,j),i,j),zBt(:,1:t_size(i,j),i,j),Rt(:,:,1:t_size(i,j),i,j),wBt(:,1:t_size(i,j),i,j),wBtdot(:,1:t_size(i,j),i,j)] = compute_orientations(t(1:t_size(i,j),i,j)',m,a(:,1:t_size(i,j),i,j),adot(:,1:t_size(i,j),i,j),addot(:,1:t_size(i,j),i,j),traj(:,1:t_size(i,j),i,j),trajd(:,1:t_size(i,j),i,j),trajdd(:,1:t_size(i,j),i,j));

    %% Simulate
    q(:,1:t_size(i,j),i,j) = simulate_quad(m,t(1:t_size(i,j),i,j)',dt,x0(:,i,j),xd0(:,i,j),Rt,wBt(:,1:t_size(i,j),i,j),wBtdot(:,1:t_size(i,j),i,j),xt(:,1:t_size(i,j)),xdt(:,1:t_size(i,j)),a(:,1:t_size(i,j)));
  end
end

%% Plot Trajectories
h1 = figure;
hold on

for i=1:length(phi_vals)
  for j=1:(length(speeds)-1)
    % plot end points
    plot3(xf(1,i,j),xf(2,i,j),j,'kO')

    % trajectory
%     plot_trajectory(h1,traj(:,1:t_size(i,j),i,j),xBt(:,1:t_size(i,j),i,j),yBt(:,1:t_size(i,j),i,j),zBt(:,1:t_size(i,j),i,j),t(1:t_size(i,j),i,j)',0)
    plot3(traj(1,1:t_size(i,j),i,j),traj(2,1:t_size(i,j),i,j),j*ones(1,t_size(i,j)),'b-')
  end
end

view(30,20)
grid on
xlabel('X [m]')
ylabel('Y [m]')
zlabel('Initial Speed [m/s]')
title('Minimum-Snap Trajectories')
set(gcf,'defaultlinelinewidth',4)
axis(1.2*[-0.2*rad, rad, -rad, rad])
hold off

%% Simulation
% h2 = figure;
% plot_quad(h2,traj(:,1:t_size(i,j),i,j),xBt(:,1:t_size(i,j),i,j),yBt(:,1:t_size(i,j),i,j),zBt(:,1:t_size(i,j),i,j),q(:,1:t_size(i,j),i,j),t(1:t_size(i,j),i,j)')