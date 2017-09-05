function d = meltcurveNdim_derivative(mymeltcurve)
d=mymeltcurve(1,1:end-1);
for i=2: size(mymeltcurve,1)
   deriv=diff(mymeltcurve(i,:));
   d=cat(1,d,deriv);
end
