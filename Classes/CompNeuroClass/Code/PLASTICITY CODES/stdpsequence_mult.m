% stdpsequence_multi.m
% couples several cells together in a sequence, 
% assuming they are place cells with overlapping place 
% fields in a repeated run
clear
dt = 0.001;                         % timestep
tmax = 5;                           % maximum time
Nt = floor(tmax/dt);                % number of time points
Ntrials = 101;                      % number of runs
Ncells = 3;                         % number of neurons

t = 0:dt:tmax;                      % time vector, t
tau = 0.01;                         % time constant for firing rate model
taustdp = 0.05;

W0 = 0.1;                           % initial synaptic weights
dW = 0.02;                          % maximum fractional change in weight per spike pair
W = W0*ones(Ncells);                % initalize as a matrix of all equal weights

Iapp = zeros(length(t),Ncells);     % applied current to each cell
Iapp0 = 20;                         % level of peak input

Ith0 = 0.0;                         % firing threshold for each cell
Ith = Ith0*ones(1,Ncells);          % set equal to Ith0 for every cell


sigma = Nt/(5*Ncells);              % spread in time of Gaussian inputs
centers = zeros(Ncells);            % center(i) is center of input for each cell
for i = 1:Ncells                                            % center(i) is equally 
    center(i) = floor((Nt/(2*Ncells))*(Ncells/4+i-0.25))    % spaced across times
    for j = 1:length(t)                     % j runs through all time points
        dj = (j-center(i))/sigma;           % dj is no. of S.D.s from center of input
        Iapp(j,i) = Iapp0*exp(-0.5*dj*dj);  % input varies as a Gaussian in time
    end
end

for trial = 1:Ntrials                   % inputs do not change across a series of trials
   r = zeros(length(t),Ncells);         % initialize rates of all cells to zero
   spikes = zeros(length(t),Ncells);    % and initialize to no spikes yet

   
   for it = 2:length(t)                         % integrate through time
       Itot = Iapp(it,:) + r(it-1,:)*W;   % vector of total current is applied + feedback
       rinf = max(Itot-Ith,0);          % firing rate is threshold-linear in applied current
       r(it,:) = rinf + (r(it-1,:)-rinf)*exp(-dt/tau); % update firing rate of all cells
       
       for  cell = 1:Ncells             % for each cell
           if r(it,cell)*dt > rand(1)   % Poisson spike generation
               spikes(it,cell) = 1;     % note when it generates a spike
           end
       end
   end

   if mod(trial-1,25) == 0              % every 25 trials
       figure(1);
       imagesc(W);                  % plot the connectivity matrix
       xlabel('Postsynaptic cell');
       ylabel('Presynaptic cell');
       colorbar
       figure()
       for cell = 1:Ncells              % for each cell

           subplot(Ncells,1,cell)   
           plot(t,10*spikes(:,cell),'r')    % plot the spiketrain
           hold on
           plot(t,r(:,cell))            % plot its firing rate
           xlabel('Time (sec)');
           ylabel('Firing rate (Hz)');

       end
       figure(1);
   end
   
   % Now do the STDP rule
   for cell1 = 1:Ncells;                % for each cell

       s1 = find(spikes(:,cell1));      % find the spike times for the cell
       N1 = length(s1)                  % N1 is number of spikes
       for cell2 = 1:Ncells;            % for every partner cell
           dwsum = 0.0;                   % always initialize a sum to zero

           if cell1 ~= cell2                % if cell1 is NOT cell2
               s2 = find(spikes(:,cell2));  % find partner cells spikes
               N2 = length(s2)              % number of spikes in partner cell
               for i = 1:N1                 % for all cell1 spikes
                   for j = 1:N2             % and all cell2 spikes
                       deltat = dt*(s2(j)-s1(i));   % difference in spike times
                       if (deltat > 0 )     % if pre before post
                           dwsum = dwsum + exp(-deltat/taustdp); % increase weight
                       end
                       if ( deltat < 0 )    % if post before pre
                           dwsum = dwsum - exp(deltat/taustdp); % decrease weight
                       end
                   end
               end
               dwsum = dwsum*dW;            % multiply by maximal weight change per pair
               dwsum = min(dwsum,0.5)       % don't allow more than a 50% increase per run
               dwsum = max(dwsum,-0.5)      % or a 50% decrease per run
               W(cell1,cell2) = W(cell1,cell2)*(1.0 + dwsum) % update synaptic strength 

           end
       end
   end
   
end

