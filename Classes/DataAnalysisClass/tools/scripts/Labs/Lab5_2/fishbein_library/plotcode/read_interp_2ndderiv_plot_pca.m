function [normalizefirstvalinterpstandards, pc, themean] = read_interp_2ndderiv_plot_pca(filename)

standards = read_standard_data(filename);
interp_standards = modify_standards(standards,'interpolate_meltcurve');
normalizeinterpstandards = modify_standards(interp_standards,'meltcurve_2derivative');
normalizefirstvalinterpstandards = modify_standards(normalizeinterpstandards,'normalize_by_firstvalue');

figure;
[h,pc,v,themean]=plot_standard_pca(normalizefirstvalinterpstandards);

title([filename],'Interpreter','none');
