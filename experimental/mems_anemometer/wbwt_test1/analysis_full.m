clear all
close all
clc

%% Setup
plot_wind_mean = 0;
plot_wind_xpressure = 1;
plot_wind_ypressure = 1;
plot_wind_speed = 1;
plot_wind_angle = 1;
plot_wind_speed_pitch = 1;
plot_wind_angle_pitch = 1;

save_figures = 1;
figure_path = '~/ware_thesis_ms/figures/';

path{1} = '~/flowfield/mems_anemometer/wbwt_test1/wbwt_wspi_2015-08-18/';
path{2} = '~/flowfield/mems_anemometer/wbwt_test1/wbwt_wspi_2015-08-19/';
filename{1} = 'lcmlog_2015_08_18_';
filename{2} = 'lcmlog_2015_08_19_';
extension = '.mat';

%% No Props, Yaw 0
clearvars listing start_time stop_time file

listing{1,:} = {'02','04','08','16','26'};
listing{2,:} = {'00','12','24'};

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

wspi_noprops_yaw0 = wspi_calc(file,start_time,stop_time);

%% No Props, Yaw45
clearvars listing start_time stop_time file

listing{1,:} = {'06','10','19','28'};
listing{2,:} = {'03','15','26'};

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

wspi_noprops_yaw45 = wspi_calc(file,start_time,stop_time);

%% No Props, Yaw90
clearvars listing start_time stop_time file

listing{1,:} = {'13','21'};
listing{2,:} = {'06','18','28'};

count = 1;
for i=1:2
  for j=1:length(listing{i})
    file{count} = strcat(path{i},filename{i},listing{i}(j),extension);
    count = count + 1;
  end
end

% start and stop times
% 16 m/s
start_time(1) = 0;
stop_time(1) = 60;

% 14.5 m/s
start_time(2) = 0;
stop_time(2) = 85;

% 10 m/s
start_time(3) = 0;
stop_time(3) = 65;

% 8 m/s
start_time(4) = 0;
stop_time(4) = 65;

% 6 m/s
start_time(5) = 0;
stop_time(5) = 70;

wspi_noprops_yaw90 = wspi_calc(file,start_time,stop_time);

%% Props, Yaw0
clearvars listing start_time stop_time file

listing{1,:} = {'00','05','09','17','27'};
listing{2,:} = {'01','13','25'};

count = 1;
for i=1:2
  for j=1:length(listing{i})
    file{count} = strcat(path{i},filename{i},listing{i}(j),extension);
    count = count + 1;
  end
end

% start and stop times
% 25 m/s
start_time(1) = 10;
stop_time(1) = 90;

% 20 m/s
start_time(2) = 10;
stop_time(2) = 60;

% 16 m/s
start_time(3) = 10;
stop_time(3) = 70;

% 14.5 m/s
start_time(4) = 0;
stop_time(4) = 25;

% 12 m/s
start_time(5) = 10;
stop_time(5) = 100;

% 10 m/s
start_time(6) = 10;
stop_time(6) = 70;

% 8 m/s
start_time(7) = 10;
stop_time(7) = 70;

% 6 m/s
start_time(8) = 10;
stop_time(8) = 70;

wspi_props_yaw0 = wspi_calc(file,start_time,stop_time);

%% Props, Yaw45
clearvars listing start_time stop_time file

listing{1,:} = {'06','11','19','29'};
listing{2,:} = {'04','16','27'};

count = 1;
for i=1:2
  for j=1:length(listing{i})
    file{count} = strcat(path{i},filename{i},listing{i}(j),extension);
    count = count + 1;
  end
end

% start and stop times
% 20 m/s
start_time(1) = 85;
stop_time(1) = 115;

% 16 m/s
start_time(2) = 22;
stop_time(2) = 38;

% 14.5 m/s
start_time(3) = 10;
stop_time(3) = 60;

% 12 m/s
start_time(4) = 10;
stop_time(4) = 70;

% 10 m/s
start_time(5) = 10;
stop_time(5) = 70;

% 8 m/s
start_time(6) = 10;
stop_time(6) = 80;

% 6 m/s
start_time(7) = 10;
stop_time(7) = 90;

wspi_props_yaw45 = wspi_calc(file,start_time,stop_time);

%% Props, Yaw90
clearvars listing start_time stop_time file

listing{1,:} = {'14','22'};
listing{2,:} = {'07','19','29'};

count = 1;
for i=1:2
  for j=1:length(listing{i})
    file{count} = strcat(path{i},filename{i},listing{i}(j),extension);
    count = count + 1;
  end
end

% start and stop times
% 16 m/s
start_time(1) = 16;
stop_time(1) = 55;

% 14.5 m/s
start_time(2) = 5;
stop_time(2) = 60;

% 10 m/s
start_time(3) = 5;
stop_time(3) = 60;

% 8 m/s
start_time(4) = 5;
stop_time(4) = 60;

% 6 m/s
start_time(5) = 5;
stop_time(5) = 70;

wspi_props_yaw90 = wspi_calc(file,start_time,stop_time);

%% No Props, Yaw0, Pitch
clearvars listing start_time stop_time file

listing{1,:} = {'23','31'};  % 8/18
listing{2,:} = {'09','21','30'};  % 8/19

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

wspi_noprops_yaw0_pitch = wspi_calc(file,start_time,stop_time);

%% Props, Yaw0, Pitch
clearvars listing start_time stop_time file

listing{1,:} = {'24','33'};  % 8/18
listing{2,:} = {'10','22','31'};  % 8/19

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
stop_time(2) = 45;

% 10 m/s
start_time(3) = 0;
stop_time(3) = 65;

% 8 m/s
start_time(4) = 0;
stop_time(4) = 70;

% 6 m/s
start_time(5) = 0;
stop_time(5) = 130;

wspi_props_yaw0_pitch = wspi_calc(file,start_time,stop_time);

%% Plot
if plot_wind_xpressure
  figure
  hold on

  % props
  errorbar(wspi_props_yaw0.wind_mean,wspi_props_yaw0.pressure1_mean,wspi_props_yaw0.pressure1_stderr,'r*-','LineWidth',2)
  errorbar(wspi_props_yaw45.wind_mean,wspi_props_yaw45.pressure1_mean,wspi_props_yaw45.pressure1_stderr,'b*-','LineWidth',2)
%   errorbar(wspi_props_yaw90.wind_mean,wspi_props_yaw90.pressure1_mean,wspi_props_yaw90.pressure1_stderr,'b*-','LineWidth',2)
  
  % no props
  errorbar(wspi_noprops_yaw0.wind_mean,wspi_noprops_yaw0.pressure1_mean,wspi_noprops_yaw0.pressure1_stderr,'r*--','LineWidth',2)
  errorbar(wspi_noprops_yaw45.wind_mean,wspi_noprops_yaw45.pressure1_mean,wspi_noprops_yaw45.pressure1_stderr,'b*--','LineWidth',2)
%   errorbar(wspi_noprops_yaw90.wind_mean,wspi_noprops_yaw90.pressure1_mean,wspi_noprops_yaw90.pressure1_stderr,'b*--','LineWidth',2)
  

  title('Mean X-Pressure Vs. Mean Wind Speed')
  xlabel('Tunnel Wind Speed [m/s]')
  ylabel('X-Pressure [Pa]')
  legend('props, yaw0','props, yaw45','noprops, yaw0','noprops, yaw45','Location','NorthEast')
  hold off
  
  if save_figures
%     set(gcf,'units','inches','paperposition',[0 0 1 1])
    saveas(gcf,strcat(figure_path,'wspi_wind_xpressure.eps'),'epsc')
  end
end

if plot_wind_ypressure
  figure
  hold on

  % props
  errorbar(wspi_props_yaw0.wind_mean,wspi_props_yaw0.pressure2_mean,wspi_props_yaw0.pressure2_stderr,'r*-','LineWidth',2)
  errorbar(wspi_props_yaw45.wind_mean,wspi_props_yaw45.pressure2_mean,wspi_props_yaw45.pressure2_stderr,'b*-','LineWidth',2)
%   errorbar(wspi_props_yaw90.wind_mean,wspi_props_yaw90.pressure2_mean,wspi_props_yaw90.pressure2_stderr,'b*-','LineWidth',2)
  
  % no props
  errorbar(wspi_noprops_yaw0.wind_mean,wspi_noprops_yaw0.pressure2_mean,wspi_noprops_yaw0.pressure2_stderr,'r*--','LineWidth',2)
  errorbar(wspi_noprops_yaw45.wind_mean,wspi_noprops_yaw45.pressure2_mean,wspi_noprops_yaw45.pressure2_stderr,'b*--','LineWidth',2)
%   errorbar(wspi_noprops_yaw90.wind_mean,wspi_noprops_yaw90.pressure2_mean,wspi_noprops_yaw90.pressure2_stderr,'b*--','LineWidth',2)
  

  title('Mean Y-Pressure Vs. Mean Wind Speed')
  xlabel('Tunnel Wind Speed [m/s]')
  ylabel('Y-Pressure [Pa]')
  legend('props, yaw0','props, yaw45','noprops, yaw0','noprops, yaw45','Location','NorthEast')
  hold off
  
  if save_figures
%     set(gcf,'units','inches','paperposition',[0 0 1 1])
    saveas(gcf,strcat(figure_path,'wspi_wind_ypressure.eps'),'epsc')
  end
end

if plot_wind_speed
  figure
  hold on

  % props
  errorbar(wspi_props_yaw0.wind_mean,wspi_props_yaw0.speed_mean,wspi_props_yaw0.speed_stderr,'r*-','LineWidth',2)
  errorbar(wspi_props_yaw45.wind_mean,wspi_props_yaw45.speed_mean,wspi_props_yaw45.speed_stderr,'b*-','LineWidth',2)
%   errorbar(wspi_props_yaw90.wind_mean,wspi_props_yaw90.speed_mean,wspi_props_yaw90.speed_stderr,'b*-','LineWidth',2)
  
  % no props
  errorbar(wspi_noprops_yaw0.wind_mean,wspi_noprops_yaw0.speed_mean,wspi_noprops_yaw0.speed_stderr,'r*--','LineWidth',2)
  errorbar(wspi_noprops_yaw45.wind_mean,wspi_noprops_yaw45.speed_mean,wspi_noprops_yaw45.speed_stderr,'b*--','LineWidth',2)
%   errorbar(wspi_noprops_yaw90.wind_mean,wspi_noprops_yaw90.speed_mean,wspi_noprops_yaw90.speed_stderr,'b*--','LineWidth',2)
  
  % reference
  plot([5,30],[5,30],'k-.','LineWidth',2)

  title('Mean Measured Speed Vs. Mean Wind Speed')
  xlabel('Tunnel Wind Speed [m/s]')
  ylabel('Measured Speed [m/s]')
  legend('props, yaw0','props, yaw45','noprops, yaw0','noprops, yaw45','ideal','Location','NorthWest')
  axis([5,30,5,30])
  hold off
  
  if save_figures
%     set(gcf,'units','inches','paperposition',[0 0 1 1])
    saveas(gcf,strcat(figure_path,'wspi_wind_speed.eps'),'epsc')
  end
end

if plot_wind_angle
  figure
  hold on

    % props
  errorbar(wspi_props_yaw0.wind_mean,wspi_props_yaw0.angle_mean,wspi_props_yaw0.angle_stderr,'r*-','LineWidth',2)
  errorbar(wspi_props_yaw45.wind_mean,wspi_props_yaw45.angle_mean,wspi_props_yaw45.angle_stderr,'b*-','LineWidth',2)
%   errorbar(wspi_props_yaw90.wind_mean,wspi_props_yaw90.speed_mean,wspi_props_yaw90.speed_stderr,'b*-','LineWidth',2)
  
  % no props
  errorbar(wspi_noprops_yaw0.wind_mean,wspi_noprops_yaw0.angle_mean,wspi_noprops_yaw0.angle_stderr,'r*--','LineWidth',2)
  errorbar(wspi_noprops_yaw45.wind_mean,wspi_noprops_yaw45.angle_mean,wspi_noprops_yaw45.angle_stderr,'b*--','LineWidth',2)
%   errorbar(wspi_noprops_yaw90.wind_mean,wspi_noprops_yaw90.speed_mean,wspi_noprops_yaw90.speed_stderr,'b*--','LineWidth',2)

  % reference
  plot([5,30],[0,0],'k-.','LineWidth',2)
  plot([5,30],[45,45],'k--','LineWidth',2)

  title('Mean Measured Angle Vs. Mean Wind Speed')
  xlabel('Tunnel Wind Speed [m/s]')
  ylabel('Measured Wind Heading [deg]')
  legend('props, yaw0','props, yaw45','noprops, yaw0','noprops, yaw45','ideal0','ideal45','Location','NorthEast')
  axis([5,30,-5,50])
  hold off
  
  if save_figures
%     set(gcf,'units','inches','paperposition',[0 0 1 1])
    saveas(gcf,strcat(figure_path,'wspi_wind_angle.eps'),'epsc')
  end
end

if plot_wind_speed_pitch
  figure
  hold on

  % props
  errorbar(wspi_props_yaw0_pitch.wind_mean,wspi_props_yaw0_pitch.speed_mean,wspi_props_yaw0_pitch.speed_stderr,'r*-','LineWidth',2)
  
  % no props
  errorbar(wspi_noprops_yaw0_pitch.wind_mean,wspi_noprops_yaw0_pitch.speed_mean,wspi_noprops_yaw0_pitch.speed_stderr,'r*--','LineWidth',2)
  
  % reference
  plot([5,15],[5,15],'k-.','LineWidth',2)

  title('Pitched Mean Measured Speed Vs. Mean Wind Speed')
  xlabel('Tunnel Wind Speed [m/s]')
  ylabel('Measured Wind Speed [m/s]')
  legend('props, yaw0, pitch','noprops, yaw0, pitch','ideal','Location','NorthWest')
  axis([5,15,5,15])
  hold off
  
  if save_figures
%     set(gcf,'units','inches','paperposition',[0 0 1 1])
    saveas(gcf,strcat(figure_path,'wspi_wind_speed_pitch.eps'),'epsc')
  end
end

if plot_wind_angle_pitch
  figure
  hold on

    % props
  errorbar(wspi_props_yaw0.wind_mean,wspi_props_yaw0.angle_mean,wspi_props_yaw0.angle_stderr,'r*-','LineWidth',2)

  % no props
  errorbar(wspi_noprops_yaw0.wind_mean,wspi_noprops_yaw0.angle_mean,wspi_noprops_yaw0.angle_stderr,'r*--','LineWidth',2)

  % reference
  plot([5,30],[0,0],'k-.','LineWidth',2)

  title('Pitched Mean Measured Angle Vs. Mean Wind Speed')
  xlabel('Tunnel Wind Speed [m/s]')
  ylabel('Measured Wind Heading [deg]')
  legend('props, yaw0, pitch','noprops, yaw0, pitch','ideal','Location','NorthEast')
  axis([5,30,-5,5])
  hold off
  
  if save_figures
%     set(gcf,'units','inches','paperposition',[0 0 1 1])
    saveas(gcf,strcat(figure_path,'wspi_wind_angle_pitch.eps'),'epsc')
  end
end