%% Compute Node Indices and Weights for Regularized Grid Points
display('Compute Node Indices and Weights for Regularized Grid Points')
nodes_ind = zeros(length(reg_pos_xyz),4);
nodes_xyz = zeros(length(reg_pos_xyz),4,3);
nodes_xyz_delta = zeros(length(reg_pos_xyz),4,3);
nodes_dists = zeros(length(reg_pos_xyz),4);
nodes_wts = zeros(length(reg_pos_xyz),4);
for k=1:length(reg_pos_xyz)
  % report percentage complete
  if ~mod(k,floor(size(reg_pos_xyz,1)*0.1))
    fprintf('%2.0f%% Complete\n',round(k/length(reg_pos_xyz)*100));
  end
  
  % test point
  test_xyz = reg_pos_xyz(k,:);

  % get cells attached to nearest neighbor
  cell_inds = mesh_data.cells(:,1) == vert_inds(k) | mesh_data.cells(:,2) == vert_inds(k) | mesh_data.cells(:,3) == vert_inds(k) | mesh_data.cells(:,4) == vert_inds(k);
  test_cells = mesh_data.cells(cell_inds,:);
  
  % get barycentric coordinates
  [node_ind, node_wts] = testTets(test_xyz,test_cells,mesh_data);
  nodes_ind(k,:) = node_ind;
  nodes_wts(k,:) = node_wts;
end

%% Compute Velocity on Regular Grid Over Time
display('Computing Variables on Regular Grid')
for t=1:size(vel_xyz,1)
  % report percentage complete
  if ~mod(t,floor(size(vel_xyz,1)*0.1))
    fprintf('%2.0f%% Complete\n',round(t/size(vel_xyz,1)*100));
  end

  % iterate over regularized grid
  for k=1:length(reg_pos_xyz)
    reg_vel_xyz(t,k,:) = nodes_wts(k,:)*squeeze(vel_xyz(t,nodes_ind(k,:),:));
  end
end

%% Compute Reynolds Stresses on Regular Grid Over Time
display('Computing Reynolds Stresses on Regular Grid')
% iterate over regularized grid
for k=1:length(reg_pos_xyz)
  if strcmp(sol_type,'rsm')
    reg_rs_uu(k) = nodes_wts(k,:)*rs_uu(nodes_ind(k,:))';
    reg_rs_vv(k) = nodes_wts(k,:)*rs_vv(nodes_ind(k,:))';
    reg_rs_ww(k) = nodes_wts(k,:)*rs_ww(nodes_ind(k,:))';
    reg_rs_uv(k) = nodes_wts(k,:)*rs_uv(nodes_ind(k,:))';
    reg_rs_vw(k) = nodes_wts(k,:)*rs_vw(nodes_ind(k,:))';
    reg_rs_uw(k) = nodes_wts(k,:)*rs_uw(nodes_ind(k,:))';
  end
end