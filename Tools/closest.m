function [ closestIndex ] = closest( val, array )
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here

[~, index] = min(abs(array-val));
closestIndex = index(1);


end

