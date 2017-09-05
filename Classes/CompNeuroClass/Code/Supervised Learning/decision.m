% decision.m
% Rate-model code for decisions between 
% two discrete inputs.
clear 
Ntrials = 10;

dt = 0.005;
tmax = 5.0;
t = 0:dt:tmax;      % Time vector

Ncells = 2;         % Number of neurons in code

Wrecurrent = 40.0;  % Strength of connection from one group to itself
Wasym = -10;          % Strength of connection from one group to another
deltaW0 = 1.5e-7;

rmax0 = 100;        % Maximum firing rate
Ith0 = 3;           % Current needed for half-maximal firing
Iwidth0 = 1;        % ow far from threshold you need to be for rate to change

taus = 0.050;       % Time constant for synapse
taud = 0.10;        % Time constant for depression
taum = 0.010;       % Time constant for change in firing rate
taustdp = 0.02;
dW = 0.02;                          % maximum fractional change in weight per spike pair

Iapp0 = 0.4;          % Applied current
Idiff = 0.01;        % Difference across cells in applied current
Istart = 2.0;       % Time to start applied current
Iend = 4.0;         % Time to finish appplied current

p0 = 0.1;           % Base release probability of vesicles
sfrac = 0.5;        % Maximum proportion of receptors activated by a vesicle release


Iapp = zeros(Ncells,length(t)); % Applied current for each cell at all time points

imin = min(round(Istart/dt)+1,length(t));   % Index of time for applied current
imax = min(round(Iend/dt)+1,length(t));     % Index of time to end applied current


W = zeros(Ncells,Ncells);           % W is the weight matrix: strength of connections
for cell1 = 1:Ncells                
    for cell2 = 1:Ncells
        W(cell1,cell2) = Wasym;     % Set all connections to Wasym
    end
    W(cell1,cell1) = Wrecurrent;    % This is the strength of self-connections and replaces the other value 
end


for k = 1: Ntrials,
    r = zeros(Ncells,length(t));    % Firing rate for each cell at all time points
    D = zeros(Ncells,length(t));    % Depression variable for each cell at all time points
    S = zeros(Ncells,length(t));    % Synaptic gating variable for each cell at all time points
    spikes = zeros(Ncells,length(t));    % and initialize to no spikes yet

    if(k == Ntrials),
        disp(['Chaning Idiff from ' num2str(Idiff)]);
        Idiff = -Idiff;
        disp(['to ' num2str(Idiff)]);
    end
    
    for i = imin:imax
        for cell = 1:Ncells            
            Iapp(cell,i) = Iapp0 ... 
                + Idiff*(cell-1)/Ncells;       % Give the applied current between imin and imax
        end
    end
    
    rmax = rmax0*ones(Ncells,1);        % These lines give all cells the same firing rate curves
    Ith = Ith0*ones(Ncells,1);
    Iwidth = Iwidth0*ones(Ncells,1);

    for i = 2:length(t)                                 % Now integrate through time

        I = W*S(:,i-1)+Iapp(:,i);                       % I depends on feedback (S*W) and applied current
                                  % S(:,i-1) is the vector of synaptic gating
                                  % from the previous time step for all cells
                                  % This gets multiplied by the weight matrix
                                  % to give total feedback current.

        rinf = rmax./(1.+exp(-(I-Ith)./Iwidth));         % Firing rate curve gives the steady state r
        r(:,i) = rinf + (r(:,i-1)-rinf)*exp(-dt/taum);  % Update r from the previous timestep

        Dinf = 1./(1.+p0*r(:,i)*taud);                  % Steady state value of D for Poisson spiking
        D(:,i) = Dinf + ( D(:,i-1)-Dinf).*exp(-dt*(p0*r(:,i)+1/taud));  % Update with adjusted time constant

        Sinf = sfrac*p0*r(:,i).*D(:,i)*taus./(1.0+sfrac*p0*r(:,i).*D(:,i)*taus); % Steady state value of 
                                  % synaptic gating vatiable assuming vesicle
                                  % release at a rate p0*r*D
        S(:,i) = Sinf + ( S(:,i-1)-Sinf).*exp(-dt*(sfrac*p0*r(:,i).*D(:,i)+1/taus)); % update S with adjusted tau
        
        for  cell = 1:Ncells             % for each cell
           if r(cell,i)*dt > rand(1)   % Poisson spike generation
               spikes(cell,i) = 1;     % note when it generates a spike
           end
       end

    end % continue to next time step
    
    % Now do the STDP rule
   for cell1 = 1:Ncells;                % for each cell

       s1 = find(spikes(cell1,:));      % find the spike times for the cell
       N1 = length(s1);                  % N1 is number of spikes
       for cell2 = 1:Ncells;            % for every partner cell
           dwsum = 0.0;                   % always initialize a sum to zero
           if cell1 ~= cell2                % if cell1 is NOT cell2
               s2 = find(spikes(cell2,:));  % find partner cells spikes
               N2 = length(s2);              % number of spikes in partner cell
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
               W(cell1,cell2) = W(cell1,cell2) + deltaW0*dwsum;
               W(cell2,cell1) = W(cell2,cell1) - deltaW0*dwsum;
           end
       end
   end
   W
    figure;
    for cell = 1:Ncells 
        subplot(3,Ncells,cell)
        plot(t,r(cell,:))               % Plot rate of the cell as a function of time
        hold on
        plot(t,10*spikes(cell,:),'r')    % plot the spiketrain
        hold on
        plot(t,100*Iapp(cell,:), 'b')
        ylabel('Rate, Hz')
        axis([0 tmax 0 rmax0])
        subplot(3,Ncells,Ncells+cell)
        plot(t,D(cell,:))               % Plot depression variable as a function of time
        ylabel('Depression variable, D')
        axis([0 tmax 0 1])
        subplot(3,Ncells,2*Ncells+cell)
        plot(t,S(cell,:))               % Plot synaptic gating as a function of time
        xlabel('Time, sec')
        ylabel('Synaptic gating, S')
        axis([0 tmax 0 1.05*max(max(S))])
    end
end