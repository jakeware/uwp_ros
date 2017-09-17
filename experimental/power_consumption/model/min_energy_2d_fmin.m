clear all
close all
clc

%% Setup
plot_vs = 0;

% wind
Wt = 5;
Wc = 5;

% vehicle
m = 1.4;  % vehicle mass [kg]
g = 9.81;  % gravity [m/s^2]
Ao = 0.1;  % vehicle body cross sectional area [m^2]
Ar = 0.05;  % single rotor swept area
Ps = 0.1;  % rotor permeability
Cd = 0.9;  % drag coefficient
Np = 0.8;  % propeller efficiency
Nm = 0.9;  % motor efficiency
Nc = 0.95;  % controller efficiency
r = 1.225;  % density of air [gk/m^3]

% constraints
Vg_min = 0.5;  % minimum ground speed [m/s]
Vg_max = Inf;
T_min = 0;
T_max = 3*m*g;
gamma_min = 0;
gamma_max = pi/2;
% Vg > Vg_min
% T_max > T > T_min
% gamma_max > gamma

%% Analysis
%fun = @(x) -4*x(2)^1.5/(m*g*(2*r*Ar)^0.5*Nm*Np*Nc*x(1));
fun = @(x) 4*x(2)^1.5/((2*r*Ar)^0.5*Nm*Np*Nc);
x0 = [Vg_min,T_min,gamma_min];
lb = [Vg_min,T_min,gamma_min];
ub = [Vg_max,T_max,gamma_max];
opts = optimset('Display','iter','Algorithm','sqp');
[x, fval] = fmincon(fun,x0,[],[],[],[],lb,ub,@(x) nonlcon_2d(x,Wt,Wc),opts);

x
fval

% drag vs ground speed
gamma = rad2deg(10);
vg_x = 0:0.1:10;

for i=1:length(vg_x)
    drag_vg_y(i) = drag(vg_x(i),gamma,Wt,Wc);
end

% drag vs gamma
Vg = 5;
gamma_x = 0:0.05:gamma_max;

for i=1:length(gamma_x)
    drag_gamma_y(i) = drag(Vg,gamma_x(i),Wt,Wc);
end

% area vs gamma
area_gamma_y = drag_area(Ps,Ar,Ao,gamma_x);

% cost vs T
t_x = 0:0.1:30;
for i=1:length(t_x)
    cost_t_y(i) = cost_func(1,t_x(i));
end

% cost vs Vg
for i=1:length(vg_x)
    cost_vg_y(i) = cost_func(vg_x(i),10);
end

%% Plot
if plot_vs
    figure
    hold on
    title('Cost Vs. Thrust')
    plot(t_x,cost_t_y)
    hold off

    figure
    hold on
    title('Cost Vs. Vg')
    plot(vg_x,cost_vg_y)
    hold off
    
    figure
    hold on
    title('Area Vs. Angle of Attack')
    plot(gamma_x,area_gamma_y)
    hold off

    figure
    hold on
    title('Drag Vs Ground Speed')
    plot(vg_x,drag_vg_y)
    hold off

    figure
    hold on
    title('Drag Vs Angle of Attack')
    plot(gamma_x,drag_gamma_y)
    hold off
end