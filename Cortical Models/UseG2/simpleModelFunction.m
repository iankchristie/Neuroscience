function [rU rD wuDI] = untitled2(W11,W12,W21,W22)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

inputStrong = 10;
inputWeak = 5;

% Create our neurons
n1 = CorticalNeuron('name','n1');
n2 = CorticalNeuron('name','n2');

%Connect them
n1.input{1,2} = n2;
n2.input{1,2} = n1;

n1.A = inputStrong;
n2.A = inputWeak;

n1.reset();
n2.reset();

connection_matrix = [W11 W12; W21 W22];

model = createTwoCorticalModel(connection_matrix,n1,n2);

rU = max(runModel(model));

n1.A = inputWeak;
n2.A = inputStrong;

n1.reset();
n2.reset();

connection_matrix = [W11 W12; W21 W22];

model = createTwoCorticalModel(connection_matrix,n1,n2);

rD = max(runModel(model));

wuDI = (rU - rD) / (rU + rD)

end

