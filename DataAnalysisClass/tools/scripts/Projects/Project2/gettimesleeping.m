function [ totalSleep ] = gettimesleeping( crossings )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
allZero = find(crossings == 0);
count = 1;
totalSleep = 0;


for i = 2: length(allZero),
    if allZero(i) == allZero(i-1) + 1,
        count = count + 1;
    else
        if count >= 5,
            totalSleep = totalSleep + count;
            count = 1;
        end
    end
end
if count >= 5,
    totalSleep = totalSleep + count;
    count = 1;
end

end