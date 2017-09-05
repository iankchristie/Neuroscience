% recurrent.m
% Discrete short-term memory rate-model code

dt = 0.005;
tmax = 5.0;
t = 0:dt:tmax;      % Time vector

Ncells = 1;         % Number of neurons in code

Wrecurrent = 19.0;  % Strength of connection from one group to itself
Wasym = 1;          % Strength of connection from one group to another

rmax0 = 200;        % Maximum firing rate
Ith0 = 5;           % Current needed for half-maximal firing
Iwidth0 = 1;        % ow far from threshold you need to be for rate to change

taus = 0.050;       % Time constant for synapse
taud = 0.1;        % Time constant for depression
taum = 0.010;       % Time constant for change in firing rate

Iapp0 = 2;          % Applied current 
Istart = 2.0;       % Time to start applied current
Iend = 3.0;         % Time to finish appplied current

p0 = 0.25;           % Base release probability of vesicles
sfrac = 1.0;        % Maximum proportion of receptors activated by a vesicle release

r = zeros(Ncells,length(t));    % Firing rate for each cell at all time points
D = zeros(Ncells,length(t));    % Depression variable for each cell at all time points
S = zeros(Ncells,length(t));    % Synaptic gating variable for each cell at all time points
Iapp = zeros(Ncells,length(t)); % Applied current for each cell at all time points

imin = min(round(Istart/dt)+1,length(t));   % Index of time for applied current
imax = min(round(Iend/dt)+1,length(t));     % Index of time to end applied current

for i = imin:imax
    for cell = 1:Ncells             % Note in this code there is only one cell
        Iapp(cell,i) = Iapp0;       % Give the applied current between imin and imax
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
    D(cell,1) = 0.5;
    S(cell,1) = 0.0;
end

for i = 2:length(t)                                 % Now integrate through time
        
    I = S(:,i-1)*W+Iapp(:,i);                       % I depends on feedback (S*W) and applied current
                              % S(:,i-1) is the vector of synaptic gating
                              % from the previous time step for all cells
                              % This gets multiplied by the weight matrix
                              % to give total feedback current.
                                                    
    rinf = rmax./(1.+exp(-(I-Ith)/Iwidth));         % Firing rate curve gives the steady state r
    r(:,i) = rinf + (r(:,i-1)-rinf)*exp(-dt/taum);  % Update r from the previous timestep
    
    Dinf = 1./(1.+p0*r(:,i)*taud);                  % Steady state value of D for Poisson spiking
    D(:,i) = Dinf + ( D(:,i-1)-Dinf).*exp(-dt*(p0*r(:,i)+1/taud));  % Update with adjusted time constant
    
    Sinf = sfrac*p0*r(:,i).*D(:,i)*taus./(1.0+sfrac*p0*r(:,i).*D(:,i)*taus); % Steady state value of 
                              % synaptic gating vatiable assuming vesicle
                              % release at a rate p0*r*D
    S(:,i) = Sinf + ( S(:,i-1)-Sinf).*exp(-dt*(sfrac*p0*r(:,i)*D(:,i)+1/taus)); % update S with adjusted tau

end % continue to next time step


for cell = 1:Ncells 
    subplot(3,Ncells,cell)
    plot(t,r(cell,:))               % Plot rate of the cell as a function of time
    ylabel('Firing Rate (Hz)')
    subplot(3,Ncells,Ncells+cell)
    plot(t,D(cell,:))               % Plot depression variable as a function of time
    ylabel('Depression variable, D')
    subplot(3,Ncells,2*Ncells+cell)
    plot(t,S(cell,:))               % Plot synaptic gating as a function of time
    ylabel('Synaptic gating, S')
    xlabel('Time, sec')
end
