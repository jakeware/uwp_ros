clear all
close all
clc

%% Setup
plot_wind = 0;
plot_wind_mean = 0;
plot_wind_voltage = 0;
plot_wind_pressure = 0;
plot_wind_angle = 1;
plot_wind_speed = 1;
save_data = 0;

% trial to plot
trial = 8;

% 2015-08-18
% 25 m/s, still, 0 yaw: 02 (speed good)
% 20 m/s, still, 0 yaw: 04 (speed good)
% 20 m/s, still, 45 yaw: 06 (thrust at 80 seconds)
% 16 m/s, still, 0 yaw: 08 (speed good after 20 seconds)
% 16 m/s, still, 45 yaw: 10
% 16 m/s, still, 90 yaw: 13
% 14.5 m/s, still, 0 yaw: 16 (speed good after 25 seconds)
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

path{1} = '~/flowfield/mems_anemometer/wbwt_test1/wbwt_wspi_2015-08-18/';
path{2} = '~/flowfield/mems_anemometer/wbwt_test1/wbwt_wspi_2015-08-19/';
filename{1} = 'lcmlog_2015_08_18_';
filename{2} = 'lcmlog_2015_08_19_';
listing{1,:} = {'02','04','08','16','26'};
listing{2,:} = {'00','12','24'};
extension = '.mat';

count = 1;
for i=1:2
  for j=1:length(listing{i})
    file{count} = strcat(path{i},filename{i},listing{i}(j),extension);
    count = count + 1;
  end
end

% start and stop times
% 25 m/s
start_time(1) = 0;
stop_time(1) = 60;

% 20 m/s
start_time(2) = 0;
stop_time(2) = 70;

% 16 m/s
start_time(3) = 20;
stop_time(3) = 100;

% 14.5 m/s
start_time(4) = 25;
stop_time(4) = 60;

% 12 m/s
start_time(5) = 30;
stop_time(5) = 70;

% 10 m/s
start_time(6) = 30;
stop_time(6) = 90;

% 8 m/s
start_time(7) = 25;
stop_time(7) = 75;

% 6 m/s
start_time(8) = 0;
stop_time(8) = 70;

%% Load Data
% read calibration
cal1 = dlmread('calibration/PV1_n.txt');
cal2 = dlmread('calibration/PV2_n.txt');

% read data
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
  wspi_pressure1(i,1:wspi_size(i)) = spline(cal1(:,2),cal1(:,1),wspi_voltage1(i,1:wspi_size(i)));
  wspi_pressure2(i,1:wspi_size(i)) = 1.18*spline(cal2(:,2),cal2(:,1),wspi_voltage2(i,1:wspi_size(i)));
  wspi_angle(i,1:wspi_size(i)) = rad2deg(atan2(wspi_pressure2(i,1:wspi_size(i)),-wspi_pressure1(i,1:wspi_size(i))));
  wspi_speed(i,1:wspi_size(i)) = 2.15*(wspi_pressure1(i,1:wspi_size(i)).^2 + wspi_pressure2(i,1:wspi_size(i)).^2).^0.235;
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
   
  % mean, std, stderr of wspi_speed
  wspi_speed_mean(i) = mean(wspi_speed(i,wspi_start(i):wspi_stop(i)));
  wspi_speed_std(i) = std(wspi_speed(i,wspi_start(i):wspi_stop(i)));
  wspi_speed_stderr(i) = wspi_speed_std(i)/sqrt(length(wspi_speed(i,wspi_start(i):wspi_stop(i))));

  % mean, std, stderr of wspi_angle
  wspi_angle_mean(i) = mean(wspi_angle(i,wspi_start(i):wspi_stop(i)));
  wspi_angle_std(i) = std(wspi_angle(i,wspi_start(i):wspi_stop(i)));
  wspi_angle_stderr(i) = wspi_angle_std(i)/sqrt(length(wspi_angle(i,wspi_start(i):wspi_stop(i))));  
  
  % match wind time to wspi time
  for j=wspi_start(i):wspi_stop(i)
    ind = find(wind_time(i,:) >= wspi_time(i,j),1);
    if ~isempty(ind)
      wind_wspi_time(i,j) = wind_time(i,ind);
      wind_wspi_ind(i,j) = ind;
    else
      wind_wspi_time(i,j) = wind_time(i,end);
      wind_wspi_ind(i,j) = wind_stop(i);
    end
  end
end

%% Save
if save_data
  save('wind_speed_noprops_yaw0_mean','wind_speed_mean');
  save('wspi_voltage1_noprops_yaw0_mean','wspi_voltage1_mean');
  save('wspi_voltage2_noprops_yaw0_mean','wspi_voltage2_mean');
  save('wind_speed_noprops_yaw0_std','wind_speed_std');
  save('wspi_voltage1_noprops_yaw0_std','wspi_voltage1_std');
  save('wspi_voltage2_noprops_yaw0_std','wspi_voltage2_std');
  save('wind_speed_noprops_yaw0_stderr','wind_speed_stderr');
  save('wspi_voltage1_noprops_yaw0_stderr','wspi_voltage1_stderr');
  save('wspi_voltage2_noprops_yaw0_stderr','wspi_voltage2_stderr');
end

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

if plot_wind_speed
  figure
  hold on

  errorbar(wind_speed_mean(:),wspi_speed_mean(:),wspi_speed_stderr(:),'r*-')

  title('Mean WSPI Speed Vs. Mean Wind Speed for 0 deg. Yaw')
  xlabel('Wind Speed [m/s]')
  ylabel('Speed [m/s]')
  legend('X','Y')
  hold off
end

if plot_wind_angle
  figure
  hold on

  errorbar(wind_speed_mean(:),wspi_angle_mean(:),wspi_angle_stderr(:),'r*-')

  title('Mean WSPI Angle Vs. Mean Wind Speed for 0 deg. Yaw')
  xlabel('Wind Speed [m/s]')
  ylabel('Angle [deg]')
  legend('X','Y')
  hold off
end
