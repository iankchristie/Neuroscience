clear all

%Constants neurons share
sigma = .05e-9;     %coefficient of randomness
Vl = -0.070;        %Leak potential for both neurons
Vth = -0.055;       %Threshold potential for both neurons
Vspike = .02;       %Spike potential for both neurons
Vres = -0.075;      %Reset potential for both neurons
Pr = .5;            %Probability of release of vesicles
taud = .2;          %Time constant of Depression

%Constant parameters that effect neuron1
C1 = 5e-9;          %Capacity for Neuron1
Rm1 = 20e6;         %membrain resistance neuron 1
G21 = 10e-6;            %Maximum conductance affecting neuron 1
Erev21 = -0.070;    %Reversal potential affecting neuron 1
Iapp1 = 4.5e-9;       %Applied Current into neuron 1
taus1 = .002;       %Gating variable time constant

%Constant parameters that effect neuron2
C2 = 5e-9;          %Capacity for Neuron 2
Rm2 = 20e6;         %membrain resistance neuron 2
G12 = 5e-6;            %Maximum conductance affecting neuron 2
Erev12 = 0;         %Reversal potential affecting neuron 2
Iapp2 = 3e-9;       %Applied Current into neuron 2
taus2 = .01;        %Gating variable time constant

%Time variables
startT = 0;                 %Time starts at 0
dT = .001;                  %dT is 1 ms
endT = 100;                  %Time ends
timeVec = startT:dT:endT;   %Time vector from startTime to endTime in increments of dT

%variables for neuron1
Vm1 = zeros(1,length(timeVec));
Vm1(1) = Vl;
spikesN1 = zeros(1,length(timeVec));

%variables for neuron2
Vm2 = zeros(1,length(timeVec));
Vm2(1) = Vl;
spikesN2 = zeros(1,length(timeVec));

%variables for synapse 12
s1 = zeros(1,length(timeVec));
D1 = ones(1,length(timeVec));

%variables for synapse 21
s2 = zeros(1,length(timeVec));
D2 = ones(1,length(timeVec));

%%%%%%%%%%START SIMULATION%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 2: length(timeVec),
    %calculating next voltage neuron1
    Vm1(i) = Vm1(i-1) + dT*(((Vl - Vm1(i-1))/Rm1) + G21*s2(i-1)*(Erev21-Vm1(i-1))+ Iapp1 + sigma*randn(1)/sqrt(dT))/C1;
    %Calculating synaptic variables for 21
    s1(i) = s1(i-1) + dT*(-s1(i-1)/taus1);
    D1(i) = D1(i-1) + dT*((1-D1(i-1))/taud);
    
    %calculating next voltage neuron1
    Vm2(i) = Vm2(i-1) + dT*(((Vl - Vm2(i-1))/Rm2) + G12*s1(i-1)*(Erev12-Vm2(i-1))+ Iapp2 + sigma*randn(1)/sqrt(dT))/C1;
    %Calculating synaptic variables for 12
    s2(i) = s2(i-1) + dT*(-s2(i-1)/taus2);
    D2(i) = D2(i-1) + dT*((1-D2(i-1))/taud);
        
    %Check if neuron1 is spiking
    if Vm1(i) >= Vth,
        Vm1(i) = Vres;                      %set v to reset
        s1(i) = s1(i) + Pr*D1(i)*(1-s1(i)); %change gating variable for 21
        D1(i) = D1(i)*(1-Pr);               %change depression variable 21
        spikesN1(i) = 1;                    %update spikes for neuron1
    end
        
    %Check if neuron1 is spiking
    if Vm2(i) >= Vth,
        Vm2(i) = Vres;                      %set v to reset
        s2(i) = s2(i) + Pr*D2(i)*(1-s2(i)); %change gating variable for 12
        D2(i) = D2(i)*(1-Pr);               %change depression variable 21
        spikesN2(i) = 1;                    %update spikes for neuron2
    end
end

%%%%%%%%%%%%%%%Plot voltage, gating variable, depression%%%%%%%%%%%%%%%
figure;
subplot(3,1,1); 
plot(timeVec(1:500),Vm1(1:500));
hold on
plot(timeVec(1:500),Vm2(1:500),'r');
xlabel('Time (sec)')
ylabel('Voltage (V)')
title(['Time vs. Voltage'])

subplot(3,1,2); 
plot(timeVec(1:500),s1(1:500));
hold on
plot(timeVec(1:500),s2(1:500),'r');
xlabel('Time (sec)')
ylabel('Gating Variable')
title(['Time vs. Conductance'])

subplot(3,1,3); 
plot(timeVec(1:500),D1(1:500));
hold on
plot(timeVec(1:500),D2(1:500),'r');
xlabel('Time (sec)')
ylabel('Depression')
title(['Time vs. Depression'])
legend('Excitatory', 'Inhibitory');


%%%%%%%%%%%% ISI HISTOGRAM Stuff%%%%%%%%%%%%%%%%%%%%%
tempSpike1 = (find(spikesN1))*dT;   %find indexes of spikes1
tempSpike2 = (find(spikesN2))*dT;   %find indexes of spikes2

isi1 = zeros(1,length(tempSpike1)-1);   %allocate isi1
isi2 = zeros(1,length(tempSpike2)-1);   %allocate isi2

%find isi1
for i = 1: length(tempSpike1)-1
    isi1(i) = tempSpike1(i+1)-tempSpike1(i);
end

%find isi2
for i = 1: length(tempSpike2)-1
    isi2(i) = tempSpike2(i+1)-tempSpike2(i);
end

%Plot histogram with 50 bins of isi1 and isi2
figure;
subplot(2,1,1);
hist(isi1,50);
xlabel('Time (sec)')
ylabel('Number spikes')
title(['Excitatory ISI Histogram'])
subplot(2,1,2);
hist(isi2,50);
xlabel('Time (sec)')
ylabel('Number spikes')
title(['Inhibitory ISI Histogram'])


%%%%%%%%%%%%%%%% Correlation Stuff %%%%%%%%%%%%%%%%%%%%%%
r = 5; %ratio of dT:bin

%allocating for bins
binVec1 = zeros(1,ceil(length(spikesN1)/r));
binVec2 = zeros(1,ceil(length(spikesN2)/r));

%Calculate bin1
for i = 1: length(spikesN1),
    y = ceil(i/r); %offset
    if(spikesN1(i)==1),
        binVec1(y) = binVec1(y) + 1;
    end
end


%Calculate bin2
for i = 1: length(spikesN2),
    y = ceil(i/r); %offset
    if(spikesN2(i)==1),
        binVec2(y) = binVec2(y) + 1;
    end
end

%temporary so I can still look at binvec's if needed
temp1 = binVec1;
temp2 = binVec2;

%allocating for correlation vector
correlationVec = zeros(1,length(binVec1));

for i = 1: length(binVec1),
    a = temp1 * temp2' / length(temp1); %sum corresponding multiplication of vectors and divide by length
    b = mean(temp1);                    %find mean of temp1
    c = mean(temp2);                    %find mean of temp2
    correlationVec(i) = a-b*c;          %store correlation for this lag-time in vector
    temp1 = temp1(1:end-1);             %alter temp1: cut one off end
    temp2 = temp2(2:end);               %alter temp2: cut one off begining
end

%%%%%%%%%%%Plot correlation vector%%%%%%%%%%%%%%%%%%%%
figure;
plot(correlationVec);
xlabel('Time (lag (5ms))')
ylabel('Correlation')
title(['Correlation Function'])


%%%%%%%%%%%%%%%%%%%%%%%%%%Finding analogous correlation function%%%%%%%%%%%
temp1 = binVec1;
temp2 = binVec2;

correlationVec = zeros(1,length(binVec1));

for i = 1: length(binVec1),
    a = temp1 * temp2' / length(temp1);
    b = mean(temp1);
    c = mean(temp2);
    correlationVec(i) = a-b*c;
    temp1 = temp1(2:end);
    temp2 = temp2(1:end-1);
end

figure;
plot(correlationVec);
xlabel('Time (lag (5ms))')
ylabel('Correlation')
title(['Correlation Function'])
