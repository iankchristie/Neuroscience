default = .5;
steps = 30;
inc = 1;
max = zeros(1,steps);
k = zeros(1,steps);
count = 0;
for i = 0:inc:steps*inc
    count = count+1;
    [m1, m2] = quickTWCFunction(i,default);
    k(1,count) = i;
    max(1,count) = m1;
end

plot(k,max);