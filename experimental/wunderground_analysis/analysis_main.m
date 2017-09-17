clear all
close all
clc

%% Selection
% dataset checks
plot_check = 0;
plot_day_speed_mean = 0;

% window
plot_speed_win = 0;
plot_dir_win = 0;
plot_speed_pdf_win = 1;
plot_dir_pdf_win = 1;
plot_u_pdf_win = 1;
plot_v_pdf_win = 1;
plot_uv_pdf_win = 0;
plot_ut_win = 0;

% day
plot_time_day = 0;
plot_speed_pdf_day = 0;
plot_dir_pdf_day = 0;
plot_u_pdf_day = 0;
plot_v_pdf_day = 0;
plot_uv_pdf_day = 0;
plot_ut_day = 0;

%% Setup
% data selection variables
% day range: (1500-2796)
df = 2796;  % current day
di = 2500;  % start day
d_filt = [2465];  % days with bad data to be ignored

% time range: (1-144)
tn = 160;  % current time (samples)
tw = 60;  % time window (samples)
tm = tn-tw;
tp = tn+tw;

% filter variables
speed_max = 20;  % m/s
speed_min = 0.2;  % m/s

% histogram bins
speed_bins = 25;
heading_bins = 30;
uv_bins = 35;

%% Load Data
load('~/flowfield/wind_measurements/wunderground/data.mat');
load('~/flowfield/wind_measurements/wunderground/data_size.mat');

%% Structure
% 1: year
% 2: month
% 3: day
% 4: hours
% 5: minutes
% 6: total minutes
% 7: temp [F]
% 8: dewpoint [F]
% 9: pressure [in]
% 10: wind direction [deg]
% 11: wind speed [MPH]
% 12: wind gust speed [MPH]
% 13: humidity
% 14: hourly precipitation [in]
% 15: daily rain [in]
% --------------------
% 16: x velocity [MPH] - angle transformed to positive CC, E=0 deg
% 17: y velocity [MPH] - angle transformed to positive CC, E=0 deg

% calculate velocity components and convert to m/s
for i=1:length(data)
    for j=1:data_size(i)
        data(i,j,11) = data(i,j,11)*0.44704;
        data(i,j,12) = data(i,j,12)*0.44704;
        data(i,j,16) = data(i,j,11)*cos(-(data(i,j,10)-90));
        data(i,j,17) = data(i,j,11)*sin(-(data(i,j,10)-90));
    end
end

analysis_check
analysis_day
analysis_window
%analysis_gp_test_day
%analysis_gp_test_win
%analysis_ut
analysis_figs
analysis_plot_win
analysis_plot_day