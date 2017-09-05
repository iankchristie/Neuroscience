function normalizedmeltcurve = normalizeNdim_by_lastvalue(mymeltcurve)

normalizedmeltcurve = [mymeltcurve(1,:) ; mymeltcurve(2,:)/(mymeltcurve(2,end))];