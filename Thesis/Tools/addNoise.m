function [I_noise] = addNoise(I, sigma)
%UNTITLED14 Summary of this function goes here
%   Detailed explanation goes here

I_noise = sigma*randn(size(I))+I;

end

