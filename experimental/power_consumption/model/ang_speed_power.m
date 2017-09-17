clear all
close all
clc

%% Setup
% vehicle
Ar = 0.0312; %0.05;  % single rotor swept area
r = 1.225;  % density of air [gk/m^3]
Th = 0.981; %m*g/4;  % thrust at hover
Ph = Th^1.5/(2*r*Ar)^0.5;  % power at hover
Vh = (Th/(2*r*Ar))^0.5;  % induced velocity at hover [m/s]

% Note: angle of attack is negative with forward pitch

%% Analysis
Va = linspace(0,7);
gamma = linspace(deg2rad(-30),deg2rad(5));
for i=1:length(Va)
    for j=1:length(gamma)
        fun = @(Vi) Vi - Vh^2/((Va(i)*cos(gamma(j)))^2 + (Vi - Va(i)*sin(gamma(j)))^2)^0.5;
        x0 = 10;
        opts = optimset('Display','off');
        f = fsolve(fun,x0,opts);
        Vi(i,j) = f;
        P(i,j) = Th*(Vi(i,j) - Va(i)*sin(gamma(j)))/Ph;
    end
end

%% Plot
figure
hold on
title('P/Ph')
ylabel('Angle of Attack [deg]')
xlabel('Air Speed [m/s]')
% matlab is column major
contour(Va,rad2deg(gamma),P',30)
colorbar
hold off
