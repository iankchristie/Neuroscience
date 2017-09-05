function [normalizestandards3, pc, themean] = read_interp_normalize_deriv(filename)

standards = read_standard_data(filename);
interp_standards = modify_standards(standards,'interpolate_meltcurve');
normalizestandards1 = modify_standards(interp_standards,'normalizeNdim_01');
normalizestandards2 = modify_standards(normalizestandards1,'normalize_by_lastvalue');
if 1,
	normalizestandards3 = modify_standards(normalizestandards2,'meltcurveNdim_2derivative');
else,
	normalizestandards3 = modify_standards(normalizestandards2,'meltcurveNdim_2derivative');
end;
figure;
[h,pc,v,themean]=plot_standard_pca(normalizestandards3);

title([filename],'Interpreter','none');
