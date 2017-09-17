function [node_ind, node_wts] = testTets(test_xyz,test_cells,mesh_data)
  bcoords = zeros(size(test_cells,1),4);
  bsigns = zeros(size(test_cells,1),4);
  bsigns_sum = zeros(size(test_cells,1),1);
  for i=1:size(test_cells,1)
    % get point
    test_tet_xyz = mesh_data.vertices(test_cells(i,:),1:3);
    
    % get barycentric coordinates
    bcoords(i,:) = getBaryCoords(test_xyz,test_tet_xyz);
    
    % get signs of barycentric coordinates
    bsigns(i,:) = sign(bcoords(i,:,:));
    
    % check if any are negative
    bsigns_sum(i) = sum(bsigns(i,:) < 0);
  end
  
  % get cell of first cell with lowest number of negative bcoord values
  [val,ind] = min(bsigns_sum);
  
  if val > 1
    display('Warning: No valid tetrahedron found.')
  end
  
  node_ind = test_cells(ind,:);
  node_wts = bcoords(ind,:);
end