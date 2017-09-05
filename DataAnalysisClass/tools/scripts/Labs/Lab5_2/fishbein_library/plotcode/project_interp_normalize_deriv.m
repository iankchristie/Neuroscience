function [normalizestandards3] = project_interp_normalize_deriv(filename, pc, themean)

standards = read_standard_data(filename);
interp_standards = modify_standards(standards,'interpolate_meltcurve');
normalizestandards1 = modify_standards(interp_standards,'normalize_01');
normalizestandards2 = modify_standards(normalizestandards1,'normalize_by_lastvalue');
if 1,
	normalizestandards3 = modify_standards(normalizestandards2,'meltcurve_2derivative');
else,
	normalizestandards3 = modify_standards(normalizestandards2,'meltcurve_derivative');
end;
[h]=plot_standard_projection(normalizestandards3, pc, themean);

title([filename],'Interpreter','none');
