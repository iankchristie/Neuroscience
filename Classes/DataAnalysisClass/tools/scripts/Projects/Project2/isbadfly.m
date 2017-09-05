function [ out ] = isbadfly( times, crossings )
%
Threshold = 80;
out = 0;
SR = 1/60;
starting_index = round(Threshold/SR);
subvector = crossings(starting_index: end);
findsubvector = find(subvector);
if isempty(findsubvector) || length(findsubvector) == length(subvector),
    out = 1;
end
end

