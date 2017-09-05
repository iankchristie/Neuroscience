function [output] = varyTwoCorticalModel(varargin)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

inputUp = 10;
inputDown = 5;

startSelf = -1;
endSelf = 1;
incSelf = .05;

startNeighbor = -1;
endNeighbor = 1;
incNeighbor = .05;

rDefault = 0;

assign(varargin{:});

n1 = CorticalNeuron();
n2 = CorticalNeuron();

disp(n1.activationFunction);

disp(n2.activationFunction);

n1.input{1,2} = n2;
n2.input{1,2} = n1;

n1.A = inputUp;
n2.A = inputDown;

output = zeros((endSelf - startSelf)/incSelf, (endNeighbor - startNeighbor)/incNeighbor);

ci = 1;
for i = startSelf:incSelf:endSelf
    cj = 1;
    for j = startNeighbor:incNeighbor:endNeighbor
       n1.r = rDefault;
       n2.r = rDefault;
       n1.t = 0;
       n2.t = 0;
       
       n1.setSelfWeight(i);
       n2.setSelfWeight(i);

       n1.input{2,2} = j;        
       n2.input{2,2} = j;

       model = [n1 n2];
       output(ci, cj) = max(runModel(model));
       cj = cj + 1;
    end
    disp(ci);
    ci = ci + 1;
end

figure;
imagesc(output);
colorbar;
xlabel('Neighbor Connection')
ylabel('Self Connection')
title('Two Cortical Model')
set(gca, 'ydir', 'normal')


end

