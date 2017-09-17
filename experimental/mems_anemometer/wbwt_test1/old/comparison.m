clear all
close all
clc

%% Setup


%% Load
temp = load('wind_speed_noprops_yaw0.mat');
wind_speed_noprops_yaw0 = temp.wind_speed_mean;
temp = load('wspi_voltage1_noprops_yaw0.mat');
wspi_voltage1_noprops_yaw0 = temp.wspi_voltage1_mean;
temp = load('wspi_voltage2_noprops_yaw0.mat');
wspi_voltage2_noprops_yaw0 = temp.wspi_voltage2_mean;

temp = load('wind_speed_noprops_yaw45.mat');
wind_speed_noprops_yaw45 = temp.wind_speed_mean;
temp = load('wspi_voltage1_noprops_yaw45.mat');
wspi_voltage1_noprops_yaw45 = temp.wspi_voltage1_mean;
temp = load('wspi_voltage2_noprops_yaw45.mat');
wspi_voltage2_noprops_yaw45 = temp.wspi_voltage2_mean;

temp = load('wind_speed_noprops_yaw90.mat');
wind_speed_noprops_yaw90 = temp.wind_speed_mean;
temp = load('wspi_voltage1_noprops_yaw90.mat');
wspi_voltage1_noprops_yaw90 = temp.wspi_voltage1_mean;
temp = load('wspi_voltage2_noprops_yaw90.mat');
wspi_voltage2_noprops_yaw90 = temp.wspi_voltage2_mean;

%% Plot
figure
hold on

% yaw 0
plot(wind_speed_noprops_yaw0,wspi_voltage1_noprops_yaw0,'r*-','LineWidth',2)
plot(wind_speed_noprops_yaw0,wspi_voltage2_noprops_yaw0,'ro--','LineWidth',2)

% yaw 45
plot(wind_speed_noprops_yaw45,wspi_voltage1_noprops_yaw45,'g*-','LineWidth',2)
plot(wind_speed_noprops_yaw45,wspi_voltage2_noprops_yaw45,'go--','LineWidth',2)

% yaw 90
plot(wind_speed_noprops_yaw90,wspi_voltage1_noprops_yaw90,'b*-','LineWidth',2)
plot(wind_speed_noprops_yaw90,wspi_voltage2_noprops_yaw90,'bo--','LineWidth',2)

title('WSPI Output Voltage Vs. Wind Speed for No Thrust Condition')
xlabel('Wind Speed [m/s]')
ylabel('Voltage [V]')
legend('V1, 0 yaw','V2, 0 yaw','V1, 45 yaw','V2, 45 yaw','V1, 90 yaw','V2, 90 yaw','Location','SouthWest')

hold off