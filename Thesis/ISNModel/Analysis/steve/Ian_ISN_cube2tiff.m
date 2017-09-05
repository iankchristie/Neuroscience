function Ian_ISN_cube2tiff(filename)
% Ian_ISN_cube2tiff - convert a cube to a tiff and write it to disk
%
%  filename should be full path
%  NOTE: closes all open windows

close all;

[pathname,name] = fileparts(filename);

ISN_stats_name = fullfile(pathname,'ISN_stats.mat');

image_filename = fullfile(pathname,'images.tif');

load(filename);
load(ISN_stats_name);

cubeimg = drawCube(cube,ISN_stats);
map = getColorMap5;

close all;

for i=1:size(cubeimg,1),
	if i==1,
		imwrite((squeeze(cubeimg(i,:,:))),map,image_filename, 'WriteMode','overwrite');
	else,
		imwrite((squeeze(cubeimg(i,:,:))),map,image_filename, 'WriteMode','append');
	end;
end;

