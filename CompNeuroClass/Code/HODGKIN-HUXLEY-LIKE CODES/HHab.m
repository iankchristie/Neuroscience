% HHab.m Plots currents and gating variables as a function of V
clear
dV = 0.1;
Vmin = -100;
Vmax = 50;
V = Vmin:dV:Vmax;

V_L = -10.613;   % leak reversal potential
E_Na = -115;   % reversal for sodium channels
E_K = 12;   % reversal for potassium channels

g_L = 0.3;     % specific leak conductance
g_Na = 120;  % specific sodium conductance
g_K = 36;     % specific potassium conductance

cm = 1;     % specific membrane capacitance
tau = cm/g_L;   % membrane time constant

n=zeros(size(V));   % n: potassium activation gating variable
m=zeros(size(V));   % m: sodium activation gating variable
h=zeros(size(V));   % h: sodim inactivation gating variable
alpha_n = zeros(size(V));
beta_n = zeros(size(V));
alpha_m = zeros(size(V));
beta_m = zeros(size(V));
alpha_h = zeros(size(V));
beta_h = zeros(size(V));

I_L=zeros(size(V)); % in case we want to plot and look at the total current
I_Na=zeros(size(V)); % in case we want to plot and look at the total current
I_K=zeros(size(V)); % in case we want to plot and look at the total current


Itot=zeros(size(V)); % in case we want to plot and look at the total current

for i = 1:length(V); % now see how things change through time
    I_L(i) = g_L*(V_L-V(i));

    Vm = V(i);

    % Sodium and potassium gating variables are defined by the
    % voltage-dependent transition rates between states, labeled alpha and
    % beta. Written out from Dayan/Abbott, units are 1/ms.

    if ( Vm == -25 )
        alpha_m(i) = 0.1/0.1;
    else
        alpha_m(i) = (0.1*(Vm+25))/(exp(0.1*(Vm+25))-1);
    end
    beta_m(i) = 4*exp(Vm/18);
    alpha_h(i) = 0.07*exp(Vm/20);
    beta_h(i) = 1/(1+exp((Vm+30)/10));
    if ( Vm == -10)
        alpha_n(i) = 0.01/0.1;
    else
        alpha_n(i) = (0.01*(Vm+10))/(exp(0.1*(Vm+10))-1);
    end
    beta_n(i) = 0.125*exp((Vm)/80);

    % From the alpha and beta for each gating variable we find the steady
    % state values (_inf) and the time constants (tau_) for each m,h and n.

    tau_m(i) = 1/(alpha_m(i)+beta_m(i));      
    m(i) = alpha_m(i)/(alpha_m(i)+beta_m(i));

    tau_h(i) = 1/(alpha_h(i)+beta_h(i));     
    h(i) = alpha_h(i)/(alpha_h(i)+beta_h(i));

    tau_n(i) = 1/(alpha_n(i)+beta_n(i));      
    n(i) = alpha_n(i)/(alpha_n(i)+beta_n(i));

    I_Na(i) = g_Na*m(i)*m(i)*m(i)*h(i)*(E_Na-V(i)); % total sodium current

    I_K(i) = g_K*n(i)*n(i)*n(i)*n(i)*(E_K-V(i)); % total potassium current

    Itot(i) = I_L(i)+I_Na(i)+I_K(i); % total current is sum of leak + active channels + applied current


end

hold on;

plot(V,Itot);
hold on;
plot(V,I_Na,'g');
plot(V,I_K,'r');
plot(V,I_L,'m');
xlabel('Voltage, mV')
ylabel('Current, nA')
legend('Total', 'Na', 'K', 'Leak')

figure();
plot(V,m,'g');
hold on;
plot(V,h);
plot(V,n,'r');
xlabel('Voltage, mV')
ylabel('Gating variable')
legend('m', 'h', 'n')

figure();
hold on;
plot(V,alpha_m);
plot(V,beta_m,'g');

xlabel('Voltage, mV')
ylabel('rate constants')
legend('alpha_m' , 'beta_m')


