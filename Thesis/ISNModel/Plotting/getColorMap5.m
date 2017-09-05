function [ cmap ] = getColorMap5()
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here

cmap = [1, 1, 1;    %1  White: Unresponsive      (Unresponsive)
        .5, .5, .5; %2  Grey: Unselective        (Unselective)
        1, .6, 0;   %3  Orange: UnselectiveB
        0.75, 0, 0; %4  Darker red: DS nonISN    (DS)
        1, 0 0;     %5  Bright red: DS ISN             (DSSupress)
        0, 0, 0.75; %6  dark blue: Uni non-ISN    (Uni)
        0, 0, 1;    %7  bright blue : uni ISN             (UniSupress)
        0, 0.75, 0; %8  dark Green: halfUni1 non-ISN  (HalfUni)
        0, 1, 0;    %9  bright Green: halfUni1 ISN      (HalfUniSupress)
        0.75,0.75,0;%10 Light Yellow: halfUNI2 non-ISN    (HalfUni2) 
        1, 1, 0;    %11 Dark Yellow: halfUNI2 ISN    (Half2UniSupress)
        .5, 0, .5;  %12 Purple: Nan
        1, 0, 1;    %13 pink: blowsup
        0, 0, 0;];  %14 Black: None of these
end
