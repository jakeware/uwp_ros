%% Find Nearest Neighbors
% get nearest neighbors
[vert_inds, vert_dists] = knnsearch(mesh_data.vertices,reg_pos_xyz,'K',1,'NSMethod','kdtree','Distance','euclidean');

% distances
vert_dists_array = reshape(vert_dists,size(reg_pos_x_array));