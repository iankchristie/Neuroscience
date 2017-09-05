
dT = .001;

x = -10:dT:10;
y = zeros(1,length(x));

for i = 1: length(x),
    y(i) = stdp_kernel2(x(i));
end

plot(x,y);

sum(dT*y(1:floor(end/2)))

sum(dT*y(ceil(end/2)+1:end))

sum(dT*y)