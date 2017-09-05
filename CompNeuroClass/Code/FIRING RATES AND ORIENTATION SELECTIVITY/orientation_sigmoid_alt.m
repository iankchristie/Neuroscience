clear

popvec_readout = 0;

dt=0.005;                       % time step
tmax = 1;                       % maximum time: check rates are not changing by this time
t = 0:dt:tmax;                  % vector of time points

Ncells = 50;                    % total number of cells
dtheta = pi/Ncells;             % difference in preferred orientation from one cell to next
r=zeros(length(t),Ncells);      % rate matrix: all time points and all cells
r(1,:) = rand(1,Ncells)*10;     % make initial rate for each cell random from 0-10Hz

h=zeros(1,Ncells);              % this will be (thalamic) input current to cells
Itot=zeros(1,Ncells);           % total current to cells

A = 40.;                        % Maximum amplitude of thalamic input current
epsilon = 0.1;                  % How much the input modulates with orientation
J0 = -0.5;                      % Mean inhibitory connection strength to all cells
J2 = 1;                         % Extra excitatory connection to similar cells
tau = 0.050;                    % Time constant for the rate to change (slow for NMDA synapses)
noise_level = 1;

for cell1 = 1:Ncells;           % Postsynaptic cell
    for cell2 = 1:Ncells;       % Presynaptic cell
        W(cell2,cell1) = (J0+J2*cos(2*pi*(cell2-cell1)/Ncells))*dtheta;    % Connection from cell2 to cell1
    end
end
figure(4)
imagesc(W)
title('Connection Strength')
xlabel('Postsynaptic Cell')
ylabel('Presynaptic Cell')

cuecell = 15;                   % Cell no. where thalamic input is peaked
input_angle = dtheta*cuecell*180/pi
Ith = 20;                       % Rough threshold of f-I curve of cells
Iwidth = 20;                    % Inverse gradient of f-I cure near threshold
rmax = 200;                     % Maximum rate of cells
Iin = -100:0.1:100;             % Plot a range of input currents
rout = rmax./(1+exp(-(Iin-Ith)/Iwidth)).^2;   % This is the firing rate curve used in the simulation

figure(2)                       % Figure to plot f-I curve
clf                             % Clear figure
plot(Iin,rout)                  % Plot f-I curve
xlabel('Input current')         % Label x-axis
ylabel('Firing rate')           % Label y-axis

figure(1)                        % Clear figures to be used later
clf
figure(3)
clf

for c = 0:0.2:0.8;              % Use different contrasts stepping from 0 to 0.8
    
    for cell = 1:Ncells;        % For each cell, its input current depends on how close is its 
                                % prefered orientation to the cue cell
        h(cell) = A*c*(1-epsilon + epsilon*cos(2*pi*(cell-cuecell)/Ncells))+noise_level*randn();
                                % This is the formula in notes + HW
    end
    figure(3)
    plot(h);
    ylabel('Thalamic Input');
    xlabel('Cell number')
    hold on
    
    for i = 2:length(t)         % Start simulating across time
        
        Itot = h + r(i-1,:)*W;  % Total current is input current + rate of all cells * connection strength
        
        rinf = rmax./(1+exp(-(Itot-Ith)/Iwidth)).^2;    % The steady state firing rate for all cells
        
        r(i,:) = rinf + (r(i-1,:)-rinf)*exp(-dt/tau);   % The actual firing rate of all cells is updated.

    end
    
    figure(1)                       % Switch to Fig.1 for plotting network response
    plot(r(end,:))                  % Plot final firing rate of all cells for that stimulus.
    hold on
    xlabel('Cell number');
    ylabel('Final rate');
    
    
    %% Now try a population vector read-out -- Note that this method really 
    % should not be used for orientation selectivity in this manner, but
    % could be used for direction selectivity. Explanation in class. 
    % The main issue is that for the population vector readout to be valid,
    % the angle must be able to go through a complete circle from 0 to 2.pi
    % Below this first version which looks OK is a "fix".
    popvec_x = 0.0;
    popvec_y = 0.0;
    figure()
    for cell = 1:Ncells
        pref_angle = dtheta*cell;
        vec_x = r(end,cell)*cos(pref_angle);
        vec_y = r(end,cell)*sin(pref_angle);
        plot([popvec_x, popvec_x + vec_x], [popvec_y, popvec_y + vec_y])
        hold on
        popvec_x = popvec_x + vec_x;
        popvec_y = popvec_y + vec_y;
    end
    title('Population vector Readout')
    plot([0 popvec_x], [0 popvec_y],'r')
    scale_max = max(popvec_x,popvec_y);
    axis([-scale_max scale_max -scale_max scale_max])
    readout_angle = mod(atan(popvec_y/popvec_x),pi)*180/pi
    
    %% Fixed method where we treat "vertical" as opposite to "horizontal"
    if ( popvec_readout)
        popvec_x = 0.0;
        popvec_y = 0.0;
        figure()
        for cell = 1:Ncells
            pref_angle = 2*dtheta*cell;                         % Note multiplication by 2 here
            vec_x = r(end,cell)*cos(pref_angle);
            vec_y = r(end,cell)*sin(pref_angle);
            plot([popvec_x, popvec_x + vec_x], [popvec_y, popvec_y + vec_y])
            hold on
            popvec_x = popvec_x + vec_x;
            popvec_y = popvec_y + vec_y;
        end
        title('Fixed Population vector Readout')
        plot([0 popvec_x], [0 popvec_y],'r')
        scale_max = max(popvec_x,popvec_y);
        scale_max = max(scale_max,rmax);
        axis([-scale_max scale_max -scale_max scale_max])
        xlabel('Horizontal - Vertical Projection')
        
        fixed_readout_angle = 0.5*mod(atan(popvec_y/popvec_x),pi)*180/pi   % Note multiplication by 0.5 here
        
    end
end

