function [resultStruct] = bidirectionalTrainingISN(timeStruct, inputStruct, modelStruct, plasticityStruct)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%m, Lue, Lui, Rue, Rui, Lde, Ldi, Rde, Rdi, LDI, RDI, LSI, RSI

struct2var(timeStruct);
struct2var(inputStruct);
struct2var(modelStruct);
struct2var(plasticityStruct);

%Input
Itotal = createInputISN(Strong, Weak, dt); %%Fix this, should be just up or down
%%Temporary
[~, b] = size(Itotal);
pivot = round(b / 2);
Up = Itotal(:, 1 : pivot);
Down = Itotal(:, pivot : end);

tempMatrix = m;

disp('Up');
[m, Lue, Lui, Rue, Rui] = RunTrialWithPlasticity(timeStruct, Up, inputMatrix, modelStruct, plasticityStruct);
modelStruct.m = m;

disp('Down');
[m, Lde, Ldi, Rde, Rdi] = RunTrialWithPlasticity(timeStruct, Down, inputMatrix, modelStruct, plasticityStruct);

[LDI, RDI, LSI, RSI] = getDirectionIndices(Lue, Lde, Rue, Rde, Lui, Ldi, Rui, Rdi);

dWMatrix = (m - tempMatrix) .* plasticityStruct.plasticityMatrix;

resultStruct = struct('m', m, 'Lue', Lue, 'Lui', Lui, 'Rue', Rue, 'Rui', Rui, ...
                        'Lde', Lde, 'Ldi', Ldi, 'Rde', Rde, 'Rdi', Rdi, ...
                        'LDI', LDI, 'RDI', RDI, 'LSI', LSI, 'RSI', RSI, 'dWMatrix', dWMatrix);

end