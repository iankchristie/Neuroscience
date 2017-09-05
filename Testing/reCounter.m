function [count] = reCounter(num, start, stop, inc)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

count = 0;

for i = start:inc:stop,
    count = count + 1;
    if num == i,
        break
    end
end
end
