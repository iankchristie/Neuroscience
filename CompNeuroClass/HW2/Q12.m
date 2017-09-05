clear all

%What neurons share
sigma = .05e-9;     %coefficient of randomness
Vl = -0.070;        %Leak potential for both neurons
Vth = -0.055;       %Threshold potential for both neurons
Vspike = .02;       %Spike potential for both neurons
Vres = -0.075;      %Reset potential for both neurons
Pr = .5;            %Probability of release of vesicles
taud = .2;          %Time constant of Depression

%parameters that effect neuron1
C1 = 5e-9;          %Capacity for Neuron1
Vm1 = -0.070;       %Membrane potential neuron1
Rm1 = 20e6;         %membrain resistance neuron 1
G21 = 0;            %Maximum conductance affecting neuron 1
s2 = 0;             %Gating variable affecting neuron 1
Erev21 = -0.070;    %Reversal potential affecting neuron 1
Iapp1 = 4e-3;       %Applied Current into neuron 1
taus1 = .002;       %Gating variable time constant
D1 = 1;             %Depression

%parameters that effect neuron2
C2 = 5e-9;          %Capacity for Neuron 2
Vm2 = -0.070;       %Membrane potential neuron2
Rm2 = 20e6;         %membrain resistance neuron 2
G12 = 0;            %Maximum conductance affecting neuron 2
s1 = 0;             %Gating variable affecting neuron 2
Erev12 = 0;         %Reversal potential affecting neuron 2
Iapp2 = 4e-9;       %Applied Current into neuron 2
taus2 = .01;        %Gating variable time constant
D2 = 1;             %Depression

%Time variables
startT = 0;                 %Time starts at 0
dT = .001;                  %dT is 1 ms
endT = 30;                  %Time ends
timeVec = startT:dT:endT;   %Time vector from startTime to endTime in increments of dT

%logging vectors
voltageVecN1 = zeros(size(timeVec));
voltageVecN2 = zeros(size(timeVec));
conductanceVecs1 = zeros(size(timeVec));
conductanceVecs2 = zeros(size(timeVec));
vecD1 = zeros(size(timeVec));
vecD2 = zeros(size(timeVec));

for i = 1: length(timeVec),
    %Checking to see if either neurons are spiking
    if Vm1 >= Vth,
        Vm1 = Vres;
        s1 = s1 + Pr*D1*(1-s1);
        D1 = D1*(1-Pr);
    end
    if Vm2 >= Vth,
        Vm2 = Vres;
        s2 = s2 + Pr*D2*(1-s2);
        D2 = D2*(1-Pr);
    end
    
    %Calculate next voltage
    Vm1 = Vm1 + dT*(((Vl - Vm1)/Rm1) + G21*s2*(Erev21-Vm1)+ Iapp1 + sigma*randn(1)/sqrt(dT))/C1;
    Vm2 = Vm2 + dT*(((Vl - Vm2)/Rm2) + G12*s1*(Erev12-Vm2)+ Iapp2 + sigma*randn(1)/sqrt(dT))/C1;
    
    %Calculate next conductances for synapses
    s1 = s1 + dT*(-s1/taus1);
    D1 = D1 + dT*((1-D1)/taud);
    
    s2 = s2 + dT*(-s2/taus2);
    D2 = D2 + dT*((1-D2)/taud);
    
    %Check if over threshold
    if Vm1 >= Vth,
        Vm1 = Vspike;
    end
    if Vm2 >= Vth,
        Vm2 = Vspike;
    end
        
    %log parameters of interest
    voltageVecN1(i) = Vm1;
    voltageVecN2(i) = Vm2;
    conductanceVecs1(i) = s1;
    conductanceVecs2(i) = s2;
    vecD1(i) = D1;
    vecD2(i) = D2;
end

figure;
subplot(3,1,1); 
plot(timeVec,voltageVecN1);
xlabel('Time (sec)')
ylabel('Voltage (V)')
title(['Time vs. Voltage'])

subplot(3,1,2); 
plot(timeVec,conductanceVecs2);
xlabel('Time (sec)')
ylabel('Conductance')
title(['Time vs. Conductance'])

subplot(3,1,3); 
plot(timeVec,vecD2);
xlabel('Time (sec)')
ylabel('Depression')
title(['Time vs. Depression'])

figure;
subplot(3,1,1); 
plot(timeVec,voltageVecN2);
xlabel('Time (sec)')
ylabel('Voltage (V)')
title(['Time vs. Voltage'])

subplot(3,1,2); 
plot(timeVec,conductanceVecs1);
xlabel('Time (sec)')
ylabel('Conductance')
title(['Time vs. Conductance'])

subplot(3,1,3); 
plot(timeVec,vecD1);
xlabel('Time (sec)')
ylabel('Depression')
title(['Time vs. Depression'])

