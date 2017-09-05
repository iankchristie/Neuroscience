function [resultStruct] = randomTrainingISN(timeStruct, inputStruct, modelStruct, plasticityStruct)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%m, Lue, Lui, Rue, Rui, Lde, Ldi, Rde, Rdi, LDI, RDI, LSI, RSI

struct2var(timeStruct);
struct2var(inputStruct);
struct2var(modelStruct);
struct2var(plasticityStruct);

%Input
lowerBound = Weak;
rangeBound = Strong - Weak;
amountAdd = rand * rangeBound;
a = lowerBound + amountAdd;
b = lowerBound + rangeBound - amountAdd;
inputA = max([a b]);
inputB = min([a b]);

Itotal = createInputISN(inputA, inputB, dt); %%Fix this, should be just up or down
Itesting = createInputISN(Strong, Weak, dt);
%%Temporary
[~, b] = size(Itotal);
pivot = round(b / 2);
Up = Itotal(:, 1 : pivot);
Down = Itotal(:, pivot : end);

%split testing too
[~, bTesting] = size(Itesting);
pivotTesting = round(bTesting / 2);
UpTesting = Itesting(:, 1 : pivotTesting);
DownTesting = Itesting(:, pivotTesting : end);

tempMatrix = m;

if randi(2) == 1, %show up with plasticity

    disp('Up');
    [m] = RunTrialWithPlasticity(timeStruct, Up, inputMatrix, modelStruct, plasticityStruct);
    modelStruct.m = m;

else %show down with plasticity
    disp('Down');
    [m] = RunTrialWithPlasticity(timeStruct, Down, inputMatrix, modelStruct, plasticityStruct);
    modelStruct.m = m;
    
end

    disp('Testing');
    [m, Lue, Lui, Rue, Rui] = RunTrialWithOutPlasticity(timeStruct, UpTesting, inputMatrix, modelStruct);
    [m, Lde, Ldi, Rde, Rdi] = RunTrialWithOutPlasticity(timeStruct, DownTesting, inputMatrix, modelStruct);

[LDI, RDI, LSI, RSI] = getDirectionIndices(Lue, Lde, Rue, Rde, Lui, Ldi, Rui, Rdi);
dWMatrix = (m - tempMatrix) .* plasticityStruct.plasticityMatrix;

resultStruct = struct('m', m, 'Lue', Lue, 'Lui', Lui, 'Rue', Rue, 'Rui', Rui, ...
                        'Lde', Lde, 'Ldi', Ldi, 'Rde', Rde, 'Rdi', Rdi, ...
                        'LDI', LDI, 'RDI', RDI, 'LSI', LSI, 'RSI', RSI, 'dWMatrix', dWMatrix);

end