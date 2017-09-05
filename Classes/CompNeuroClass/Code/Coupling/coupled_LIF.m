% coupled_LIF.m
% This code has 2 leaky integrate and fire neuron with
% added noise term scaled by sigma.
% neurons are coupled by synapses with simple 
% exponential decay time constant.

clear
clf

E=-70e-3;           % Leak potential
Rm=10e6;            % Membrane resistance
tau_m=10e-3;        % Membrane time constant
Vth=-54e-3;         % Threshold
Vreset=-80e-3;      % Reset voltage
Iappmax = 2e-9;     % Maximum value of applied current

Esyn12 = 0e-3;         % Reversal potential for synapse
Esyn21 = 0e-3;         % Use 0 for excitatory and -70e-3 for inhibitory

g21 = 1e-8;         % Conductance of synapse from 2 to 1
g12 = 1e-8;         % Conductance of synapse from 1 to 2

tau_s1 = 0.002;     % time constant of synapse from 1 to 2
tau_s2 = 0.002;     % time constant of synapse from 2 to 1

delta_s = 0.5;      % fraction of receptors opened by one spike

sigma = 1e-7;       % sigma scales the noise term
% 1e-8 is low noise
% 5e-7 is very high noise

dt=0.0002
tmax=5;             % Maximum time used to calculate rate
tpulse=0.0;         % This starts the pulse at the beginning of the trial
lengthpulse=tmax-tpulse; % and finishes it at the end of the trial.

Nt=tmax/dt +1;      % Nt is number of time points
T=0:dt:tmax;        % Time vector

Iapp = 2e-9;     % Maximum current used

I=zeros(size(T));
I1=zeros(size(T));
I2=zeros(size(T));
V1=zeros(size(T));
V2=zeros(size(T));
s1=zeros(size(T));
s2=zeros(size(T));

noise = randn(2,length(T))*sigma*sqrt(dt);

V1(1)=E;                 % Begin at rest (leak) voltage
V2(1)=E;                 % Begin at rest (leak) voltage
tref=0.002;
lastspike1=-2*tref;      % Begin outside the last refractory period
lastspike2=-2*tref;      % Begin outside the last refractory period
spikes1=zeros(size(T));
spikes2=zeros(size(T));

for i = tpulse/dt+1 : (tpulse+lengthpulse)/dt
    I(i) = Iapp;     % Set the current pulse
end;

for i = 2:Nt;
    I1(i-1) = I(i-1) + g21*s2(i-1)*(Esyn21-V1(i-1));
    V1_inf = E+Rm*(I1(i-1)+noise(1,i-1)); % Steady state voltage with noise term
    V1(i) = V1_inf + (V1(i-1) - V1_inf)*exp(-dt/tau_m); % Integration step

    I2(i-1) = I(i-1) + g12*s1(i-1)*(Esyn12-V2(i-1));
    V2_inf = E+Rm*(I2(i-1)+noise(2,i-1)); % Steady state voltage with noise term
    V2(i) = V2_inf + (V2(i-1) - V2_inf)*exp(-dt/tau_m); % Integration step

    s1(i) = s1(i-1)*exp(-dt/tau_s1);
    s2(i) = s2(i-1)*exp(-dt/tau_s2);
    
    if ( T(i) < lastspike1 + tref ) % is still in the refractory period
        V1(i) = Vreset;             % keep at reset
    end
    if V1(i) > Vth       % if voltage is above threshold
        V1(i) = Vreset;  % set to reset
        spikes1(i) = 1;  % record a spike
        lastspike1=T(i); % time of last spike
        s1(i) = s1(i)+delta_s*(1-s1(i));    % Increase synaptic gating variable
    end
    
    if ( T(i) < lastspike2 + tref ) % is still in the refractory period
        V2(i) = Vreset;             % keep at reset
    end
    if V2(i) > Vth       % if voltage is above threshold
        V2(i) = Vreset;  % set to reset
        spikes2(i) = 1;  % record a spike
        lastspike2=T(i); % time of last spike
        s2(i) = s2(i)+delta_s*(1-s2(i));    % Increase synaptic gating variable
    end
end;    % end of time loop, for i = 2:Nt

figure(2)
subplot(2,1,1)
plot(T,spikes1)
axis([3 3.05 0 1])
hold on
plot(T,spikes2,'r')
legend('spikes1', 'spikes2')
subplot(2,1,2)
axis([3 3.05 0 1])
hold on
plot(T,s1)
plot(T,s2,'r')
legend('s1', 's2')
xlabel('Time (sec)')
