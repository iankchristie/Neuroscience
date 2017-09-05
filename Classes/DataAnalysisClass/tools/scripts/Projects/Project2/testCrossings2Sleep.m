function [ resultTimes, resultCrossings ] = testCrossings2Sleep( times, crossings )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%timeSleeping = [];
%[binnedTimes, binnedCrossings] = binData(times, crossings);
%[m,n] = size(binnedCrossings)
%for i = 1: m,
%   timeSleeping = [timeSleeping; getTimeSleeping(binnedCrossings)]
%end
%times = mean(binnedTimes')

intervalTime = .5;
SR = 1/60;
intervalIndex = intervalTime/SR;

count = 1;
row = 1;
resultTimes = zeros(ceil(length(times)/ intervalIndex), intervalIndex);
resultCrossings = zeros(ceil(length(crossings)/ intervalIndex), intervalIndex);

for i = 1: length(crossings),
    if count > intervalIndex,
        row = row + 1;
        count = 1;
    end
    resultTimes(row, count) = times(i);
    resultCrossings(row, count) = crossings(i);
    count = count + 1;
end

countVec = [0,0];
count = 0;
new = 0;

for i = 1: length(crossings),
    if crossings(i) == 0,
        countVec(end) = countVec(end) + 1;
        new = 1;
    elseif new == 1,
        countVec(end+1) = 0;
        new = 0;
    end   
end

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
totalSleep = totalSleep + count;

end

