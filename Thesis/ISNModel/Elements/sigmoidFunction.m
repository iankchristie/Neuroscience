function [out] = sigmoidFunction(x, varargin)
%sigmoidFunction follows function in Honda paper figure 6
%   
% Variables:
% alpha = 100;
% beta = 0.12;
% gamma = 1.984;
% x0 = 26;


alpha = 100;
beta = 0.14;
x0 = 26;

assign(varargin{:});

out = (alpha ./ (1+exp(beta*(-x + x0))));

end

