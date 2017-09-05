function [respstruct_out,r,t] = plot_ISN_timeseries(respstruct, altfunc)
% PLOT_ISN_TIMESERIES - Compute and plot an ISN model time series
%
%  [T,R,RESPSTRUCT_OUT] = PLOT_ISN_TIMESERIES(RESPSTRUCT)
%
%  Inputs:
%    RESPSTRUCT.m - the connection matrix
%    RESPSTRUCT.Strong - the strong bias response
%    RESPSTRUCT.Weak - the weak bias response
%

if nargin<2,
	altfunc = 'rectified115';
end;

Weak = respstruct.Weak;
Strong = respstruct.Strong;
m = respstruct.m;

w = [1 0; 1 0; 0 1; 0 1];

t0 = 0;
dt = .001;
tend = 2; %2 
timeVect = t0:dt:tend;
tau = .004;

v = zeros(4,length(timeVect));

Itotal = createInputISN(Strong, Weak, dt);

r = runISNTime(timeVect, dt, tau, m, Itotal, w, v,altfunc);

PlotISN(timeVect, Itotal, r);
PlotISNAll(timeVect, Itotal, r);

[LUe, LDe, RUe, RDe, LDI, RDI, SS, LUi, LDi, RUi, RDi, LSI, RSI] = analyzeISNOutput(r,dt)

respstruct_out = var2struct('m','LUe','LDe','RUe','RDe','LUi','LDi','RUi','RDi','SS','Strong','Weak');
