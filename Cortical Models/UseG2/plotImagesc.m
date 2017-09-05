function [output] = plotImagesc(vectorX, vectorY, matrix, t, xax, yax)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

output = 0;

imagesc(vectorX, vectorY, matrix);
colorbar;
set(gca, 'ydir','normal');
title(t);
xlabel(xax);
ylabel(yax);

output = output + 1;

end
