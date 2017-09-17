function f = drag(Vg,gamma,Wt,Wc)
    Ao = 0.2;  % vehicle body cross sectional area [m^2]
    Ar = 0.05;  % single rotor swept area
    Ps = 0.5;  % rotor permeability
    Cd = 0.9;  % drag coefficient
    r = 1.225;  % density of air [gk/m^3]

    f = 0.5*r*(4*Ps*Ar*sin(gamma) + Ao)*(Wc^2 + (Wt - Vg)^2)*Cd;
end