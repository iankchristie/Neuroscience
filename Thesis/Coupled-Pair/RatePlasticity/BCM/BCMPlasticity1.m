function [w] = BCMPlasticity1(w_init, pre, post, dt)
%BCMPLASTICITY1 Summary of this function goes here
%   Detailed explanation goes here

w = w_init;
alpha = 100;
beta = 0.15;
x0 = 26;


syms s
sigmoid = (alpha ./ (1+exp(beta*(-s + x0))));

difSigmoid = diff(sigmoid);


for i = 1: length(post),
    y = post(i);
    x = pre(i);
    thetaM = mean(y^.2);
    w = w+y*(y - thetaM)*x*difSigmoid(y);
end

end

