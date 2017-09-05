% Question 1 e
% This model is the two-compartment alternative to the Pinsky-Rinzel model (1994)
clear
dt = 0.0001; %.1 ms
tmax=30;

iclamp_flag = 1; % if this is 1, run under current clamp conditions
vclamp_flag = 0; % otherwise this should be 1, for voltage clamp conditions

vstart = 0.25;  % time to step voltage
vlength = 0.5;  % length of voltage step
V0 = -0.080     % initial voltage before step
Ve = -0.040;    % value of votage stepped to

E_L = -0.065;   % leak reversal potential
E_Na = 0.055;   % reversal for sodium channels
E_K = -0.090;   % reversal for potassium channels

g_LD = 1.8e-6;     % specific leak conductance in Siemens per mm-square
g_LS = 1.8e-6;     % specific leak conductance in Siemens per mm-square
g_Na = 0.55e-3;   % specific sodium conductance
g_Na = 0.75e-3;
g_K = 0.25e-3;    % specific potassium conductance
g_NaP = 2e-6;    % persistent sodium conductance
g_KS = 20e-6;      % Slow Potassium conductance

g_Link = 12e-6; % conductance linking dendrite and soma divided by total membrane area
%g_Link = 500e-6; % conductance linking dendrite and soma divided by total membrane area

S_frac = 0.15;  % fraction of total membrane area that is soma
D_frac = 1-S_frac; % rest of area is dendritic

g_S_Link = g_Link/S_frac; %link conductance divided by somatic area
g_D_Link = g_Link/D_frac; % link conductance divided by dendritic area

cm = 10e-9;     % specific membrane capacitance in Farads per mm-square

t=0:dt:tmax;        % time vector
VS=zeros(size(t));  % somatic voltage vector
VD=zeros(size(t));  % dendritic voltage vector

I_L= zeros(size(t));
I_Na = zeros(size(t));
I_K = zeros(size(t));
I_NaP = zeros(size(t));
I_KS = zeros(size(t));
IS = zeros(size(t));
ID = zeros(size(t));
I_Link = zeros(size(t));
I_LD = zeros(size(t));
I_LS = zeros(size(t));

if ( iclamp_flag ) % i.e. if in current-clamp mode 
    VS(1) = E_L;    % set the inititial value of somatic voltage     
    VD(1) = E_L;    % set the inititial value of dendritic voltage     
end

n=zeros(size(t));   % n: potassium activation gating variable
n(1) = 0.0;         % start off at zero
m=zeros(size(t));   % m: sodium activation gating variable
m(1) = 0.0;         % start off at zero
h=zeros(size(t));   % h: sodim inactivation gating variplot(t,V)able
h(1) = 0.0;         % start off at zero

a=zeros(size(t));   % A-current activation gating variable
a(1) = 0.0;         % start off at zero
b=zeros(size(t));   % A-current inactivation gating variable
b(1) = 0.0;         % start off at zero

mnap=zeros(size(t)); % persistent sodium current activation gating variable
mnap(1) = 0.0;          
mks=zeros(size(t)); % slow potassium activation gating variable
mks(1) = 0.0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%Code Added Below%%%%%%%%%%%%%%%%%%%%%%%%%%
Iapp= zeros(size(t));
startCurrent = 0;
for i = 1: length(Iapp),
    Iapp(i) = startCurrent;
    if (mod(i*dt,.001)==0), %when time is divisible by 10 ms
        startCurrent = randn(1)*200e-9; %alter current
    end
end
%spike vector
spikes = zeros(size(t));
threshold = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%Code Added Above%%%%%%%%%%%%%%%%%%%%%%%%%%

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

for i = 2:length(t); % now see how things change through time
    I_LS(i) = g_LS*(E_L-VS(i-1));
    I_LD(i) = g_LD*(E_L-VD(i-1));
   
    Vm = VS(i-1)*1000; % converts voltages to mV
    VmD = VD(i-1)*1000; % converts voltages to mV
    
    % Sodium and potassium gating variables are defined by the
    % voltage-dependent transition rates between states, labeled alpha and
    % beta. 
    if ( Vm == -31 ) 
        alpha_m = 10;
    else 
        alpha_m = 1*(Vm+31)/(1-exp(-0.1*(Vm+31)));
    end
    beta_m = 40*exp(-(Vm+56)/18);

    alpha_h = 0.233*exp(-0.05*(Vm+47));
    beta_h = 3.33/(1+exp(-0.1*(Vm+17)));
    

    if ( Vm == -34 ) 
       alpha_n = 0.033/0.1;
    else
        alpha_n = 0.033*(Vm+34)/(1-exp(-0.1*(Vm+34)));
    end
    beta_n = 0.417*exp(-0.0125*(Vm+44));
     
    % From the alpha and beta for each gating variable we find the steady
    % state values (_inf) and the time constants (tau_) for each m,h and n.
    
    tau_m = 1e-3/(alpha_m+beta_m);      % time constant converted from ms to sec
    m_inf = alpha_m/(alpha_m+beta_m);
 
    if( m_inf < 0 ) 
        m_inf = 0;
    end
    if ( m_inf > 1 ) 
        m_inf = 1;
    end
        
    tau_h = 1e-3/(alpha_h+beta_h);      % time constant converted from ms to sec
    h_inf = alpha_h/(alpha_h+beta_h);
    if ( h_inf < 0 ) 
        h_inf = 0;
    end
    if ( h_inf > 1 )
        h_inf = 1;
    end
    
    tau_n = 1e-3/(alpha_n+beta_n);      % time constant converted from ms to sec
    n_inf = alpha_n/(alpha_n+beta_n);   
    if ( n_inf < 0 ) 
        n_inf = 0;
    end
    if ( n_inf > 1 ) 
        n_inf = 1;
    end
    
    m(i) = m_inf - (m_inf-m(i-1))*exp(-dt/tau_m);    % Update m, assuming time constant is neglible.
    
    h(i) = h_inf - (h_inf-h(i-1))*exp(-dt/tau_h);    % Update h
    
    n(i) = n_inf - (n_inf-n(i-1))*exp(-dt/tau_n);    % Update n
    
    % For the persistent sodium current, activation is assumed so fast that
    % steady state value is reached immediately with no timec onstant.
    
    mnap_inf = 1/(1+exp(-(VmD+57.7)/7.7));
       
    mnap(i) = mnap_inf;    % Update mnap
    
    % Now the slow potassium conductance:
    
    mks_inf = 1/(1+exp(-(VmD+35)/6.5));
    tau_mks = 200e-3/( exp(-(VmD+55)/30) +exp((VmD+55)/30) );
   
    mks(i) = mks_inf - (mks_inf-mks(i-1))*exp(-dt/tau_mks);
    
    g_Na_now = g_Na*m(i)*m(i)*m(i)*h(i);
    I_Na(i) = g_Na_now*(E_Na-VS(i-1)); % sodium current in soma
    
    g_K_now = g_K*n(i)*n(i)*n(i)*n(i);
    I_K(i) = g_K_now*(E_K-VS(i-1)); % potassium delayed rectifier current, soma
    
    g_NaP_now = g_NaP*mnap(i)*mnap(i)*mnap(i);
    I_NaP(i) = g_NaP_now*(E_Na-VD(i-1)); % persistent sodium current in dendrite
    
    g_KS_now = g_KS*mks(i);
    I_KS(i) = g_KS_now*(E_K-VD(i-1)); % slow potassium current in dendrite
    
    I_Link(i) = g_Link*(VD(i-1)-VS(i-1));
    
    IS(i) = I_LS(i)+I_Na(i)+I_K(i)+I_Link(i)/S_frac; % total current in soma
    ID(i) = I_LD(i)+I_NaP(i)+I_KS(i)-I_Link(i)/D_frac; % total current in dendrite
    
    gS_Tot = g_LS+g_Na_now+g_K_now+g_S_Link;
    VS_inf = (g_LS*E_L + g_Na_now*E_Na + g_K_now*E_K ...
            + VD(i-1)*g_S_Link)/gS_Tot;
                   
    gD_Tot = g_LD+g_NaP_now+g_KS_now+g_D_Link;
    VD_inf = (g_LD*E_L + g_NaP_now*E_Na + g_KS_now*E_K ...
            + VS(i-1)*g_D_Link + Iapp(i))/gD_Tot;
                   
    VS(i) = VS_inf - (VS_inf-VS(i-1))*exp(-dt*gS_Tot/cm);  % Update the membrane potential, V.
    VD(i) = VD_inf - (VD_inf-VD(i-1))*exp(-dt*gD_Tot/cm);  % Update the membrane potential, V.

    if ( vclamp_flag )      % if we are using voltage clamp
        VS(i) = Vapp(i);     % ignore the voltage integration and set V to be the applied voltage
    end
    
%%%%%%%%%%%%%%%%%%%%%%Code Added Below%%%%%%%%%%%%%%%%%%%%%%%%%%
    if( VS(i) >= threshold && VS(i-1) < threshold) %count as spike
        spikes(i) = 1;
    end
%%%%%%%%%%%%%%%%%%%%%%Code Added Above%%%%%%%%%%%%%%%%%%%%%%%%%%
    
end

figure;
subplot(2,1,1);
plot(t,VS)
xlabel('Time (sec)')
ylabel('Soma Voltage (v)')
title('Voltage vs. time')
subplot(2,1,2);
plot(t,Iapp);
xlabel('Time (sec)')
ylabel('Current (amps)')
title('Current vs. time')