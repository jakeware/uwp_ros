function [ msh_file_contents ] = mshread( filelocation, disp_loading_progress )
%MSHREAD Loads Fluent msh file.
%
% USAGE: (Loading files)
% [ msh_file_contents ] = mshread( filelocation )
% [ msh_file_contents ] = mshread( '' ); % asks for *.MSH file.
% OPTIONAL - show loading progress
% [ msh_file_contents ] = mshread( filelocation , 1); % load file // show progress
% [ msh_file_contents ] = mshread( '' , 1);           
%
% % VISUALISATION EXAMPLE
% [ msh_file_contents ] = mshread( '' , 1); % load file // show progress
%
% f1 = figure(1); set(f1,'color','w'); axis off; hold on
% colors = {'r','g','b','m','y','k','r','g','b','m','y','k','r','g','b','m','y','k','r','g','b','m','y','k','r','g','b','m','y','k','r','g','b','m','y','k','r','g','b','m','y','k'};
% fnames = fieldnames(msh_file_contents);
% fnames = fnames(~strcmpi(fnames,'vertices')'); lg=1;
% for i = 1:numel(fnames)
%     if strcmp(msh_file_contents.(fnames{i}).facetype,'wall')
%        patch('Faces',msh_file_contents.(fnames{i}).faces,'Vertices',msh_file_contents.vertices,'FaceColor',colors{i},'edgecolor','k'); hold on
%        legend_names{lg} = fnames{i}; lg = lg+1;
%     end
% end
% legend(legend_names{:})
% view(3); axis equal vis3d tight

%% CHECK INPUTS
narginchk(0,2); nargoutchk(1,1);
switch nargin
    case 0, validfile = 0;
    case 1, if exist(filelocation,'file') == 2, validfile = 1; else validfile = 0; disp_loading_progress = 0; end
    case 2, if exist(filelocation,'file') == 2, validfile = 1; else validfile = 0; try if disp_loading_progress ~= 1,disp_loading_progress = 0; end, catch, disp_loading_progress = 0; end; end
end
if ~validfile % if no (valid) filepath is provided; let the user select one
    [filename,pathtofile] = uigetfile({'*.msh;*.MSH','msh files'},'Select *.msh file to load...');
    filelocation = fullfile(pathtofile,filename);
end

%% Open
t1 = tic;
fid = fopen(filelocation,'r');

%% Parse
vertices_array = [];
vertices_total = 0;
vertices_zone_count = 0;
vertices_zone_number = [];
all_vertices = {};
faces_array = [];
faces_total = 0;
all_faces = {};
cells_total = 0;
region_id = 1;

% read until eof
while ~feof(fid)
  
  % ignore some crap
  cur_line = fgetl(fid);
  while (length(cur_line) < 6) || (~strcmp(cur_line(end-1:end),')(') && ~strcmp(cur_line(end-2:end),'())') && ~(strcmp(cur_line(1:3),'(12') && strcmp(cur_line(6),'2'))) && ~feof(fid)
      cur_line = fgetl(fid);
  end

  % read section header
  results = sscanf(cur_line,'(%g (%x %x %x %x %x)(')';
  
  % read vertices
  if results(1) == 10
    % increment count
    vertices_zone_count = vertices_zone_count + 1;
    
    % parse header
    vertices_number = results(2);
    vertices_count = results(4)-results(3)+1;  % # of vertices
    
    % get zone number
    vertices_zone_number(vertices_zone_count) = vertices_number;
    
    % read vertices
    vertices = fscanf(fid,'%f',[3 vertices_count])';
    eval(['vertices_' num2str(vertices_number) ' = vertices; all_vertices = {[''vertices_'' num2str(vertices_number)] all_vertices{:}};'])
    
    % print results
    if disp_loading_progress
      disp(['vertices read: ', num2str(length(vertices)), ', time: ', num2str(toc(t1)), ' seconds'])
    end
    
    % store vertices
    vertices_total = vertices_total + vertices_count;
    vertices_array = [vertices_array; vertices];
  end
  
  % read faces
  if results(1) == 13
    % parse header
    faces_number = results(2);  % zone id
    faces_count = results(4)-results(3)+1;  % # of faces
    faces_type = results(6);  % type of faces (3 connected points, 4 connected points)
    
    % read faces
    faces = fscanf(fid,'%x %x %x %x %x',[5 faces_count])';
    eval(['faces_' num2str(faces_number) ' = faces(:,1:3); all_faces = {[''faces_'' num2str(faces_number)] all_faces{:}};'])
            

    % print results
    if disp_loading_progress
       disp(['faces read: ', num2str(length(faces)), ', time: ', num2str(toc(t1)), ' seconds'])
    end

    % store faces
    faces_total = faces_total + faces_count;
    faces_array = [faces_array; faces];
  end
  
  % read cells
  if results(1) == 12
    % parse header
    cells_count = results(4)-results(3)+1;  % # of cells
    
    % print results
    if disp_loading_progress
       disp(['cells count: ', num2str(cells_count)])
    end
    
    % store cells
    cells_total = cells_total + cells_count;
  end
  
  % read zones
  if results(1) == 45
    result = strsplit(cur_line,{')','(',' '});
    eval('ZONE(region_id).number = num2str(result{3});')
    eval('ZONE(region_id).name   = result{5};')
    eval('ZONE(region_id).type   = result{4};')
    
    region_id = region_id + 1;
  end
end

%% close file
if feof(fid)
    fclose(fid);
end

%% Cells
% increment cell id
% faces_array(:,4) = faces_array(:,4) + 1;
% faces_array(:,5) = faces_array(:,5) + 1;

% create faces
cells_array = zeros(cells_total,4);
for i=1:size(cells_array,1)
%   inds = find(faces_array(:,4) == i | faces_array(:,5) == i);
  cells_array(i,:) = unique(faces_array(faces_array(:,4) == i | faces_array(:,5) == i,1:3))';
end

%% Output
% for i = 1:length(vertices_zone_count)
%   msh_file_contents.vertices(i) = eval(['vertices_' num2str(vertices_zone_number(i)]);
% end
% msh_file_contents.vertices = eval(['vertices_' num2str(vertices_zone_number(2))]);
msh_file_contents.vertices = vertices_array;
msh_file_contents.faces = faces_array;
msh_file_contents.cells = cells_array;
for i = 1:length(ZONE)
    if ~strcmp(ZONE(i).type,'fluid') % somehow fluid part is not present in the msh file - is called default-interior
        msh_file_contents.(strrep(ZONE(i).name,'-','_')).faces = eval(['faces_' num2str(ZONE(i).number)]);
        msh_file_contents.(strrep(ZONE(i).name,'-','_')).facetype = ZONE(i).type;
        msh_file_contents.(strrep(ZONE(i).name,'-','_')).number = ZONE(i).number;
    end
end