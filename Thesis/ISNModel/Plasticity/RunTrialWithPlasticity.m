function [m, E1, I1, E2, I2] = RunTrialWithPlasticity(timeStruct, input, inputMatrix, modelStruct, plasticityStruct)
%RUNTRIALWITHPLASTICITY Summary of this function goes here
%   Detailed explanation goes here

struct2var(timeStruct);
struct2var(modelStruct);
struct2var(plasticityStruct);

%Time
time = t0:dt:tend;
tempVector = zeros(4,length(time));

r = runISNTime(time, dt, tau, m, input, inputMatrix, tempVector, 'rectified115');
%%% TODO Return Responses!!!!!
[E1, I1, E2, I2] = getSingleStimulationResponse(r, dt);

[a, b] = find(plasticityMatrix);

for i = 1: length(a),
    from = a(i);
    to = b(i);
    dW = ratePlasticityISN(r(from,:), r(to,:), alphaPos, alphaNeg, dt);
    disp(['Dw ' num2str(dW)]);
    m(from, to) = rectify(m(from, to) + dW);
end

end

