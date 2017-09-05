function [output] = firingFrequencyCurve(input, varargin)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

taum = .015;
Rm = 12E6;
El = -.070;
Vreset = -.065;
Vth = -.050;

assign(varargin{:});

output = zeros(1,length(input));

for i = 1:length(input)
    output(i) = 1/(taum*log(input(i)*Rm+El-Vreset)-taum*log(input(i)*Rm+El-Vth)); 
end

