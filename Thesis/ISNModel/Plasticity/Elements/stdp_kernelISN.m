function [w] = stdp_kernelISN(deltaT, alphaPos, alphaNeg)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here



w = 0;
beta1 = exp(1);

if deltaT > 0,
    w = alphaPos*exp(-beta1*deltaT);
end

if deltaT < 0,
    w = -alphaNeg*exp(beta1*deltaT);
end

end

