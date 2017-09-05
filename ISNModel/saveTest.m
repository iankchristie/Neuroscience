function [ out ] = saveTest( a, b, c)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

out = 2*a;

save(sprintf('/Users/ianchristie/Desktop/S%dW%d/A.mat', b, c), 'out');

end

