% exponential_V.m
%
% Plots passive response to current input.

Vl = -0.070;    % Reversal potential of leak current
Rm = 10e6;      % Total membrane resistance
Cm = 5e-9;      % Total membrane capacitance

taum = Cm*Rm;   % Membrane time constant

Iapp = 2e-9;    % Value of applied current

Ion = 1;        % Time to start applied current
Ioff = 2;       % Time to stop applied current

tmax = 3;       % Total time to plot/simulate

dt = 0.001;     % Time step to use (will be adjusted)

t = 0:dt:tmax;  % Create a vector of time points   

Vss = Vl+Iapp*Rm; % Steady state voltage with applied current

% Use the analytic solution for the exponential decay to steady state
% The heaviside function is 1 if the bracketed term is positive, 
% and is 0 if the bracketed term is less than zero.
y = Vl*heaviside(Ion-t) + ...
    (Vss+(Vl-Vss)*exp(-(t-Ion)/taum)).*heaviside(t-Ion).*heaviside(Ioff-t) ...
    + (Vl +(Vss-Vl)*exp(-(t-Ioff)/taum)).*heaviside(t-Ioff);


%% Voltage integration now.
V = zeros(size(t));             % First set up the vector of zeros
I = Iapp*heaviside(t-Ion).*heaviside(Ioff-t);   % The applied current vector

V(1) = Vl;              % Starting voltage

for i = 2:length(t)     % Now step through time
   Vss = Vl+I(i)*Rm;    % Steady state voltage depends on current current
   % Next line is the Euler integration (see notes).
   % Voltage at next time point is present voltage + (dV/dt)*dt
   V(i) = V(i-1) + dt*((Vl-V(i-1))/Rm + I(i-1))/Cm;  
end

plot(t,y,'r')       % plot analytic solution in red
hold on;            % Do not erase old plot
plot(t,V,'k.')           % Plot the simulated solution

xlabel('time, sec')
ylabel('membrane potential, V')
