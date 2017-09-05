function [ rotatedEllipse ] = makeRotatedEllipse(sizeOfImage, majorRadius, minorRadius, thetaDegrees)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

x = -sizeOfImage/2:sizeOfImage/2;

[X,Y] = meshgrid(x,x);

theta = thetaDegrees * pi / 180;

rotatedEllipse = ((X*cos(theta)+X*sin(theta)).^2)/majorRadius^2+((X*sin(theta)-Y*cos(theta)).^2)/minorRadius^2 <= 1;


end

