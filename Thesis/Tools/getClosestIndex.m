function [index] = getClosestIndex(val, arr)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

index = -1;

temp = abs(arr-val);

[~, index] = min(temp); %index of closest value

end

