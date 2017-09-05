function [w] = stdp_kernel(deltaT)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

w = 0;
alphaPos = .0005;
alphaNeg = .00064;
beta = exp(1);

if deltaT > 0,
    w = alphaPos*exp(-beta*deltaT);
end

if deltaT < 0,
    w = -alphaNeg*exp(beta*deltaT);
end

end

