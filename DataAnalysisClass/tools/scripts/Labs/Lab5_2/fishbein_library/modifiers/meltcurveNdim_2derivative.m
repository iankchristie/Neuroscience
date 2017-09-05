function d = meltcurveNdim_2derivative(mymeltcurve)

d = mymeltcurve(1,2:end-1);
for i=2:size(mymeltcurve,1)
   deriv=mymeltcurve(i,3:end) + mymeltcurve(i,1:end-2) - 2*mymeltcurve(i,2:end-1);
   d=cat(1,d,deriv);
end
