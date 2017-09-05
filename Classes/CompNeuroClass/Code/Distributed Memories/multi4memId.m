% multimem6.m
% attempt to do Hopfield-like network on a visible grid with neurons.
% multimem6.m switches threshold from post to presynaptic cell for plasticity

N1 = 15;    % size of edge of square array
viewmatrix = zeros(N1,N1); % square array for viewing
Ncells = numel(viewmatrix); % no. of cells in the array
Ntrials = 250;  % No. of trials for learning
inputstrength = 50; % input strength during training

Wmean = -0.3/Ncells;
W = zeros(Ncells,Ncells)+Wmean; % set initial connections to < 0.

rng(9)

Npatterns = 4; % No. of patterns to define and learn
pattern1 = zeros(size(viewmatrix));
pattern2 = zeros(size(viewmatrix));
pattern3 = zeros(size(viewmatrix));
pattern4 = zeros(size(viewmatrix));

% see patterns by imagesc(pattern1);
% First pattern is letter "X" 
for i = 1:N1
    pattern1(i,i) = 1;
    pattern1(i,N1+1-i) = 1;
    if ( i < N1 )
        pattern1(i,i+1) = 1;
        pattern1(i,N1-i) = 1;
    end
end
%Second pattern is letter "Y"
for i = 1:(N1)/2-1;
    pattern2(i,i+2) = 1;
    pattern2(i,N1-1-i) = 1;
    pattern2(i,i+3) = 1;
    pattern2(i,N1-2-i) = 1;
end
for i = ceil((N1+2)/2)-3:N1
    pattern2(i,floor((N1+2)/2)) = 1;
    %pattern2(i,floor((N1)/2)) = 1;
end
% 3rd pattern is letter "Z"
for j = 1:N1
    pattern3(1,j) = 1;
    pattern3(N1,j) = 1;
    if ( j > 1 ) 
       pattern3(N1+2-j,j) = 1; 
    end
end
% 4th pattern is letter "O"
for i = 2:N1-1
    pattern4(i,2) = 1;
    pattern4(i,N1-1) = 1;
end
for j = 2:N1-1
    pattern4(2,j) = 1;
    pattern4(N1-1,j) = 1;
end

% Training via rate model
dt = 0.001; % time step for simulation
tau = 0.010; % time constant for cells 
exp_mdt_otau = exp(-dt/tau);
tmax = 1; % maximum time to wait
t = 0:dt:tmax; %time vector
rmax = 50; %        maximum firing rate
gain = 1;  % slope of sigmoid f-I curve
threshold = 10; % threshold of sigmoid f-I curve

epsilon = 0.05/Ncells;  % amount of plasticity per trial
Iepsilon = -0.05/Ncells;  % amount of plasticity per trial
Wmax = 8/Ncells;     % Maximum connection strength
Wmin = -8/Ncells;    % Minimum connection strength

errorprob_train = 0.06;

rmatrix = zeros(N1,N1); % matrix for viewing rates at the end
for trial = 1:Ntrials    % iterate through trials
    rate = zeros(1,Ncells); % initialize rates to zero
    selectpattern = ceil(rand*Npatterns); % choose a pattern randomly
    if (selectpattern == 0 ) % just in case random number was zero
        selectpattern = 1;
    end
    if ( selectpattern == 1 )
%         for i = 1:Ncells
%             input(i) = pattern1(i); % input is pattern 1
%         end
    input = pattern1;
    end
    if ( selectpattern == 2 )
%         for i = 1:Ncells
%             input(i) = pattern2(i); % input is pattern 2
%         end
        input = pattern2;
    
    end
    if ( selectpattern == 3 )
%         for i = 1:Ncells
%             input(i) = pattern3(i); % input is pattern 3
%         end
            input = pattern3;

    end
    if ( selectpattern == 4 )
%         for i = 1:Ncells
%             input(i) = pattern4(i); % input is pattern 4
%         end
            input = pattern4;

    end
    
    flipinputs = find(rand(Ncells,1) < errorprob_train );
    input(flipinputs) = 1-input(flipinputs);

    for i = 2:length(t)              % simulate network response to input
        current = input(:)'*inputstrength + rate*W;
        rss = rmax./(1+exp(-gain*(current-threshold))); % steady state
        rate = rss + (rate-rss)*exp_mdt_otau;           % rate evolves to steady state
    end
    for cell = 1:Ncells
        rmatrix(cell) = rate(cell);   % rmatrix is purely for viewing
    end
    dW = (double(rate>rmax/2)')*(double(rate>rmax/2)); % update for coactive cells
    W = W+dW*epsilon; 
    dW = (double(rate>rmax/2)')*(double(rate<rmax/2)); % update for coactive cells
    W = W + dW*Iepsilon;
    
    W = min(W,Wmax);  % maximumu connection strength
    W = max(W,Wmin);  % minimum is negative
    W = W - mean(mean(W))+Wmean;  % normalize to enforce a global balance

    
    if ( mod(trial,40) == 1)
        figure(1)
        subplot(2,1,1)
        imagesc(input)
        subplot(2,1,2)
        imagesc(rmatrix)
        drawnow
        data = [max(max(W)) min(min(W))]
    end
    


end
% Now move to testing memory of inputs in same manner, but no update of W
errorprob = 0.1; % produce degradation if non-zero
% Now test a pattern
inputstrength = inputstrength*0.5; % use weaker than original input
for trial = 1:Npatterns  
    rate = zeros(1,Ncells);
    selectpattern = trial;
    if (selectpattern == 0 ) 
        selectpattern = 1;
    end
    if ( selectpattern == 1 )
        for i = 1:Ncells
            input(i) = pattern1(i);
        end
    end
    if ( selectpattern == 2 )
        for i = 1:Ncells
            input(i) = pattern2(i);
        end
    end
    if ( selectpattern == 3 )
        for i = 1:Ncells
            input(i) = pattern3(i);
        end
    end
    if ( selectpattern == 4 )
        for i = 1:Ncells
            input(i) = pattern4(i);
        end
    end
    flipinputs = find(rand(Ncells,1) < errorprob );
    input(flipinputs) = 1-input(flipinputs);

    for cell = 1:Ncells
        rmatrix(cell) = input(cell);
    end
    figure()
    imagesc(rmatrix); % View input patterns 

    for i = 2:length(t)
        if ( i < length(t) / 2 ) % Only input for first 1/2 of trial
            current = input(:)'*inputstrength + rate*W;
        else
            current= rate*W;     % Network evolves due to internal structure
        end
        rss = rmax./(1+exp(-gain*(current-threshold))); 
        rate = rss + (rate-rss)*exp_mdt_otau;
    end
    for cell = 1:Ncells
        rmatrix(cell) = rate(cell);
    end
 
    figure()    % Now view final rates
    imagesc(rmatrix);
end