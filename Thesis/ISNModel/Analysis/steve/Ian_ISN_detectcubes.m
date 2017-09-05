function Ian_ISN_detectcubes(indexes)

pathname = '/Users/vanhoosr/Dropbox/brandeis/publications_ongoing/cortical_model_direction_selectivity/Neuroscience/ISNModel/Data/data115 4:28/';

d = dirstrip(dir(pathname));

d = d([d.isdir]);

for i=1:length(indexes),
	filename = [pathname d(indexes(i)).name filesep 'Cube.mat'];
	disp(['Working on ' filename '.']);
	Ian_ISN_detectcube(filename);
end;


