function [ cmap ] = getColorMap4()
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here

cmap = [1, 1, 1;    %1  White: Unresponsive      (Unresponsive)
        .5, .5, .5; %2  Grey: Unselective        (Unselective)
        1, .6, 0;   %3  Orange: UnselectiveB
        0, 0, 1;    %4  Light Blue: DS nonISN    (DS)
        0, 0, .5;   %5  Dark Blue: DS ISN             (DSSupress)
        1, 0, 0;    %6  Light Red: Uni non-ISN    (Uni)
        .5, 0, 0;   %7  Dark Red: uni ISN             (UniSupress)
        0, 1, 0;    %8  LightGreen: halfUni1 non-ISN  (HalfUni)
        0, .5, 0;   %9  Dark Green: halfUni1 ISN      (HalfUniSupress)
        1, 1, 0;    %10 Light Yellow: halfUNI2 ISN    (HalfUni2) 
        .5, .5, 0;  %11 Dark Yellow: halfUNI2 ISN    (Half2UniSupress)
        .5, 0, .5;  %12 Purple: Nan
        1, 0, 1;    %13 pink: blowsup
        0, 0, 0;];  %14 Black: None of these
end