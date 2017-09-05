function [ DI ] = DirectionIndex(respPref, respNull)
%DIRECTIONINDEX Summary of this function goes here
%   Detailed explanation goes here

DI = (respPref - respNull) / (respPref + respNull);

end

