function [bool, count] = oscillating(v, num)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

bool = 0;

count = 0;

avg = mean(v);

for i=2:length(v),
    if (v(i) > avg && v(i-1) <= avg)
        count = count + 1;
    end
    if (v(i) <= avg && v(i-1) > avg)
        count = count + 1;
    end
end

if count >= num
    bool = bool + 1;
end

end

