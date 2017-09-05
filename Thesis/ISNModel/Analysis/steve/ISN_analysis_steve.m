
prefix = '/Users/vanhoosr/Dropbox/brandeis/publications_ongoing/cortical_model_direction_selectivity/Neuroscience/ISNModel/Data/Data4D';

addpath(genpath('/Users/vanhoosr/Dropbox/brandeis/publications_ongoing/cortical_model_direction_selectivity/Neuroscience/ISNModel/Analysis'));
addpath(genpath('/Users/vanhoosr/Dropbox/brandeis/publications_ongoing/cortical_model_direction_selectivity/Neuroscience/ISNModel/Elements'));
addpath(genpath('/Users/vanhoosr/Dropbox/brandeis/publications_ongoing/cortical_model_direction_selectivity/Neuroscience/ISNModel/Plotting'));
addpath(genpath('/Users/vanhoosr/Dropbox/brandeis/publications_ongoing/cortical_model_direction_selectivity/Neuroscience/ISNModel/Run'));

filelist = {'S9W1','S9W8','S10W9','S15W10','S17W10','S20W10','S18W16','S17W15'};

if ~exist('cubelist','var'),
	cubelist = {};

	for i=1:length(filelist),
		disp(['Loading cube ' int2str(i) ' of ' int2str(length(filelist)) '.']);
		cubelist{i} = getfield(load([prefix filesep filelist{i} filesep 'Cube.mat'],'-mat'),'cube');
	end;
end;

out=plot_ISN_4d_2dproj(cubelist,'x.Wxi1','x.Wxi2','Constraint1','(x.Wxe1==0)&&(x.Wxe2==0)',...
	'SubplotTitles',filelist);


out2=plot_ISN_4d_2dproj(cubelist,'x.Wxi1','x.Wxi2','Constraint1','(x.Wxe1==0.2)&&(x.Wxe2==0)',...
	'SubplotTitles',filelist);

out8=plot_ISN_4d_2dproj(cubelist,'x.Wxi1','x.Wxi2','Constraint1','(x.Wxe1==0.8)&&(x.Wxe2==0)',...
	'SubplotTitles',filelist);


out55=plot_ISN_4d_2dproj(cubelist,'x.Wxi1','x.Wxi2','Constraint1','(x.Wxe1==0.5)&&(x.Wxe2==0.5)',...
	'SubplotTitles',filelist);  % boring, nothing going on, all responsive

out4015=plot_ISN_4d_2dproj(cubelist,'x.Wxi1','x.Wxi2','Constraint1','(abs(x.Wxe1-0.4)<0.001)&&(abs(x.Wxe2-0.15)<0.001)',...
	'SubplotTitles',filelist);

outi5525=plot_ISN_4d_2dproj(cubelist,'x.Wxe1','x.Wxe2','Constraint1','(abs(x.Wxi1-0.55)<0.001)&&(abs(x.Wxi2-0.25)<0.001)',...
	'SubplotTitles',filelist);

