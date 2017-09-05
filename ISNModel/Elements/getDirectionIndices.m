function [LDI, RDI, LSI, RSI ] = getDirectionIndices(Lue, Lde, Rue, Rde, Lui, Ldi, Rui, Rdi)
%GETDIRECTIONINDICES Summary of this function goes here
%   Detailed explanation goes here

LDI = DirectionIndex(Lue, Lde);

RDI = DirectionIndex(Rde, Rue);

LSI = DirectionIndex(Lui, Ldi);

RSI = DirectionIndex(Rdi, Rui);

end

