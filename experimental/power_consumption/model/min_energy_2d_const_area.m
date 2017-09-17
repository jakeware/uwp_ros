clear all
close all
clc

%% Setup
plot_pow = 1;
plot_thrust = 0;
plot_speed = 0;
plot_ang = 0;
plot_drag = 0;

% vehicle
m = 1.952;  % vehicle mass [kg]
g = 9.81;  % gravity [m/s^2]
A = [0.1,0.2,0.25,0.3,0.4,0.5];  % vehicle body cross sectional area [m^2]
Ar = 0.05;  % single rotor swept area
Cd = 0.9;  % drag coefficient
Np = 0.6;  % propeller efficiency
Nm = 0.85;  % motor efficiency
Nc = 0.95;  % controller efficiency
r = 1.151;  % density of air [gk/m^3]
Th = m*g/4;  % thrust at hover
Ph = Th^1.5/(2*r*Ar)^0.5;  % power at hover
Vh = (Th/(2*r*Ar))^0.5;  % induced velocity at hover [m/s]

% Note: angle of attack is positive with forward pitch

%% Forward Flight Analysis
% get power to air speed curve
Va = linspace(0,10);
for i=1:length(A)
    for j=1:length(Va)
        drag(i,j) = 0.5*r*A(i)*Va(j)^2*Cd;
        gamma(i,j) = atan(drag(i,j)/m/g);
        T(i,j) = m*g/4/cos(gamma(i,j));

        fun = @(Vi) Vi - Vh^2/((Va(j)*cos(gamma(i,j)))^2 + (Va(j)*sin(gamma(i,j)) + Vi)^2)^0.5;
        x0 = Vh;
        opts = optimset('Display','off');
        Vi(i,j) = fsolve(fun,x0,opts);

        % influence of forward and descent flight on quadrotor dynamics
        %T2(j) = 8*r*Ar*Vi(j)*((Va(j)*cos(gamma(j)))^2 + (Va(j)*sin(gamma(j)) + Vi(j))^2 + (Va(j)*sin(gamma(j)))^2/7.67)^0.5;

        P(i,j) = 4*T(i,j)*(Va(j)*sin(gamma(i,j)) + Vi(i,j))/(Np*Nm*Nc);
        %P(j) = 4*T(j)*(Vi(j) - Va(j)*sin(gamma(j)))/(Np*Nm*Nc);
    end
end

% fit curve
f = fit(Va',P(3,:)','poly4');
p = [f.p1, f.p2, f.p3, f.p4, f.p5];

% plot data
fit_x = Va(3:3:end);
fit_y = zeros(size(fit_x));
for i = 1:length(p)
    fit_y = fit_y + p(i)*fit_x.^(length(p)-i);
end

%% Plot
if plot_pow
    figure
    colors = colormap(jet(length(A)));
    
    hold on
    ylabel('Power [W]')
    xlabel('Air Speed [m/s]')
    
    for i=1:length(A)
        plot(Va,P(i,:),'--','color',colors(i,:),'LineWidth',2)
    end
    plot(Va,P(3,:),'k','LineWidth',2)
    scatter(fit_x,fit_y,'r*')
    axis([0,10,180,280])
    hleg = legend('0.1','0.2','0.25','0.3','0.4','0.5', 'Location', 'SouthWest');
    htitle = get(hleg,'Title');
    set(htitle,'String','C.S. Area [m^2]')
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