function [statemap, map] = StateMap2D( UpA, UpB, DownA, DownB )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

map = [1 0 0; %red, DS
        1 1 0; %yellow, One neuron firing at both
        0 1 0; %green, all firing
        0 0 1; %blue, Unidirectional
        .5 .5 .5]; %grey, else
    
threshUP = 80;
threshDown = 40;

statemap = zeros(size(UpA));



for i = 1: size(statemap, 1),
    for j = 1: size(statemap, 2),
        if ((UpA(i,j) > threshUP && DownA(i,j) > threshUP) && (UpB(i,j) > threshUP && DownB(i,j) > threshUP)) %%%All firing
            statemap(i,j) = 3;
        elseif ((UpA(i,j) > threshUP && DownA(i,j) > threshUP) || (UpB(i,j) > threshUP && DownB(i,j) > threshUP)) %%%one nueron is continiously firing
            statemap(i,j) = 2;
        elseif ((UpA(i,j) > threshUP && DownB(i,j) > threshUP) || (DownA(i,j) > threshUP && UpB(i,j) > threshUP)) %%%opposite firing
            statemap(i,j) = 1;
        elseif ((UpA(i,j) > threshUP && UpB(i,j) > threshUP) || (DownA(i,j) > threshUP && DownB(i,j) > threshUP)) %%%similar firing
            statemap(i,j) = 4;
        else
            statemap(i,j) = 5;
        end
    end
end

end

