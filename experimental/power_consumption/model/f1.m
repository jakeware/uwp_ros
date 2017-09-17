function f = f1(x,Va,m,Ao,Ar,Cd,r,Ps)
g = 9.81;  % gravity [m/s^2]

f = [-m*g + x(1)*cos(x(2));
      -0.5*r*(4*Ps*Ar*sin(x(2)) + Ao)*Va^2*Cd + x(1)*sin(x(2))];