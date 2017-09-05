function [r] = runModelTime(time, dt, tau, M, I, W)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

r = zeros(2,length(time));

for i = 2:length(time),
    temp = W*I(:,i) + M'*r(:,i-1);
    f = F(temp);     
    delta = dt*(-r(:,i-1)+f)/tau;
    r(:,i) = r(:,i-1)+delta;
end

end

