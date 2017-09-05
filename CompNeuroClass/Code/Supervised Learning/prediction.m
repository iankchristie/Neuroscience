% prediction.m
% Code to predict a choice like weather based on probabilistic evidence
% 5 different inputs and a choice of 2 outputs

clear
Nstims = 5;                             % Number of informative stimuli
probs = [0.95, 0.75, 0.5, 0.25 , 0.05]; % probability of inputs corresponding to sun

dt = 0.001;
t = 0:dt:0.5;
tau = 0.020;                            % time constant for all cell/synapse updates
ton = 0.1;                              % time for stimulus to come on

Win0 = 1.0;                             % initial strength of input connections
Wmax = 3*Win0;                          % maximum input connection strength
dWplus = 0.01;                          % increase in synaptice strengths following correct trials
dWminus = 0.015;                        % decrease in synaptic strengths following incorrect trials

Ntrials = 100;

Win = Win0*ones(Nstims,2);              % weight from each stimulus cell to decision cell

Ndecisions = 2;                         % Here choice is just between sun or no sun 

Wrecurrent = 0.25;                      % Decision-making cells self-excitation
Wcross = -3;                            % Decision-making cells cross-inhibition
for i = 1:Ndecisions
    for j = 1:Ndecisions
        W(i,j) = Wcross;                % Cross inhibition for different cells
    end
    W(i,i) = Wrecurrent;                % Self-excitation for a cell to itself
end

Iapp0 = 30.0;                           % current to stimulus cells
rstimmax = 100;                         % max rate of input stimulus cells
rdecidemax = 100;                       % max rate of decision-making cells
Ith = 30;                               % threshold of input cells
Idecideth = 50;                         % threshold of decision-making cells
Iwidth = 5;                             % determines steepness of f-I curve 
sigmaI = 0.1;                           % fractional noise in current to decision-making cells

sumrightwrong = zeros(1,Ntrials);       % will tally correct minus wrong responses

for trial = 1:Ntrials

    sun = 0;
    stimuluson = zeros(1,Nstims);       % default of no stimulus
    if rand(1) > 0.5 
        sun = 1;                        % half the time it is sunny
        for stim = 1:Nstims             % run through each possible stimulus
            if rand(1) < probs(stim)
                stimuluson(stim) = 1;   % if sunny, probs(stim) is probability stimulus is on
            end
        end
    else
        for stim = 1:Nstims             % run through each possible stimulus
            if rand(1) > probs(stim)
                stimuluson(stim) = 1;   % stimulus is on with 1-prob(stim) when it rains
            end
        end
    end

    rstim = zeros(Nstims);              % rates of stimulus input neurons
    rdecide = zeros(Ndecisions);        % rates of decision-making neurons
    for i = 2:length(t)
        if  t(i) > ton
            Iapp = Iapp0*stimuluson;    %  this gives applied current to subset of stimulus neurons
        else
            Iapp = zeros(size(stimuluson)); % no current before stimulus comes on
        end


        rstiminf = rstimmax./(1+exp(-(Iapp-Ith)/Iwidth));   % steady state rate of input cells
        rstim(i,:) = rstiminf + (rstim(i-1,:) - rstiminf)*exp(-dt/tau);     % integrate to steady state

        Idecide = (rstim(i-1,:)*Win + rdecide(i-1,:)*W) .* ...  % current to decision cells
            (1.0 + sigmaI*randn(1,Ndecisions)/sqrt(dt));        % with added noise

        rdecideinf = rdecidemax./(1+exp(-(Idecide-Idecideth)/Iwidth));  % steady state rate of decision cells
        rdecide(i,:) = rdecideinf + (rdecide(i-1,:) - rdecideinf)*exp(-dt/tau);     % integrate to steady state
        
    end             
    
    winner = 1;                             % find which decision is made, start by assuming 1
    rmax = rdecide(length(t),winner);       % initialize maximum rate at end of simulation
    for cell = 2:Ndecisions                 % see if other cell beats cell1
        if rdecide(length(t),cell) > rmax   % if rate of other cell is higher than max
            winner = cell;                  % that cell is the winner
            rmax = rdecide(length(t),cell); % reset max rate
        end
    end
        
    % winner should be 2 if it is sunny (sun is 1) 
    % otherwise winner should be 1 if it is not sunny (sun is 0)
    if sun+1 == winner              
        correct = 1                 % correct response
    else                            
        correct = 0                 % wrong response 
    end
    
    % sumrightwrong will tally the number of correct responses minus the
    % number of incorrect responses to date
     if ( trial == 1 ) 
        sumrightwrong(trial) = 2*correct-1;
    else
        sumrightwrong(trial) = sumrightwrong(trial-1) + 2*correct-1;
    end
   
    if correct == 1                 % with a correct response
        for cell = 1:Nstims         % potentiate synapses from stimuli that were on
            Win(cell,winner) = Win(cell,winner) + dWplus*stimuluson(cell);
        end
    else                            % with an incorrect response
        for cell = 1:Nstims         % depress synapses from the stimuli that were on
            Win(cell,winner) = Win(cell,winner) - dWminus*stimuluson(cell);
        end
    end
        
    Win = max(Win,0);               % weights can not be negative
    Win = min(Win,Wmax);            % or greater than some maximum

%     figure(1)
%     plot(t,rstim)
%     xlabel('time, sec')
%     ylabel('rate of input cells')

    figure(2)
    plot(t,rdecide)
    xlabel('time, sec')
    ylabel('rate of decision-making cells')
    
    figure(3)
    plot([1 2 3 4 5], Win)
    xlabel('presynaptic cell number')
    ylabel('connection strength to decision cells')
    
end

figure(4)
plot(sumrightwrong)
xlabel('trial number')
ylabel('excess number of correct responses to date')
