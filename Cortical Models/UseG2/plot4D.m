function [output] = plot4D(matrix,uniformVector)
%plot4D plots a 4 dimensional matrix assuming it is of equal length on all
%dimensions
%   Pass in a 4 dimensional matrix and a uniform vector. Primarily
%   [-1:.2:1]
output = 0;

[x y m n] = size(matrix);

plotLength = ceil(sqrt(n));
plotWidth = floor(sqrt(n));

for i=1: m,
    temp = num2str(uniformVector(i));
    titleString = ['W22 set to ' temp];
    figure('name',titleString);
    
    for j=1: n,
        subplot(plotLength,plotWidth,j);
        temp2 = num2str(uniformVector(j));
        plotImagesc(uniformVector, uniformVector, matrix(:,:,j,i), ['W21 set to' temp2],'W12','W11');
        caxis([-1 1]);
    end
end
output = output +1;
end

