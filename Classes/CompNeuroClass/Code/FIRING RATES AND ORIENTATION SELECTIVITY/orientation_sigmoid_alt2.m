clear

dt=0.001;                       % time step
tmax = 3;                       % maximum time: check rates are not changing by this time
t = 0:dt:tmax;                  % vector of time points
ton = 1.0;
toff = 2.0;

Ncells = 50;                    % total number of cells
dtheta = pi/Ncells;             % difference in preferred orientation from one cell to next
r=zeros(length(t),Ncells);      % rate matrix: all time points and all cells
r(1,:) = rand(1,Ncells)*10;     % make initial rate for each cell random from 0-10Hz

h=zeros(1,Ncells);              % this will be (thalamic) input current to cells
Itot=zeros(1,Ncells);           % total current to cells

A = 40.;                        % Maximum amplitude of thalamic input current
epsilon = 0.1;                  % How much the input moddulates with orientation
J0 = -0.5;                      % Mean inhibitory connection strength to all cells
J2 = 1.2;                         % Extra excitatory connection to similar cells
tau = 0.050;                    % Time constant for the rate to change (slow for NMDA synapses)

sigma_th = 1.0;

for cell1 = 1:Ncells;           % Postsynaptic cell
    for cell2 = 1:Ncells;       % Presynaptic cell
        W(cell2,cell1) = (J0+J2*cos(2*pi*(cell2-cell1)/Ncells))*dtheta;    % Connection from cell2 to cell1
    end
end
figure(4)
imagesc(W)

cuecell = 25;                   % Cell no. where thalamic input is peaked

Ith = 20+sigma_th*randn(1,Ncells);                       % Rough threshold of f-I curve of cells
Iwidth = 20;                    % Inverse gradient of f-I cure near threshold
rmax = 200;                     % Maximum rate of cells
Iin = -100:0.1:100;             % Plot a range of input currents
for cell = 1:Ncells
    rout(cell,:) = rmax./(1+exp(-(Iin-Ith(cell))/Iwidth)).^2;   % This is the firing rate curve used in the simulation
end
figure(2)                       % Figure to plot f-I curve
clf                             % Clear figure
plot(Iin,rout)                  % Plot f-I curve
xlabel('Input current')         % Label x-axis
ylabel('Firing rate')           % Label y-axis

figure(1)                        % Clear figures to be used later
clf
figure(3)
clf

c = 0.8;                        % base contrast
for cuecell = 0:floor(Ncells/5):Ncells              % Use different cue cells
    
    for cell = 1:Ncells;        % For each cell, its input current depends on how close is its 
                                % prefered orientation to the cue cell
        h(cell) = A*c*(1-epsilon + epsilon*cos(2*pi*(cell-cuecell)/Ncells));
                                % This is the formula in notes + HW
    end
    figure(3)
    plot(h);
    ylabel('Thalamic Input');
    hold on
    
    for i = 2:length(t)         % Start simulating across time
        if ( ( t(i) > ton ) && (t(i) < toff ) )
            Itot = h + r(i-1,:)*W;  % Total current is input current + rate of all cells * connection strength
        else
            Itot = r(i-1,:)*W;
        end
        
        rinf = rmax./(1+exp(-(Itot-Ith)/Iwidth)).^2;    % The steady state firing rate for all cells
        
        r(i,:) = rinf + (r(i-1,:)-rinf)*exp(-dt/tau);   % The actual firing rate of all cells is updated.

    end
    
    figure(1)                       % Switch to Fig.1 for plotting network response
    plot(r(end,:))                  % Plot final firing rate of all cells for that stimulus.
    hold on
    xlabel('Cell number');
    ylabel('Final rate');

    figure() 
    imagesc(r');
    xlabel('time, sec')
    ylabel('Neuron index')
    title(['cuecell is ', num2str(cuecell)])

end
