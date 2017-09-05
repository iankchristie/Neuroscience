function normalizedmeltcurve = normalizeNdim_01(mymeltcurve)
    normalizedmeltcurve=mymeltcurve(1,:);
    for i=2:size(mymeltcurve,1)
        myzerocurve = mymeltcurve(i,:)-mymeltcurve(i,1);
        normalizedmeltcurve = cat(1,normalizedmeltcurve,myzerocurve);
    end
    

