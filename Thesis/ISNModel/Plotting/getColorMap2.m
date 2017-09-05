function [ cmap ] = getColorMap2()
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here

cmap = [0, 0, 0;    %1 Black:None of these 
        1, 1, 1;    %2 white: Unresponsive      (Unresponsive)
        .5, .5, .5; %3 Grey: Unselective        (Unselective)
        0, 0, 1;    %4 Blue: DS ISN             (DSSupress)
        0, 0, .5;   %5 Light Blue: DS nonISN    (DS)
        1, 0, 0;    %6 red: uni ISN             (UniSupress)
        .5, 0, 0;   %7 lightRed: Uni non-ISN    (Uni)
        0, 1, 0;    %8 Green: halfUni1 ISN      (HalfUniSupress)
        0, .5, 0;   %9 Green: halfUni1 non-ISN  (HalfUni)
        1, 1, 0;    %10 Yellow: halfUNI2 ISN    (Half2UniSupress)
        .5, .5, 0;];%11 Yellow: halfUNI2 ISN    (HalfUni2)
end