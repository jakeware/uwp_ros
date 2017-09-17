function result = wspi_calc(file,start_time,stop_time)

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
    wspi_angle(i,1:wspi_size(i)) = -rad2deg(atan2(wspi_pressure2(i,1:wspi_size(i)),-wspi_pressure1(i,1:wspi_size(i))));
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

%     % match wind time to wspi time
%     for j=wspi_start(i):wspi_stop(i)
%       ind = find(wind_time(i,:) >= wspi_time(i,j),1);
%       if ~isempty(ind)
%         wind_wspi_time(i,j) = wind_time(i,ind);
%         wind_wspi_ind(i,j) = ind;
%       else
%         wind_wspi_time(i,j) = wind_time(i,end);
%         wind_wspi_ind(i,j) = wind_stop(i);
%       end
%     end
  end
  
  %% Assignment
  result.wind_mean = wind_speed_mean;
  result.wind_std = wind_speed_std;
  result.wind_stderr = wind_speed_stderr;
  result.voltage1_mean = wspi_voltage1_mean;
  result.voltage1_std = wspi_voltage1_std;
  result.voltage1_stderr = wspi_voltage1_stderr;
  result.voltage2_mean = wspi_voltage2_mean;
  result.voltage2_std = wspi_voltage2_std;
  result.voltage2_stderr = wspi_voltage2_stderr;
  result.pressure1_mean = wspi_pressure1_mean;
  result.pressure1_std = wspi_pressure1_std;
  result.pressure1_stderr = wspi_pressure1_stderr;
  result.pressure2_mean = wspi_pressure2_mean;
  result.pressure2_std = wspi_pressure2_std;
  result.pressure2_stderr = wspi_pressure2_stderr;
  result.speed_mean = wspi_speed_mean;
  result.speed_std = wspi_speed_std;
  result.speed_stderr = wspi_speed_stderr;
  result.angle_mean = wspi_angle_mean;
  result.angle_std = wspi_angle_std;
  result.angle_stderr = wspi_angle_stderr;
end