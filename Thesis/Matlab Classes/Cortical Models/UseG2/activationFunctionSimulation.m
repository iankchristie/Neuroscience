function [data] = activationFunctionSimulation(varargin)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

tV = 0:.001:.175;
aV = 0:.1:15;
data = zeros(2,length(aV));
temp = zeros(1,length(tV));

for k = 1:length(aV)
    cn = CorticalNeuron();
    cn.A = aV(k);

    for i = 1: length(tV)
        cn.nextState();
        cn.step();
        temp(i) = cn.r;  
    end
    data(1,k) = aV(k);
    data(2,k) = max(temp);
    temp = zeros(1,length(tV));
end

plot(data(1,:),data(2,:));
    
end

