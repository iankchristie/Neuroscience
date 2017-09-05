function [ out ] = PlotTrainingData( resultStruct )
%PLOTTRAININGDATA Summary of this function goes here
%   Detailed explanation goes here

out = 0;

LDI = [resultStruct.LDI];
RDI = [resultStruct.RDI];
LSI = [resultStruct.LSI];
RSI = [resultStruct.RSI];

%TODO Correct colors
%Direction Indices
figure;

PlotFourDataISN(LDI, RDI, LSI, RSI, 5, 1, 1);
title('Direction Indices');
ylabel('Direction Index');
ylim([-1 1]);
legend('LDI', 'RDI', 'LSI', 'RSI');

%Responses in up direction
Lue = [resultStruct.Lue];
Rue = [resultStruct.Rue];
Lui = [resultStruct.Lui];
Rui = [resultStruct.Rui];

PlotFourDataISN(Lue, Rue, Lui, Rui, 5, 1, 2);
title('Responses in Up Direction');
ylabel('Response (Hz)');
legend('Lue', 'Rue', 'Lui', 'Rui');

%Responses in down direction
Lde = [resultStruct.Lde];
Rde = [resultStruct.Rde];
Ldi = [resultStruct.Ldi];
Rdi = [resultStruct.Rdi];

PlotFourDataISN(Lde, Rde, Ldi, Rdi, 5, 1, 3);
title('Responses in Down Direction');
ylabel('Response (Hz)');
legend('Lde', 'Rde', 'Ldi', 'Rdi');

%Changes in synaptic weight
%use color order
dWMatrix = [resultStruct.dWMatrix];
[~, m] = size(dWMatrix);
dWMatrix = reshape(dWMatrix, 4,4,m/4);
[a, b] = find(dWMatrix(:,:,1));
legendArray = cell(1,length(a));
subplot(5,1,4);
colorOrder = get(gca, 'ColorOrder');
for i = 1: length(a),
    dWVec = dWMatrix(a(i), b(i), :);
    dWVec = squeeze(dWVec);
    plot(dWVec, 'Color', colorOrder(1+mod(i-1, 7), :));
    hold on
    legendArray{i} = getSynapseNameISN(a(i), b(i));
end
title('Change in Synaptic Weight');
ylabel('Conductance (S)');
legend(legendArray{:});

subplot(5,1,5);
dWMatrix = [resultStruct.dWMatrix];
[~, m] = size(dWMatrix);
dWMatrix = reshape(dWMatrix, 4,4,m/4);
[a, b] = find(dWMatrix(:,:,1));
legendArray = cell(1,length(a));
mMatrices = reshape([resultStruct.m], 4,4,m/4);
colorOrder = get(gca, 'ColorOrder');
for i = 1: length(a),
    mVec = squeeze(mMatrices(a(i), b(i), :));
    plot(mVec, 'Color', colorOrder(1+mod(i-1, 7), :));
    hold on
    legendArray{i} = getSynapseNameISN(a(i), b(i));
end
title('Synaptic Weight');
xlabel('Trial Number');
ylabel('Conductance (S)');
legend(legendArray{:});

out = 1;

end

