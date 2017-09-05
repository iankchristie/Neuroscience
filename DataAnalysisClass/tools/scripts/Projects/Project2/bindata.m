function [ result_times, result_crossings ] = bindata( times, crossings )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
intervalTime = 0.5;
SR = 1/60;
intervalIndex = intervalTime/SR;

count = 1;
row = 1;
result_times = zeros(ceil(length(times)/ intervalIndex), intervalIndex);
result_crossings = zeros(ceil(length(crossings)/ intervalIndex), intervalIndex);
for i = 1: length(crossings),
    if count > intervalIndex,
        row = row + 1;
        count = 1;
    end
    result_times (row,count) = times(i);
    result_crossings(row, count) = crossings(i);
    count = count+1;
end


end




