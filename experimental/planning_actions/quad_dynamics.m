function f = dynamics(q,m,J,F,M)
  R = reshape(q(7:15),3,3);

  % Gravity
  g_global = [0,0,-9.81];
  g_body = R'*g_global';

  % System Derivative
  f = nan(18,1);
  f(1:3) = J\(cross(-q(1:3),J*q(1:3))+M);
  f(4:6) = cross(-q(1:3),q(4:6))+g_body+[0;0;1]*F/m;
  f(7:15) = reshape(R*hat(q(1:3)),9,1);
  f(16:18) = R*q(4:6);
end