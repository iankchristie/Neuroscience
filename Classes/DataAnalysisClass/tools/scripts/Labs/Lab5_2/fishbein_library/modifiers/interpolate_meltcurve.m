function normalizedmeltcurve = interpolate_meltcurve(mymeltcurve)
skyeglobals;

normalizedmeltcurve = [skye_common_temp; interp1(mymeltcurve(1,:),mymeltcurve(2,:), skye_common_temp,'linear')];
