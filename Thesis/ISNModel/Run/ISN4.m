function [t, r] = ISN4(W,u,M,t,dt)
% ISN4 - Calculate responses for the ISN4 network
%
% [T,R] = ISN4(W,U,M,T,DT)
%
%  Inputs: 
%     W - Weight ? (scalar?)
%     u - Time varying current input to each neuron
%     M - connection matrix
%     t - time points to run
%     dt - time step
%
%  Outputs:
%    t - returned unchanged
%    r - firing rate of each neuron
%

%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here

tau = dt*20;
r = zeros(4,length(t));

for i = 2: length(t),
    I = W*u(:,i)+M'*r(:,i-1);
    if(I < 0)
        I = 0;
    end
    r(:,i) = r(:,i-1) + dt*(-r(:,i-1)+I)/tau;
end

end
