function [ output ] = PlotAssymetric4Color(matrixA, matrixB, W11, W12, W21, W22)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

output = 0;

[~, ~, m, n] = size(matrixA);

plotLength = floor(sqrt(n));
plotWidth = ceil(sqrt(n));

while(plotLength*plotWidth < n),
    plotLength = plotLength + 1;
end

for i=1: m,
    temp = num2str(W22(i));
    titleString = ['W22 set to ' temp];
    figure('name', titleString);
    
    for j=1: n,
        subplot(plotLength,plotWidth,j);
        temp2 = num2str(W21(j));
        plot4Color(W12, W11, matrixA(:,:,j,i), matrixB(:,:,j,i), ['W21 set to ' temp2],'W12','W11');
    end
end

output = output + 1;
end

