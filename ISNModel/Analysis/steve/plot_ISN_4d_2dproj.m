function out = plot_ISN_4d_2dproj(cubelist, XAxis, YAxis, varargin)
% PLOT_ISN_4D_2DPROJ - Plot a 2d projection of ISN model simulations
%
%  OUT = PLOT_ISN_4D_2DPROJ(CUBELIST,LABELCOLORSTRUCT,XAXIS,YAXIS,...)
%
%  Given a cubelist, plots a 2d projection (as an image) of the space
%
%  X_axis is the value to use to read the X axis (e.g., 'x.Wxi1')
%  Y_axis is the value to use to read the Y axis (e.g., 'x.Wxi2')
%
%  This function also takes extra arguments in name/value pairs:
%  Parameter (default value)  |  Description
%  ---------------------------------------------------------------------   
%  'DoPlot' (1)               |  Should we actually do the image plot?
%  'Constraint1' ('1')        |  Constraint for inclusion in plot (1 means include)
%                             |    (e.g., 'x.Wxe1==0')
%  'Constraint2' ('1')        |  Constraint for inclusion in plot (1 means include)
%  'labelcolorstruct'         |  Structure list of labels, colors, and labeling functions
%    (IanISNlabelscolors)     |     (see HELP IANISNLABELSCOLORS)
%  'SubplotTitles' {}         |  Subplot titles (1 entry per cubelist entry)
%

if nargin == 0, % it's a callback

	out = get(gcf,'userdata');
	pt = get(gca,'CurrentPoint');
	pt = pt(1,[1 2]); % get 2D proj

	axistag = get(gca,'tag');
	axis_num = sscanf(axistag,'Axis%d',1);
	if ~isempty(axis_num),
		disp(['On axis ' int2str(axis_num)]);
		x_index = findclosest(out(axis_num).X_axis_values,pt(1));
		y_index = findclosest(out(axis_num).Y_axis_values,pt(2));
		figure;
		plot_ISN4d_output(out(axis_num).D_struct{x_index,y_index});
	end;

	return;
end;

Constraint1 = '1';
Constraint2 = '1';
labelcolorstruct = IanISNlabelscolors;
SubplotTitles = {};
DoPlot = 1;

assign(varargin{:});

if ischar(cubelist{1}),
	cubefilenames = cubelist;
else,
	cubefilenames = {};
end;

out = [];

for i=1:length(cubelist),
	if ischar(cubelist{i}),
		cubelist{i} = getfield(load(cubelist{i},'cube','-mat'),'cube');
	end;

	X_axis_values = [];
	Y_axis_values = [];
	D = [];
	D_indexes = [];
	D_cubeindexes = [];
	D_struct = {};

	disp(['Now working on cube ' int2str(i) ' of ' int2str(length(cubelist)) '.']); 
	for j=1:numel(cubelist{i}),
		if mod(j,50000)==0, disp(['  Now on iteration ' int2str(j) ' of ' int2str(numel(cubelist{i})) '.']); end;
		x = cubelist{i}{j};
		a = eval(Constraint1);
		b = eval(Constraint2);
		if a & b,
			x_value = eval(XAxis);
			ind_x = find(X_axis_values==x_value,1);
			if isempty(ind_x),
				X_axis_values(end+1) = x_value;
				ind_x = numel(X_axis_values);
			end;

			y_value = eval(YAxis);
			ind_y = find(Y_axis_values==y_value,1);
			if isempty(ind_y),
				Y_axis_values(end+1) = y_value;
				ind_y = numel(Y_axis_values);
			end;

			[c,ind] = get_ISN_labelcolor(x,labelcolorstruct,'ErrorIfNotUnique',1);
			if isempty(ind),
				ind = -1;
				c = [0 0 0];
			end;
			%if ind_x==3 & ind_y==16, keyboard; end;
			D(ind_x,ind_y,:) = reshape(c,1,1,3);
			%if all(size(D_indexes)>=[ind_x ind_y])
			%	if D_indexes(ind_x,ind_y)~=0,
			%		keyboard;
			%	end;
			%end;
			D_indexes(ind_x,ind_y) = ind;
			D_cubeindexes(ind_x,ind_y) = j;
			D_struct{ind_x,ind_y} = x;
		end;
	end;

	if isempty(out),
		out = var2struct('X_axis_values','Y_axis_values','D','D_indexes','D_cubeindexes','D_struct');
	else,
		out(end+1) = var2struct('X_axis_values','Y_axis_values','D','D_indexes','D_cubeindexes','D_struct');
	end;

	if ~isempty(cubefilenames),
		cubelist{i} = []; % release memory
	end;
end;

 % now do the plotting
 % for now, restrict to 9 graphs

if length(cubelist)==1,
	plot_r = 1;
	plot_c = 1;
elseif length(cubelist)<=3,
	plot_r = 1;
	plot_c = 3;
elseif length(cubelist)>9,
	error(['i am currently not smart enough to plot more than 9 graphs simultaneously']);
else,
	plot_r = 3;
	plot_c = 3;
end;

f = figure;

for i=1:length(cubelist),
	subplot(plot_r,plot_c,i);

	if 0,
		h=image(out(i).X_axis_values,out(i).Y_axis_values,out(i).D_indexes + 2,'ButtonDownFcn',plot_ISN_4d_2dproj');
		labelcolors = reshape([labelcolorstruct.PlotColor],3,length(labelcolorstruct))';
		cmap = [0 0 0; 0.2 0.2 0.2;  labelcolors; labelcolors*0.5];
		colormap(cmap);
	else,
		h=image(out(i).X_axis_values,out(i).Y_axis_values,permute(out(i).D,[2 1 3]),'ButtonDownFcn',plot_ISN_4d_2dproj');
	end;

	axis square;

	if length(SubplotTitles)>= i,
		title(SubplotTitles{i},'interp','none');
	end;
	ylabel(YAxis,'interp','none');
	xlabel(XAxis,'interp','none');

	set(gca,'ButtonDownFcn','plot_ISN_4d_2dproj;','tag',['Axis' int2str(i) ],'ydir','normal');

	box off;
	set(h,'ButtonDownFcn','plot_ISN_4d_2dproj;');
end;

set(f,'userdata',out);


