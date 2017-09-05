function [maxN1, maxN2] = quickTWCFunction(n1Strength, n2Strength)
    c1 = {'name','neuron1'};
    c2 = {'name','neuron2'};
    twc = twoCorticalModel(c1,c2,'strengthA',n1Strength,'strengthB',n2Strength);
    %twc.neuron1.inputStrengths = n1Strength;
    %twc.neuron2.inputStrengths = n2Strength;
    [~, data] = run(twc);
    maxN1 = max(data(1,:));
    maxN2 = max(data(2,:));
end

