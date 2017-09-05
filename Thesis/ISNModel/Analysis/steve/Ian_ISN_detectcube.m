function Ian_ISN_detectcube(filename)
% 
%
%  FILENAME: full path


[dirname, thefilename] = fileparts(filename),

load(filename);

ISN_stats = {};

for i=1:26,
	for j=1:size(cube,2),
		[i j],
		for k=1:size(cube,3),
			ISN_stats{i,j,k} = Ian_ISN_detect(cube{i,j,k});
		end;
	end;
end;

save(fullfile(dirname,'ISN_stats.mat'),'ISN_stats','-mat');
