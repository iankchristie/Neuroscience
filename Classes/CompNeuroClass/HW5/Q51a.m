clear all

%Time
T = 0;                              %Start time (0 sec)
dT = .00001;                       %Time increment sec
numTrials = 14;                     %number of trials per run
trialLength = .2;                   %Length of each Trial
endTime = numTrials*trialLength;    %Total time of simulation 

trialTime = T:dT:trialLength;
time = T:dT:endTime;                %Creating of time vector

%Integrate and Fire Constants
Cm = 10e-9;         %capacivity in F/mm^2... May have to come back for units
Gl = 1e-6;          %membrane conductance S/mm^2... May have to come back for units
El = -.070;         %leak potential V
Vex = 0;            %reversal potential of synapses
Vth = -.054;        %threshold potential V
Vreset = -.080;     %reset potential


%Integrate and Fire Variables
V = zeros(1,length(time));     %membrane potential
V(1) = El;

%Synaptic Constants
taus = .005;        %synaptic time constant Sec

%Synaptic Variables
S1 = zeros(1,length(time));     %synaptic gating variable 1
S2 = zeros(1,length(time));     %synaptic gating variable 2

%Plasticity Constants
Altp = 0.35e-6;
taultp = .025;
Altd = 0.45e-6;
taultd = .035;
Gcsmin = 0;
Gcsmax = 1.2e-6;

%Plasticity variables
Gus = 1.2e-6;       %Maximum conductance of unconditioned stimulus
Gcs = 0;            %Maximum conductance of conditioned stimulus
deltaTltp = 0;      %Not so much a delta as just keeping track of the last post-synaptic spike
deltaTltd = 0;      %Not so much a delta as just keeping track of the last pre-synaptic spike

%Conditioned stimulus
t1IntroCs = .090;
trial1CS = zeros(1,length(trialTime)-1);
trial1CS(floor(t1IntroCs/dT)) = 1;

t2IntroCs = .110;
trial2CS = zeros(1,length(trialTime)-1);
trial2CS(floor(t2IntroCs/dT)) = 1;

CStime = [trial1CS trial1CS trial1CS trial1CS trial1CS...
    trial1CS trial1CS trial2CS trial2CS trial2CS...
    trial2CS trial2CS trial2CS trial2CS 0];

%Unconditioned stimulus
t1IntroUs = .100;
trial1US = zeros(1,length(trialTime)-1);
trial1US(floor(t1IntroUs/dT)) = 1;


UStime = [trial1US trial1US trial1US trial1US trial1US...
    zeros(1,length(trialTime)) zeros(1,length(trialTime)-1) trial1US trial1US trial1US...
    trial1US trial1US zeros(1,length(trialTime)-1) zeros(1,length(trialTime)-1)];

trialCounter = 1;
trialCounter2 = 1;
postFirst = 0;
preFirst = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Simulation%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Trial Number 1');
for i = 2: length(time),
    
    %New trial
    if(trialCounter*dT == .2),
        trialCounter2 = trialCounter2 + 1;
        disp(['Trial Number: ' num2str(trialCounter2)]);
        preFirst = 0; %There hasn't been a pre-synaptic spike yet
        postFirst = 0; %There hasn't been a post-synaptic spike yet
        trialCounter = 0; %Reset the counter
        S1(i-1) = 0;    %reset the unconditioned synaptic gating variable
        S2(i-1) = 0;    %reset the conditioned synaptic gating variable
        V(i-1) = El;    %reset the membrane potential
    end
    
    %calculate potential
    part1 = -Gl*(V(i-1)-El);
    part2 = (V(i-1)-Vex)*(Gus*S1(i-1)+Gcs*S2(i-1));
    %disp(Gcs);
    V(i) = V(i-1) + dT*(-Gl*(V(i-1)-El)-(V(i-1)-Vex)*(Gus*S1(i-1)+Gcs*S2(i-1)))/Cm;
    
    S1(i) = S1(i-1)+dT*(-S1(i-1))/taus;
    S2(i) = S2(i-1)+dT*(-S2(i-1))/taus;
    
    %when post-synaptic spike
    if(V(i)>=Vth),
        V(i) = Vreset; %first reset potential
        if(preFirst),   %if there was a conditioned spike
            Gcs = min(Gcsmax,Gcs+Altp*exp(-((time(i)-deltaTltp)*dT)/taultp)); %update Gcs based on the deltaTltp
            disp(['Time: ' num2str(time(i)) '     Increasing GCS: ' num2str(Gcs)]);
        else %else, post is spiking first
            deltaTltd = time(i);    %set the deltaTltd
            postFirst = 1;          %communicate this is a post-synaptic spike first for LTD
        end
    end
    
    %If the conditioned stimulus is being applied
    if(CStime(i)),
        S2(i) = S2(i) + 1; %update the gating variable
        if(postFirst), %if there was already a postsynaptic spike the do LTD
            Gcs = max(Gcsmin, Gcs-Altd*exp(-((time(i)-deltaTltd)*dT)/taultd)); %update for LTD
            disp(['Time: ' num2str(time(i)) '     Decreasing GCS: ' num2str(Gcs)]);
        else %else this pre is spiking first
            preFirst = 1;    %communicate this is a pre-synaptic spike first for LTP
            deltaTltp = time(i); %set the deltaTltd
        end
    end
    
    %update
    if(UStime(i)),
        S1(i) = S1(i) + 1;
    end
    
    %update trialCounter
    trialCounter = trialCounter + 1;
end


%%%%%%%%%%%%%%%%%%%%Plotting%%%%%%%%%%%%%%%%%%%%%%%
figure(1);

subplot(3,1,1);
plot(time,V);
title('Membrane Potential of Post-synaptic Neuron');
xlabel('Time (sec)');
ylabel('Voltage (V)');

subplot(3,1,2);
plot(time,CStime);
title('Time of Presentation of Condictioned Stimulus');
xlabel('Time (sec)');


subplot(3,1,3);
plot(time,UStime);
title('Time of Presentation of Uncondictioned Stimulus');
xlabel('Time (sec)');

