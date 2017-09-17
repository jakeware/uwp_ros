function [c,ceq] = nonlcon_2d(x,Wt,Wc)
    m = 1.4;  % vehicle mass [kg]
    g = 9.81;  % gravity [m/s^2]
    Ao = 0.1;  % vehicle body cross sectional area [m^2]
    Ar = 0.05;  % single rotor swept area
    Ps = 0.1;  % rotor permeability
    Cd = 0.9;  % drag coefficient
    r = 1.225;  % density of air [gk/m^3]

    c = [];
    ceq(1) = -m*g + x(2)*cos(x(3));
    ceq(2) = -0.5*r*(4*Ps*Ar*sin(x(3)) + Ao)*(Wc^2 + (Wt - x(1))^2)*Cd + x(2)*sin(x(3));
end