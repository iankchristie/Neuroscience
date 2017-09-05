function [maxN1, maxN2] = quickwithoutTWCFunction(strength)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here


c1 = {'name','neuron1'};
c2 = {'name','neuron2'};
twc = twoCorticalModel(c1,c2,'strenthA', 0, 'StrengthB', 0);
twc.neuron1.A = strength;
twc.neuron2.feedForwardInput = Input(0);
[~, data] = run(twc);
maxN1 = max(data(1,:));
maxN2 = max(data(2,:));

end
