% dominancelif1.m 
% Models synaptic cometition between groups of inputs, 
% involved in the formation of ocular dominance stripes.
% The inputs are grouped into two, with each group having 
% an average rate that covaries together but is out of 
% phase with the other group.
% The inputs generate synaptic current in a leaky-integrate-and-fire cell
% which fires spikes. 
% Synaptic strengths between inputs and the postsynaptic LIF neuron 
% are updated according to a rule for spike-timing dependent plasticity.

clear
   
figure(1)
clf

Ninputs = 30;           % total number of input cells
Ntrials = 100;          % number of runs with plasticity between each run

tmax = 10;              % time for a run
dt = 0.001;             % timestep for integration
t = 0:dt:tmax;          % time vector

period = 5;             % period of sinusoid input
offset = 0.5;           % fraction of a cycle out of phase of the two eyes
tausyn = 0.005;         % synaptic timeconstant
itau = ceil(tausyn/dt); % number of timesteps in tau

taustdpp = 0.010;       % time window of 2 spikes for potentiation 
taustdpm = 0.025;       % time window of 2 spikes for depression
depress_bias = 0.01;    % fraction of greater depression than potentiation

Iapp = zeros(length(t),2);  % applied current as function of time for each of two groups
Iapp0 = 20;                 % maximum applied current
W0 = 0.6e-9;                % initial average synaptic strengths
W = W0*(ones(Ninputs,1) +0.05*randn(Ninputs,1))/Ninputs;    % set of synaptic strengths with random variation
dW = 0.01;              % maximum fractional change in strength for each pairing
Wmax = 4.0*W0/Ninputs;  % maximum allowed synaptic strength
W = min(W,Wmax);        % ensure W is no higher than Wmax
W = max(W,0);           % an no lower than zero

Vth = -0.055;           % threshold voltage
Vl = -0.070;            % leak voltage
Vreset = -0.080;        % reset voltage
cm = 1e-8;              % specific membrane capacitance
gL = 1e-6;              % specific leak conductance
taum = cm/gL            % membrane time constant

for trial = 1:Ntrials   % begin trials
    
    Iapp(:,1) = Iapp0*(1+cos(2*pi*t/period));   % applied current for group 1

    if mod(trial,2) == 0                        % on even trials oscillations for group 2 
        Iapp(:,2) = Iapp0*(1+cos(2*pi*(t/period-offset))); % follow those of group 1
    else                                                    % and in odd trials 
        Iapp(:,2) = Iapp0*(1+cos(2*pi*(t/period+offset)));  % group 2 leads group 1
    end
    
    spikesin = zeros(Ninputs,length(t));    % series of spikes for each input
    spikesout = zeros(size(t));             % series of spikes generated by LIF neuron
    Itot = zeros(size(t));                  % input current to LIF neuron
    
    for i = 1:Ninputs/2                     % first group of inputs
        for j = 1:length(t)                 
            if Iapp(j,1)*dt > rand(1)       % random Poisson process at rate Iapp
                spikesin(i,j) = 1;          % to generate spikes at inputs
                
                kmax = min(j+5*itau,length(t));     % how long to add current
                for k = j+1:kmax                    % from the spike
                    Itot(k) = Itot(k) + ...         % add current from input i 
                            W(i)*exp(-dt*(k-j)/tausyn)/tausyn;
                end
            end
        end
    end
    
    for i = Ninputs/2+1:Ninputs             % second group of inputs
        for j = 1:length(t) 
            if Iapp(j,2)*dt > rand(1)       % spike according to a different rate
                spikesin(i,j) = 1;          % still Poisson
                
                kmax = min(j+5*itau,length(t));     % how long to add current
                for k = j+1:kmax                    % from the spike
                    Itot(k) = Itot(k) + ...         % add current from input i
                        W(i)*exp(-dt*(k-j)/tausyn)/tausyn;
                end
            end
        end
    end
  
    % Completed generation of set of input current from input spike trains
    % Now see how the LIF neuron responds to these inputs
    
    V = zeros(size(t));     % membrane potential of LIF neuron
    V(1) = Vl;              % initialize at leakage potential
    
    for i = 2:length(t)     % integrate through time

        Vinf = Vl + Itot(i-1)/gL;           % calculate steady state voltage
        V(i) = Vinf + (V(i-1)-Vinf)*exp(-dt/taum);  % and integrate towards it

        if V(i) >= Vth                  % if voltage passes threshold
            spikesout(i) = 1;           % generate spike in LIF neuron
            V(i) = Vreset;              % and reset the membrane potential
        end
    end
      
    figure(1)                       
    plot(t,V);              % plot membrane potential as function of time
    drawnow
    s1 = find(spikesout);   % series of spike times of LIF cell 
    N1 = length(s1)         % total number of LIF spikes
    for cell2 = 1:Ninputs;  % for each input
        dwsum = 0.0;        % initialize change in weight as zero
        
        s2 = find(spikesin(cell2,:));   % series of spike times for input cell
        N2 = length(s2);                % number of input spikes from that cell
        
        for i = 1:N1                    % i runs through LIF spikes
            for j = 1:N2                % j runs through input cell spikes
                deltat = dt*(s1(i)-s2(j)); % difference in spike times
                if (deltat > 0 )        % if pre before post
                    dwsum = dwsum + exp(-deltat/taustdpp); % do LTP with decay window
                end
                if ( deltat < 0 )       % if post before pre 
                    dwsum = dwsum - (1+depress_bias)* ... % reduce synaptic weight
                        exp(deltat/taustdpm)*taustdpp/taustdpm; % note amplitude 
                end
            end
        end
        dwsum = dwsum*dW;               % dW is fixed maximal weight change per pair
        dwsum = min(dwsum,0.5);         % allow no more than 50% increase in weight per trial
        dwsum = max(dwsum,-0.5);        % allow no more than 50% decrease in weight per trial
        W(cell2) = W(cell2) + dwsum*Wmax; % now change the synaptic strength of that cell
    end
    
    input1 = mean(W(1:Ninputs/2))           % input1 is average of weights from group 1
    input2 = mean(W(Ninputs/2+1:Ninputs))   % input 2 is average of weights form group 2
    scale = sum(W)/W0                       % scale is total weight divided by goal weight
    W = W/scale;                            % scale all W to keep the sum at the goal
    W = min(W,Wmax);                        % now ensure no W is above maximum allowed
    W = max(W,0);                           % and no W is less than zero

    figure(2)
    plot(W,'o')                         % plot the set of wights in Fig.2
    

end