%% Load Data
% header {nodenumber, x-coordinate, y-coordinate, z-coordinate, velocity-magnitude, x-velocity, y-velocity, z-velocity, cell-id, cell-element-type, cell-type, cell-zone, partition-neighbors, cell-children}
listing = dir(strcat(project_path,data_string));

if length(listing) > 1
  sol_type = 'les';
else
  sol_type = 'rans';  % assume this for now and check for reynolds stresses in data
end

for i=1:length(listing)
  % report percentage complete
  if ~mod(i,floor(length(listing)*0.1))
    fprintf('%2.0f%% Complete\n',round(i/length(listing)*100));
  end
  
  temp = csvread(strcat(project_path,listing(i).name),1,0);

  % only need to get these once
  if i==1
    % check for reynolds stress data (must be exporting reynolds stresses)
    if size(temp,2) > 7 && ~strcmp(sol_type,'les')
      sol_type = 'rsm';
    elseif size(temp,2) < 7 && ~strcmp(sol_type,'les')
      sol_type = 'rans';
    end
    
    pos_xyz(:,1) = temp(:,2);
    pos_xyz(:,2) = temp(:,3);
    pos_xyz(:,3) = temp(:,4);
    
    % get sort order
    order = zeros(1,size(pos_xyz,1));
    for j=1:size(pos_xyz,1)
      % find vertex position in mesh_data
      eps = 0.0001;
      c1 = (mesh_data.vertices(:,1) > pos_xyz(j,1) - eps);
      c2 = (mesh_data.vertices(:,1) < pos_xyz(j,1) + eps);
      c3 = (mesh_data.vertices(:,2) > pos_xyz(j,2) - eps);
      c4 = (mesh_data.vertices(:,2) < pos_xyz(j,2) + eps);
      c5 = (mesh_data.vertices(:,3) > pos_xyz(j,3) - eps);
      c6 = (mesh_data.vertices(:,3) < pos_xyz(j,3) + eps);
      ii = find(c1 & c2 & c3 & c4 & c5 & c6);
      
      order(j) = ii;
      
      if isempty(ii)
        display('Error: Multiple matching vertices in sort.')
        return
      end
    end
    
    % sort according to mesh_data locations
    node_num(order) = temp(:,1);
    pos_xyz(order,:) = pos_xyz;
    if strcmp(sol_type,'rsm')
      rs_uu(order) = temp(:,8);
      rs_vv(order) = temp(:,9);
      rs_ww(order) = temp(:,10);
      rs_uv(order) = temp(:,11);
      rs_vw(order) = temp(:,12);
      rs_uw(order) = temp(:,13);
    end
    
    % allocate arrays
    node_num = zeros(length(order),1);
    vel_xyz = zeros(length(listing),length(order),3);
  end
  
  vel_xyz(i,order,1) = temp(:,5);
  vel_xyz(i,order,2) = temp(:,6);
  vel_xyz(i,order,3) = temp(:,7);
end