function [normalizestandards3, pc, themean] =interp_normalize_deriv(standards)

interp_standards = modify_standards(standards,'interpolateNdim_meltcurve');
normalizestandards1 = modify_standards(interp_standards,'normalizeNdim_01');
normalizestandards2 = modify_standards(normalizestandards1,'normalizeNdim_by_lastvalue');
normalizestandards3 = modify_standards(normalizestandards2,'meltcurveNdim_2derivative');
