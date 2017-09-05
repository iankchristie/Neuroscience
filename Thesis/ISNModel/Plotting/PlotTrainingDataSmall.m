function [ out ] = PlotTrainingDataSmall( resultStruct )
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

PlotFourDataISN(LDI, RDI, LSI, RSI, 2, 1, 1);
title('Direction Indices');
ylabel('Direction Index');
ylim([-1 1]);
legend('LDI', 'RDI', 'LSI', 'RSI');
box off

subplot(2,1,2);
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
box off

out = 1;

end
