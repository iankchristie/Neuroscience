function [fig] = PlotFourDataISN(le, re, li, ri, x, y, z)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

f = gcf;

subplot(x, y, z);
plot(le);
hold on
plot(re, 'r');
hold on
plot(li, 'g');
hold on
plot(ri, 'y');
hold off

end

