function [w] = stdp_kernel3(deltaT)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

w = 0;
alphaPos = .0018;
alphaNeg = .002;
beta = exp(1);

if deltaT > 0,
    w = alphaPos*exp(-beta*deltaT);
end

if deltaT < 0,
    w = -alphaNeg*exp(beta*deltaT);
end


end

