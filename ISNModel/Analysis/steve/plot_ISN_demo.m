function [timeVect,r] = plot_ISN_demo(respstruct)
% PLOT_ISN_DELAYEDTIMESERIES - Compute and plot an ISN model time series
%
%  [T,R] = PLOT_ISN_DELAYEDTIMESERIES(RESPSTRUCT)
%
%  Inputs:
%    RESPSTRUCT.m - the connection matrix
%    RESPSTRUCT.Strong - the strong bias response
%    RESPSTRUCT.Weak - the weak bias response
%
%  Example:
%    respstruct.m = [ 0.8 0.4 0 0 ; -0.41 0 0 0; 0 0 0 0; 0 0 0 0];
%    respstruct.Strong = 8;
%    respstruct.Weak = 2;
%
%  Uses createInputISN_delayed, weak input is delayed 0.2s

weak = respstruct.Weak;
strong = respstruct.Strong;
m = respstruct.m;

w = [1 0; 1 1 ; 0 0; 0 0];

t0 = 0;
dt = .001;
tend = 2;
timeVect = t0:dt:tend;
tau = .004;

v = zeros(4,length(timeVect));

Itotal = createInputISN_delayed(strong, weak, dt);

r = runISNTime(timeVect, dt, tau, m, Itotal, w, v, 'rectified115');

PlotISN(timeVect, Itotal, r);
PlotISNAll(timeVect, Itotal, r);

