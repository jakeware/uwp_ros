clear all
close all
clc

%% Setup
% vehicle
m = 1;  % vehicle mass [kg]
g = 9.81;  % gravity [m/s^2]
Ar = 0.05;  % single rotor swept area
r = 1.225;  % density of air [gk/m^3]
Vh = 6;  % induced velocity at hover [m/s]
P = 25;  % constant power input

% Note: angle of attack is negative with forward pitch

%% Analysis
Va = linspace(0,6);
gamma = linspace(deg2rad(-20),deg2rad(20));
for i=1:length(Va)
    for j=1:length(gamma)
        fun = @(Vi) Vi - Vh^2/((Va(i)*cos(gamma(j)))^2 + (Vi - Va(i)*sin(gamma(j)))^2)^0.5;
        x0 = Vh;
        opts = optimset('Display','off');
        Vi(i,j) = fsolve(fun,x0,opts);

        T(i,j) = P/(Vi(i,j) - Va(i)*sin(gamma(j)))/(Vh^2*2*r*Ar);
    end
end

%% Plot
figure
hold on
title('T/Th')
ylabel('Angle of Attack [deg]')
xlabel('Air Speed [m/s]')
% matlab is column major
contour(Va,rad2deg(gamma),T',30)
colorbar
hold off
