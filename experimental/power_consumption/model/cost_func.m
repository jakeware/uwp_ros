function f = cost_func(Vg,T)
    m = 1.4;  % vehicle mass [kg]
    g = 9.81;  % gravity [m/s^2]
    Ar = 0.05;  % single rotor swept area
    Np = 0.8;  % propeller efficiency
    Nm = 0.9;  % motor efficiency
    Nc = 0.95;  % controller efficiency
    r = 1.225;  % density of air [gk/m^3]

    f = (4*T^1.5)/m/g/(2*r*Ar)^0.5/Nm/Np/Nc/Vg; 
end