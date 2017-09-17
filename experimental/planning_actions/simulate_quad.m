function q = simulate_quad(m,t,dt,x0,xd0,Rt,wBt,wBtdot,xt,xdt,a)
  g = 9.81;  % m/s
  
  % World Frame
  xW = [1 0 0]';
  yW = [0 1 0]';
  zW = [0 0 1]';

  % Control gains
  Kp = 3*eye(3);
  Kv = 3*eye(3);
  Kr = 2*eye(3);
  Kw = .2*eye(3);

  J = [2.32e-3 0 0;0 2.32e-3 0;0 0 4.41e-3]; % kg*m^2
  
  wG = [0;0;xd0(4)];
  vG = xd0(1:3);
  R = eye(3);
  D = x0(1:3);

  % Omega and Velocity in body frame
  wB = R'*wG;
  vB = R'*vG;

  % Initial State
  q0 = [wB;vB;R(:);D];
  q = nan(18,length(t));
  q(:,1) = q0;

  for i = 1:length(t)-1
    % Compute Force and Moments for Given State
    R = reshape(q(7:15,i),3,3);
    M_ff = cross(q(1:3,i),J*q(1:3,i))-J*(hat(q(1:3,i))*R'*Rt(:,:,i)*wBt(:,i)-...
       R'*Rt(:,:,i)*wBtdot(:,i));

    % Here is the control law from the UPenn paper, which is wrong as
    % observed in the C++ implementation.
  %     M_ff = J*wdotBWt(:,i) + cross(wBWt(:,i),J*wBWt(:,i));

    % Feedback Control
    ep = q(16:18,i)-xt(:,i);
    ev = R*q(4:6,i)-xdt(:,i);
    erhat = (1/2)*(Rt(:,:,i)'*R-R'*Rt(:,:,i));
    er = [-erhat(2,3);erhat(1,3);-erhat(1,2)];
    ew = q(1:3,i)-R'*Rt(:,:,i)*wBt(:,i);

    F_ff = dot(m*g*zW + m*a(:,i),R*zW);
    F_fb = dot(-Kp*ep - Kv*ev,R*zW);
    F = F_ff + F_fb;
    M = M_ff - Kr*er - Kw*ew;

    % 4th Order Runge-Kutta Integrator
    % State q = [omega_bodyaxes, v_bodyaxes, R_global, delta_global]'
    k1 = quad_dynamics(q(:,i),m,J,F,M);
    k2 = quad_dynamics(q(:,i)+dt*k1/2,m,J,F,M);
    k3 = quad_dynamics(q(:,i)+dt*k2/2,m,J,F,M);
    k4 = quad_dynamics(q(:,i)+dt*k3,m,J,F,M);
    q(:,i+1) = q(:,i) + (dt/6)*(k1+2*k2+2*k3+k4);
  end
end