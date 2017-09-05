% manypoisson.m
% Multiple Poisson spike trains through synapses to see 
% how variable is the total synaptic conductance produced.
% The quantity produced, "syn" is known as the synaptic gating variable and
% corresponds to the fraction of channels open at a given synapse.

clear
Ncells = 100;           % No. of cells
tmax = 2.0;             % Max time of trial
dt=0.001;               % Time step
t=0:dt:tmax;            % Time vector

tausyn1 = 0.100;        % Synaptic time constant no.1
tausyn2 = 0.002;        % Synaptic time constant no.2
nsyn1 = 10*tausyn1/dt;  % No. of time steps to calculate synaptic current
nsyn2= 10*tausyn2/dt;
s0 = 0.5;               % Fraction of channels opened by single spike

rate0 = 30;             % Average presynaptic firing rate

spikes=zeros(Ncells,length(t));     % Each row is set of spike times for each presynaptic cell
syn = zeros(Ncells,length(t));      % Each row is synaptic "gating variable" for each synapse


for cell = 1: Ncells;   % Loop through presynaptic cells
   for i = 1:length(t)              % Loop through time
      if rand(1) < dt*rate0         % Poisson criterion for a spike
          spikes(cell,i) = 1;       % Record the spike for that cell
          synmax = s0*(1.0-syn(cell,i));        % Fraction of channels opened initially by the spike
          for j = i+1:min(length(t),i+nsyn2)    % Add contribution for later times (but not past tmax)    
              syn(cell,j) = syn(cell,j) + synmax*exp(-dt*(j-i)/tausyn2); % Exponential decay added
          end
      end
       
   end
    
end

% Here plot in 3 separate colors the synaptic gating variable from the
% first three synapses
figure()
plot(t,syn(1,:))               
xlabel('time (sec)')
ylabel('synaptic gating')
hold on

plot(t,syn(2,:),'r')
plot(t,syn(3,:),'g')

% Now plot the mean synaptic gating variable across all synapses
figure
plot(t,mean(syn))
xlabel('time (sec)')
ylabel('mean synaptic gating variable')

    
