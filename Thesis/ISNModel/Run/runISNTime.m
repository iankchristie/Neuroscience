function [r] = runISNTime(time, dt, tau, M, I, W, r, inputoutputname)
% RUNISNTIME - Run an Ian ISN model for a particular duration
%   
%   R = RUNISNTIME(TIME, DT, TAU, M, I, W, R, INPUTOUTPUTNAME)
%
%   Inputs:
%     Time - The timesteps for which the simulation should be run 
%             (e.g., 0:dt:1)
%     dt - the timestep to use (e.g., 0.001)
%     tau - the time constant of the system (e.g., 0.004)
%     M - the connection matrix (4x4)
%     I - the feed-forward input to all neurons (timestepsx4)
%     W - the weights between the feed-forward input and the neurons
%     R - the initial firing rate of each unit
%     INPUTOUTPUTNAME - the name of the input/output function to use;
%       e.g., 'sigmoidFunction','rectified115','rectified2'
%
%  Output:
%     r - the firing rate of each neuron at each timestep


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

