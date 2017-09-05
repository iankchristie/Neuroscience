function [ v,time ] = RunLinearModel( M, U, W )
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here

T = 0;  
dT = .001;         
endTime = 1;        
time = T:dT:endTime;
tau = 0.004;

v = zeros(2,length(time));

for i = 2:length(time),
    I = W*U + M'*v(:,i-1);
    %I = rectify(I);
    delta = dT*(-v(:,i-1)+I)/tau;
    v(:,i) = v(:,i-1)+delta;
end

end

