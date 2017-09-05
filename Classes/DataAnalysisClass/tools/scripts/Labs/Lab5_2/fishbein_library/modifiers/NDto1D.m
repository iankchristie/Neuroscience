function d = NDto1D(mymeltcurve)

d = [ mymeltcurve(1,:) ; mymeltcurve(2,:) ];

temp_start = d(1,1);

for i=3:size(mymeltcurve,1),
	d = [ d [ (d(1,end)-temp_start)+5+mymeltcurve(1,:) ; mymeltcurve(i,:) ] ];
end;
