function [k, max] = TWCFunction(varargin)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here


default = .314;
final = 5;
inc = .1;
start = 0;

assign(varargin{:});

max = zeros(2,(final-start)/inc);
k = zeros(1,(final-start)/inc);

count = 0;
for i = start:inc:final
    count = count+1;
    [m1, m2] = quickTWCFunction(i,default);
    k(1,count) = i;
    max(1,count) = m1;
    max(2,count) = m2;
end

plot(k,max);

end

