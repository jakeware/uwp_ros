clear all
close all
clc

%% Setup
% grid discretization
xy_step = 1;
% z_step = 1;  % unused

% 2d grid height
z_samp = 4;

% plot settings
plot_mesh = 0;
plot_obs = 0;
plot_node_vels = 0;
plot_grid_vels = 1;

% clear flags
clear_mesh = 0;
clear_data = 1;
clear_grid = 1;
clear_stats = 1;

% enable data output
export_data = 1;
export_figs = 1;

%% Data Paths
% steady
data_string = 'sol_it6000.csv';
project_path = '/home/jakeware/Dropbox/MIT/rrg/flow_field/fluent/exported_data/single_building_v2_comparison/steady_rsm_lps/';

% path to export solution files
data_path = strcat(project_path,'data/');

% path to export figures
figure_path = strcat(project_path,'figures/');

%% Check Export Paths
if ~exist(strcat(data_path),'dir')
  mkdir(data_path)
end

if ~exist(strcat(figure_path),'dir')
  mkdir(figure_path)
end

%% Load Mesh
display('Load Mesh')
tic
% check if data exists and load
if exist(strcat(data_path,'mesh_data.mat'),'file') && ~clear_mesh
  load(strcat(data_path,'mesh_data.mat'))
else
  mesh_data = mshread(strcat(project_path,'mesh_ascii.msh'), 1); % load file // show progress
  save(strcat(data_path,'mesh_data.mat'),'mesh_data');
end
toc

% Plot Mesh
if plot_mesh
  plotMesh
end

%% Load Data
display('Load Data')
tic
% check if data exists and load
if exist(strcat(data_path,'vel_xyz.mat'),'file') && ~clear_data
  load(strcat(data_path,'node_num.mat'))
  load(strcat(data_path,'pos_xyz.mat'))
  load(strcat(data_path,'vel_xyz.mat'))
else
  loadData
  save(strcat(data_path,'node_num.mat'),'node_num');
  save(strcat(data_path,'pos_xyz.mat'),'pos_xyz');
  save(strcat(data_path,'vel_xyz.mat'),'vel_xyz');
end
toc

% Plot Node Values
if plot_node_vels
  plotNodeVels
end

%% Get Grid Values
display('Interpolate Grid')
tic
% check if data exists and load
if exist(strcat(data_path,'reg_vel_xyz.mat'),'file') && ~clear_grid
  load(strcat(data_path,'reg_vel_xyz.mat'))
  load(strcat(data_path,'obs_mask.mat'))
else
  getObs
  regularizeGrid
  nearestGrid
  interpolateGrid
  save(strcat(data_path,'reg_vel_xyz.mat'),'reg_vel_xyz');
  save(strcat(data_path,'obs_mask.mat'),'obs_mask');
end
toc

if plot_obs
  plotGrid
end

%% Wind Field Statistics
display('Calculate Grid Statistics')
tic
% check if data exists and load
if exist(strcat(data_path,'reg_mean_vel_xyz.mat'),'file') && ~clear_stats
  load(strcat(data_path,'reg_mean_vel_xyz.mat'))
  load(strcat(data_path,'reg_cov_vel_xyz.mat'))
else
  getStatsGrid
  reshapeGrid
  save(strcat(data_path,'reg_mean_vel_xyz.mat'),'reg_mean_vel_xyz');
  save(strcat(data_path,'reg_cov_vel_xyz.mat'),'reg_cov_vel_xyz');
end
toc

% Plot Grid Values
if plot_grid_vels
  plotGridVels
  if strcmp(sol_type,'les') || strcmp(sol_type,'rsm')
    plotGridCovs
  end
end

%% Export
saveData  % save grid data in matrix