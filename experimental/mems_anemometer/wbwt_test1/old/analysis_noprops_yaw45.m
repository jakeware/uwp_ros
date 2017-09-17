clear all
close all
clc

%% Setup
plot_wind = 0;
plot_wind_mean = 0;
plot_wind_voltage = 1;
plot_wind_pressure = 0;

% trial to plot
trial = 7;

% 2015-08-18
% 25 m/s, still, 0 yaw: 02
% 20 m/s, still, 0 yaw: 04
% 20 m/s, still, 45 yaw: 06
% 16 m/s, still, 0 yaw: 08
% 16 m/s, still, 45 yaw: 10
% 16 m/s, still, 90 yaw: 13
% 14.5 m/s, still, 0 yaw: 16
% 14.5 m/s, still, 45 yaw: 19
% 14.5 m/s, still, 90 yaw: 21
% 12 m/s, still, 0 yaw: 26
% 12 m/s, still, 45 yaw: 28
% 12 m/s, still, 90 yaw: NA

% 2015-08-19
% 10 m/s, still, 0 yaw: 00
% 10 m/s, still, 45 yaw: 03
% 10 m/s, still, 90 yaw: 06
% 8 m/s, still, 0 yaw: 12
% 8 m/s, still, 45 yaw: 15
% 8 m/s, still, 90 yaw: 18
% 6 m/s, still, 0 yaw: 24
% 6 m/s, still, 45 yaw: 26
% 6 m/s, still, 90 yaw: 28

path{1} = '../wbwt_wspi_2015-08-18/';
path{2} = '../wbwt_wspi_2015-08-19/';
filename{1} = 'lcmlog_2015_08_18_';
filename{2} = 'lcmlog_2015_08_19_';
listing{1,:} = {'06','10','19','28'};
listing{2,:} = {'03','15','26'};
extension = '.mat';

count = 1;
for i=1:2
  for j=1:length(listing{i})
    file{count} = strcat(path{i},filename{i},listing{i}(j),extension);
    count = count + 1;
  end
end

% start and stop times
% 20 m/s
start_time(1) = 0;
stop_time(1) = 150;

% 16 m/s
start_time(2) = 0;
stop_time(2) = 80;

% 14.5 m/s
start_time(3) = 0;
stop_time(3) = 70;

% 12 m/s
start_time(4) = 0;
stop_time(4) = 65;

% 10 m/s
start_time(5) = 0;
stop_time(5) = 65;

% 8 m/s
start_time(6) = 0;
stop_time(6) = 70;

% 6 m/s
start_time(7) = 0;
stop_time(7) = 70;

%% Load Data
for i=1:length(file)
  temp = load(file{i}{1},'CV7_OUTPUT','WSPI_DATA');

  % wind speed
  wind_size(i) = length(temp.CV7_OUTPUT);
  wind_speed(i,1:wind_size(i)) = 0.5144*temp.CV7_OUTPUT(:,4);  % convert from knots to m/s
  wind_time(i,1:wind_size(i)) = temp.CV7_OUTPUT(:,7);
  wind_start(i) = find(wind_time(i,1:wind_size(i)) > start_time(i),1);
  wind_stop(i) = find(wind_time(i,1:wind_size(i)) > stop_time(i),1);

  % wspi wind sensor
  wspi_size(i) = length(temp.WSPI_DATA);
  wspi_voltage1(i,1:wspi_size(i)) = temp.WSPI_DATA(:,2);  % convert from knots to m/s
  wspi_voltage2(i,1:wspi_size(i)) = temp.WSPI_DATA(:,3);
  wspi_pressure1(i,1:wspi_size(i)) = temp.WSPI_DATA(:,4);
  wspi_pressure2(i,1:wspi_size(i)) = temp.WSPI_DATA(:,5);
  wspi_time(i,1:wspi_size(i)) = temp.WSPI_DATA(:,8);
  wspi_start(i) = find(wspi_time(i,1:wspi_size(i)) > start_time(i),1);
  wspi_stop(i) = find(wspi_time(i,1:wspi_size(i)) > stop_time(i),1);
end

%% Analysis
for i=1:length(file)
  % mean, std, stderr of wind speed
  wind_speed_mean(i) = mean(wind_speed(i,wind_start(i):wind_stop(i)));
  wind_speed_std(i) = std(wind_speed(i,wind_start(i):wind_stop(i)));
  wind_speed_stderr(i) = wind_speed_std(i)/sqrt(length(wind_speed(i,wind_start(i):wind_stop(i))));
  
  % mean, std, stderr of wspi_voltage1
  wspi_voltage1_mean(i) = mean(wspi_voltage1(i,wspi_start(i):wspi_stop(i)));
  wspi_voltage1_std(i) = std(wspi_voltage1(i,wspi_start(i):wspi_stop(i)));
  wspi_voltage1_stderr(i) = wspi_voltage1_std(i)/sqrt(length(wspi_voltage1(i,wspi_start(i):wspi_stop(i))));
  
  % mean, std, stderr of wspi_voltage2
  wspi_voltage2_mean(i) = mean(wspi_voltage2(i,wspi_start(i):wspi_stop(i)));
  wspi_voltage2_std(i) = std(wspi_voltage2(i,wspi_start(i):wspi_stop(i)));
  wspi_voltage2_stderr(i) = wspi_voltage2_std(i)/sqrt(length(wspi_voltage2(i,wspi_start(i):wspi_stop(i))));
 
  % mean, std, stderr of wspi_pressure1
  wspi_pressure1_mean(i) = mean(wspi_pressure1(i,wspi_start(i):wspi_stop(i)));
  wspi_pressure1_std(i) = std(wspi_pressure1(i,wspi_start(i):wspi_stop(i)));
  wspi_pressure1_stderr(i) = wspi_pressure1_std(i)/sqrt(length(wspi_pressure1(i,wspi_start(i):wspi_stop(i))));
   
  % mean, std, stderr of wspi_pressure2
  wspi_pressure2_mean(i) = mean(wspi_pressure2(i,wspi_start(i):wspi_stop(i)));
  wspi_pressure2_std(i) = std(wspi_pressure2(i,wspi_start(i):wspi_stop(i)));
  wspi_pressure2_stderr(i) = wspi_pressure2_std(i)/sqrt(length(wspi_pressure2(i,wspi_start(i):wspi_stop(i))));
end

%% Save
save('wind_speed_noprops_yaw45_mean','wind_speed_mean');
save('wspi_voltage1_noprops_yaw45_mean','wspi_voltage1_mean');
save('wspi_voltage2_noprops_yaw45_mean','wspi_voltage2_mean');
save('wind_speed_noprops_yaw45_std','wind_speed_std');
save('wspi_voltage1_noprops_yaw45_std','wspi_voltage1_std');
save('wspi_voltage2_noprops_yaw45_std','wspi_voltage2_std');
save('wind_speed_noprops_yaw45_stderr','wind_speed_stderr');
save('wspi_voltage1_noprops_yaw45_stderr','wspi_voltage1_stderr');
save('wspi_voltage2_noprops_yaw45_stderr','wspi_voltage2_stderr');

%% Plot
if plot_wind
  figure
  hold on

  plot(wind_time(trial,1:wind_size(trial)),wind_speed(trial,1:wind_size(trial)))

  title('Wind Speed Vs. Time')
  xlabel('Time [s]')
  ylabel('Velocity [m/s]')
  hold off
end

if plot_wind_mean
  figure
  hold on

  errorbar(1:length(wind_speed_mean),wind_speed_mean,wind_speed_stderr,'-*')

  title('Mean Ground Truth Wind Speed Vs. Trial')
  xlabel('Trial')
  ylabel('Velocity [m/s]')
  hold off
end

if plot_wind_voltage
  figure
  hold on

  errorbar(wind_speed_mean(:),wspi_voltage1_mean(:),wspi_voltage1_stderr(:),'r*-')
  errorbar(wind_speed_mean(:),wspi_voltage2_mean(:),wspi_voltage2_stderr(:),'b*-')

  title('Mean WSPI Voltage Vs. Mean Wind Speed for 0 deg. Yaw')
  xlabel('Wind Speed [m/s]')
  ylabel('Votlage [V]')
  legend('V1','V2')
  hold off
end

if plot_wind_pressure
  figure
  hold on

  errorbar(wind_speed_mean(:),wspi_pressure1_mean(:),wspi_pressure1_stderr(:),'r*-')
  errorbar(wind_speed_mean(:),wspi_pressure2_mean(:),wspi_pressure2_stderr(:),'b*-')

  title('Mean WSPI Pressure Vs. Mean Wind Speed for 0 deg. Yaw')
  xlabel('Wind Speed [m/s]')
  ylabel('Pressure [Pa]')
  legend('P1','P2')
  hold off
end
