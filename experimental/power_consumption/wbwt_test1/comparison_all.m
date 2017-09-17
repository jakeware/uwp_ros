clear all
close all
clc

%% TODO
% add horizontal error bars
% add power model

%% Setup
% plotting
plot_pitch = 0;
plot_power = 0;
plot_norm_power = 1;
plot_thrust = 0;
plot_rc_pitch = 0;
plot_rc_thrust = 0;
plot_norm_thrust = 0;

% measured parameters
roe_ref = 1.225;  % 15C

% model parameters
Ar = 0.05;  % single rotor swept area
m = 1.952;  % vehicle mass [kg]
g = 9.81;  % gravity [m/s^2]
Np = 0.6;  % propeller efficiency
Nm = 0.85;  % motor efficiency
Nc = 0.95;  % controller efficiency
r = 1.225;  % density of air [kg/m^3]

%% Select Data
% session 1
listing{1,1} = '/home/jakeware/flowfield/power_consumption/flight_tests/2015-03-10_hd/lcmlog_2015_03_10_02.mat';  % hover
listing{1,2} = '/home/jakeware/flowfield/power_consumption/flight_tests/2015-03-09_wbwt/lcmlog_2015_03_09_04.mat';  % 5 mph
listing{1,3} = '/home/jakeware/flowfield/power_consumption/flight_tests/2015-03-09_wbwt/lcmlog_2015_03_09_06.mat';  % 10mph
listing{1,4} = '/home/jakeware/flowfield/power_consumption/flight_tests/2015-03-09_wbwt/lcmlog_2015_03_09_08.mat';  % 15mph

% density
roe(1) = 1.275;  % 32F

% number of datasets
listing_size(1) = 4;

% useful portion of the flight time
start_time(1,1:listing_size(1)) = [100,100,60,60];  % seconds
stop_time(1,1:listing_size(1)) = [450,300,105,70];

% session 2
listing{2,1} = '/home/jakeware/flowfield/power_consumption/flight_tests/2015-03-10_hd/lcmlog_2015_03_10_02.mat';  % hover
listing{2,2} = '/home/jakeware/flowfield/power_consumption/flight_tests/2015-03-11_wbwt/lcmlog_2015_03_11_02.mat';  % 5 mph
listing{2,3} = '/home/jakeware/flowfield/power_consumption/flight_tests/2015-03-11_wbwt/lcmlog_2015_03_11_03.mat';  % 10mph
listing{2,4} = '/home/jakeware/flowfield/power_consumption/flight_tests/2015-03-11_wbwt/lcmlog_2015_03_11_05.mat';  % 15mph
listing{2,5} = '/home/jakeware/flowfield/power_consumption/flight_tests/2015-03-11_wbwt/lcmlog_2015_03_11_09.mat';  % 20mph

% density
roe(2) = 1.238;  % 45F

% number of datasets
listing_size(2) = 5;

% useful portion of the flight time
start_time(2,1:listing_size(2)) = [100,60,60,60,80];  % seconds
stop_time(2,1:listing_size(2)) = [450,150,160,230,100];

% session 3
listing{3,1} = '/home/jakeware/flowfield/power_consumption/flight_tests/2015-03-10_hd/lcmlog_2015_03_10_02.mat';  % hover
listing{3,2} = '/home/jakeware/flowfield/power_consumption/flight_tests/2015-03-13_wbwt/lcmlog_2015_03_13_00.mat';  % 15mph
listing{3,3} = '/home/jakeware/flowfield/power_consumption/flight_tests/2015-03-13_wbwt/lcmlog_2015_03_13_01.mat';  % 20mph
listing{3,4} = '/home/jakeware/flowfield/power_consumption/flight_tests/2015-03-13_wbwt/lcmlog_2015_03_13_02.mat';  % 25mph

% density
roe(3) = 1.225;  % 51F

% number of datasets
listing_size(3) = 4;

% useful portion of the flight time
start_time(3,1:listing_size(3)) = [100,200,200,158];  % seconds
stop_time(3,1:listing_size(3)) = [450,550,500,163];


%% Load Data
% load flight data from hover tests
load('mean_power.mat')
load('mean_wind.mat')
load('stderr_power.mat')

% loop over sessions
for i=1:size(listing,1)
    % loop over trials
    for j=1:listing_size(i)
        temp = load(listing{i,j});

        % skip hover data
        if j>1
            % wind speed
            wind_size(i,j) = length(temp.CV7_OUTPUT);
            wind_speed(i,j,1:wind_size(i,j)) = 0.5144*temp.CV7_OUTPUT(:,4);  % convert from knots to m/s
            wind_time(i,j,1:wind_size(i,j)) = temp.CV7_OUTPUT(:,7);
            wind_start(i,j) = find(wind_time(i,j,1:wind_size(i,j)) > start_time(i,j),1);
            wind_stop(i,j) = find(wind_time(i,j,1:wind_size(i,j)) > stop_time(i,j),1);
        end

        % get power size and time
        power_size(i,j) = length(temp.POWER_OUTPUT);
        power_time(i,j,1:power_size(i,j)) = temp.POWER_OUTPUT(:,5);
        power_start(i,j) = find(power_time(i,j,1:power_size(i,j)) > start_time(i,j),1);
        power_stop(i,j) = find(power_time(i,j,1:power_size(i,j)) > stop_time(i,j),1);
        power(i,j,1:power_size(i,j)) = temp.POWER_OUTPUT(:,4);

        % current
        current(i,j,1:power_size(i,j)) = temp.POWER_OUTPUT(:,2);

        % voltage
        voltage(i,j,1:power_size(i,j)) = temp.POWER_OUTPUT(:,3);

        % orientation
        state_size(i,j) = length(temp.STATE_ESTIMATOR_POSE);
        state_time(i,j,1:state_size(i,j)) = temp.STATE_ESTIMATOR_POSE(:,18);
        state_start(i,j) = find(state_time(i,j,1:state_size(i,j)) > start_time(i,j),1);
        state_stop(i,j) = find(state_time(i,j,1:state_size(i,j)) > stop_time(i,j),1);
        state_quat(i,j,1:state_size(i,j),1) = temp.STATE_ESTIMATOR_POSE(:,8);
        state_quat(i,j,1:state_size(i,j),2) = temp.STATE_ESTIMATOR_POSE(:,9);
        state_quat(i,j,1:state_size(i,j),3) = temp.STATE_ESTIMATOR_POSE(:,10);
        state_quat(i,j,1:state_size(i,j),4) = temp.STATE_ESTIMATOR_POSE(:,11);

        % control
        control_size(i,j) = length(temp.LQR_CONTROL);
        control_time(i,j,1:control_size(i,j)) = temp.LQR_CONTROL(:,15);
        control_start(i,j) = find(control_time(i,j,1:control_size(i,j)) > start_time(i,j),1);
        control_stop(i,j) = find(control_time(i,j,1:control_size(i,j)) > stop_time(i,j),1);
        control_rpyt(i,j,1:control_size(i,j),1) = rad2deg(temp.LQR_CONTROL(:,2));
        control_rpyt(i,j,1:control_size(i,j),2) = rad2deg(temp.LQR_CONTROL(:,3));
        control_rpyt(i,j,1:control_size(i,j),3) = rad2deg(temp.LQR_CONTROL(:,4));
        control_rpyt(i,j,1:control_size(i,j),4) = temp.LQR_CONTROL(:,5);
        
        % asctec
        asctec_size(i,j) = length(temp.ASCTEC_RC_DATA);
        asctec_time(i,j,1:asctec_size(i,j)) = temp.ASCTEC_RC_DATA(:,19);
        asctec_start(i,j) = find(asctec_time(i,j,1:asctec_size(i,j)) > start_time(i,j),1);
        asctec_stop(i,j) = find(asctec_time(i,j,1:asctec_size(i,j)) > stop_time(i,j),1);
        asctec_pitch(i,j,1:asctec_size(i,j)) = temp.ASCTEC_RC_DATA(:,3);
        asctec_thrust(i,j,1:asctec_size(i,j)) = temp.ASCTEC_RC_DATA(:,5);
    end
end

%% Analysis
for i=1:size(listing,1)
    for j=1:listing_size(i)
        % get rpy from quat
        [yaw,pitch,roll] = quat2angle(squeeze(state_quat(i,j,1:state_size(i,j),1:4)));
        state_rpy(i,j,1:state_size(i,j),1:3) = rad2deg([roll,pitch,yaw]);
        
        % power mean, std, and stderr
        power_mean(i,j) = mean(power(i,j,power_start(i,j):power_stop(i,j)));
        power_std(i,j) = std(power(i,j,power_start(i,j):power_stop(i,j)));
        power_stderr(i,j) = power_std(i,j)/sqrt(length(power(i,j,power_start(i,j):power_stop(i,j))));

        % wind mean, std, and stderr
        % no wind speed for hover
        if j>1
            wind_speed_mean(i,j) = mean(wind_speed(i,j,wind_start(i,j):wind_stop(i,j)));
            wind_speed_std(i,j) = std(wind_speed(i,j,wind_start(i,j):wind_stop(i,j)));
            wind_speed_stderr(i,j) = wind_speed_std(i,j)/sqrt(length(wind_speed(i,j,wind_start(i,j):wind_stop(i,j))));
        else
            wind_speed_mean(i,j) = 0;
            wind_speed_std(i,j) = 0;
            wind_speed_stderr(i,j) = 0;
        end

        % orientation mean, std, and stderr
        state_rpy_mean(i,j,2) = mean(state_rpy(i,j,state_start(i,j):state_stop(i,j),2));
        state_rpy_std(i,j,2) = std(state_rpy(i,j,state_start(i,j):state_stop(i,j),2));
        state_rpy_stderr(i,j,2) = state_rpy_std(i,j)/sqrt(length(state_rpy(i,j,state_start(i,j):state_stop(i,j),2)));

        % control mean, std, and stderr
        control_rpyt_mean(i,j,4) = mean(control_rpyt(i,j,control_start(i,j):control_stop(i,j),4));
        control_rpyt_std(i,j,4) = std(control_rpyt(i,j,control_start(i,j):control_stop(i,j),4));
        
        % asctec rc mean
        asctec_pitch_mean(i,j) = mean(asctec_pitch(i,j,asctec_start(i,j):asctec_stop(i,j)));
        asctec_thrust_mean(i,j) = mean(asctec_thrust(i,j,asctec_start(i,j):asctec_stop(i,j)));
    end
    
    % orientation offset (subtract hover pitch)
    state_rpy_mean(i,1:listing_size(i),2) = state_rpy_mean(i,1:listing_size(i),2) - state_rpy_mean(i,1,2);
    
    % correct for temperature
    roe_ratio(i) = sqrt(roe(i)/roe_ref);
    power_mean(i,1:listing_size(i)) = roe_ratio(i)*power_mean(i,1:listing_size(i));
    
    % get normalized power
    power_mean_norm(i,1:listing_size(i)) = power_mean(i,1:listing_size(i))/power_mean(i,1);
    power_std_norm(i,1:listing_size(i)) = power_std(i,1:listing_size(i))/power_mean(i,1);
    power_stderr_norm(i,1:listing_size(i)) = power_stderr(i,1:listing_size(i))/power_mean(i,1);
    
    % normalize control
    control_rpyt_mean_norm(i,1:listing_size(i),4) = control_rpyt_mean(i,1:listing_size(i),4)/control_rpyt_mean(i,1,4);
end

%% Model
Th = m*g/4;  % thrust at hover
Ph = Th^1.5/(2*r*Ar)^0.5;  % power at hover
Vh = (Th/(2*r*Ar))^0.5;  % induced velocity at hover [m/s]

Va = linspace(0,14);  % get power to air speed curve
%drag = 0.5*r*A*Va.^2*Cd;  % drag force
%model_pitch = atan(drag/m/g);  % angle of attack

% gather pitch data
speed_data = wind_speed_mean(1,1:listing_size(1));
pitch_data = deg2rad(state_rpy_mean(1,1:listing_size(1),2));
for i=2:size(listing,1)
    speed_data = [speed_data,wind_speed_mean(i,1:listing_size(i))];
    pitch_data = [pitch_data,deg2rad(state_rpy_mean(i,1:listing_size(i),2))];
end

% fit line to measured pitch data
p = polyfit(speed_data,pitch_data,2);

model_pitch = polyval(p,Va);
model_thrust = m*g/4./cos(model_pitch);  % thrust

% solve for induced flow at each point
for i=1:length(Va)
    fun = @(Vi) Vi - Vh^2/((Va(i)*cos(model_pitch(i)))^2 + (Va(i)*sin(model_pitch(i)) + Vi)^2)^0.5;
    x0 = Vh;
    opts = optimset('Display','off');
    Vi(i) = fsolve(fun,x0,opts);
    
    P(i) = 4*model_thrust(i)*(Va(i)*sin(model_pitch(i)) + Vi(i))/(Np*Nm*Nc);
end

% fit power data
p_new = polyfit(Va,P,4);

% normalize power
P_norm = P/P(1);

% fit asctec pitch
% gather thrust data
speed_data = wind_speed_mean(1,1:listing_size(1));
asctec_pitch_data = asctec_pitch_mean(1,1:listing_size(1));
for i=2:size(listing,1)
    speed_data = [speed_data,wind_speed_mean(i,1:listing_size(i))];
    asctec_pitch_data = [asctec_pitch_data,asctec_pitch_mean(i,1:listing_size(i))];
end
% fit line to measured pitch data
p_pitch = polyfit(speed_data,asctec_pitch_data,1);
fit_asctec_pitch = polyval(p_pitch,Va);

% fit asctec thrust
% gather thrust data
speed_data = wind_speed_mean(1,1:listing_size(1));
asctec_thrust_data = asctec_thrust_mean(1,1:listing_size(1));
for i=2:size(listing,1)
    speed_data = [speed_data,wind_speed_mean(i,1:listing_size(i))];
    asctec_thrust_data = [asctec_thrust_data,asctec_thrust_mean(i,1:listing_size(i))];
end
% fit line to measured thrust data
p_thrust = polyfit(speed_data,asctec_thrust_data,5);
fit_asctec_thrust = polyval(p_thrust,Va);

%% Old Power Curve
% get old power curve
p_old = [-0.003044,0.3193,-0.9984,-2.956,109.2];
fit_power_old = polyval(p_old,Va);
P_old_norm = fit_power_old/fit_power_old(1);

%% Hover Power
P_hover_norm = mean_power/mean_power(1);
stderr_power_norm = stderr_power/mean_power(1);

%% Plot
if plot_pitch
    figure
    colors = lines(length(listing));
    hold on
    
    % measured
    for i=1:size(listing,1)
        %plot(wind_speed_mean(i,1:listing_size(i)),state_rpy_mean(i,1:listing_size(i),2),'o','color',colors(i,:));
        
        % color code tests
        %h(i) = errorbar(wind_speed_mean(i,1:listing_size(i)),state_rpy_mean(i,1:listing_size(i),2),state_rpy_std(i,1:listing_size(i),2),'*','color',colors(i,:));
        
        % single color
        h(1) = errorbar(wind_speed_mean(i,1:listing_size(i)),state_rpy_mean(i,1:listing_size(i),2),state_rpy_stderr(i,1:listing_size(i),2),'b*','LineWidth',2);
    end
    
    % model (color code)
    %h(i+1) = plot(Va,rad2deg(model_pitch),'k','LineWidth',2);
    
    % model (single color)
    h(2) = plot(Va,rad2deg(model_pitch),'k','LineWidth',2);
    
    title('Vehicle Pitch Angle Vs. Air Speed')
    
    xlabel('Air Speed [m/s]')
    xlhand = get(gca,'xlabel');
    set(xlhand,'FontSize',12,'FontWeight','Bold')
    
    ylabel('Pitch [deg]')
    ylhand = get(gca,'ylabel');
    set(ylhand,'FontSize',12,'FontWeight','Bold')
    
    ax = gca;
    ax.FontWeight = 'Bold';
    
%     legend(h,{'test1-std','test2-std','test3-std','fit'},'Location','NorthWest')
    legend(h(1:2),{'Measured','Fit'},'Location','NorthWest')
    hold off
    
    set(gcf,'units','inches','paperposition',[0 0 7 3])
    saveas(gcf,'/home/jakeware/ware_icra16/figures/v2/wbwt_pitch3.eps','epsc')
end

if plot_power
    figure
    colors = lines(length(listing));
    hold on
    
    for i=1:size(listing,1)
        h(i) = plot(wind_speed_mean(i,1:listing_size(i)),power_mean(i,1:listing_size(i)),'color',colors(i,:))
        errorbar(wind_speed_mean(i,1:listing_size(i)),power_mean(i,1:listing_size(i)),power_stderr(i,1:listing_size(i)),'color',colors(i,:))
    end
    
    title('Power Vs. Air Speed')
    xlabel('Air Speed [m/s]')
    ylabel('Power [W]')
    legend(h,{'test1-stderr','test2-stderr'},'Location','NorthWest')
    hold off
end

if plot_norm_power
    figure
    colors = lines(length(listing));
    hold on
    
    % measured
    for i=1:size(listing,1)
        %scatter(wind_speed_mean(i,1:listing_size(i)),power_mean_norm(i,1:listing_size(i)),30,colors(i,:));
        
        % color code tests
        %h(i) = errorbar(wind_speed_mean(i,1:listing_size(i)),power_mean_norm(i,1:listing_size(i)),power_std_norm(i,1:listing_size(i)),'*','color',colors(i,:));
    
        % single color
        h(1) = errorbar(wind_speed_mean(i,1:listing_size(i)),power_mean_norm(i,1:listing_size(i)),power_stderr_norm(i,1:listing_size(i)),'b*','LineWidth',2);
    end
    
    % model (color code)
    %h(i+1) = plot(Va,P_norm,'k');
    
    % single color
    h(2) = plot(Va,P_norm,'k','LineWidth',2);
    
    % old power curve
%     h(3) = plot(Va,P_old_norm,'m','LineWidth',2);
    
    % hover power
%     h(3) = errorbar(mean_wind,P_hover_norm,stderr_power_norm,'r*','LineWidth',2);
    
    axis([0,15,0.8,1.5])
    
    title('Normalized Power Vs. Air Speed')
    
    xlabel('Air Speed [m/s]')
    xlhand = get(gca,'xlabel');
    set(xlhand,'FontSize',12,'FontWeight','Bold')
    
    ylabel('P/Ph')
    ylhand = get(gca,'ylabel');
    set(ylhand,'FontSize',12,'FontWeight','Bold')
    
    ax = gca;
    ax.FontWeight = 'Bold';
    
    %legend(h,{'test1-std','test2-std','test3-std','model'},'Location','NorthWest')
%     legend(h(1:3),{'Measured','Model','Hover'},'Location','NorthWest')
    legend(h(1:2),{'Measured','Model'},'Location','NorthWest')
    hold off
    
    set(gcf,'units','inches','paperposition',[0 0 7 3])
    saveas(gcf,'/home/jakeware/ware_icra16/figures/v2/power_speed_test2.eps','epsc')
end

if plot_thrust
    figure
    colors = lines(length(listing));
    hold on
    
    for i=1:size(listing,1)
        h(i) = scatter(wind_speed_mean(i,1:listing_size(i)),control_rpyt_mean(i,1:listing_size(i),4),30,colors(i,:));
        %errorbar(wind_speed_mean(i,1:listing_size(i)),control_rpyt_mean(i,1:listing_size(i),4),control_rpyt_std(i,1:listing_size(i),4),'color',colors(i,:))
    end
    
    title('Thrust Command Vs. Air Speed')
    xlabel('Air Speed [m/s]')
    ylabel('Thrust Command')
    legend(h,{'test1-stddev','test2-stddev','test3-stddev'},'Location','NorthWest')
    hold off
end

if plot_rc_thrust
    figure
    colors = lines(length(listing));
    hold on
    
    for i=1:size(listing,1)
        h(i) = scatter(wind_speed_mean(i,1:listing_size(i)),asctec_thrust_mean(i,1:listing_size(i)),30);
        %errorbar(wind_speed_mean(i,1:listing_size(i)),control_rpyt_mean(i,1:listing_size(i),4),control_rpyt_std(i,1:listing_size(i),4),'color',colors(i,:))
    end
    
    h(i+1) = plot(Va,fit_asctec_thrust,'k');
    
    title('Thrust Command Vs. Air Speed')
    xlabel('Air Speed [m/s]')
    ylabel('Thrust Command')
    legend(h,{'test1','test2','test3','poly-fit'},'Location','NorthWest')
    hold off
end

if plot_rc_pitch
    figure
    colors = lines(length(listing));
    hold on
    
    for i=1:size(listing,1)
        h(i) = scatter(wind_speed_mean(i,1:listing_size(i)),asctec_pitch_mean(i,1:listing_size(i)),30);
        %errorbar(wind_speed_mean(i,1:listing_size(i)),control_rpyt_mean(i,1:listing_size(i),4),control_rpyt_std(i,1:listing_size(i),4),'color',colors(i,:))
    end
    
    h(i+1) = plot(Va,fit_asctec_pitch,'k');
    
    title('Pitch Command Vs. Air Speed')
    xlabel('Air Speed [m/s]')
    ylabel('Thrust Command')
    legend(h,{'test1','test2','test3','poly-fit'},'Location','NorthWest')
    hold off
end

if plot_norm_thrust
    figure
    colors = lines(length(listing));
    hold on
    
    for i=1:size(listing,1)
        h(i) = scatter(wind_speed_mean(i,1:listing_size(i)),control_rpyt_mean_norm(i,1:listing_size(i),4),30,colors(i,:));
        %errorbar(wind_speed_mean(i,1:listing_size(i)),control_rpyt_mean(i,1:listing_size(i),4),control_rpyt_std(i,1:listing_size(i),4),'color',colors(i,:))
    end
    
    title('Thrust Command Vs. Air Speed')
    xlabel('Air Speed [m/s]')
    ylabel('Thrust Command')
    legend(h,{'test1-stddev','test2-stddev','test3-stddev'},'Location','NorthWest')
    hold off
end