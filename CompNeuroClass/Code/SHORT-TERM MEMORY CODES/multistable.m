% multistable.m
% Rate-model code for a network with many stable states.

dt = 0.005;
tmax = 20.0;
t = 0:dt:tmax;      % Time vector

Ncells = 13;         % Number of neurons in code
rmax0 = 100;        % Maximum firing rate
Ith0 = 4;           % Current needed for half-maximal firing
Ithrange = 3;       % Range of thresholds across all cells
Iwidth0 = 0.5;        % How far from threshold you need to be for rate to change
taus = 0.050;       % Time constant for synapse
taud = 0.10;        % Time constant for depression
taum = 0.010;       % Time constant for change in firing rate
p0 = 0.1;           % Base release probability of vesicles
sfrac = 0.5;        % Maximum proportion of receptors activated by a vesicle release

Iapp0 = 0.7;          % Applied current
Idiff = 0.01;        % Difference across cells in applied current
Istart = 1.0;       % Time to start applied current
Iend = 5;         % Time to finish appplied current
imin = min(round(Istart/dt)+1,length(t));   % Index of time for applied current
imax = min(round(Iend/dt)+1,length(t));     % Index of time to end applied current

sigma = 0.1;       % standard deviation of noise in current
r = zeros(Ncells,length(t));    % Firing rate for each cell at all time points
D = zeros(Ncells,length(t));    % Depression variable for each cell at all time points
S = zeros(Ncells,length(t));    % Synaptic gating variable for each cell at all time points
Iapp = zeros(Ncells,length(t)); % Applied current for each cell at all time points

for i = imin:imax
    for cell = 1:Ncells             % Note in this code there are 13 cells
        Iapp(cell,i) = Iapp0;
      
      %      + Idiff*(cell-1)/Ncells;       % Give the applied current between imin and imax
    end
end
Iapp(Ncells) = 0.0;

W = zeros(Ncells,Ncells);           % W is the weight matrix: strength of connections
Wrecurrent = 65.0;  % Strength of connection from one group to itself
Wasym = 1.75;          % Strength of connection from one group to another
for cell1 = 1:Ncells                
    for cell2 = 1:Ncells
        W(cell1,cell2) = Wasym;     % Set all connections to Wasym
    end
    W(cell1,cell1) = Wrecurrent;    % This is the strength of self-connections and replaces the other value 
end
for i = 1:Ncells
    W(Ncells,i) = 5.0;              % Connection strength to readout cell from other cells
end
W(Ncells,Ncells) = 0.0;             % Last cell is a readout cell and not bistable

rmax = rmax0*ones(Ncells,1);        % These lines give all cells the same firing rate curves
Ith = Ith0*ones(Ncells,1);
for i = 1:Ncells
    Ith(i) = Ith(i) +(i-1)*Ithrange/(Ncells-1); % Implements a range of thresholds
end
Iwidth = Iwidth0*ones(Ncells,1);
Ith(Ncells) = 4.0;                  % Readout cell has a different threshold
Iwidth(Ncells) = 2.0;               % Readout cell has a different steepness of slope

for cell = 1: Ncells                % Set the initial conditions for each cell the same
    r(cell,1) = 0.0;
    D(cell,1) = 1.0;
    S(cell,1) = 0.0;
end

for i = 2:length(t)                            % Now integrate through time
    I = W*S(:,i-1)+Iapp(:,i) ...        % I depends on feedback (S*W) and applied current
        + sigma*randn(1)/sqrt(dt);      % and additional noise
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
end % continue to next time step

subplot(2,2,1)
plot(t,r(1,:))               % Plot rate of the cell as a function of time
ylabel('Rate of first cell')
subplot(2,2,3)
plot(t,r(ceil(Ncells/2),:),'r')               % Plot depression variable as a function of time
ylabel('Rate of mid-cell')
subplot(2,2,2)
plot(t,r(Ncells,:),'g')               % Plot synaptic gating as a function of time
xlabel('Time, sec')
ylabel('Rate of last cell')
subplot(2,2,4)
imagesc(W)
colorbar
xlabel('Presynaptic Cell')
ylabel('Postsynaptic Cell')
title('Connectivity Matrix')