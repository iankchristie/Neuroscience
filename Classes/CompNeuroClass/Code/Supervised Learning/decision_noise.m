% recurrent.m
% Discrete short-term memory rate-model code

dt = 0.005;
tmax = 5.0;
t = 0:dt:tmax;      % Time vector

Ncells = 2;         % Number of neurons in code

Wrecurrent = 40.0;  % Strength of connection from one group to itself
Wasym = -10;          % Strength of connection from one group to another

rmax0 = 100;        % Maximum firing rate
Ith0 = 3;           % Current needed for half-maximal firing
Iwidth0 = 1;        % ow far from threshold you need to be for rate to change

taus = 0.050;       % Time constant for synapse
taud = 0.10;        % Time constant for depression
taum = 0.010;       % Time constant for change in firing rate

Iapp0 = 0.4;          % Applied current
Idiff = 0.1;        % Difference across cells in applied current
Istart = 2.0;       % Time to start applied current
Iend = 4.0;         % Time to finish appplied current

sigma = 0.02;          % Standard deviation of noise in current to each neuron

p0 = 0.1;           % Base release probability of vesicles
sfrac = 0.5;        % Maximum proportion of receptors activated by a vesicle release

r = zeros(Ncells,length(t));    % Firing rate for each cell at all time points
D = zeros(Ncells,length(t));    % Depression variable for each cell at all time points
S = zeros(Ncells,length(t));    % Synaptic gating variable for each cell at all time points
Iapp = zeros(Ncells,length(t)); % Applied current for each cell at all time points

imin = min(round(Istart/dt)+1,length(t));   % Index of time for applied current
imax = min(round(Iend/dt)+1,length(t));     % Index of time to end applied current

for i = imin:imax
    for cell = 1:Ncells             % Note in this code there is only one cell
        Iapp(cell,i) = Iapp0 ... 
            + Idiff*(cell-1)/Ncells;       % Give the applied current between imin and imax
    end
end

W = zeros(Ncells,Ncells);           % W is the weight matrix: strength of connections
for cell1 = 1:Ncells                % Recall only one cell here, so W(1,1) is all that is used
    for cell2 = 1:Ncells
        W(cell1,cell2) = Wasym;     % Set all connections to Wasym
    end
    W(cell1,cell1) = Wrecurrent;    % This is the strength of self-connections and replaces the other value 
end

rmax = rmax0*ones(Ncells,1);        % These lines give all cells the same firing rate curves
Ith = Ith0*ones(Ncells,1);
Iwidth = Iwidth0*ones(Ncells,1);

for cell = 1: Ncells                % Set the initial conditions for each cell the same
    r(cell,1) = 0.0;
    D(cell,1) = 1.0;
    S(cell,1) = 0.0;
end

for i = 2:length(t)                                 % Now integrate through time
        
    I = W*S(:,i-1)+Iapp(:,i) ...
        + randn(Ncells,1)*sigma/sqrt(dt);             % I depends on feedback (S*W) and applied current
                              % S(:,i-1) is the vector of synaptic gating
                              % from the previous time step for all cells
                              % This gets multiplied by the weight matrix
                              % to give total feedback current.
                                                    
    rinf = rmax./(1.+exp(-(I-Ith)./Iwidth)); % Firing rate curve gives the steady state r
    r(:,i) = rinf + (r(:,i-1)-rinf)*exp(-dt/taum);  % Update r from the previous timestep
    
    Dinf = 1./(1.+p0*r(:,i)*taud);                  % Steady state value of D for Poisson spiking
    D(:,i) = Dinf + ( D(:,i-1)-Dinf).*exp(-dt*(p0*r(:,i)+1/taud));  % Update with adjusted time constant
    
    Sinf = sfrac*p0*r(:,i).*D(:,i)*taus./(1.0+sfrac*p0*r(:,i).*D(:,i)*taus); % Steady state value of 
                              % synaptic gating vatiable assuming vesicle
                              % release at a rate p0*r*D
    S(:,i) = Sinf + ( S(:,i-1)-Sinf).*exp(-dt*(sfrac*p0*r(:,i).*D(:,i)+1/taus)); % update S with adjusted tau

end % continue to next time step


for cell = 1:Ncells 
    subplot(3,Ncells,cell)
    plot(t,r(cell,:))               % Plot rate of the cell as a function of time
    ylabel('rate, Hz')
    axis([0 tmax 0 rmax0])

    subplot(3,Ncells,Ncells+cell)
    plot(t,D(cell,:))       % Plot depression variable as a function of time
    ylabel('Depression variable, D')
    subplot(3,Ncells,2*Ncells+cell)
    plot(t,S(cell,:))               % Plot synaptic gating as a function of time
    ylabel('Synaptic gating variable, S')
    xlabel('Time, sec')
end
