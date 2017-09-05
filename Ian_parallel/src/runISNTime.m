function [r] = runISNTime(time, dt, tau, M, I, W, r, inputoutputname)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if nargin<8,
	inputoutputname = 'sigmoidFunction';
end;

for i = 2:length(time),
    temp = W*I(:,i) + M'*r(:,i-1);
    f = feval(inputoutputname,temp);
    delta = dt*(-r(:,i-1)+f)/tau;
    r(:,i) = r(:,i-1)+delta;
end

end

