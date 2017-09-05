function [finalnorm] = project_read_interp_normalize_2derivN(filename, pcaN)

if nargin<2,
    usePCAN = 0;
else,
    usePCAN = pcaN;
end;

shift_standards = read_standard_raw_data(filename);

 % change below so it
 % normalize each dimension by first and last value (you'll have to write a pair of new modifiers that does this for each dimension)
 % make a multidimensional interp function that interpolates each dimension
 % make a 2nd derivative that works in ND
 % convert to 1D
 % project to pca

interp_standards = modify_standards(shift_standards,'interpolateNdim_meltcurve');
normalizestandards1 = modify_standards(interp_standards,'normalizeNdim_01');
normalizestandards2 = modify_standards(normalizestandards1,'normalizeNdim_by_lastvalue');
normalizestandards3 = modify_standards(normalizestandards2,'meltcurveNdim_2derivative');
finalnorm=modify_standards(normalizestandards3,'NDto1D');
if usePCAN,
    h = plot_standard_pcaN(finalnorm,3);
else,
    h=plot_standard_pca(finalnorm);
end;
title([filename],'Interpreter','none');
