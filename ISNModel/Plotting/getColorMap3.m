function [ cmap ] = getColorMap3()
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here

cmap = [1, 1, 1;    %1 white: Unresponsive      (Unresponsive)
        .5, .5, .5; %2 Grey: Unselective        (Unselective)
        0, 0, 1;    %3 Blue: DS ISN             (DSSupress)
        0, 0, .5;   %4 Light Blue: DS nonISN    (DS)
        1, 0, 0;    %5 red: uni ISN             (UniSupress)
        .5, 0, 0;   %6 lightRed: Uni non-ISN    (Uni)
        0, 1, 0;    %7 Green: halfUni1 ISN      (HalfUniSupress)
        0, .5, 0;   %8 Green: halfUni1 non-ISN  (HalfUni)
        1, 1, 0;    %9 Yellow: halfUNI2 ISN    (Half2UniSupress)
        .5, .5, 0;  %10 Dark Yellow: halfUNI2 ISN    (HalfUni2)
        0, 0, 0;    %11 Black: None of these 
        1, 0, 1;  %12 Purple: Nan
         1, .6, 0;  %13 Orange: Oscillates
         .5, 0, .5];  %14 pink: blowsup
end