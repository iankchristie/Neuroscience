% decision_simple.m
% Binary decision-making rate-model code

clear
Ntrials = 10;

dt = 0.0002;       % A small dt is needed for the simple method of Poisson spike generation from high rates.
tmax = 5.0;
t = 0:dt:tmax;      % Time vector

Ncells = 2;         % Number of neurons in code

Wrecurrent = 0.025;  % Strength of connection from one group to itself
Wasym = -0.02;          % Strength of connection from one group to another
deltaW0 = 1.5e-7;

rmax0 = 1000;        % Maximum firing rate
Ith0 = 8;           % Current needed for half-maximal firing
Iwidth0 = 3;        % ow far from threshold you need to be for rate to change

taum = 0.010;       % Time constant for change in firing rate
taustdp = 0.02;     % time constant for plasticity

Iapp0 = 0.2;          % Applied current
Idiff = 0.02;        % Difference across cells in applied current
Istart = 2.0;       % Time to start applied current
Iend = 4.0;         % Time to finish appplied current

homeostatic_plasticity = 1;
plastic_constant = 2*Wasym;

W = zeros(Ncells,Ncells);           % W is the weight matrix: strength of connections
for cell1 = 1:Ncells
    for cell2 = 1:Ncells
        W(cell1,cell2) = Wasym;     % Set all connections to Wasym
    end
    W(cell1,cell1) = Wrecurrent;    % This is the strength of self-connections and replaces the other value
end

for k = 1: Ntrials,
    if(k == Ntrials),
        disp(['Chaning Idiff from ' num2str(Idiff)]);
        Idiff = -Idiff;
    end
    disp(['Idiff ' num2str(Idiff)]);
    
    r = zeros(length(t),Ncells);    % Firing rate for each cell at all time points
    Iapp = zeros(length(t),Ncells); % Applied current for each cell at all time points
    spikes = zeros(length(t),Ncells);    % and initialize to no spikes yet

    imin = min(round(Istart/dt)+1,length(t));   % Index of time for applied current
    imax = min(round(Iend/dt)+1,length(t));     % Index of time to end applied current

    for i = imin:imax
        for cell = 1:Ncells
            Iapp(i,cell) = Iapp0 ...
                + Idiff*(cell-1)/Ncells;       % Give the applied current between imin and imax
        end
    end
    
    rmax = rmax0*ones(1,Ncells);        % These lines give all cells the same firing rate curves
    Ith = Ith0*ones(1,Ncells);
    Iwidth = Iwidth0*ones(1,Ncells);

    r(1,:) = 0.0;              % Set the initial conditions for each cell the same

    for i = 2:length(t)                                 % Now integrate through time

        I = r(i-1,:)*W+Iapp(i,:);                       % I depends on feedback (S*W) and applied current

        rinf = rmax./(1.+exp(-(I-Ith)./Iwidth));        % Firing rate curve gives the steady state r
        r(i,:) = rinf + (r(i-1,:)-rinf)*exp(-dt/taum);  % Update r from the previous timestep

        for  cell = 1:Ncells           % for each cell
           if r(i,cell)*dt > rand(1)   % Poisson spike generation
               spikes(i,cell) = 1;     % note when it generates a spike
           end
       end
        
    end % continue to next time step
    
        % Now do the STDP rule
   for cell1 = 1:Ncells;                % for each cell

       s1 = find(spikes(:,cell1));      % find the spike times for the cell
       N1 = length(s1);                  % N1 is number of spikes
       for cell2 = 1:Ncells;            % for every partner cell
           dwsum = 0.0;                   % always initialize a sum to zero
           if cell1 ~= cell2                % if cell1 is NOT cell2
               s2 = find(spikes(:,cell2));  % find partner cells spikes
               N2 = length(s2);              % number of spikes in partner cell
               for i = 1:N1                 % for all cell1 spikes
                   for j = 1:N2             % and all cell2 spikes
                       deltat = dt*(s2(j)-s1(i));   % difference in spike times
                       if (deltat > 0 )     % if pre before post
                           W(cell1,cell2) = W(cell1,cell2) + deltaW0*exp(-deltat/taustdp);
                           W(cell2,cell1) = W(cell2,cell1) - deltaW0*exp(-deltat/taustdp);
                       end
                       if ( deltat < 0 )    % if post before pre
                           W(cell1,cell2) = W(cell1,cell2) - deltaW0*exp(deltat/taustdp);
                           W(cell2,cell1) = W(cell2,cell1) + deltaW0*exp(deltat/taustdp);
                       end
                   end
               end
           end
       end
   end
   
   if(homeostatic_plasticity)
       plastic_total = W(1,2)+W(2,1);
       W(1,2) = W(1,2)*(plastic_constant / plastic_total);
       W(2,1) = W(2,1)*(plastic_constant / plastic_total);
   end
W
    figure()
    for cell = 1:Ncells
        subplot(Ncells,1,cell)
        plot(t,r(:,cell))               % Plot rate of the cell as a function of time
        hold on
        plot(t,50*spikes(:,cell),'r')    % plot the spiketrain
        hold on
        plot(t,100*Iapp(:,cell), 'g')
        ylabel('rate, Hz')
        xlabel('Time, sec')
        axis([0 tmax 0 rmax0])
    end
end
