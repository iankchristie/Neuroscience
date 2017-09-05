function [normalizestandards3, pc, themean] = read_shift_interp_normalize_2deriv(filename, normmethodarg)

if nargin<2, normmethod = 1;
else, normmethod = normmethodarg;
end;

 % normmethod 
 %  1 means use first and last point
 %  2 means use first point of 2nd derivative

standards = read_standard_data(filename);
shift_standards = modify_standards(standards,'shift_meltcurve_trough88');
interp_standards = modify_standards(shift_standards,'interpolate_meltcurve');
if normmethod==1, 
	normalizestandards1 = modify_standards(interp_standards,'normalize_01');
	normalizestandards2 = modify_standards(normalizestandards1,'normalize_by_lastvalue');
elseif normmethod==2, 
	normalizestandards2 = interp_standards;
end;
if 1,
	normalizestandards3 = modify_standards(normalizestandards2,'meltcurve_2derivative');
else,
	normalizestandards3 = modify_standards(normalizestandards2,'meltcurve_derivative');
end;

if normmethod==2,
	normalizestandards3 = modify_standards(normalizestandards3,'normalize_by_firstvalue');
end;

figure;
[h,pc,v,themean]=plot_standard_pca(normalizestandards3);

title([filename],'Interpreter','none');
