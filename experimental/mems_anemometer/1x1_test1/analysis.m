clear all
close all
clc

%% Setup
select = 0;  % dataset to plot
save_files = 1;  % save data to files
plot_cv7_yaw0 = 1;
plot_cv7_yaw45 = 1;
plot_wspi_yaw0 = 1;
plot_wspi_yaw45 = 1;
plot_wspi_yaw0_voltage = 1;
plot_wspi_yaw45_voltage = 1;


%% Ground Truth [m/s]
cv7_yaw0_target_speed = [3,5,8,10,15,20];
cv7_yaw0_pitot_speed = [3.1293,4.91,8.0467,9.8777,14.7523,19.6186];
cv7_yaw0_hot_wire_speed = [2.94,4.5,7.7,10.7,17,22.5];

cv7_yaw45_target_speed = [0,3,8,15];
cv7_yaw45_pitot_speed = [0,3.1293,8.0467,14.7523];
cv7_yaw45_hot_wire_speed = [0,2.97,8.3,17.1];

wspi_yaw0_target_speed = [0,3,5,8,10,15,20];
wspi_yaw0_pitot_speed = [0,3.1293,4.91,8.0467,9.875,14.7523,19.6186];
wspi_yaw0_hot_wire_speed = [0,2.97,5.22,8.32,11.2,17,22.5];

wspi_yaw0_plate_target_speed = [3,8,15];
wspi_yaw0_plate_pitot_speed = [3.1293,8.0467,14.7523];
wspi_yaw0_plate_hot_wire_speed = [3,8.32,17];

wspi_yaw45_plate_target_speed = [3,8,15];
wspi_yaw45_plate_pitot_speed = [3.1293,8.0467,14.7523];
wspi_yaw45_plate_hot_wire_speed = [3,8.32,17.1];


%% Sensor: ultrasonic (cv7), Yaw: 0, Props: Off
path = './1x1_cv7_2016-02-10/';
filename = 'lcmlog_2016_02_10_';
listing = {'00','02','04','06','08','10'};
extension = '.mat';

clear('file')
for i=1:length(listing)
  file{i} = strcat(path,filename,listing{i},extension);
end

% load
for i=1:length(file)
  temp = load(file{i},'CV7_OUTPUT'); 

  cv7_yaw0_off_size(i) = length(temp.CV7_OUTPUT);
  cv7_yaw0_off_speed(i,1:cv7_yaw0_off_size(i)) = 0.5144*temp.CV7_OUTPUT(:,4);  % convert from knots to m/s
  cv7_yaw0_off_time(i,1:cv7_yaw0_off_size(i)) = temp.CV7_OUTPUT(:,7);
end

% parse
for i=1:length(file)
  % mean, std, stderr of cv7 speed
  cv7_yaw0_off_speed_mean(i) = mean(cv7_yaw0_off_speed(i,1:cv7_yaw0_off_size(i)));
  cv7_yaw0_off_speed_std(i) = std(cv7_yaw0_off_speed(i,1:cv7_yaw0_off_size(i)));
  cv7_yaw0_off_speed_stderr(i) = cv7_yaw0_off_speed_std(i)/sqrt(length(cv7_yaw0_off_speed(i,1:cv7_yaw0_off_size(i))));
end


%% Sensor: ultrasonic (cv7), Yaw: 0, Props: On
path = './1x1_cv7_2016-02-10/';
filename = 'lcmlog_2016_02_10_';
listing = {'01','03','05','07','09','11'};
extension = '.mat';

clear('file')
for i=1:length(listing)
  file{i} = strcat(path,filename,listing{i},extension);
end

% load
for i=1:length(file)
  temp = load(file{i},'CV7_OUTPUT'); 

  cv7_yaw0_on_size(i) = length(temp.CV7_OUTPUT);
  cv7_yaw0_on_speed(i,1:cv7_yaw0_on_size(i)) = 0.5144*temp.CV7_OUTPUT(:,4);  % convert from knots to m/s
  cv7_yaw0_on_time(i,1:cv7_yaw0_on_size(i)) = temp.CV7_OUTPUT(:,7);
end

% parse
for i=1:length(file)
  % mean, std, stderr of cv7 speed
  cv7_yaw0_on_speed_mean(i) = mean(cv7_yaw0_on_speed(i,1:cv7_yaw0_on_size(i)));
  cv7_yaw0_on_speed_std(i) = std(cv7_yaw0_on_speed(i,1:cv7_yaw0_on_size(i)));
  cv7_yaw0_on_speed_stderr(i) = cv7_yaw0_on_speed_std(i)/sqrt(length(cv7_yaw0_on_speed(i,1:cv7_yaw0_on_size(i))));
end


%% Sensor: ultrasonic (cv7), Yaw: 45, Props: Off
path = './1x1_cv7_2016-02-10/';
filename = 'lcmlog_2016_02_10_';
listing = {'38','40','42','44'};
extension = '.mat';

clear('file')
for i=1:length(listing)
  file{i} = strcat(path,filename,listing{i},extension);
end

% load
for i=1:length(file)
  temp = load(file{i},'CV7_OUTPUT'); 

  cv7_yaw45_off_size(i) = length(temp.CV7_OUTPUT);
  cv7_yaw45_off_speed(i,1:cv7_yaw45_off_size(i)) = 0.5144*temp.CV7_OUTPUT(:,4);  % convert from knots to m/s
  cv7_yaw45_off_time(i,1:cv7_yaw45_off_size(i)) = temp.CV7_OUTPUT(:,7);
end

% parse
for i=1:length(file)
  % mean, std, stderr of cv7 speed
  cv7_yaw45_off_speed_mean(i) = mean(cv7_yaw45_off_speed(i,1:cv7_yaw45_off_size(i)));
  cv7_yaw45_off_speed_std(i) = std(cv7_yaw45_off_speed(i,1:cv7_yaw45_off_size(i)));
  cv7_yaw45_off_speed_stderr(i) = cv7_yaw45_off_speed_std(i)/sqrt(length(cv7_yaw45_off_speed(i,1:cv7_yaw45_off_size(i))));
end


%% Sensor: ultrasonic (cv7), Yaw: 45, Props: On
path = './1x1_cv7_2016-02-10/';
filename = 'lcmlog_2016_02_10_';
listing = {'39','41','43','45'};
extension = '.mat';

clear('file')
for i=1:length(listing)
  file{i} = strcat(path,filename,listing{i},extension);
end

% load
for i=1:length(file)
  temp = load(file{i},'CV7_OUTPUT'); 

  cv7_yaw45_on_size(i) = length(temp.CV7_OUTPUT);
  cv7_yaw45_on_speed(i,1:cv7_yaw45_on_size(i)) = 0.5144*temp.CV7_OUTPUT(:,4);  % convert from knots to m/s
  cv7_yaw45_on_time(i,1:cv7_yaw45_on_size(i)) = temp.CV7_OUTPUT(:,7);
end

% parse
for i=1:length(file)
  % mean, std, stderr of cv7 speed
  cv7_yaw45_on_speed_mean(i) = mean(cv7_yaw45_on_speed(i,1:cv7_yaw45_on_size(i)));
  cv7_yaw45_on_speed_std(i) = std(cv7_yaw45_on_speed(i,1:cv7_yaw45_on_size(i)));
  cv7_yaw45_on_speed_stderr(i) = cv7_yaw45_on_speed_std(i)/sqrt(length(cv7_yaw45_on_speed(i,1:cv7_yaw45_on_size(i))));
end


%% Sensor: mems (unipi, wspi), Yaw: 0 deg, Props: Off
path = './1x1_wspi_2016-02-10/';
filename = 'lcmlog_2016_02_10_';
listing = {'12','14','16','18','20','22','24'};
extension = '.mat';

clear('file')
for i=1:length(listing)
  file{i} = strcat(path,filename,listing{i},extension);
end

% load
for i=1:length(file)
  temp = load(file{i},'WSPI_DATA'); 

  wspi_yaw0_off_size(i) = length(temp.WSPI_DATA);
  wspi_yaw0_off_voltage1(i,1:wspi_yaw0_off_size(i)) = temp.WSPI_DATA(:,2);
  wspi_yaw0_off_voltage2(i,1:wspi_yaw0_off_size(i)) = temp.WSPI_DATA(:,3);
  wspi_yaw0_off_time(i,1:wspi_yaw0_off_size(i)) = temp.WSPI_DATA(:,8);
end

% parse
for i=1:length(file)
  % mean, std, stderr of wspi_voltage1
  wspi_yaw0_off_voltage1_mean(i) = mean(wspi_yaw0_off_voltage1(i,1:wspi_yaw0_off_size(i)));
  wspi_yaw0_off_voltage1_std(i) = std(wspi_yaw0_off_voltage1(i,1:wspi_yaw0_off_size(i)));
  wspi_yaw0_off_voltage1_stderr(i) = wspi_yaw0_off_voltage1_std(i)/sqrt(length(wspi_yaw0_off_voltage1(i,1:wspi_yaw0_off_size(i))));
  
  % mean, std, stderr of wspi_voltage2
  wspi_yaw0_off_voltage2_mean(i) = mean(wspi_yaw0_off_voltage2(i,1:wspi_yaw0_off_size(i)));
  wspi_yaw0_off_voltage2_std(i) = std(wspi_yaw0_off_voltage2(i,1:wspi_yaw0_off_size(i)));
  wspi_yaw0_off_voltage2_stderr(i) = wspi_yaw0_off_voltage2_std(i)/sqrt(length(wspi_yaw0_off_voltage2(i,1:wspi_yaw0_off_size(i))));
end


%% Sensor: mems (unipi, wspi), Yaw: 0 deg, Props: On
path = './1x1_wspi_2016-02-10/';
filename = 'lcmlog_2016_02_10_';
listing = {'13','15','17','19','21','23','25'};
extension = '.mat';

clear('file')
for i=1:length(listing)
  file{i} = strcat(path,filename,listing{i},extension);
end

% load
for i=1:length(file)
  temp = load(file{i},'WSPI_DATA'); 

  wspi_yaw0_on_size(i) = length(temp.WSPI_DATA);
  wspi_yaw0_on_voltage1(i,1:wspi_yaw0_on_size(i)) = temp.WSPI_DATA(:,2);
  wspi_yaw0_on_voltage2(i,1:wspi_yaw0_on_size(i)) = temp.WSPI_DATA(:,3);
  wspi_yaw0_on_time(i,1:wspi_yaw0_on_size(i)) = temp.WSPI_DATA(:,8);
end

% parse
for i=1:length(file)
  % mean, std, stderr of wspi_voltage1
  wspi_yaw0_on_voltage1_mean(i) = mean(wspi_yaw0_on_voltage1(i,1:wspi_yaw0_on_size(i)));
  wspi_yaw0_on_voltage1_std(i) = std(wspi_yaw0_on_voltage1(i,1:wspi_yaw0_on_size(i)));
  wspi_yaw0_on_voltage1_stderr(i) = wspi_yaw0_on_voltage1_std(i)/sqrt(length(wspi_yaw0_on_voltage1(i,1:wspi_yaw0_on_size(i))));
  
  % mean, std, stderr of wspi_voltage2
  wspi_yaw0_on_voltage2_mean(i) = mean(wspi_yaw0_on_voltage2(i,1:wspi_yaw0_on_size(i)));
  wspi_yaw0_on_voltage2_std(i) = std(wspi_yaw0_on_voltage2(i,1:wspi_yaw0_on_size(i)));
  wspi_yaw0_on_voltage2_stderr(i) = wspi_yaw0_on_voltage2_std(i)/sqrt(length(wspi_yaw0_on_voltage2(i,1:wspi_yaw0_on_size(i))));
end


%% Sensor: mems (unipi, wspi), Yaw: 0 deg, Props: Off, Plate: On
path = './1x1_wspi_2016-02-10/';
filename = 'lcmlog_2016_02_10_';
listing = {'30','26','28'};
extension = '.mat';

clear('file')
for i=1:length(listing)
  file{i} = strcat(path,filename,listing{i},extension);
end

% load
for i=1:length(file)
  temp = load(file{i},'WSPI_DATA'); 

  wspi_yaw0_off_plate_size(i) = length(temp.WSPI_DATA);
  wspi_yaw0_off_plate_voltage1(i,1:wspi_yaw0_off_plate_size(i)) = temp.WSPI_DATA(:,2);
  wspi_yaw0_off_plate_voltage2(i,1:wspi_yaw0_off_plate_size(i)) = temp.WSPI_DATA(:,3);
  wspi_yaw0_off_plate_time(i,1:wspi_yaw0_off_plate_size(i)) = temp.WSPI_DATA(:,8);
end

% parse
for i=1:length(file)
  % mean, std, stderr of wspi_voltage1
  wspi_yaw0_off_plate_voltage1_mean(i) = mean(wspi_yaw0_off_plate_voltage1(i,1:wspi_yaw0_off_plate_size(i)));
  wspi_yaw0_off_plate_voltage1_std(i) = std(wspi_yaw0_off_plate_voltage1(i,1:wspi_yaw0_off_plate_size(i)));
  wspi_yaw0_off_plate_voltage1_stderr(i) = wspi_yaw0_off_plate_voltage1_std(i)/sqrt(length(wspi_yaw0_off_plate_voltage1(i,1:wspi_yaw0_off_plate_size(i))));
  
  % mean, std, stderr of wspi_voltage2
  wspi_yaw0_off_plate_voltage2_mean(i) = mean(wspi_yaw0_off_plate_voltage2(i,1:wspi_yaw0_off_plate_size(i)));
  wspi_yaw0_off_plate_voltage2_std(i) = std(wspi_yaw0_off_plate_voltage2(i,1:wspi_yaw0_off_plate_size(i)));
  wspi_yaw0_off_plate_voltage2_stderr(i) = wspi_yaw0_off_plate_voltage2_std(i)/sqrt(length(wspi_yaw0_off_plate_voltage2(i,1:wspi_yaw0_off_plate_size(i))));
end


%% Sensor: mems (unipi, wspi), Yaw: 0 deg, Props: On, Plate: On
path = './1x1_wspi_2016-02-10/';
filename = 'lcmlog_2016_02_10_';
listing = {'31','27','29'};
extension = '.mat';

clear('file')
for i=1:length(listing)
  file{i} = strcat(path,filename,listing{i},extension);
end

% load
for i=1:length(file)
  temp = load(file{i},'WSPI_DATA'); 

  wspi_yaw0_on_plate_size(i) = length(temp.WSPI_DATA);
  wspi_yaw0_on_plate_voltage1(i,1:wspi_yaw0_on_plate_size(i)) = temp.WSPI_DATA(:,2);
  wspi_yaw0_on_plate_voltage2(i,1:wspi_yaw0_on_plate_size(i)) = temp.WSPI_DATA(:,3);
  wspi_yaw0_on_plate_time(i,1:wspi_yaw0_on_plate_size(i)) = temp.WSPI_DATA(:,8);
end

% parse
for i=1:length(file)
  % mean, std, stderr of wspi_voltage1
  wspi_yaw0_on_plate_voltage1_mean(i) = mean(wspi_yaw0_on_plate_voltage1(i,1:wspi_yaw0_on_plate_size(i)));
  wspi_yaw0_on_plate_voltage1_std(i) = std(wspi_yaw0_on_plate_voltage1(i,1:wspi_yaw0_on_plate_size(i)));
  wspi_yaw0_on_plate_voltage1_stderr(i) = wspi_yaw0_on_plate_voltage1_std(i)/sqrt(length(wspi_yaw0_on_plate_voltage1(i,1:wspi_yaw0_on_plate_size(i))));
  
  % mean, std, stderr of wspi_voltage2
  wspi_yaw0_on_plate_voltage2_mean(i) = mean(wspi_yaw0_on_plate_voltage2(i,1:wspi_yaw0_on_plate_size(i)));
  wspi_yaw0_on_plate_voltage2_std(i) = std(wspi_yaw0_on_plate_voltage2(i,1:wspi_yaw0_on_plate_size(i)));
  wspi_yaw0_on_plate_voltage2_stderr(i) = wspi_yaw0_on_plate_voltage2_std(i)/sqrt(length(wspi_yaw0_on_plate_voltage2(i,1:wspi_yaw0_on_plate_size(i))));
end


%% Sensor: mems (unipi, wspi), Yaw: 45 deg, Props: Off, Plate: On
path = './1x1_wspi_2016-02-10/';
filename = 'lcmlog_2016_02_10_';
listing = {'32','34','36'};
extension = '.mat';

clear('file')
for i=1:length(listing)
  file{i} = strcat(path,filename,listing{i},extension);
end

% load
for i=1:length(file)
  temp = load(file{i},'WSPI_DATA'); 

  wspi_yaw45_off_plate_size(i) = length(temp.WSPI_DATA);
  wspi_yaw45_off_plate_voltage1(i,1:wspi_yaw45_off_plate_size(i)) = temp.WSPI_DATA(:,2);
  wspi_yaw45_off_plate_voltage2(i,1:wspi_yaw45_off_plate_size(i)) = temp.WSPI_DATA(:,3);
  wspi_yaw45_off_plate_time(i,1:wspi_yaw45_off_plate_size(i)) = temp.WSPI_DATA(:,8);
end

% parse
for i=1:length(file)
  % mean, std, stderr of wspi_voltage1
  wspi_yaw45_off_plate_voltage1_mean(i) = mean(wspi_yaw45_off_plate_voltage1(i,1:wspi_yaw45_off_plate_size(i)));
  wspi_yaw45_off_plate_voltage1_std(i) = std(wspi_yaw45_off_plate_voltage1(i,1:wspi_yaw45_off_plate_size(i)));
  wspi_yaw45_off_plate_voltage1_stderr(i) = wspi_yaw45_off_plate_voltage1_std(i)/sqrt(length(wspi_yaw45_off_plate_voltage1(i,1:wspi_yaw45_off_plate_size(i))));
  
  % mean, std, stderr of wspi_voltage2
  wspi_yaw45_off_plate_voltage2_mean(i) = mean(wspi_yaw45_off_plate_voltage2(i,1:wspi_yaw45_off_plate_size(i)));
  wspi_yaw45_off_plate_voltage2_std(i) = std(wspi_yaw45_off_plate_voltage2(i,1:wspi_yaw45_off_plate_size(i)));
  wspi_yaw45_off_plate_voltage2_stderr(i) = wspi_yaw45_off_plate_voltage2_std(i)/sqrt(length(wspi_yaw45_off_plate_voltage2(i,1:wspi_yaw45_off_plate_size(i))));
end


%% Sensor: mems (unipi, wspi), Yaw: 45 deg, Props: On, Plate: On
path = './1x1_wspi_2016-02-10/';
filename = 'lcmlog_2016_02_10_';
listing = {'33','35','37'};
extension = '.mat';

clear('file')
for i=1:length(listing)
  file{i} = strcat(path,filename,listing{i},extension);
end

% load
for i=1:length(file)
  temp = load(file{i},'WSPI_DATA'); 

  wspi_yaw45_on_plate_size(i) = length(temp.WSPI_DATA);
  wspi_yaw45_on_plate_voltage1(i,1:wspi_yaw45_on_plate_size(i)) = temp.WSPI_DATA(:,2);
  wspi_yaw45_on_plate_voltage2(i,1:wspi_yaw45_on_plate_size(i)) = temp.WSPI_DATA(:,3);
  wspi_yaw45_on_plate_time(i,1:wspi_yaw45_on_plate_size(i)) = temp.WSPI_DATA(:,8);
end

% parse
for i=1:length(file)
  % mean, std, stderr of wspi_voltage1
  wspi_yaw45_on_plate_voltage1_mean(i) = mean(wspi_yaw45_on_plate_voltage1(i,1:wspi_yaw45_on_plate_size(i)));
  wspi_yaw45_on_plate_voltage1_std(i) = std(wspi_yaw45_on_plate_voltage1(i,1:wspi_yaw45_on_plate_size(i)));
  wspi_yaw45_on_plate_voltage1_stderr(i) = wspi_yaw45_on_plate_voltage1_std(i)/sqrt(length(wspi_yaw45_on_plate_voltage1(i,1:wspi_yaw45_on_plate_size(i))));
  
  % mean, std, stderr of wspi_voltage2
  wspi_yaw45_on_plate_voltage2_mean(i) = mean(wspi_yaw45_on_plate_voltage2(i,1:wspi_yaw45_on_plate_size(i)));
  wspi_yaw45_on_plate_voltage2_std(i) = std(wspi_yaw45_on_plate_voltage2(i,1:wspi_yaw45_on_plate_size(i)));
  wspi_yaw45_on_plate_voltage2_stderr(i) = wspi_yaw45_on_plate_voltage2_std(i)/sqrt(length(wspi_yaw45_on_plate_voltage2(i,1:wspi_yaw45_on_plate_size(i))));
end


%% Save Data
vars = {
  'cv7_yaw0_target_speed',
  'cv7_yaw0_pitot_speed',
  'cv7_yaw0_hot_wire_speed',
  'cv7_yaw45_target_speed',
  'cv7_yaw45_pitot_speed',
  'cv7_yaw45_hot_wire_speed',
  'wspi_yaw0_target_speed',
  'wspi_yaw0_pitot_speed',
  'wspi_yaw0_hot_wire_speed',
  'wspi_yaw0_plate_target_speed',
  'wspi_yaw0_plate_pitot_speed',
  'wspi_yaw0_plate_hot_wire_speed',
  'wspi_yaw45_plate_target_speed',
  'wspi_yaw45_plate_pitot_speed',
  'wspi_yaw45_plate_hot_wire_speed',
  
  % cv7, props off, yaw 0
  'cv7_yaw0_off_speed_mean',
  'cv7_yaw0_off_speed_std',
  'cv7_yaw0_off_speed_stderr',
  
  % cv7, props on, yaw 0
  'cv7_yaw0_on_speed_mean',
  'cv7_yaw0_on_speed_std',
  'cv7_yaw0_on_speed_stderr',
  
  % cv7, props off, yaw 45
  'cv7_yaw45_off_speed_mean',
  'cv7_yaw45_off_speed_std',
  'cv7_yaw45_off_speed_stderr',
  
  % cv7, props on, yaw 45
  'cv7_yaw45_on_speed_mean',
  'cv7_yaw45_on_speed_std',
  'cv7_yaw45_on_speed_stderr',
  
  % wspi, props off, plate off, yaw 0
  'wspi_yaw0_off_voltage1_mean',
  'wspi_yaw0_off_voltage1_std',
  'wspi_yaw0_off_voltage1_stderr',
  'wspi_yaw0_off_voltage2_mean',
  'wspi_yaw0_off_voltage2_std',
  'wspi_yaw0_off_voltage2_stderr',
  
  % wspi, props on, plate off, yaw 0
  'wspi_yaw0_on_voltage1_mean',
  'wspi_yaw0_on_voltage1_std',
  'wspi_yaw0_on_voltage1_stderr',
  'wspi_yaw0_on_voltage2_mean',
  'wspi_yaw0_on_voltage2_std',
  'wspi_yaw0_on_voltage2_stderr',
  
  % wspi, props off, plate on, yaw 0
  'wspi_yaw0_off_plate_voltage1_mean',
  'wspi_yaw0_off_plate_voltage1_std',
  'wspi_yaw0_off_plate_voltage1_stderr',
  'wspi_yaw0_off_plate_voltage2_mean',
  'wspi_yaw0_off_plate_voltage2_std',
  'wspi_yaw0_off_plate_voltage2_stderr',
  
  % wspi, props on, plate on, yaw 0
  'wspi_yaw0_on_plate_voltage1_mean',
  'wspi_yaw0_on_plate_voltage1_std',
  'wspi_yaw0_on_plate_voltage1_stderr',
  'wspi_yaw0_on_plate_voltage2_mean',
  'wspi_yaw0_on_plate_voltage2_std',
  'wspi_yaw0_on_plate_voltage2_stderr',
  
  % wspi, props off, plate on, yaw 45
  'wspi_yaw45_off_plate_voltage1_mean',
  'wspi_yaw45_off_plate_voltage1_std',
  'wspi_yaw45_off_plate_voltage1_stderr',
  'wspi_yaw45_off_plate_voltage2_mean',
  'wspi_yaw45_off_plate_voltage2_std',
  'wspi_yaw45_off_plate_voltage2_stderr',
  
  % wspi, props on, plate on, yaw 45
  'wspi_yaw45_on_plate_voltage1_mean',
  'wspi_yaw45_on_plate_voltage1_std',
  'wspi_yaw45_on_plate_voltage1_stderr',
  'wspi_yaw45_on_plate_voltage2_mean',
  'wspi_yaw45_on_plate_voltage2_std',
  'wspi_yaw45_on_plate_voltage2_stderr',
  };

if save_files
    paths = cell(strcat('./data/',vars));
  
  for i=1:length(vars)
    save(paths{i},vars{i});
  end
end

%% Plot Ultrasonic Time
if select
  figure
  hold on
  
  plot(cv7_yaw0_off_time(select,1:cv7_yaw0_off_size(select)),cv7_yaw0_off_speed(select,1:cv7_yaw0_off_size(select)),'r*-')
  plot(cv7_yaw0_on_time(select,1:cv7_yaw0_on_size(select)),cv7_yaw0_on_speed(select,1:cv7_yaw0_on_size(select)),'b*-')
  
  xlabel('Time [s]')
  ylabel('Wind Speed [m/s]')
  legend('props on','props off')
  
  hold off
end


%% Plot Ultrasonic, Yaw 0
if plot_cv7_yaw0
  figure
  hold on

  errorbar(cv7_yaw0_target_speed,cv7_yaw0_off_speed_mean,cv7_yaw0_off_speed_std,'r*-')
  errorbar(cv7_yaw0_target_speed,cv7_yaw0_on_speed_mean,cv7_yaw0_on_speed_std,'b*-')
  plot(cv7_yaw0_target_speed,cv7_yaw0_hot_wire_speed,'go-')
  plot(cv7_yaw0_target_speed,cv7_yaw0_pitot_speed,'mo-')
  plot([0,25],[0,25],'k--')

  title('Measured Vs Target Wind Speed for 0 deg Yaw')
  xlabel('Target Wind Speed [m/s]')
  ylabel('Wind Speed [m/s]')
  legend('ultrasonic - std','ultrasonic, props on - std','hotwire','pitot','Location','NorthWest')
  axis([0,25,0,25])

  hold off
end


%% Plot Ultrasonic, Yaw 45
if plot_cv7_yaw45
  figure
  hold on

  errorbar(cv7_yaw45_target_speed,cv7_yaw45_off_speed_mean,cv7_yaw45_off_speed_std,'r*-')
  errorbar(cv7_yaw45_target_speed,cv7_yaw45_on_speed_mean,cv7_yaw45_on_speed_std,'b*-')
  
  plot(cv7_yaw45_target_speed,cv7_yaw45_hot_wire_speed,'go-')
  plot(cv7_yaw45_target_speed,cv7_yaw45_pitot_speed,'mo-')
  plot([0,25],[0,25],'k--')

  title('Measured Vs Target Wind Speed for 45 deg Yaw')
  xlabel('Target Wind Speed [m/s]')
  ylabel('Wind Speed [m/s]')
  legend('ultrasonic - std','ultrasonic, props - std','hotwire','pitot','Location','NorthWest')
  axis([0,25,0,25])

  hold off
end


%% Plot WSPI, Yaw 0
if plot_wspi_yaw0_voltage
  figure
  hold on

  % props off, plate off
  errorbar(wspi_yaw0_target_speed,wspi_yaw0_off_voltage1_mean,wspi_yaw0_off_voltage1_std,'r*-')
  errorbar(wspi_yaw0_target_speed,wspi_yaw0_off_voltage2_mean,wspi_yaw0_off_voltage2_std,'b*-')
  
  % props on, plate off
  errorbar(wspi_yaw0_target_speed,wspi_yaw0_on_voltage1_mean,wspi_yaw0_on_voltage1_std,'r*--')
  errorbar(wspi_yaw0_target_speed,wspi_yaw0_on_voltage2_mean,wspi_yaw0_on_voltage2_std,'b*--')
  
  % props off, plate on
  errorbar(wspi_yaw0_plate_target_speed,wspi_yaw0_off_plate_voltage1_mean,wspi_yaw0_off_plate_voltage1_std,'g*-')
  errorbar(wspi_yaw0_plate_target_speed,wspi_yaw0_off_plate_voltage2_mean,wspi_yaw0_off_plate_voltage2_std,'m*-')
  
  % props on, plate on
  errorbar(wspi_yaw0_plate_target_speed,wspi_yaw0_on_plate_voltage1_mean,wspi_yaw0_on_plate_voltage1_std,'g*--')
  errorbar(wspi_yaw0_plate_target_speed,wspi_yaw0_on_plate_voltage2_mean,wspi_yaw0_on_plate_voltage2_std,'m*--')

  title('WSPI Voltage Vs. Target Wind Speed for 0 deg Yaw')
  xlabel('Targert Wind Speed [m/s]')
  ylabel('Sensor Votlage [V]')
  legend('V1 - std','V2 - std','V1, props - std','V2, props - std','V1, plate - std','V2, plate - std','V1, props, plate - std','V2, props, plate - std','Location','SouthWest')
  hold off
end


%% Plot WSPI, Yaw 45
if plot_wspi_yaw45_voltage
  figure
  hold on

  % props off
  errorbar(wspi_yaw45_plate_target_speed,wspi_yaw45_off_plate_voltage1_mean,wspi_yaw45_off_plate_voltage1_std,'r*-')
  errorbar(wspi_yaw45_plate_target_speed,wspi_yaw45_off_plate_voltage2_mean,wspi_yaw45_off_plate_voltage2_std,'b*-')
  
  % props on
  errorbar(wspi_yaw45_plate_target_speed,wspi_yaw45_on_plate_voltage1_mean,wspi_yaw45_on_plate_voltage1_std,'r*--')
  errorbar(wspi_yaw45_plate_target_speed,wspi_yaw45_on_plate_voltage2_mean,wspi_yaw45_on_plate_voltage2_std,'b*--')

  title('WSPI Voltage Vs. Target Wind Speed for 45 deg Yaw')
  xlabel('Target Wind Speed [m/s]')
  ylabel('Sensor Votlage [V]')
  legend('V1, plate - std','V2, plate - std','V1, props, plate - std','V2, props, plate - std','Location','SouthWest')
  hold off
end
