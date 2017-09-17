clear all
close all
clc

%% Setup
% quad parameters
m = 2; % kg

% trajectory parameters
tf = 2;
dt = .005;
t = 0:dt:tf;

%% Start and End States
% Initial and final states
x0 = [0 0 0 0]';
xf = [4 0 0 -pi]';

% Initial and final derivatives
xd0 = [0 4 0 0]';
xdf = [0 -4 0 0]';

% Initial and final accelerations
xdd0 = [0 0 0 0]';
xddf = [0 0 0 0]';

% Initial and final jerk
xddd0 = [0 0 0 0]';
xdddf = [0 0 0 0]';

% Initial and final snap
xdddd0 = [0 0 0 0]';
xddddf = [0 0 0 0]';

%% Generate Trajectories
[traj,trajd,trajdd,trajddd,trajdddd] = generate_trajectory(tf, t, x0, xd0, xdd0, xddd0, xdddd0, xf, xdf, xddf, xdddf, xddddf);

xt = [traj{1};traj{2};traj{3}];
xdt = [trajd{1};trajd{2};trajd{3}];
a = [trajdd{1};trajdd{2};trajdd{3}];
adot = [trajddd{1};trajddd{2};trajddd{3}];
addot = [trajdddd{1};trajdddd{2};trajdddd{3}];
  
%% Compute Orientations
[xBt,yBt,zBt,Rt,wBt,wBtdot] = compute_orientations(t,m,a,adot,addot,traj,trajd,trajdd);

%% Simulate
q = simulate_quad(m,t,dt,x0,xd0,Rt,wBt,wBtdot,xt,xdt,a);

%% Plot
h1 = figure;
plot_trajectory(h1,traj,xBt,yBt,zBt,t)

h2 = figure;
plot_quad(h2,traj,xBt,yBt,zBt,q,t)