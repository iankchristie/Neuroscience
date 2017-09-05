function [ cmap ] = getColorMap()
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here

cmap = [0, 0, 0;    %1-Black: Nan
        .5,.5,.5;   %2-Grey: Blowsup
        1, 1, 1;    %3-white: Oscilates
        .75,.75,.75;%4-Grey-white: blowsup and oscillates
        0, 0, .5;   %5-lightBlue: DS no suppression
        0, 0, 1;    %6-Blue: Ds suppression
        .5, 0, 0;   %7-lightRed: Uni & suppression doesn't follow
        1, 0, 0;    %8-red: uni & with suppression pattern
        1 1 0;];    %9-idk now

end