% threeconnors.m
% This model is the Connors-Stevens model, similar to Hodgkin-Huxley, but
% more like neurons in the cortex, being type-I.
% See Dayan and Abbott pp 166-172 then pp.196-198 and p.224.
% Three neurons are coupled in this version
clear
tic
dt = 0.00005;
Idt = 0.001;
dtratio = Idt/dt;

tmax=30;
Ncells = 3;

iclamp_flag = 1; % if this is 1, run under current clamp conditions
vclamp_flag = 0; % otherwise this should be 1, for voltage clamp conditions

istart = 0; % time applied current starts
ilength=tmax;   % length of applied current pulse
%Ie=2.405e-7;     % magnitude of applied current pulse
Ie=2.0e-8;     % magnitude of applied current pulse
%Ie = 0.78e-7; % threshold for constant spiking with no A-current
sigma_I = 10e-9/sqrt(Idt);

V_L = -0.070;   % leak reversal potential
E_Na = 0.055;   % reversal for sodium channels
E_K = -0.072;   % reversal for potassium channels
E_A = -0.075;   % reversal for A-type potassium channels

g_L = 3e-7;     % specific leak conductance
g_Na = 1.2e-3;  % specific sodium conductance
g_K = 1e-4;     % specific potassium conductance
g_A = 1.0e-4;  % specific A-tpe potassium conductance
%g_A = 0.0;
cm = 10e-9;     % specific membrane capacitance

g_syn = zeros(Ncells); % By default no connections between neurons: add each connection by hand
V_syn = zeros(1,Ncells); % By default, synapses are excitatory with reversal potential at 0mV

g_syn0 = 2.0e-3;
g_syn(1,3) = 10*g_syn0; % high conductance when time constant is short
g_syn(2,3) = 2*g_syn0;  % lower conductance with longer time constant

tau_syn = 0.002*ones(Ncells); %AMPA time constant is about 2ms
tau_syn(2) = 0.020; % A slow GABA time constant of 20ms

V_syn(2) = -0.065;  % make the cell(2) inhibitory

syn = zeros(1,Ncells);
D=ones(1,Ncells);
F=ones(1,Ncells);
pr0 = 0.02*ones(1,Ncells);
pr = pr0.*ones(1,Ncells);
tau_d = 0.2;
tau_f = 0.1;
fac = 1.0*ones(1,Ncells);
fac(1) = 0.0;
lspike = -1.0*ones(1,Ncells);

t=0:dt:tmax;    % time vector
V=zeros(Ncells,length(t)); % voltage vector
Iapp = zeros(Ncells,length(t)); % Applied current can differ to each cell
for i = 1:round(length(t)/dtratio)
    Irand = sigma_I*randn(1);
    Isave(1,i) = Irand+Ie;
    for j = 1:dtratio
        Iapp(1,(i-1)*dtratio+j) = Irand+Ie;
        Iapp(2,(i-1)*dtratio+j) = 0.5*Irand+3*Ie;
    end
end

spikes = zeros(Ncells,length(t)); % vector of spike times
spikenow = zeros(1,Ncells);   % variable that is 1 during a spike
Vspike = 0.0; % voltage at which a spike is registered

if ( iclamp_flag ) % i.e. if in current-clamp mode
    for cell =1:Ncells
        V(cell,1) = V_L;    % set the inititial value of voltage
    end
end

n=zeros(Ncells,length(t));   % n: potassium activation gating variable

m=zeros(Ncells,length(t));   % m: sodium activation gating variable
h=zeros(Ncells,length(t));   % h: sodim inactivation gating variable

a=zeros(Ncells,length(t));   % A-current activation gating variable
b=zeros(Ncells,length(t));   % A-current inactivation gating variable

for cell =1:Ncells
    n(cell,1) = 0.0;         % start off deactivated
    m(cell,1) = 0.0;         % start off deactivated
    h(cell,1) = 0.0;         % start off inactivated
    a(cell,1) = 0.0;         % start off deactivated
    b(cell,1) = 0.0;         % start off inactivated

end

for i = 2:length(t); % now see how things change through time

    for cell = 1:Ncells % update one cell at a time

        I_L = g_L*(V_L-V(cell,i-1));

        Vm = V(cell,i-1)*1000; % converts voltages to mV as needed (cf on p.224 of Dayan/Abbott)

        % Sodium and potassium gating variables are defined by the
        % voltage-dependent transition rates between states, labeled alpha and
        % beta. Written out from Dayan/Abbott, units are 1/ms.


        if ( Vm == -29.7 )
            alpha_m = 0.38/0.1;
        else
            alpha_m = 0.38*(Vm+29.7)/(1-exp(-0.1*(Vm+29.7)));
        end
        beta_m = 15.2*exp(-0.0556*(Vm+54.7));

        alpha_h = 0.266*exp(-0.05*(Vm+48));
        beta_h = 3.8/(1+exp(-0.1*(Vm+18)));

        if ( Vm == -45.7 )
            alpha_n = 0.02/0.1;
        else
            alpha_n = 0.02*(Vm+45.7)/(1-exp(-0.1*(Vm+45.7)));
        end
        beta_n = 0.25*exp(-0.0125*(Vm+55.7));

        % From the alpha and beta for each gating variable we find the steady
        % state values (_inf) and the time constants (tau_) for each m,h and n.

        tau_m = 1e-3/(alpha_m+beta_m);      % time constant converted from ms to sec
        m_inf = alpha_m/(alpha_m+beta_m);

        tau_h = 1e-3/(alpha_h+beta_h);      % time constant converted from ms to sec
        h_inf = alpha_h/(alpha_h+beta_h);

        tau_n = 1e-3/(alpha_n+beta_n);      % time constant converted from ms to sec
        n_inf = alpha_n/(alpha_n+beta_n);

        m(cell,i) = m_inf - (m_inf-m(cell,i-1))*exp(-dt/tau_m);    % Update m

        h(cell,i) = h_inf - (h_inf-h(cell,i-1))*exp(-dt/tau_h);    % Update h

        n(cell,i) = n_inf - (n_inf-n(cell,i-1))*exp(-dt/tau_n);    % Update n

        % For the A-type current gating variables, instead of using alpha and
        % beta, we just use the steady-state values a_inf and b_inf along with
        % the time constants tau_a and tau_b that are found empirically
        % (Dayan-Abbott, p. 224)

        a_inf = (0.0761*exp(0.0314*(Vm+94.22))/(1+exp(0.0346*(Vm+1.17))))^(1/3.0);
        tau_a = 0.3632*1e-3 + 1.158e-3/(1+exp(0.0497*(Vm+55.96)));

        b_inf = (1/(1+exp(0.0688*(Vm+53.3))))^4;
        tau_b = 1.24e-3 + 2.678e-3/(1+exp(0.0624*(Vm+50)));

        a(cell,i) = a_inf - (a_inf-a(cell,i-1))*exp(-dt/tau_a);    % Update a
        b(cell,i) = b_inf - (b_inf-b(cell,i-1))*exp(-dt/tau_b);    % Update b

        g_Na_now = g_Na*m(cell,i)*m(cell,i)*m(cell,i)*h(cell,i); % total sodium current

        g_K_now = g_K*n(cell,i)*n(cell,i)*n(cell,i)*n(cell,i); % total potassium current

        g_A_now = g_A*a(cell,i)*a(cell,i)*a(cell,i)*b(cell,i); % total A-type current

        g_syn_now = 0.0;
        gV_syn_now = 0.0;
        for cell_pre = 1:Ncells
            g_syn_now = g_syn_now + syn(cell_pre)*g_syn(cell_pre,cell);
            gV_syn_now = gV_syn_now + syn(cell_pre)*g_syn(cell_pre,cell)*V_syn(cell_pre);
        end

        g_tot = g_L + g_Na_now+g_K_now+g_A_now + g_syn_now;

        V_inf = (g_L*V_L + g_Na_now*E_Na + g_K_now*E_K + ...
                    g_A_now*E_A + gV_syn_now + Iapp(cell,i-1) )/g_tot;

 %       if ( ( V_inf < -0.080 ) || (V_inf > 0.050 ) ) 
 %           g_Na_now
 %           g_A_now
 %           g_K_now
 %           Iapp(cell,i-1)
 %           Iapp(cell,i)
 %           gV_syn_now
 %           g_syn_now
 %           g_tot
 %           cell
 %           V(cell,i-1)
 %           break
 %       end
                   
        V(cell,i) = V_inf + (V(cell,i-1)-V_inf)*exp(-dt*g_tot/cm);        % Update the membrane potential, V.

        if ( spikenow(cell) == 0 )
            if ( V(cell,i) > Vspike )
                D(cell) = 1 - (1-D(cell))*exp(-(t(i)-lspike(cell))/tau_d);
                F(cell) = 1 - (1-F(cell))*exp(-(t(i)-lspike(cell))/tau_f);
                pr(cell) = pr0(cell)*F(cell);
                spikenow(cell) = 1;
                spikes(cell,i) = 1;
                syn(cell) = syn(cell) + (1-syn(cell))*D(cell)*F(cell)*pr0(cell);
                syn(cell);
                D(cell) = D(cell)*(1 - pr(cell));
                pr(cell) = pr(cell) + fac(cell)*(1-pr(cell));                
                F(cell) = pr(cell)/pr0(cell);
                lspike(cell) = t(i);
                D(cell);
                F(cell);
            end
        else
            if ( V(cell,i) < Vspike-0.010 )
                spikenow(cell) = 0;
            end
        end

    end % Next Cell

    for cell = 1:Ncells
        syn(cell) = syn(cell)*exp(-dt/tau_syn(cell));
    end
    
end

spiketimes = dt*find(spikes);

figure()
hold on;

plot(t,V)
xlabel('t,sec')
ylabel('V')
legend('cell1 ', 'cell2', 'cell3')
toc