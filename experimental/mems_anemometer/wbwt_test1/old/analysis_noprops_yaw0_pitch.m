clear all
close all
clc

%% Setup
plot_wind_time = 0;
plot_wind_mean = 0;
plot_wind_voltage = 1;
plot_wind_pressure = 0;

% trial to plot
trial = 1;

% 2015-08-18
% 14.5 m/s, thrust, 0 yaw: 00, 40 pitch: 23
% 12 m/s, thrust, 0 yaw: 00, 30  pitch: 31

% 2015-08-19
% 10 m/s, thrust, 0 yaw: 00, 22.9 pitch: 9
% 8 m/s, thrust, 0 yaw: 00, 16.8 pitch: 21
% 6 m/s, thrust, 0 yaw: 00, 11.5 pitch: 30

path{1} = '../wbwt_wspi_2015-08-18/';
path{2} = '../wbwt_wspi_2015-08-19/';
filename{1} = 'lcmlog_2015_08_18_';
filename{2} = 'lcmlog_2015_08_19_';
listing{1,:} = {'23','31'};  % 8/18
listing{2,:} = {'09','21','30'};  % 8/19
extension = '.mat';

count = 1;
for i=1:2
  for j=1:length(listing{i})
    file{count} = strcat(path{i},filename{i},listing{i}(j),extension);
    count = count + 1;
  end
end

% start and stop times
% 14.5 m/s
start_time(1) = 0;
stop_time(1) = 65;

% 12 m/s
start_time(2) = 0;
stop_time(2) = 85;

% 10 m/s
start_time(3) = 0;
stop_time(3) = 60;

% 8 m/s
start_time(4) = 0;
stop_time(4) = 80;

% 6 m/s
start_time(5) = 0;
stop_time(5) = 60;


%% Load Data
for i=1:length(file)
  temp = load(file{i}{1},'CV7_OUTPUT','WSPI_DATA','ASCTEC_CTRL_COMMAND','RPYT_ND_COMMAND','ASCTEC_STATUS','ASCTEC_RC_DATA'); 

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
  
  control_size(i) = length(temp.ASCTEC_CTRL_COMMAND);
  control_thrust(i,1:control_size(i)) = temp.ASCTEC_CTRL_COMMAND(:,5);
  control_enable(i,1:control_size(i)) = temp.ASCTEC_CTRL_COMMAND(:,8);
  control_time(i,1:control_size(i)) = temp.ASCTEC_CTRL_COMMAND(:,9);
  control_start(i) = find(control_time(i,1:control_size(i)) > start_time(i),1);
  control_stop(i) = find(control_time(i,1:control_size(i)) > stop_time(i),1);
  
  rc_size(i) = length(temp.ASCTEC_RC_DATA);
  rc_thrust(i,1:rc_size(i)) = temp.ASCTEC_RC_DATA(:,6);
  rc_enable(i,1:rc_size(i)) = temp.ASCTEC_RC_DATA(:,5);
  rc_time(i,1:rc_size(i)) = temp.ASCTEC_RC_DATA(:,10);
  rc_start(i) = find(rc_time(i,1:rc_size(i)) > start_time(i),1);
  rc_stop(i) = find(rc_time(i,1:rc_size(i)) > stop_time(i),1);
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
save('wind_speed_noprops_yaw0_pitch_mean','wind_speed_mean');
save('wspi_voltage1_noprops_yaw0_pitch_mean','wspi_voltage1_mean');
save('wspi_voltage2_noprops_yaw0_pitch_mean','wspi_voltage2_mean');
save('wind_speed_noprops_yaw0_pitch_std','wind_speed_std');
save('wspi_voltage1_noprops_yaw0_pitch_std','wspi_voltage1_std');
save('wspi_voltage2_noprops_yaw0_pitch_std','wspi_voltage2_std');
save('wind_speed_noprops_yaw0_pitch_stderr','wind_speed_stderr');
save('wspi_voltage1_noprops_yaw0_pitch_stderr','wspi_voltage1_stderr');
save('wspi_voltage2_noprops_yaw0_pitch_stderr','wspi_voltage2_stderr');

%% Plot
if plot_wind_time
  figure
  hold on

  plot(wind_time(trial,1:wind_size(trial)),wind_speed(trial,1:wind_size(trial)))
  plot(rc_time(trial,1:rc_size(trial)),rc_thrust(trial,1:rc_size(trial))/1024)
  plot(rc_time(trial,1:rc_size(trial)),rc_enable(trial,1:rc_size(trial))/1024)
  plot(control_time(trial,1:control_size(trial)),control_enable(trial,1:control_size(trial)))

  title('Wind Speed Vs. Time')
  xlabel('Time [s]')
  legend('Wind Speed','RC Thrust','RC Enable','Control Enable','Location','SouthEast')
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
