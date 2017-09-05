% This model is the Connors-Stevens model, similar to Hodgkin-Huxley, but
% more like neurons in the cortex, being type-I. 
% See Dayan and Abbott Sect 5.5, pp 166-172 then Sect 6.1-2, pp.196-198 and Sect 6.6 p.224.
clear
dt = 0.000002;
tmax=2.5;

iclamp_flag = 1; % if this is 1, run under current clamp conditions
vclamp_flag = 0; % otherwise this should be 1, for voltage clamp conditions

istart = 0.5; % time applied current starts
ilength=0.5;   % length of applied current pulse
Ie=2.405e-7;     % threshold for spiking with A-current
Ibase = 0.8e-7;
%Ie = 0.784e-7; % threshold for constant spiking with no A-current
Ie= 0.785e-7;
Ie = 0.95e-7;

vstart = 0.5;  % time to step voltage
vlength = 1;  % length of voltage step
V0 = -0.054     % initial voltage before step
Ve = -0.040;    % value of votage stepped to

V_L = -0.070;   % leak reversal potential
E_Na = 0.055;   % reversal for sodium channels
E_K = -0.072;   % reversal for potassium channels
E_A = -0.075;   % reversal for A-type current

g_L = 3e-6;     % specific leak conductance
g_Na = 1.2e-3;  % specific sodium conductance
g_K = 2e-4;     % specific potassium conductance
%g_A = 4.77e-4;  % specific A-tpe potassium conductance
g_A = 0.0;     % if g_A is zero it switches off the A-current

cm = 10e-9;     % specific membrane capacitance

t=0:dt:tmax;    % time vector
V=zeros(size(t)); % voltage vector

Iapp=Ibase*ones(size(t)); % Applied current, relevant in current-clamp mode
if ( iclamp_flag )   % i.e. if in current-clamp mode 
    for i=round(istart/dt)+1:round((istart+ilength)/dt) % make non-zero for duration of current pulse
        Iapp(i) = Ie;
    end
end

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

if ( iclamp_flag ) % i.e. if in current-clamp mode 
    V(1) = V0;    % set the inititial value of voltage     
else
    V(1) = Vapp(1);
end

n=zeros(size(t));   % n: potassium activation gating variable
n(1) = 0.35;         % start off at zero
m=zeros(size(t));   % m: sodium activation gating variable
m(1) = 0.05;         % start off at zero
h=zeros(size(t));   % h: sodim inactivation gating variable
h(1) = 0.75;         % start off at zero

a=zeros(size(t));   % A-current activation gating variable
a(1) = 0.0;         % start off at zero
b=zeros(size(t));   % A-current inactivation gating variable
b(1) = 0.0;         % start off at zero

Itot=zeros(size(t)); % in case we want to plot and look at the total current
I_Na=zeros(size(t));
I_K=zeros(size(t));
I_A=zeros(size(t));
I_L=zeros(size(t));

for i = 1:length(t)-1; % now see how things change through time
    I_L(i) = g_L*(V_L-V(i));
    
    Vm = V(i)*1000; % converts voltages to mV as needed in the equations on p.224 of Dayan/Abbott
    
    % Sodium and potassium gating variables are defined by the
    % voltage-dependent transition rates between states, labeled alpha and
    % beta. Written out from Dayan/Abbott, units are 1/ms.
    
    alpha_m = 0.38*(Vm+29.7)/(1-exp(-0.1*(Vm+29.7)));
    beta_m = 15.2*exp(-0.0556*(Vm+54.7));

    alpha_h = 0.266*exp(-0.05*(Vm+48));
    beta_h = 3.8/(1+exp(-0.1*(Vm+18)));
    
    alpha_n = 0.02*(Vm+45.7)/(1-exp(-0.1*(Vm+45.7)));
    beta_n = 0.25*exp(-0.0125*(Vm+55.7));
    
    % From the alpha and beta for each gating variable we find the steady
    % state values (_inf) and the time constants (tau_) for each m,h and n.
    
    tau_m = 1e-3/(alpha_m+beta_m);      % time constant converted from ms to sec
    m_inf = alpha_m/(alpha_m+beta_m);
    
    tau_h = 1e-3/(alpha_h+beta_h);      % time constant converted from ms to sec
    h_inf = alpha_h/(alpha_h+beta_h);
    
    tau_n = 1e-3/(alpha_n+beta_n);      % time constant converted from ms to sec
    n_inf = alpha_n/(alpha_n+beta_n);   
    
    if ( i > 1 ) 
        m(i) = m(i-1) + (m_inf-m(i-1))*dt/tau_m;    % Update m
    
        h(i) = h(i-1) + (h_inf-h(i-1))*dt/tau_h;    % Update h
    
        n(i) = n(i-1) + (n_inf-n(i-1))*dt/tau_n;    % Update n
    end
    
    % For the A-type current gating variables, instead of using alpha and
    % beta, we just use the steady-state values a_inf and b_inf along with 
    % the time constants tau_a and tau_b that are found empirically
    % (Dayan-Abbott, p. 224)
    
    a_inf = (0.0761*exp(0.0314*(Vm+94.22))/(1+exp(0.0346*(Vm+1.17))))^(1/3.0);
    tau_a = 0.3632*1e-3 + 1.158e-3/(1+exp(0.0497*(Vm+55.96)));
    
    b_inf = (1/(1+exp(0.0688*(Vm+53.3))))^4;
    tau_b = 1.24e-3 + 2.678e-3/(1+exp(0.0624*(Vm+50)));
    
    if ( i > 1 ) 
        a(i) = a(i-1) + (a_inf-a(i-1))*dt/tau_a;    % Update a
        b(i) = b(i-1) + (b_inf-b(i-1))*dt/tau_b;    % Update b
    end
    
    I_Na(i) = g_Na*m(i)*m(i)*m(i)*h(i)*(E_Na-V(i)); % total sodium current
    
    I_K(i) = g_K*n(i)*n(i)*n(i)*n(i)*(E_K-V(i)); % total potassium current
    
    I_A(i) = g_A*a(i)*a(i)*a(i)*b(i)*(E_A-V(i)); % total A-type current
    
    Itot(i) = I_L(i)+I_Na(i)+I_K(i)+I_A(i)+Iapp(i); % total current is sum of leak + active channels + applied current
    
    V(i+1) = V(i) + Itot(i)*dt/cm;        % Update the membrane potential, V.

    if ( vclamp_flag )      % if we are using voltage clamp
        V(i+1) = Vapp(i+1);     % ignore the voltage integration and set V to be the applied voltage
    end
    
end

hold on;

figure(1)
plot(t,V);
hold on
plot(t,Iapp*1e6,'r')

legend('V','Iapp')

xlabel('time, sec')
ylabel('Membrane potential, V')

figure(2)
plot(t,(V-E_K)*5e-5);
hold on
plot(t,I_Na,'g')
plot(t,-I_K,'r')
axis([0.502 0.507 0 8e-6])

legend('scaled V', 'I_Na', '-I_K')

xlabel('time, sec')

figure(3)
plot(t,(V-E_K)*5,'k');
hold on
plot(t,m,'g')
plot(t,h,'b')
plot(t,n,'r')
axis([0.502 0.507 0 1])

legend('scaled V', 'm', 'h', 'n')
xlabel('time, sec')

