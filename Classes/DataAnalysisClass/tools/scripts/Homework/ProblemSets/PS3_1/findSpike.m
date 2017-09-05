function [ result ] = findSpike(v, thresh)
%FINDSPIKE returns bitmap of indices where v(i-1) is above threshold and
%v(i) is below threshhold  

result = zeros(1, length(v));

for i = 2: length(v),
    if v(i) <= thresh && v(i-1) > thresh,
        result(i) = 1;
    end
end

end

