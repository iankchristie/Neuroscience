function [t r o] = Diff6(varargin)
%Diff6 follows differential equation in Honda paper figure 6
%   
%Variables:
% i = 0;            Initial Condition of variable
% dT = .001;        Time step
% steps = 1000;     Number of iterations
% tau = .04;        Tau
% t = 0;            initial time
% At_t = .344;      Constant multiplying in input
% A=1;              Coefficient of input (FFI)
% 
% input = 1;        boolean for allowing input (Why not allow input?)
% plotIt = 1;       boolean for plotting
% 
% forF = [];        Parameters being passed to F function
% forFFI = [];      Parameters being passed to FFI function
%

i = 0;
dT = .001;
steps = 1000;
tau = .004;
t = 0;
At_t = .344;
A=1;

input = 0;
plotIt = 1;

forF = [];
forFFI = [];

assign(varargin{:});

r = i;
o = 0;

disp(forF);
for k=t:dT:t+(steps*dT)
    r(end+1) = r(end)+(dT*(-r(end)/tau));
    if input
        o(end+1) = A*FFI(k, forFFI);
        r(end) = r(end) + dT*F(o(end)-At_t*r(end-1),forF)/tau;
    end
    t(end+1) = k;
end

if plotIt
    clf;
    plot(t,o)
    hold on
    plot(t,r,'k')
end

end

