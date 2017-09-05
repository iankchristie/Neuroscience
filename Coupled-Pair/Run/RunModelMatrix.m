function [v, time] = RunModelMatrix(M, U, W)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

T = 0;  
dT = .001;         
endTime = .5;        
time = T:dT:endTime;
tau = 0.004;

v = zeros(2,length(time));

for i = 2:length(time),
    I = W*U*FFIStep(time(i)) + M'*v(:,i-1);
    f = F(I);     
    delta = dT*(-v(:,i-1)+f)/tau;
    v(:,i) = v(:,i-1)+delta;
end

end

