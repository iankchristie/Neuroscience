function out = FFI(t,varargin)
%FFI Input for neuron based on Honda Figure 6
%   
% Variables:
% Tp = .150;
% A1 = -1;
% A2 = 1;
% B = -1;

Tp = .150;
A1 = 1;
A2 = -1;
B = 1;

assign(varargin{:});

if t >= 0 && t <= Tp
    out = A1*t+B;
elseif t > Tp && t <= .300
    out = A2*(t - Tp) + Tp*A1 + B;
else
    out = 0;
end

end

