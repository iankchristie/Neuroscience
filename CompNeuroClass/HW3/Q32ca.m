% Question 2 C part a
% This model contains a T-type Calcium current to generate a
% post-inhibitory rebound as a models of thalamic relay cells.
clear
dt = 0.000005;
tmax=1.15;

iclamp_flag = 1; % if this is 1, run under current clamp conditions
vclamp_flag = 0; % otherwise this should be 1, for voltage clamp conditions

istart = 0.5; % time applied current starts
ilength=0.5;   % length of applied current pulse
I0= 6e-9;       % choose -10 to + 10 e-9 (eg +6, 0 , -4, -8)
Ie=I0+5e-9;     % magnitude of applied current pulse
%Ie = 0.78e-7; % threshold for constant spiking with no A-current

vstart = 0.25;  % time to step voltage
vlength = 0.5;  % length of voltage step
V0 = -0.080     % initial voltage before step
Ve = -0.040;    % value of votage stepped to

E_L = -0.070;   % leak reversal potential
E_Na = 0.055;   % reversal for sodium channels
E_K = -0.090;   % reversal for potassium channels
E_Ca = 0.120    % reversal potential for Ca current

g_L = 1.0e-6;     % specific leak conductance in Siemens per mm-square
g_Na = 0.36e-3;   % specific sodium conductance
g_K = 0.16e-3;    % specific potassium conductance
g_CaT = 20e-6;    % T-type calcium conductance

cm = 10e-9;     % specific membrane capacitance in Farads per mm-square

t=0:dt:tmax;    % time vector
V=zeros(size(t)); % voltage vector

I_L= zeros(size(t));
I_Na= zeros(size(t));
I_K= zeros(size(t));
I_CaT = zeros(size(t));

if ( iclamp_flag ) % i.e. if in current-clamp mode 
    V(1) = E_L;    % set the inititial value of voltage     
end

n=zeros(size(t));   % n: potassium activation gating variable
n(1) = 0.0;         % start off at zero
m=zeros(size(t));   % m: sodium activation gating variable
m(1) = 0.0;         % start off at zero
h=zeros(size(t));   % h: sodim inactivation gating variplot(t,V)able
h(1) = 0.0;         % start off at zero

mca=zeros(size(t)); % CaT current activation gating variable
mca(1) = 0.0;          
hca=zeros(size(t)); % CaT current inactivation gating variable
hca(1) = 0.0;

%%%%%%%%%%%%%%%%%%%%%%Code Added Below%%%%%%%%%%%%%%%%%%%%%%%%%%
Amplitude1 = 5e-9;
VerticalShift1 = -5e-9;
Period = 2;

Iapp= Amplitude1*sin(2*pi*Period*t)+VerticalShift1;
spikes = zeros(size(t));
threshold = 0;
%%%%%%%%%%%%%%%%%%%%%%Code Added Above%%%%%%%%%%%%%%%%%%%%%%%%%%

Vapp=zeros(size(t)); % Applied voltage, relevant in voltage-clamp mode
if ( vclamp_flag )
    for i = 1:round(vstart/dt)          % % make V0 before pulse
        Vapp(i) = V0;
    end
    for i=round(vstart/dt)+1:round((vstart+vlength)/dt) % make Ve for duration of voltage pulse
        Vapp(i) = Ve;
    end
    for i=round((vstart+vlength)/dt):length(Vapp) % make V0 following pulse
        Vapp(i) = V0;
    end
end

Itot=zeros(size(t)); % in case we want to plot and look at the total current

for i = 2:length(t); % now see how things change through time
    I_L(i-1) = g_L*(E_L-V(i-1));
    
    Vm = V(i-1)*1000; % converts voltages to mV as needed in the equations on p.224 of Dayan/Abbott
    
    % Sodium and potassium gating variables are defined by the
    % voltage-dependent transition rates between states, labeled alpha and
    % beta. Written out from Dayan/Abbott, units are 1/ms.
    
    
    if ( Vm == -35 ) 
        alpha_m = 1;
    else 
        alpha_m = 0.1*(Vm+35)/(1-exp(-0.1*(Vm+35)));
    end
    beta_m = 4*exp(-(Vm+60)/18);

    alpha_h = 0.35*exp(-0.05*(Vm+58));
    beta_h = 5/(1+exp(-0.1*(Vm+28)));
    
    if ( Vm == -34 ) 
       alpha_n = 0.05/0.1;
    else
        alpha_n = 0.05*(Vm+34)/(1-exp(-0.1*(Vm+34)));
    end
    beta_n = 0.625*exp(-0.0125*(Vm+44));
     
    % From the alpha and beta for each gating variable we find the steady
    % state values (_inf) and the time constants (tau_) for each m,h and n.
    
    m_inf = alpha_m/(alpha_m+beta_m);
    
    tau_h = 1e-3/(alpha_h+beta_h);      % time constant converted from ms to sec
    h_inf = alpha_h/(alpha_h+beta_h);
    
    tau_n = 1e-3/(alpha_n+beta_n);      % time constant converted from ms to sec
    n_inf = alpha_n/(alpha_n+beta_n);   
    
    m(i) = m_inf;    % Update m, assuming time constant is neglible.
    
    h(i) = h_inf - (h_inf-h(i-1))*exp(-dt/tau_h);    % Update h
    
    n(i) = n_inf - (n_inf-n(i-1))*exp(-dt/tau_n);    % Update n
    
    % for the Ca_T current gating variables are given by formulae for the 
    % steady states and time constants:
    
    mca_inf = 1/(1+exp(-(Vm+52)/7.4));

    hca_inf = 1/(1+exp((Vm+76)/2));
    if ( Vm < -80 ) 
        tau_hca = 1e-3*exp((Vm+467)/66.6);
    else
        tau_hca = 24e-3+1e-3*119/(1+exp((Vm+70)/3));
    end
    
    mca(i) = mca_inf;
    hca(i) = hca_inf - (hca_inf-hca(i-1))*exp(-dt/tau_hca);
    
    g_Na_now = g_Na*m(i)*m(i)*m(i)*h(i);
    I_Na(i-1) = g_Na_now*(E_Na-V(i-1)); % total sodium current
    
    g_K_now = g_K*n(i)*n(i)*n(i)*n(i);
    I_K(i-1) = g_K_now*(E_K-V(i-1)); % total potassium current
    
    g_CaT_now = g_CaT*mca(i)*mca(i)*hca(i);
    I_CaT(i-1) = g_CaT_now*(E_Ca-V(i-1)); % Calcium T-type current
    
    
    Itot(i-1) = I_L(i-1)+I_Na(i-1)+I_K(i-1) ...
                +I_CaT(i-1) +Iapp(i-1); % total current is sum of leak + active channels + applied current
     
    g_Tot = g_L+g_Na_now+g_K_now+g_CaT_now;
    V_inf = (g_L*E_L + g_Na_now*E_Na + g_K_now*E_K  + g_CaT_now*E_Ca+Iapp(i-1))/g_Tot;
                   
    V(i) = V_inf - (V_inf-V(i-1))*exp(-dt*g_Tot/cm);  % Update the membrane potential, V.

    if ( vclamp_flag )      % if we are using voltage clamp
        V(i) = Vapp(i);     % ignore the voltage integration and set V to be the applied voltage
    end
    
%%%%%%%%%%%%%%%%%%%%%%Code Added Below%%%%%%%%%%%%%%%%%%%%%%%%%%
    if( V(i) >= threshold && V(i-1) < threshold) %count as spike
        spikes(i) = 1;
    end
%%%%%%%%%%%%%%%%%%%%%%Code Added Above%%%%%%%%%%%%%%%%%%%%%%%%%%
    
end

figure;
subplot(2,1,1)
plot(t,Iapp,'k')
xlabel('Time (sec)')
ylabel('Current (amps)')
title('Current vs. time')
hold on
subplot(2,1,2)
plot(t,V,'k')
hold on
xlabel('Time (sec)')
ylabel('Voltage (v)')
title('Voltage vs. time')
    