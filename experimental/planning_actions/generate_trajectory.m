function [traj,trajd,trajdd,trajddd,trajdddd] = generate_trajectory(tf, t, x0, xd0, xdd0, xddd0, xdddd0, xf, xdf, xddf, xdddf, xddddf)
  N = 9;
  der_costs = [0 0 0 0 1 0 0 0 0 0]';  % only penalize snap

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
  

end
