function normalizedmeltcurve = normalize_by_first_value(mymeltcurve)

normalizedmeltcurve = [mymeltcurve(1,:) ; mymeltcurve(2,:)/(mymeltcurve(2,1))];
