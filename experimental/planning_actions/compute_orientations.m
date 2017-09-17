function [xBt,yBt,zBt,Rt,wBt,wBtdot] = compute_orientations(t,m,a,adot,addot,traj,trajd,trajdd)
g = 9.81;

% World Frame
xW = [1 0 0]';
yW = [0 1 0]';
zW = [0 0 1]';

% Compute orientations from trajectory
for j = 1:length(t)
  u1t(j) = m*norm(a(:,j)+g*zW);
  zBt(:,j) = (a(:,j)+g*zW)/norm(a(:,j)+g*zW);
  xCt(:,j) = [cos(traj(4,j)) sin(traj(4,j)) 0];
  yBt(:,j) = cross(zBt(:,j),xCt(:,j))/norm(cross(zBt(:,j),xCt(:,j)));
  xBt(:,j) = cross(yBt(:,j),zBt(:,j));

  % Desired Rotation Matrix
  Rt(:,:,j) = [xBt(:,j) yBt(:,j) zBt(:,j)];
  hwt(:,j) = (m/u1t(j))*(adot(:,j)-dot(zBt(:,j),adot(:,j))*zBt(:,j));

  % Desired Body-Frame Angular Velocities
  pt(j) = dot(-hwt(:,j),yBt(:,j));
  qt(j) = dot(hwt(:,j),xBt(:,j));
  rt(j) = dot(trajd(4,j)*zW,zBt(:,j));
  wBWt(:,j) = pt(j)*xBt(:,j) + qt(j)*yBt(:,j) + rt(j)*zBt(:,j);
end

% get orientation
wBt = [pt;qt;rt];

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
  rdot(jj) = dot(trajdd(4,jj)*zW,zBt(:,jj))+...
      dot(trajd(4,jj)*zW,zBtdot(:,jj));
  wdotBWt(:,jj) = pdot(jj)*xBt(:,jj)+...
      qdot(jj)*yBt(:,jj)+...
      rdot(jj)*zBt(:,jj)+...
      pt(:,jj)*xBtdot(:,jj)+...
      qt(:,jj)*yBtdot(:,jj)+...
      rt(:,jj)*zBtdot(:,jj);
end

% get orientation rate in body frame
wBtdot = [pdot;qdot;rdot];