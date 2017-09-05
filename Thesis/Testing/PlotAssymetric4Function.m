function [ matrix ] = PlotAssymetric4Function(matrix, W11, W12, W21, W22)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[m, ~, ~, n] = size(matrix);

plotLength = floor(sqrt(n));
plotWidth = ceil(sqrt(n));

while(plotLength*plotWidth < n),
    plotLength = plotLength + 1;
end

for i=1: m,
    temp = num2str(W11(i));
    titleString = ['W11 set to ' temp];
    figure('name', titleString);
    
    for j=1: n,
        subplot(plotLength,plotWidth,j);
        temp2 = num2str(W22(j));
        plotImagesc(W12, W21, permute(matrix(i,:,:,j), [2 3 1 4]), ['W22 set to' temp2],'W12','W21');
        %caxis([-1 1]);
    end
end

end

