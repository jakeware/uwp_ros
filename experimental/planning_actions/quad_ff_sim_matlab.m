% Simulation based on T. Lee, "Geometric Control...on SE(3)," CDC 2010
function quad_ff_sim_matlab
clear,clc

% Control gains
Kp = 3*eye(3);
Kv = 3*eye(3);
Kr = 2*eye(3);
Kw = .2*eye(3);

% Quad parameters
m = 0.66; % kg
J = [2.32e-3 0 0;0 2.32e-3 0;0 0 4.41e-3]; % kg*m^2

% Params
N = 9;
tf = 2;
dt = .005;
t = 0:dt:tf;
g = 9.81;

% World Frame
xW = [1 0 0]';
yW = [0 1 0]';
zW = [0 0 1]';

% Initial and final states
x0 = [0 0 0 0]';
xf = [4 0 0 -pi]';

% Initial and final derivatives
xd0 = [0 4 0 0]';
xdf = [0 -4 0 0]';

% Initial and final accelerations
xdd0 = [0 0 0 0]';
xddf = [0 0 0 0]';

% Initial and final jerk
xddd0 = [0 0 0 0]';
xdddf = [0 0 0 0]';

% Initial and final snap
xdddd0 = [0 0 0 0]';
xddddf = [0 0 0 0]';

% Costs: only penalize acceleration
der_costs = [0 0 0 0 1 0 0 0 0 0]';

% Allocate variables
p = cell(4,1); % Polynomials describing position (x,y,z,psi)
d = cell(4,1); % Derivatives of polynomials
dd = cell(4,1); % Second derivatives of polynomials
ddd = cell(4,1); % Third derivatives of polynomials
dddd = cell(4,1); % Fourth derivatives of polynomials
cost = cell(4,1); % Cost
traj = cell(4,1); % Trajectories
trajd = cell(4,1); % Derivatives of trajectories
trajdd = cell(4,1); % Second derivatives of trajectories
trajddd = cell(4,1); % Third derivatives of trajectories
trajdddd = cell(4,1); % Fourth derivatives of trajectories

% Minimum-Snap Trajectory Following
% Generate trajectory and derivatives
for i = 1:4
    [p{i},cost{i}] = poly_opt_single(N, tf,...
    [x0(i) xd0(i) xdd0(i) xddd0(i) xdddd0(i)]',...
    [xf(i) xdf(i) xddf(i) xdddf(i) xddddf(i)]',der_costs);
    traj{i} = polyval(p{i},t);
    
    d{i} = polyder(p{i});
    trajd{i} = polyval(d{i},t);
    
    dd{i} = polyder(d{i});
    trajdd{i} = polyval(dd{i},t);
    
    ddd{i} = polyder(dd{i});
    trajddd{i} = polyval(ddd{i},t);
    
    dddd{i} = polyder(ddd{i});
    trajdddd{i} = polyval(dddd{i},t);
end

xt = [traj{1};traj{2};traj{3}];
xdt = [trajd{1};trajd{2};trajd{3}];
a = [trajdd{1};trajdd{2};trajdd{3}];
adot = [trajddd{1};trajddd{2};trajddd{3}];
addot = [trajdddd{1};trajdddd{2};trajdddd{3}];

% Compute orientations from trajectory
for j = 1:length(t)
    u1t(j) = m*norm(a(:,j)+g*zW);
    zBt(:,j) = (a(:,j)+g*zW)/norm(a(:,j)+g*zW);
    xCt(:,j) = [cos(traj{4}(j)) sin(traj{4}(j)) 0];
    yBt(:,j) = cross(zBt(:,j),xCt(:,j))/norm(cross(zBt(:,j),xCt(:,j)));
    xBt(:,j) = cross(yBt(:,j),zBt(:,j));
    
    % Desired Rotation Matrix
    Rt(:,:,j) = [xBt(:,j) yBt(:,j) zBt(:,j)];
    hwt(:,j) = (m/u1t(j))*(adot(:,j)-dot(zBt(:,j),adot(:,j))*zBt(:,j));
    
    % Desired Body-Frame Angular Velocities
    pt(j) = dot(-hwt(:,j),yBt(:,j));
    qt(j) = dot(hwt(:,j),xBt(:,j));
    rt(j) = dot(trajd{4}(j)*zW,zBt(:,j));
    wBWt(:,j) = pt(j)*xBt(:,j) + qt(j)*yBt(:,j) + rt(j)*zBt(:,j);
end

wBt = [pt;qt;rt];

% Numerically differentiate wBWt
wdotBWt_numerical(1,:) = gradient(wBWt(1,:))/dt;
wdotBWt_numerical(2,:) = gradient(wBWt(2,:))/dt;
wdotBWt_numerical(3,:) = gradient(wBWt(3,:))/dt;

% Analytically differentiate wBWt
for jj = 1:length(t)
    xBtdot(:,jj) = cross(wBWt(:,jj),xBt(:,jj));
    yBtdot(:,jj) = cross(wBWt(:,jj),yBt(:,jj));
    zBtdot(:,jj) = cross(wBWt(:,jj),zBt(:,jj));
    u1tdot(jj) = dot(zBt(:,jj),m*adot(:,jj));
    hwdot(:,jj) = m*(-1*u1t(jj)^-2)*u1tdot(jj)*...
        (adot(:,jj)-dot(zBt(:,jj),adot(:,jj))*zBt(:,jj)) +...
        (m/u1t(jj))*(addot(:,jj)-...
        (dot(zBtdot(:,jj),adot(:,jj))*zBt(:,jj)+...
        (dot(zBt(:,jj),addot(:,jj))*zBt(:,jj))+...
        (dot(zBt(:,jj),adot(:,jj))*zBtdot(:,jj))));
    pdot(jj) = dot(-hwdot(:,jj),yBt(:,jj)) + dot(-hwt(:,jj),yBtdot(:,jj));
    qdot(jj) = dot(hwdot(:,jj),xBt(:,jj)) + dot(hwt(:,jj),xBtdot(:,jj));
    rdot(jj) = dot(trajdd{4}(jj)*zW,zBt(:,jj))+...
        dot(trajd{4}(jj)*zW,zBtdot(:,jj));
    wdotBWt(:,jj) = pdot(jj)*xBt(:,jj)+...
        qdot(jj)*yBt(:,jj)+...
        rdot(jj)*zBt(:,jj)+...
        pt(:,jj)*xBtdot(:,jj)+...
        qt(:,jj)*yBtdot(:,jj)+...
        rt(:,jj)*zBtdot(:,jj);
end

wBtdot = [pdot;qdot;rdot];

% Simulate
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
    k1 = dynamics(q(:,i),m,J,F,M);
    k2 = dynamics(q(:,i)+dt*k1/2,m,J,F,M);
    k3 = dynamics(q(:,i)+dt*k2/2,m,J,F,M);
    k4 = dynamics(q(:,i)+dt*k3,m,J,F,M);
    q(:,i+1) = q(:,i) + (dt/6)*(k1+2*k2+2*k3+k4);
end

% figure(1),clf,hold on
% plot3(q(16,:),q(17,:),q(18,:));
plot_quad(traj,xBt,yBt,zBt,q,t)

end

function plot_quad(traj,xBt,yBt,zBt,q,t)

for m = 1:5:length(t)-1
    h = figure(1);set(gcf,'defaultlinelinewidth',4)
    clf,hold on
    fscale = .2;
    
    % Plot axes
    plot3([traj{1}(m) traj{1}(m)+zBt(1,m)],...
        [traj{2}(m) traj{2}(m)+zBt(2,m)],...
        [traj{3}(m) traj{3}(m)+zBt(3,m)],'K:')
    plot3([traj{1}(m) traj{1}(m)+xBt(1,m)],...
        [traj{2}(m) traj{2}(m)+xBt(2,m)],...
        [traj{3}(m) traj{3}(m)+xBt(3,m)],'K:')
    plot3([traj{1}(m) traj{1}(m)+yBt(1,m)],...
        [traj{2}(m) traj{2}(m)+yBt(2,m)],...
        [traj{3}(m) traj{3}(m)+yBt(3,m)],'K:')
    
    % Plot negative of xB and yB
    plot3([traj{1}(m) traj{1}(m)-xBt(1,m)],...
        [traj{2}(m) traj{2}(m)-xBt(2,m)],...
        [traj{3}(m) traj{3}(m)-xBt(3,m)],'K:')
    plot3([traj{1}(m) traj{1}(m)-yBt(1,m)],...
        [traj{2}(m) traj{2}(m)-yBt(2,m)],...
        [traj{3}(m) traj{3}(m)-yBt(3,m)],'K:')
    
    plot3([q(16,m) q(16,m)+q(13,m)],...
        [q(17,m) q(17,m)+q(14,m)],...
        [q(18,m) q(18,m)+q(15,m)],'K')
    plot3([q(16,m) q(16,m)+q(7,m)],...
        [q(17,m) q(17,m)+q(8,m)],...
        [q(18,m) q(18,m)+q(9,m)],'R')
    plot3([q(16,m) q(16,m)+q(10,m)],...
        [q(17,m) q(17,m)+q(11,m)],...
        [q(18,m) q(18,m)+q(12,m)],'B')
    plot3([q(16,m) q(16,m)-q(7,m)],...
        [q(17,m) q(17,m)-q(8,m)],...
        [q(18,m) q(18,m)-q(9,m)],'B')
    plot3([q(16,m) q(16,m)-q(10,m)],...
        [q(17,m) q(17,m)-q(11,m)],...
        [q(18,m) q(18,m)-q(12,m)],'B')
    
    plot3(traj{1}(1:m),traj{2}(1:m),traj{3}(1:m),'b-')
    view(30,20)
    grid on
    axis equal
    axis([-3 6 -3 6 -3 3])
    title('Simulated Minimum-Snap Trajectory Following')
    pause(0.01)

end
end

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

function vec_hat = hat(vec)
vec_hat = [0 -vec(3) vec(2);
           vec(3) 0 -vec(1);
           -vec(2) vec(1) 0];    
end