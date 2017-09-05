function [output] = runModel(model, varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

startT = 0;
endT = .3;
dT = .001;

assign(varargin{:});

output = zeros(1,(endT - startT)/dT);
k = startT:dT:endT;

ci = 1;
for i = startT:dT:endT
    for i = 1:length(model),
        model(i).nextState;
    end
    for i = 1:length(model)
        model(i).step();
        output(ci) = model(1).r;
    end
    ci = ci + 1;
end

end

