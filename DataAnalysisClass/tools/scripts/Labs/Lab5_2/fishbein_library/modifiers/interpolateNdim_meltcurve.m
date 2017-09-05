function newmeltcurve = interpolateNdim_meltcurve(mymeltcurve,N)
skyeglobals;

if nargin<2, n = size(mymeltcurve,1);
else, n = N; end;

newmeltcurve=[skye_common_temp];

for i=2:n,
    normalizedmeltcurve = [interp1(mymeltcurve(1,:),mymeltcurve(i,:), skye_common_temp,'linear')];
    newmeltcurve= cat(1,newmeltcurve,normalizedmeltcurve);
end
