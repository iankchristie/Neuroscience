function [ out ] = drawCube(cube, ISN_stats)
%UNTITLED13 Summary of this function goes here
%   Detailed explanation goes here

[n, m, p] = size(cube);

out = zeros(n,m,p);

for i = 1: n,
    out(i,:,:) = drawSlice(cube(i,:,:), ISN_stats(i,:,:));
    title(['Slice ' int2str(i) '.']);
end

end

