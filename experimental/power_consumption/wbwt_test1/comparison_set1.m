clear all
close all
clc

%% Setup
plot_pitch = 1;
plot_power = 1;
plot_thrust = 1;
plot_control_pitch = 1;

%% Load Data
listing{1} = '../flight_tests/2015-03-10_hd/lcmlog_2015_03_10_02.mat';  % hover
listing{2} = '../flight_tests/2015-03-09_wbwt/lcmlog_2015_03_09_04.mat';  % 5mph
listing{3} = '../flight_tests/2015-03-09_wbwt/lcmlog_2015_03_09_06.mat';  % 10mph
listing{4} = '../flight_tests/2015-03-09_wbwt/lcmlog_2015_03_09_08.mat';  % 15mph

start_time = [100,100,60,60];  % seconds into log file
stop_time = [450,300,105,70];  % seconds into log file

for i=1:length(listing)
    temp = load(listing{i});

    % skip hover data
    if i>1
        % wind speed
        wind_size(i) = length(temp.CV7_OUTPUT);
        wind_speed(i,1:wind_size(i)) = 0.5144*temp.CV7_OUTPUT(:,4);  % convert from knots to m/s
        wind_time(i,1:wind_size(i)) = temp.CV7_OUTPUT(:,7);
        wind_start(i) = find(wind_time(i,1:wind_size(i)) > start_time(i),1);
        wind_stop(i) = find(wind_time(i,1:wind_size(i)) > stop_time(i),1);
    end
    
    % get power size and time
    power_size(i) = length(temp.POWER_OUTPUT);
    power_time(i,1:power_size(i)) = temp.POWER_OUTPUT(:,5);
    power_start(i) = find(power_time(i,1:power_size(i)) > start_time(i),1);
    power_stop(i) = find(power_time(i,1:power_size(i)) > stop_time(i),1);
    power(i,1:power_size(i)) = temp.POWER_OUTPUT(:,4);
    
    % current
    current(i,1:power_size(i)) = temp.POWER_OUTPUT(:,2);
    
    % voltage
    voltage(i,1:power_size(i)) = temp.POWER_OUTPUT(:,3);
    
    % orientation
    state_size(i) = length(temp.STATE_ESTIMATOR_POSE);
    state_time(i,1:state_size(i)) = temp.STATE_ESTIMATOR_POSE(:,18);
    state_start(i) = find(state_time(i,1:state_size(i)) > start_time(i),1);
    state_stop(i) = find(state_time(i,1:state_size(i)) > stop_time(i),1);
    state_quat(i,1:state_size(i),1) = temp.STATE_ESTIMATOR_POSE(:,8);
    state_quat(i,1:state_size(i),2) = temp.STATE_ESTIMATOR_POSE(:,9);
    state_quat(i,1:state_size(i),3) = temp.STATE_ESTIMATOR_POSE(:,10);
    state_quat(i,1:state_size(i),4) = temp.STATE_ESTIMATOR_POSE(:,11);
    
    % control
    control_size(i) = length(temp.LQR_CONTROL);
    control_time(i,1:control_size(i)) = temp.LQR_CONTROL(:,15);
    control_start(i) = find(control_time(i,1:control_size(i)) > start_time(i),1);
    control_stop(i) = find(control_time(i,1:control_size(i)) > stop_time(i),1);
    control_rpyt(i,1:control_size(i),1) = rad2deg(temp.LQR_CONTROL(:,2));
    control_rpyt(i,1:control_size(i),2) = rad2deg(temp.LQR_CONTROL(:,3));
    control_rpyt(i,1:control_size(i),3) = rad2deg(temp.LQR_CONTROL(:,4));
    control_rpyt(i,1:control_size(i),4) = temp.LQR_CONTROL(:,5);
end

%% Analysis
% get rpy from quat
for i=1:length(listing)
    [yaw,pitch,roll] = quat2angle(squeeze(state_quat(i,1:state_size(i),1:4)));
    state_rpy(i,1:state_size(i),1:3) = rad2deg([roll,pitch,yaw]);
end

% find mean and std
for i=1:length(listing)
    power_mean(i) = mean(power(i,power_start(i):power_stop(i)));
    power_std(i) = std(power(i,power_start(i):power_stop(i)));
    power_stderr(i) = power_std(i)/sqrt(length(power(i,power_start(i):power_stop(i))));
    
    % no wind speed for hover
    if i>1
        wind_speed_mean(i) = mean(wind_speed(i,wind_start(i):wind_stop(i)));
        wind_speed_std(i) = std(wind_speed(i,wind_start(i):wind_stop(i)));
        wind_speed_stderr(i) = wind_speed_std(i)/sqrt(length(wind_speed(i,wind_start(i):wind_stop(i))));
    else
        wind_speed_mean(i) = 0;
        wind_speed_std(i) = 0;
        wind_speed_stderr(i) = 0;
    end
    
    % orientation
    state_rpy_mean(i,2) = mean(state_rpy(i,state_start(i):state_stop(i),2));
    state_rpy_std(i,2) = std(state_rpy(i,state_start(i):state_stop(i),2));
    state_rpy_stderr(i,2) = state_rpy_std(i)/sqrt(length(state_rpy(i,state_start(i):state_stop(i),2)));
    
    % control
    control_rpyt_mean(i,4) = mean(control_rpyt(i,control_start(i):control_stop(i),4));
    control_rpyt_std(i,4) = std(control_rpyt(i,control_start(i):control_stop(i),4));
end

% orientation offset
state_rpy_mean(:,2) = state_rpy_mean(:,2) - state_rpy_mean(1,2);

%% Plot
if plot_pitch
    figure
    hold on
    
    plot(wind_speed_mean,state_rpy_mean(:,2))
    errorbar(wind_speed_mean,state_rpy_mean(:,2),state_rpy_stderr(:,2))
    
    title('Pitch Vs. Air Speed')
    xlabel('Air Speed [m/s]')
    ylabel('Pitch [deg]')
    hold off
end

if plot_power
    figure
    hold on
    
    plot(wind_speed_mean,power_mean)
    errorbar(wind_speed_mean,power_mean,power_stderr)
    
    title('Power Vs. Air Speed')
    xlabel('Air Speed [m/s]')
    ylabel('Power [W]')
    hold off
end

if plot_thrust
    figure
    hold on
    
    plot(wind_speed_mean,control_rpyt_mean(:,4))
    errorbar(wind_speed_mean,control_rpyt_mean(:,4),control_rpyt_std(:,4))
    
    title('Thrust Command Vs. Air Speed')
    xlabel('Air Speed [m/s]')
    ylabel('Thrust Command')
    hold off
end

if plot_control_pitch
    trial = 4;
    
    figure
    hold on
    
    plot(control_time(trial,1:control_size(trial)),control_rpyt(trial,1:control_size(trial),2))
    
    title('Pitch Command Vs. Time')
    xlabel('Time [s]')
    ylabel('Pitch Command [deg]')
    hold off
end