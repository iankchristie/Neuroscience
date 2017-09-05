% PR.m
% This model is the two-compartment model of Pinsky and Rinzel (1994)
clear
dt = 0.00002;
tmax=5;

iclamp_flag = 1; % if this is 1, run under current clamp conditions
vclamp_flag = 0; % otherwise this should be 1, for voltage clamp conditions

idendrite_flag =1; %if this is one, apply current in dendrite, otherwise in soma
IappS = 0.0;
IappD = 0.0;

isine_flag = 0;  % if this is one send in an oscillatory current
freq = 3;        % frequency of current oscillations

istart = 0.0; % time applied current starts
ilength=5;   % length of applied current pulse
I0=-20e-9;
Ie=0e-9;     % magnitude of applied current pulse
%Ie = 0.78e-7; % threshold for constant spiking with no A-current

vstart = 0.25;  % time to step voltage
vlength = 0.5;  % length of voltage step
V0 = -0.080     % initial voltage before step
Ve = -0.000;    % value of votage stepped to

E_L = -0.062;   % leak reversal potential
E_Na = 0.070;   % reversal for sodium channels
E_K = -0.075;   % reversal for potassium channels
E_Ca = 0.100;   % reversal for calcium channels

g_LD = 1e-6;     % specific leak conductance in Siemens per mm-square
g_LS = 1e-6;     % specific leak conductance in Siemens per mm-square
g_Na = 0.60e-3;   % specific sodium conductance
g_K = 0.3e-3;    % specific potassium conductance

g_Ca = 0.08e-3;    % calcium conductance
%g_KAHP = 8e-6;      % Potassium conductance to generate after-hyperpolarization
g_KAHP = 0;
g_KCa = 0.15e-3;      % calcium-dependent Potassium conductance

g_Link = 4e-6; % conductance linking dendrite and soma divided by total membrane area
g_Link = 5e-6; % conductance linking dendrite and soma divided by total membrane area

tau_Ca = 0.1;       % time constant for removal of calcium from cell
convert_Ca = 10000;  % conversion changing calcium charge entry per unit area into concentration

S_frac = 0.15;  % fraction of total membrane area that is soma
D_frac = 1-S_frac; % rest of area is dendritic

g_S_Link = g_Link/S_frac; %link conductance divided by somatic area
g_D_Link = g_Link/D_frac; % link conductance divided by dendritic area

cm = 10e-9;     % specific membrane capacitance in Farads per mm-square

t=0:dt:tmax;        % time vector
VS=zeros(size(t));  % somatic voltage vector
VD=zeros(size(t));  % dendritic voltage vector
VD(1) = E_L;
VS(1) + E_L;

Ca=zeros(size(t));  % dendritic calcium level (extra Ca above base level)
Ca(1) = 0;          % initialize with no (extra) Ca in cell.

I_LD= zeros(size(t));   % leak current in dendrite
I_LS= zeros(size(t));   % leak current in soma
I_Na = zeros(size(t));
I_K = zeros(size(t));
I_Ca = zeros(size(t));
I_KAHP = zeros(size(t));
I_KCa = zeros(size(t));

if ( iclamp_flag ) % i.e. if in current-clamp mode 
    VS(1) = E_L;    % set the inititial value of somatic voltage     
    VD(1) = E_L;    % set the inititial value of dendritic voltage     
end

n=zeros(size(t));   % n: potassium activation gating variable
m=zeros(size(t));   % m: sodium activation gating variable
h=zeros(size(t));   % h: sodim inactivation gating variplot(t,V)able

mca=zeros(size(t)); % CaT current activation gating variable
mkca=zeros(size(t)); % CaT current inactivation gating variable
mkahp = zeros(size(t));

Iapp = zeros(size(t));
if ( iclamp_flag )   % i.e. if in current-clamp mode 
    for i = 1:round(istart/dt)
        Iapp(i) = I0;
    end
    for i=round(istart/dt)+1:round((istart+ilength)/dt) % make non-zero for duration of current pulse
        if ( isine_flag ) % if the pulse is oscillatory
            Iapp(i) = Ie - (Ie-I0)*cos((t(i)-istart)*freq*2*pi);
        else
            Iapp(i) = Ie;
        end
    end
    for i = round((istart+ilength)/dt):length(Iapp)
        Iapp(i) = I0;
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

    Vapp = V0+(Ve-V0)*t/tmax;
end

Itot=zeros(size(t)); % in case we want to plot and look at the total current

for i = 2:length(t); % now see how things change through time
    I_LS(i) = g_LS*(E_L-VS(i-1));
    I_LD(i) = g_LD*(E_L-VD(i-1));
   
    Vm = VS(i-1)*1000; % converts voltages to mV
    VmD = VD(i-1)*1000; % converts voltages to mV
    
    % Sodium and potassium gating variables are defined by the
    % voltage-dependent transition rates between states, labeled alpha and
    % beta. 
    if ( Vm == -46.9 ) 
        alpha_m = 0.32/0.25;
    else 
        alpha_m = 0.32*(Vm+46.9)/(1-exp(-0.25*(Vm+46.9)));
    end
    if ( Vm == -19.9 ) 
        beta_m = 0.28/0.2;
    else 
        beta_m = 0.28*(Vm+19.9)/(exp(0.2*(Vm+19.9))-1);
    end

    alpha_h = 0.128*exp(-(Vm+43)/18);
    beta_h = 4.0/(1+exp(-0.2*(Vm+20)));
    

    if ( Vm == -24.9 ) 
       alpha_n = 0.016/0.2;
    else
        alpha_n = 0.016*(Vm+24.9)/(1-exp(-0.2*(Vm+24.9)));
    end
    beta_n = 0.25*exp(-0.025*(Vm+40));
     
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
        
    tau_h = 0.5e-3/(alpha_h+beta_h);      % time constant converted from ms to sec
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
    
%    m(i) = m_inf - (m_inf-m(i-1))*exp(-dt/tau_m);    
 
    m(i) = m_inf; % Update m, assuming time constant is neglible.
    
    h(i) = h_inf - (h_inf-h(i-1))*exp(-dt/tau_h);    % Update h
    
    n(i) = n_inf - (n_inf-n(i-1))*exp(-dt/tau_n);    % Update n
    
   
    % Now do the same for dendritic conductances
    
    alpha_mca = 1.6/( 1+exp(-0.072*(VmD-5)) );
    if ( VmD == -8.9 ) 
        beta_mca = 0.02/0.2;
    else 
        beta_mca = 0.02*(VmD+8.9)/(exp(0.2*(VmD+8.9))-1);
    end

    if ( VmD > -10 ) 
        alpha_kca = 2.0*exp(-(53.5+VmD)/27);
        beta_kca = 0;
    else
        alpha_kca = exp( (VmD+50)/11 -(VmD+53.5)/27 )/18.975;
        beta_kca = 2*exp(-(53.5+VmD)/27)-alpha_kca;
    end
        
    if ( 2*Ca(i-1) > 0.01 ) 
        alpha_kahp = 0.01;
    else
        alpha_kahp = 2*Ca(i-1);
    end
    beta_kahp = 0.001;
         
    % From the alpha and beta for each gating variable we find the steady
    % state values (_inf) and the time constants (tau_) for each mca, kca and kahp.
    
    tau_mca = 1e-3/(alpha_mca+beta_mca);      % time constant converted from ms to sec
    mca_inf = alpha_mca/(alpha_mca+beta_mca);
 
    if( mca_inf < 0 ) 
        mca_inf = 0;
    end
    if ( mca_inf > 1 ) 
        mca_inf = 1;
    end
        
    tau_mkca = 1e-3/(alpha_kca+beta_kca);      % time constant converted from ms to sec
    mkca_inf = alpha_kca/(alpha_kca+beta_kca);
    if ( mkca_inf < 0 ) 
        mkca_inf = 0;
    end
    if ( mkca_inf > 1 )
        mkca_inf = 1;
    end
    
    tau_mkahp = 1e-3/(alpha_kahp+beta_kahp);      % time constant converted from ms to sec
    mkahp_inf = alpha_kahp/(alpha_kahp+beta_kahp);   
    
    mca(i) = mca_inf - (mca_inf-mca(i-1))*exp(-dt/tau_mca);    % Update mca
    
    mkca(i) = mkca_inf - (mkca_inf-mkca(i-1))*exp(-dt/tau_mkca);    % Update mkca
    
    mkahp(i) = mkahp_inf - (mkahp_inf-mkahp(i-1))*exp(-dt/tau_mkahp);    % Update mkahp   
     
    g_Na_now = g_Na*m(i)*m(i)*h(i);
    I_Na(i) = g_Na_now*(E_Na-VS(i-1)); % sodium current in soma
    
    g_K_now = g_K*n(i)*n(i);
    I_K(i) = g_K_now*(E_K-VS(i-1)); % potassium delayed rectifier current, soma
    
    g_Ca_now = g_Ca*mca(i)*mca(i);
    I_Ca(i) = g_Ca_now*(E_Ca-VD(i-1)); % persistent sodium current in dendrite
    
    if ( Ca(i-1) > 250e-6 ) 
        g_KCa_now = g_KCa*mkca(i);
    else
        g_KCa_now = g_KCa*mkca(i)*Ca(i-1)/250e-6;
    end
    I_KCa(i) = g_KCa_now*(E_K-VD(i-1)); % calcium-dependent potassium current in dendrite
    
    g_KAHP_now = g_KAHP*mkahp(i);
    I_KAHP(i) = g_KAHP_now*(E_K-VD(i-1)); % calcium-dependent potassium current in dendrite
       
    
    I_Link(i) = g_Link*(VD(i-1)-VS(i-1));
    
    if ( idendrite_flag ) 
        IappD = Iapp(i);
    else
        IappS = Iapp(i);
    end
    
    IS(i) = I_LS(i)+I_Na(i)+I_K(i)+I_Link(i)/S_frac+IappS; % total current in soma
    ID(i) = I_LD(i)+I_Ca(i)+I_KCa(i)+I_KAHP(i)-I_Link(i)/D_frac +IappD; % total current in dendrite
    
    gS_Tot = g_LS+g_Na_now+g_K_now+g_S_Link;
    VS_inf = (g_LS*E_L + g_Na_now*E_Na + g_K_now*E_K ...
            + VD(i-1)*g_S_Link + IappS)/gS_Tot;
                   
    gD_Tot = g_LD+g_Ca_now+g_KCa_now+g_KAHP_now+g_D_Link;
    VD_inf = (g_LD*E_L + g_Ca_now*E_Ca + g_KCa_now*E_K + g_KAHP_now*E_K ...
            + VS(i-1)*g_D_Link + IappD )/gD_Tot;
                   
    VS(i) = VS_inf - (VS_inf-VS(i-1))*exp(-dt*gS_Tot/cm);  % Update the membrane potential, V.
    VD(i) = VD_inf - (VD_inf-VD(i-1))*exp(-dt*gD_Tot/cm);  % Update the membrane potential, V.
    Ca_inf = tau_Ca*convert_Ca*I_Ca(i);
    Ca(i) = Ca_inf - (Ca_inf-Ca(i-1))*exp(-dt/tau_Ca);  % update Ca level
    
    if ( vclamp_flag )      % if we are using voltage clamp
        VS(i) = Vapp(i);     % ignore the voltage integration and set V to be the applied voltage
        VD(i) = Vapp(i);     % ignore the voltage integration and set V to be the applied voltage
    end
    
end

    