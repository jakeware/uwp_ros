%% Plot Mesh Wall Zones
if plot_mesh
  f1 = figure(1); set(f1,'color','w'); axis off; hold on
  colors = {'r','g','b','m','y','k','r','g','b','m','y','k','r','g','b','m','y','k','r','g','b','m','y','k','r','g','b','m','y','k','r','g','b','m','y','k','r','g','b','m','y','k'};
  fnames = fieldnames(mesh_data);
  fnames = fnames((~strcmpi(fnames,'vertices') & ~strcmpi(fnames,'faces') & ~strcmpi(fnames,'cells') & ~strcmpi(fnames,'cells_count'))'); lg=1;
  for i = 1:numel(fnames)
      if strcmp(mesh_data.(fnames{i}).facetype,'wall') || strcmp(mesh_data.(fnames{i}).facetype,'velocity-inlet') || strcmp(mesh_data.(fnames{i}).facetype,'pressure-outlet')
  %     if strcmp(mesh_data.(fnames{i}).facetype,'interior')
         patch('Faces',mesh_data.(fnames{i}).faces,'Vertices',mesh_data.vertices,'FaceColor',colors{i},'edgecolor','k'); hold on
         legend_names{lg} = fnames{i}; lg = lg+1;
      end
  end
  legend(legend_names{:})
  view(3); axis equal vis3d tight
  hold off
end