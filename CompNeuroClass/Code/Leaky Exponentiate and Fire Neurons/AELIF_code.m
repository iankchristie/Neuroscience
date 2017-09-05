% AELIF_code.m
% Adaptive Exponential Leaky Integrate and Fire Model
% a 2-variable model than can reproduce many types of neural behavior
% see Naud, Marcille, Clopath, Gerstner, Biol. Cybern. 2006

clear

%% List of Cell Parameters

gL = 12;                % Leak conductance (microS)
C = 200;                % Capacitance (nF) 
EL = -70;               % Leak potential (mV)
V_Thresh = -50;         % Threshold potential (mV)
V_Reset = -60;          % Reset potential (mV)
deltaT = 2;             % Threshold shift factor (mV)
tauw = 30;              % Adaptation time constant (ms)
a = 4;                  % adaptation recovery 
b = 50;                  % adaptation strength

Iapp = 300;             % Applied current (nA)

Vmax = 100;              % level of voltage to detect a spike

%% Simulation set-up

dt = 0.001;               % dt in ms
tmax = 1000;            % maximum time in ms
tvector = 0:dt:tmax;

v = zeros(size(tvector));       % initialize voltage
v(1) = EL;
w = zeros(size(tvector));       % initialize adaptation variable

for j = 1:length(tvector)-1     % simulation of tmax

    if ( v(j) > Vmax )          % if there is a spike
        v(j) = V_Reset;         % reset the voltage
        w(j) = w(j) + b;        % increase the adaptation variable by b
    end
    
    % next line integrates the voltage over time, first part is like LIF
    % second part is an exponential spiking term
    % third part includes adaptation
    v(j+1) = v(j) + dt*( gL*(EL-v(j) + deltaT*exp((v(j)-V_Thresh)/deltaT) ) ...
       - w(j) + Iapp)/C;

   % next line decys the adaptation toward a steady state in between spikes
    w(j+1) = w(j) + dt*( a*(v(j)-EL) - w(j) )/tauw;
    
end
            

figure(1)
subplot(2,1,1)
plot(tvector,v)
subplot(2,1,2)
plot(tvector,w)

