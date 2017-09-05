function [m, E1, I1, E2, I2] = RunTrialWithOutPlasticity(timeStruct, input, inputMatrix, modelStruct)
%RUNTRIALWITHPLASTICITY Summary of this function goes here
%   Detailed explanation goes here

struct2var(timeStruct);
struct2var(modelStruct);

%Time
time = t0:dt:tend;
tempVector = zeros(4,length(time));

r = runISNTime(time, dt, tau, m, input, inputMatrix, tempVector, 'rectified115');
%%% TODO Return Responses!!!!!
[E1, I1, E2, I2] = getSingleStimulationResponse(r, dt);

end
