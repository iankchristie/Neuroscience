% SRA_tref_LIF.m
% Leaky-integrate-and-fire neuron with spike rate adaptation and a
% refractory current.

clear

SRA_on = 1;         % set to zero to remove spike rate adaptation
gref_on = 1;        % set to zero to remove refractory conductance

E=-70e-3;
Rm=10e6;
tau_m=10e-3;
Vth=-54e-3;
Vreset=-80e-3;
Vspike = 20e-3;
E_K = -80e-3;       % reversal potential for spike-rate adaptation (SRA) and 
                    % refractory current

Iapp = 3e-9; 
dt=0.0002;
%Isigma = 0.4e-9/sqrt(dt);
Isigma = 0.01e-9/sqrt(dt);

tmax=100;
tpulse=0;
lengthpulse=tmax;
Nt=tmax/dt;
t=0:dt:tmax;
I=zeros(size(t));
V=zeros(size(t));
gsra=zeros(size(t));    % spike-rate adaptaion conductance
tau_sra = 0.2;          % time for spike-rate adaptation to decay
if ( SRA_on )
    delta_gsra = 20e-9;     % increase in spike-rate conductance per spike
else
    delta_gsra = 0;
end

gref=zeros(size(t));    % spike refractory conductance
tau_ref = 0.002;        % time for refractory conductance to decay
if ( gref_on )
    delta_gref = 5000e-9;     % increase in refractory conductance per spike
else
    delta_gref = 0;
end

V(1)=E;                 % begin simulation with membrane potential at leak level
gsra(1) = 0;            % initially no spike-rate adaptation
gref(1) = 0;            % initially no refractory current

spikes=zeros(size(t));  % vector to record spike times
for i = 1+tpulse/dt : (tpulse+lengthpulse)/dt
    I(i) = Iapp;        % applied current during a pulse
end
I = I + Isigma*randn(size(I));

for i = 2:Nt;
    
    % Next line solves tau_sra*(d gsra/dt) = -gsra
    gsra(i) = gsra(i-1)*(1-dt/tau_sra);
    % Next line solves tau_ref*(d gref/dt) = -gref
    gref(i) = gref(i-1)*(1-dt/tau_ref);
    
    if ( V(i-1) == Vspike ) 
        V(i) = Vreset;      % reset after spike
    else
        V(i) = V(i-1) + ...     %otherwise integrate 
            dt/tau_m*(E - V(i-1) +Rm*I(i-1) - ...
        (V(i-1)-E_K)*Rm*(gsra(i-1)+gref(i-1)) );
    
    end
    
    if V(i) > Vth       % if voltage is greater than threshold spike
        V(i) = Vspike;  % change voltage so we see the spike
        spikes(i) = 1;  % record the time of the spike
        gsra(i) = gsra(i-1) + delta_gsra;   % increase the spike-rate-daptation conductance
        gref(i) = gref(i-1) + delta_gref;   % increase the refractory conductance
    end
end

%clf;
figure(2);
clf
subplot(3,1,1);
plot(t,I);
ylabel('Applied current')
hold on;
subplot(3,1,2);
plot(t,V);
ylabel('Membrane potential, V')
axis([0 0.7 -0.08 0.02])
hold on;
subplot(3,1,3);
plot(t,gsra);
hold on
plot(t,gref,'r')
axis([0 0.7 0 2.5e-7])
xlabel('Time, sec')
ylabel('Conductance, S')
legend(' g_{SRA} ', 'g_{ref}')
