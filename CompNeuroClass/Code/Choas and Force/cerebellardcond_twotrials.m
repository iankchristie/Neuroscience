% cerebellarcond_twotrials.m   ---    model of cerebellar conditioning with a bunch of granule cells excited by the CS, that excite one Purkinje cell,
% which also receives inputs from a climbing fiber is excited by the US. Coincident granule cell and climbing fibre firing leads to LTD.

% This code deos not do the conditioning, but rather shows chaotic behavior
% of the Granule Cells firing rates with altered parameters.

clear;  dt = 0.005; tmax = 5; t = 0:dt:tmax; Ntrials = 2;
NGcells = 200;               % No. of granule cells
NIcells = NGcells;          % No. of inhibitory (Golgi) cells

rng(2)

% Granule cell f-I curves:
IthGC = 5*ones(1,NGcells)+15*rand(1,NGcells);   % Randomness in thresholds of granule cells
IwidthGC = 10*ones(1,NGcells);                  % Width of f-I curve
rmaxGC = 100*ones(1,NGcells);                   % Max. firing rate
tauGC = 0.010;                                   % membrane time constant
taus = zeros(1,NGcells);                        % synaptic time constant
tauf = zeros(1,NGcells);                        % time constant for facilitation
taud = zeros(1,NGcells);                        % time constant for depression
taus0 = 0.075;                                   % base value for synaptic time constant
taud0 = 0.1;                                    % base value for depression time constant
tauf0 = 0.2;                                    % base value for facilitation time constant

for cell = 1:NGcells
    taus(cell) = taus0;                         % fixed synaptic time consants for all cells
    tauf(cell) = tauf0*(1.0+2*rand(1));       % heterogeneity in time constant for facilitation
    taud(cell) = taud0*(1.0+2*rand(1));       % heterogeneity in time constant for deression
end

% Inhibitory (Golgi) cell f-I curves
IthIC = 13;                 % fixed threshold
IwidthIC = 8;               % fixed width of sigmoid
rmaxIC = 300;               % fixed maximum rate
tauIC = 0.010;              % fixed time constant

% Climbing fiber f-I curve
IthCF = 15;                 % fixed threshold
IwidthCF = 5;               % fixed width of sigmoid
rmaxCF = 300;               % fixed maximum rate
tauCF = 0.002;              % fixed time constant

IthPC = 15;                 % fixed threshold
IwidthPC = 5;               % fixed width of sigmoid
rmaxPC = 30;                % fixed maximum rate
tauPC = 0.010;              % fixed time constant

IthNI = 10;                 % fixed threshold
IwidthNI = 3;               % fixed width of sigmoid
rmaxNI = 100;               % fixed maximum rate
tauNI = 0.005;              % fixed time constant

% Now set all the connection strengths only WGP will vary

WGP0 = 15.0/NGcells;        % Base granule cell to Purkinje Cell connection strength
WGP = WGP0*ones(NGcells,1); % Vector of individual connections
dW0 = 0.02;                 % Maximum fractional change in weight per trial

WGN = 4.0;                  % Connection from granule cell to nucleus
WPN = 10.0;                 % Inhibitory strength from Purkinje Cll to nucleus

WGG = zeros(NGcells);           % Granule cells to granule cells
WGI = zeros(NGcells,NIcells);   % Granule cells to interneurons
WIG = zeros(NIcells,NGcells);   % Interneurons to granule cells

WGG0 = 1.5;                 % Base connection strengths
WGI0 = 1;
WIG0 = 40/NIcells;
connectprob = 0.05;          % connection probability between granule cells
for cell1 = 1:NGcells
    for cell2 = 1:NGcells
        if rand(1) > connectprob    % only connect if random number is less than probability
            WGG(cell1,cell2) = 0.0; % otherwise no connection
        else                        % connection strength has structure and randomness
            WGG(cell1,cell2) = WGG0*(NGcells-mod(cell2-cell1+NGcells,NGcells))/NGcells * (1.0+5.0*rand(1))/connectprob;
        end
    end
    WGG(cell1,cell1) = 0.25*WGG0*(1.0+0.2*randn(1));   % self-connection is fixed
    WGI(cell1,cell1) = WGI0;        % each granule cell connects to one interneuron
end
WGG = max(WGG,0);

for cell1 = 1:NIcells
    for cell2 = 1:NIcells           % all to all connections from interneuron to granule cells
        WIG(cell1,cell2) = WIG0*(0.5+rand(1)); % but with randomness in strengths
    end
end

tCSon = 0.2;                % time of CS onset
lengthCS = tmax;            % length of CS
ICS0 = 20.0;               % steady state CS applied current
ICS1 = 10.0;               % intitial peak CS current
tauCS = 0.05;               % time for decay of peak CS current

tUSon = 1.2;                % time for US onset
lengthUS = 0.025;           % length of US
IUS0 = 100.0;               % applied current for US

ICS = zeros(size(t));       % set up input current vectors, one for CS
IUS = zeros(size(t));       % and one for US
Iapp = zeros(length(t),NGcells);    % each granule cell can get a different applied current
for i = max(1,floor(tCSon/dt)+1):min(floor((tCSon+lengthCS)/dt)+1,length(ICS))
    ICS(i) = ICS0+ICS1*exp(-(t(i)-tCSon)/tauCS);
    for cell = 1:NGcells/5
        Iapp(i,cell) = ICS(i)*(NGcells-cell)/(NGcells-1);
    end
end

for trial = 1:Ntrials; trial
    rGC = zeros(length(t),NGcells);     % rates of all Granule Cells
    D = ones(length(t),NGcells);        % synaptic depression of Granule Cells
    F = ones(length(t),NGcells);        % facilitation of granule cells
    S = zeros(length(t),NGcells);       % synaptic output of granule cells
    rI = zeros(length(t),NIcells);      % rates of all inhibitory Golgi cells
    rPC = zeros(length(t),1);           % rate of Purkinje cell
    rCF = zeros(length(t),1);           % rate of spikes in Climbing Fiber
    rNI = zeros(length(t),1);           % firing rate of interpositus nucleus
    ItotPC = zeros(size(t));            % current to Purkinje cells
    
    for i = floor(tUSon/dt)+1:floor((tUSon+lengthUS)/dt)+1
        IUS(i) = IUS0;                  % Unconditioned Stimulus is on
    end
    
    for i = 2:length(t)
        
        % Evaluate inputs and rates of granule cells
        ItotGC = Iapp(i-1,:) + S(i-1,:)*WGG - rI(i-1,:)*WIG;
        rinfGC = rmaxGC./(1+exp(-(ItotGC-IthGC)./IwidthGC)).^2;    % rinf is a vector of the steady state firing rate
        rGC(i,:) = rinfGC + (rGC(i-1,:)-rinfGC)*exp(-dt/tauGC);   % update r from r(i-1) for all cells
        
        % Include faclilitation with time constant tauf
        Finf = rGC(i,:).*tauf./(rGC(i,:).*tauf + 1.0);
        F(i,:) = Finf + (F(i-1,:)-Finf).*exp(-dt./tauf);
        
        % Include depression with time constant taus
        Dinf = 1.0./(rGC(i,:).*taud.*F(i,:) + 1.0);
        D(i,:) = Dinf + (D(i-1,:)-Dinf).*exp(-dt./taud);
        
        % Hence calculate synaptic output (no saturation here)
        Sinf = rGC(i,:).*D(i,:).*F(i,:);
        S(i,:) = Sinf + (S(i-1,:)-Sinf).*exp(-dt./taus);
        
        % Now evaluate inputs and rates of inhibitory (Golgi) cells
        ItotIC = rGC(i-1,:)*WGI;
        rinfI = rmaxIC./(1+exp(-(ItotIC-IthIC)/IwidthIC)).^2;    % rinf is a vector of the steady state firing rate
        rI(i,:) = rinfI + (rI(i-1,:)-rinfI)*exp(-dt/tauIC);   % update r from r(i-1) for all cells
        
        % Now evaluate inputs and rate of climbing fiber
        ItotCF = IUS(i);
        rinfCF = rmaxCF./(1+exp(-(ItotCF-IthCF)/IwidthCF)).^2;
        rCF(i) = rinfCF + (rCF(i-1)-rinfCF)*exp(-dt/tauCF);
        
        % Now evaluate inputs and rate of the Purkinje cell
        ItotPC(i) = rGC(i-1,:)*WGP;
        rinfPC = rmaxPC./(1+exp(-(ItotPC(i)-IthPC)/IwidthPC)).^2;
        rPC(i) = rinfPC + (rPC(i-1)-rinfPC)*exp(-dt/tauPC);
        
        % Now evaluate inputs and rate of the nuceleus
        ItotNI = mean(S(i-1,:))*WGN - rPC(i-1)*WPN; % excitation by mossy fibers and inhibition by Purkinje Cell
        rinfNI = rmaxNI./(1+exp(-(ItotNI-IthNI)/IwidthNI)).^2;
        rNI(i) = rinfNI + (rNI(i-1)-rinfNI)*exp(-dt/tauNI);
        
        if ( ( i == round (length(t)/4 ) ) && ( trial == 2 ) )  % Make a tiny alteration to the rate of one cell on the 2nd trial.
            rGC(i,2) = rGC(i,2) + 1;
            newrate = rGC(i,2)
        end
        
        
        
    end   % end time loop
    
    % Now to adjust the synapses from GC to PC
    ratecorr = zeros(NGcells,1);
    for cell = 1:NGcells
        ratecorr(cell) = sum(S(:,cell).*rCF(:))*dt;     % coincidence between granule cell output and climbing fiber spikes
    end
    
    ms = mean(S,1);                                     % Mean synaptic output for each granule cell
    dW = dW0*(ms'.*ratecorr-15)/(mean(ratecorr)*mean(ms));  % Change in W
    % dW = dW0*(ratecorr-20)/(mean(ratecorr));  % Change in W
    dW = max(-0.1,dW);                                     % can not be reduced by more than 5%
    dW = min(0.1,dW);                                      % or increased by more than 5%
    WGP = WGP.*(1.0-dW);                                    % Update all granule to PC synapses
    WGP = max(WGP,0.0);                                     % can not be less than zero
    WGP = min(WGP,5*WGP0);                                  % or greater than 3*base level
    WGP = WGP*WGP0/mean(WGP);                               % this prevents the mean from changing
    
    
    if ( trial == 1 )
        figure(1)
        plot(t,rGC(:,1) )
        xlabel('Time')
        ylabel('Firing rate')
        title ('Cell 1')
        hold on
        
        figure(2)
        plot(t,rGC(:,2))
        xlabel('Time')
        ylabel('Firing rate')
        title ('Cell 2 (perturbed)')

        hold on
        figure(3)
        plot(t,rGC(:,13))
        xlabel('Time')
        ylabel('Firing rate')
        title ('Cell 13')

        hold on
    else
        figure(1)
        plot(t,rGC(:,1),'r')
        figure(2)
        plot(t,rGC(:,2),'r')
        figure(3)
        plot(t,rGC(:,13),'r')
       
        
        
    end
    
    %     if ( trial == 1 ); figure(1); subplot(2,2,1); plot(t,rGC); axis([ 0 tmax -5 105 ]); end
    %
    %     if ( ( trial == 1 ) || ( mod(trial,10) == 0 ) )
    %         figure(1); subplot(2,2,2); cla; plot(t,rNI);  hold on;
    %         plot(t,rPC,'r'); xlabel('time'); ylabel('Firing rate (red=Purkinje; blue=Nucleus)');
    %
    %         figure(1); subplot(2,2,3); cla; plot(WGP); axis([0 NGcells 0 5*WGP0 ])
    %         xlabel('Granule Cell Index'); ylabel('Connection Strength, WGP'); hold on;
    %         figure(1); subplot(2,2,4); cla; plot(t,ItotPC); axis([0 tmax 0 1500])
    %         xlabel('time'); ylabel('Purkinje Cell Input');
    %     end
end  % end of trial loop