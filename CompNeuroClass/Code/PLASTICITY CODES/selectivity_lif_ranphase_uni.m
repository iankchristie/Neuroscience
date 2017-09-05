% selectivity_lif_ranphase.m 
% Models synaptic cometition between random inputs, to produce a selective
% response. 
% The inputs generate synaptic current in a leaky-integrate-and-fire cell
% which fires spikes. 
% Synaptic strengths between inputs and the postsynaptic LIF neuron 
% are updated according to a rule for spike-timing dependent plasticity.
% In this version the potentiation rule is scaled to reduce potentiation as
% synaptic strength increases.

clear
   
figure(1)
clf

Ninputs = 100; % Total number of input cells
Ntrials = 250;          % number of runs with plasticity between each run

tmax = 10;              % time for a run
dt = 0.001;             % timestep for integration
t = 0:dt:tmax;          % time vector

period = 5;             % period of sinusoid input
offset = rand(1,Ninputs);% random phase difference between all cells
tausyn = 0.005;         % synaptic timeconstant
itau = ceil(tausyn/dt); % number of timesteps in tau

taustdpp = 0.010;       % time window of 2 spikes for potentiation 
taustdpm = 0.025;       % time window of 2 spikes for depression
depress_bias = 0.01;    % fraction of greater depression than potentiation

Iapp = zeros(Ninputs,length(t));  % applied current as function of time for each of two groups
Iapp0 = 10;                 % maximum applied current
W0 = 0.5e-9;                % initial average synaptic strengths
W = W0*(ones(Ninputs,1) +0.05*randn(Ninputs,1))/Ninputs;    % set of synaptic strengths with random variation
dW = 0.01;              % maximum fractional change in strength for each pairing
Wmax = 2.0*W0/Ninputs;  % maximum allowed synaptic strength
W = min(W,Wmax);        % ensure W is no higher than Wmax
W = max(W,0);           % an no lower than zero

Vth = -0.055;           % threshold voltage
Vl = -0.070;            % leak voltage
Vreset = -0.080;        % reset voltage
cm = 1e-8;              % specific membrane capacitance
gL = 0.5e-6;              % specific leak conductance
taum = cm/gL            % membrane time constant
noise_sigma = 2e-7*sqrt(dt);

for i = 1:Ninputs
    Iapp(i,:) = Iapp0*(1+cos(2*pi*(t/period+offset(i))));
end

for trial = 1:Ntrials   % begin trials
    
    spikesin = zeros(Ninputs,length(t));    % series of spikes for each input
    spikesout = zeros(size(t));             % series of spikes generated by LIF neuron
    Itot = noise_sigma*randn(size(t));      % input current to LIF neuron initialized with noise
    
    spikesin = Iapp*dt > rand(Ninputs,length(t));
    
    for i = 1:Ninputs                    % first group of inputs
        for j = find(spikesin(i,:))
            
            kmax = min(j+5*itau,length(t));     % how long to add current
            for k = j+1:kmax                    % from the spike
                Itot(k) = Itot(k) + ...         % add current from input i
                    W(i)*exp(-dt*(k-j)/tausyn)/tausyn;
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
        %% The next line is altered so that the amount you can increase depends on the current value
        W(cell2) = W(cell2) + dwsum*2*(Wmax-W(cell2)); % now change the synaptic strength of that cell
    end
    
    input1 = mean(W(1:Ninputs/2))           % input1 is average of weights from group 1
    input2 = mean(W(Ninputs/2+1:Ninputs))   % input 2 is average of weights form group 2
    scale = sum(W)/W0;                       % scale is total weight divided by goal weight
    W = W/scale;                            % scale all W to keep the sum at the goal
    W = min(W,Wmax);                        % now ensure no W is above maximum allowed
    W = max(W,0);                           % and no W is less than zero

    figure(2)
    plot(W,'o')                         % plot the set of wights in Fig.2
    axis([0 Ninputs 0 Wmax])
    
    trial

end