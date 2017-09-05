function [deltaW, recorder] = ratePlasticity1(pre_r, post_r, dT)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

deltaW = 0;
deltaMax = .1;
deltaMin = -.1;
recorder = zeros(size(pre_r));

for i = 1: length(pre_r),
    for j = 1: length(post_r),
        temp = stdp_kernel((j-i)*dT)*pre_r(i)*post_r(j)*dT*dT;
        deltaW = deltaW + temp;
    end
    %deltaW = min(deltaMax, deltaW);
    %deltaW = max(deltaMin, deltaW);
    recorder(i) = deltaW;
end

end

