% matchprobs.m
% Two targets are rewarded with different probabilities 
% The pair of probabilities change every Nsubtrials
% Once a target is given reward, the reward remains there
% A decision-making circuit determines which taret is selected
% If the target is selected when it has reward, dopamine-mediated 
% learning strengthens synapses to that choice.
% If the selected target has no reward then active synapses are depressed.
% The goal is to show how the ratio of chosen targets matches 
% the ratio of reward gained from those two targets.

clear
Nsubtrials = 200;                       % No. of trials before changing probabilities
Nprobs = 5;                             % probabiities will have 5 different sets of values
Ntrials = Nprobs*Nsubtrials;            % Total number of trials
Nstims = 1;                             % For ease use one stimulus cell toerpresent both targets
probs = [ 0.1 0.2 0.5 0.1 0.4; 0.5 0.2 0.1 0.3 0.2] % 5 probabilities for each of two targets

dt = 0.001;
t = 0:dt:0.5;
tau = 0.020;                            % time constant for all cell/synapse updates
ton = 0.1;                              % time for stimulus to come on

Win0 = 2.0;                             % initial strength of input connections
Wmax = 2*Win0;                          % maximum input connection strength
dWplus = 0.01;                          % increase in synaptice strengths following correct trials
dWminus = 0.02;                         % decrease in synaptic strengths following incorrect trials

Ndecisions = 2;                         % Here choice is just between sun or no sun
Win = Win0*ones(Nstims,Ndecisions);     % weight from each stimulus cell to decision cell

tallychoice = zeros(1,Ntrials);

Wrecurrent = 0.3;                       % Decision-making cells self-excitation
Wcross = -1.5;                            % Decision-making cells cross-inhibition
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
Idecideth = 30;                         % threshold of decision-making cells
Iwidth = 5;                             % determines steepness of f-I curve
sigmaI = 0.03;                          % fractional noise in current to decision-making cells

Winhistory = zeros(Ndecisions,Nprobs);  % Keep a history of synaptic strengths to decision network
trackbait = zeros(Ntrials,Ndecisions);  % Tracks which targets have reward at any time
trackchoice = zeros(Ntrials,1);         % Tracks which target is chosen at any time

totaltrial = 0;                         % Keeps track of total number of trials to date

for iprob = 1:Nprobs                    % Which set of probabilities we are in

    thisprob = probs(:,iprob)           % Select the probabilities for the targets in the current set

    bait = zeros(Ndecisions,1);         % By default no reward with any target
    for trial =1:Nsubtrials             % Run through all the trials in a subset
        totaltrial = totaltrial+1;      % Increment total number of trials
        
        for position = 1:Ndecisions     % For each target
            if bait(position) == 0      % If it is not already baited with reward
                if rand(1) < thisprob(position)     % Randomly and based on probability of reward
                    bait(position) = 1;             % add a reward to this target
                end
            end
        end

        rstim = zeros(length(t),Nstims);              % rates of stimulus cell (just one cell in this code)  
        rdecide = zeros(length(t),Ndecisions);        % rates of decision-making neurons
        figure(1);
        xlabel('time, sec');
        ylabel('firing rate'); 
        for i = 2:length(t)
            if  t(i) > ton
                Iapp = Iapp0;           %  this gives applied current to subset of stimulus neurons
            else
                Iapp = zeros(1,Nstims); % no current before stimulus comes on
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

        trackbait(totaltrial,:) = bait(:);      % keep track of where the rewards were this trial
        trackchoice(totaltrial) = winner;       % keep track of choice on this trial

        if bait(winner) == 1            % if chosen target was rewarded
            correct = 1;                % get a reward :-)
            bait(winner) = 0;           % remove the reward from that target
        else
            correct = 0;                % otherwise no reward :-(
        end

        if correct == 1                 % with a correct response
            for cell = 1:Nstims         % potentiate synapses from stimuli that were on
                Win(cell,winner) = Win(cell,winner) + dWplus;
            end
        else                            % with an incorrect response
            for cell = 1:Nstims         % depress synapses from the stimuli that were on
                Win(cell,winner) = Win(cell,winner) - dWminus;
            end
        end

        Win = max(Win,0);               % synapses must be positive
        Win = min(Win,Wmax);            % and not greater than some maximum
                
        Win = Win*Win0/mean(Win);       % this rescales synapses to have a fixed mean of Win0       
        
        
        if totaltrial > 1                               % increment from previous value each trial
            if winner == 1
                tallychoice(totaltrial) = tallychoice(totaltrial-1)+1;  % Number of target 1 choices to date
            else
                tallychoice(totaltrial) = tallychoice(totaltrial-1);    % unchanged if other target was chosen
            end
        else
            if winner == 1
                tallychoice(totaltrial) = 1;            % On the first trial just set to 1 
            else
                tallychoice(totaltrial) = 0;            % or zero 
            end
        end
        plot(t,rdecide);
        axis([0 0.5 0 100]);


        legend('choice 1', 'choice 2');

    end

    Winhistory(:,iprob) = Win(1,:);         % check connection strengths at end of subset with fixed probabilities

    figure(2)
    plot(Win,'x')
    xlabel('cell label')
    ylabel('Input connection strength')
    axis([0.95 2.05 1.6 2.4])
    
end

figure(3)
plot(Winhistory)
xlabel('cell label')
ylabel('Input connection strength')
figure(4)
plot(tallychoice)                       % The slope should roughly match the probability ratio of reward-baiting
xlabel('Trial number')
ylabel('Accumulated choices of target 1')

meanfrac2 = zeros(1,Nprobs);          % Will be fraction of choices of target 2 in a subset
meanprob1 = zeros(1,Nprobs);          % Will be fraction of trials target 1 is baited with reward in a subset
meanprob2 = zeros(1,Nprobs);          % Will be fraction of trials target 2 is baited with reward in a subset
for iprob = 1:Nprobs
    meanfrac2(iprob) = mean(trackchoice((iprob-1)*Nsubtrials+1:iprob*Nsubtrials))-1; 
    meanprob1(iprob) = mean(trackbait((iprob-1)*Nsubtrials+1:iprob*Nsubtrials,1));   % fraction baited on target 1
    meanprob2(iprob) = mean(trackbait((iprob-1)*Nsubtrials+1:iprob*Nsubtrials,2));   % fraction baited on target 2
end

figure(5)
plot(meanfrac2)                         % fraction of choices on target 2
hold on
plot(meanprob2./(meanprob1+meanprob2),'r') % fraction of reward on target 2 out of total reward

plot(probs(2,:)./(probs(2,:)+probs(1,:)),'g')                    % stated probability fraction of reward on 2 out of total
legend('choice fraction of 2', 'reward fraction of 2', 'fixed probability of 2')