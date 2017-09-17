%% Find Building Corners
zones = fieldnames(mesh_data);
matches_cell = strfind(zones,'building');
matches = 0;
for i=1:size(matches_cell,1)
  if ~isempty(matches_cell{i})
    matches = [matches,i];
  end
end
matches = matches(2:end);

obs_min_xyz = inf*ones(length(matches),3);
obs_max_xyz = -inf*ones(length(matches),3);
for i=1:length(matches)
  temp_zone = eval(strcat('mesh_data.',zones{matches(i)}));
  
  % find min over all vertices in each face of zone
  for j=1:size(temp_zone.faces,1)
    % get vertices
    temp_verts = mesh_data.vertices(temp_zone.faces(j,:),:);
    
    % min
    obs_min_xyz(i,1) = min([obs_min_xyz(i,1);temp_verts(:,1)]);
    obs_min_xyz(i,2) = min([obs_min_xyz(i,2);temp_verts(:,2)]);
    obs_min_xyz(i,3) = min([obs_min_xyz(i,3);temp_verts(:,3)]);
    
    % max
    obs_max_xyz(i,1) = max([obs_max_xyz(i,1);temp_verts(:,1)]);
    obs_max_xyz(i,2) = max([obs_max_xyz(i,2);temp_verts(:,2)]);
    obs_max_xyz(i,3) = max([obs_max_xyz(i,3);temp_verts(:,3)]);
  end
end