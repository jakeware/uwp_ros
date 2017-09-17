clear all
close all
clc

%% Notes
% same as V2, but uses a variable cross-sectional area based on angle of
% attack

%% Setup
plot_pow = 1;
plot_thrust = 0;
plot_speed = 0;
plot_ang = 0;
plot_drag = 0;

% wind
Wt = 5;
Wc = 5;

% vehicle
m = 1.4;  % vehicle mass [kg]
g = 9.81;  % gravity [m/s^2]
Ao = 0.25;  % vehicle body cross sectional area [m^2]
Ar = 0.05;  % single rotor swept area
Cd = 0.9;  % drag coefficient
Ps = 0.1;  % blade solidity ratio
Np = 0.8;  % propeller efficiency
Nm = 0.9;  % motor efficiency
Nc = 0.95;  % controller efficiency
r = 1.225;  % density of air [gk/m^3]
Vh = (m*g/4/(2*r*Ar))^0.5;  % induced velocity at hover [m/s]

%% Analysis
Va = linspace(0,10);
for i=1:length(Va)    
    x0 = [0,0];
    opts = optimset('Display','off');
    f = fsolve(@(x) f1(x,Va(i),m,Ao,Ar,Cd,r,Ps),x0,opts);
    T(i) = f(1);
    gamma(i) = f(2);
    
    f2 = @(Vi) Vi - Vh^2/((Va(i)*cos(gamma(i)))^2 + (Va(i)*sin(gamma(i)) + Vi)^2)^0.5;
    x0 = Vh;
    opts = optimset('Display','off');
    Vi(i) = fsolve(f2,x0,opts);
    
    P(i) = T(i)*(Va(i)*sin(gamma(i)) + Vi(i))/(Np*Nm*Nc);
end

%% Plot
if plot_pow
    figure
    hold on
    ylabel('Power [W]')
    xlabel('Air Speed [m/s]')
    plot(Va,P,'k','LineWidth',2)
    scatter(fit_x,fit_y,'r*')
    axis([0,10,80,280])
    hold off
end

if plot_thrust
    figure
    hold on
    title('Thrust Vs. Air Speed')
    ylabel('Thrust [N]')
    xlabel('Air Speed [m/s]')
    plot(Va,T)
    hold off
end

if plot_speed
    figure
    hold on
    title('Induced Speed Vs. Air Speed')
    ylabel('Induced Speed [m/s]')
    xlabel('Air Speed [m/s]')
    plot(Va,Vi)
    hold off
end

if plot_ang
    figure
    hold on
    title('Angle of Attack Vs. Air Speed')
    ylabel('Angle of Attack [deg]')
    xlabel('Air Speed [m/s]')
    plot(Va,rad2deg(gamma))
    hold off
end

if plot_drag
    figure
    hold on
    title('Drag Vs. Air Speed')
    ylabel('Drag [N]')
    xlabel('Air Speed [m/s]')
    plot(Va,drag)
    hold off
end