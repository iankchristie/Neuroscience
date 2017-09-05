function [deltaW, recorder] = ratePlasticity2(pre_r, post_r, dT)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

deltaW = 0;
deltaMax = .01;
deltaMin = -.01;

for i = 1: length(pre_r),
    for j = 1: length(post_r),
        temp = stdp_kernel2((i-j)*dT)*pre_r(i)*post_r(j)*dT*dT;
        deltaW = deltaW + temp;
    end
end
%       deltaW = min(deltaMax, deltaW);
%       deltaW = max(deltaMin, deltaW);
end

