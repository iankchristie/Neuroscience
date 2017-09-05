function [w] = stdp_kernel2(deltaT)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here



w = 0;
alphaPos1 = 0.000005; % 0.000005;
alphaPos2 = 0.0000005; % 0.0000005;
alphaNeg = 0.0000075; % 0.0000075;
beta1 = exp(1);
beta2 = 5;
beta3 = 1;

if deltaT > 0,
    w = alphaPos1*exp(-beta1*deltaT)+alphaPos2*exp(-beta2*deltaT);
end

if deltaT < 0,
    w = -alphaNeg*exp(beta1*deltaT);
end

end

