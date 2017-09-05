function normalizedmeltcurve = normalizeNdim_by_lastvalue(mymeltcurve)
        normalizedmeltcurve=mymeltcurve(1,:);
    for i=2:size(mymeltcurve,1)
        normmelt=mymeltcurve(i,:)/mymeltcurve(i,end);
        normalizedmeltcurve = cat(1,normalizedmeltcurve,normmelt);
    end