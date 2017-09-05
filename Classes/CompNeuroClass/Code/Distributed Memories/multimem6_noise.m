% multimem6.m
% attempt to do Hopfield-like network on a visible grid with neurons.
% multimem6.m switches threshold from post to presynaptic cell for plasticity

N1 = 12;    % size of edge of square array
viewmatrix = zeros(N1,N1); % square array for viewing
Ncells = numel(viewmatrix); % no. of cells in the array
Ntrials = 1000;  % No. of trials for learning
inputstrength = 40; % input strength during training
trainingerrorprob = 0.01;

see_training_figures = 1;   % do not watch training figures if zero

W = zeros(Ncells,Ncells)-0.1/Ncells; % set initial connections to < 0.

Npatterns = 4; % No. of patterns to define and learn
pattern1 = zeros(size(viewmatrix));
pattern2 = zeros(size(viewmatrix));
pattern3 = zeros(size(viewmatrix));
pattern4 = zeros(size(viewmatrix));
pattern5 = zeros(size(viewmatrix));
pattern6 = zeros(size(viewmatrix));

% see patterns by imagesc(pattern1);
% 1st pattern is letter "O"
for i = 2:N1-1
    pattern1(i,2) = 1;
    pattern1(i,N1-1) = 1;
end
for j = 2:N1-1
    pattern1(2,j) = 1;
    pattern1(N1-1,j) = 1;
end

% Second pattern is letter "X" 
for i = 1:N1
    pattern2(i,i) = 1;
    pattern2(i,N1+1-i) = 1;
end
% Third pattern is letter "Y"
for i = 1:(N1)/2-1;
    pattern3(i,i+1) = 1;
    pattern3(i,N1-i) = 1;
end
for i = (N1+2)/2-1:N1
    pattern3(i,(N1+2)/2) = 1;
    pattern3(i,(N1)/2) = 1;
end
% 4rd pattern is letter "Z"
for j = 1:N1
    pattern4(1,j) = 1;
    pattern4(N1,j) = 1;
    if ( j > 1 ) 
       pattern4(N1+2-j,j) = 1; 
    end
end
% 5th pattern is letter "W"
for j = 1:ceil(N1/3)
    if ( 3*j-2  < N1+1)
        pattern5(3*j-2,j) = 1;
    end
    if ( 3*j-1  < N1+1)
        pattern5(3*j-1,j) = 1;
    end
    if ( 3*j  < N1+1 )
        pattern5(3*j,j) = 1;
    end
end
for j = ceil(2*N1/3):N1
    jj = N1+1-j;
    if ( 3*jj -2 < N1+1 )
        pattern5(3*jj-2,j) = 1;
    end
    if ( 3*jj -1 < N1+1 )
        pattern5(3*jj-1,j) = 1;
    end
    if ( 3*jj < N1+1 )
        pattern5(3*jj,j) = 1;
    end
end
for j = ceil(N1/3)+1:N1/2 
    jj = 2*ceil(N1/3)-j;
    pattern5(3*jj-2,j) = 1;
    pattern5(3*jj-1,j) = 1;
    pattern5(3*jj,j) = 1;
end
for j = N1/2+1: ceil(2*N1/3)
    jj = j-ceil(N1/3)-1;
    pattern5(3*jj-2,j) = 1;
    pattern5(3*jj-1,j) = 1;
    pattern5(3*jj,j) = 1;
end
% 6th pattern is letter "V"
for j = 1:N1/2
    pattern6(2*j-1,j) = 1;
    pattern6(2*j,j) = 1;
end
for j = N1/2+1:N1
    jj = N1+1-j;
    pattern6(2*jj-1,j) = 1;
    pattern6(2*jj,j) = 1;
end

% Training via rate model
dt = 0.001; % time step for simulation
tau = 0.010; % time constant for cells 
tmax = 1; % maximum time to wait
t = 0:dt:tmax; %time vector
input = zeros(1,Ncells); % input to each cell is a vector

rmax = 50; %        maximum firing rate
gain = 1;  % slope of sigmoid f-I curve
threshold = 10; % threshold of sigmoid f-I curve

epsilon = 0.1/Ncells;  % amount of plasticity per trial
Wmax = 20*epsilon;     % Maximum connection strength
Wmin = -20*epsilon;    % Minimum connection strength

rmatrix = zeros(N1,N1); % matrix for viewing rates at the end
for trial = 1:Ntrials    % iterate through trials
    rate = zeros(1,Ncells); % initialize rates to zero
    selectpattern = ceil(rand*Npatterns); % choose a pattern randomly
    if (selectpattern == 0 ) % just in case random number was zero
        selectpattern = 1;
    end
    if ( selectpattern == 1 )
        for i = 1:Ncells
            input(i) = pattern1(i); % input is pattern 1
        end
    end
    if ( selectpattern == 2 )
        for i = 1:Ncells
            input(i) = pattern2(i); % input is pattern 2
        end
    end
    if ( selectpattern == 3 )
        for i = 1:Ncells
            input(i) = pattern3(i); % input is pattern 3
        end
    end
    if ( selectpattern == 4 )
        for i = 1:Ncells
            input(i) = pattern4(i); % input is pattern 4
        end
    end
    if ( selectpattern == 5 )
        for i = 1:Ncells
            input(i) = pattern5(i); % input is pattern 5
        end
    end
    if ( selectpattern == 6 )
        for i = 1:Ncells
            input(i) = pattern6(i); % input is pattern 6
        end
    end
    
    flipinputs = find(rand(Ncells,1) < trainingerrorprob );
    input(flipinputs) = 1-input(flipinputs);
    
    for i = 2:length(t)              % simulate network response to input
        current = input*inputstrength + rate*W;
        rss = rmax./(1+exp(-gain*(current-threshold))); % steady state
        rate = rss - (rate-rss)*exp(-dt/tau);           % rate evolves to steady state
    end
    if ( see_training_figures )
        for cell = 1:Ncells
            rmatrix(cell) = rate(cell);   % rmatrix is purely for viewing
        end
        figure(1)
        imagesc(rmatrix)
        colorbar
    end
    
    dW = (double(rate>rmax/2)')*(double(rate>rmax/2)); % update for coactive cells
    W = W+dW*epsilon; 
    W = min(W,Wmax);  % maximumu connection strength
    W = max(W,Wmin);  % minimum is negative
    W = W - mean(mean(W))-0.5/Ncells;  % normalize to enforce a global balance
end
% Now move to testing memory of inputs in same manner, but no update of W
errorprob = 0.03; % produce degradation if non-zero
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
    if ( selectpattern == 5 )
        for i = 1:Ncells
            input(i) = pattern5(i);
        end
    end
    if ( selectpattern == 6 )
        for i = 1:Ncells
            input(i) = pattern6(i);
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
            current = input*inputstrength + rate*W;
        else
            current= rate*W;     % Network evolves due to internal structure
        end
        rss = rmax./(1+exp(-gain*(current-threshold))); 
        rate = rss - (rate-rss)*exp(-dt/tau);
    end
    for cell = 1:Ncells
        rmatrix(cell) = rate(cell);
    end
 
    figure()    % Now view final rates
    imagesc(rmatrix); colorbar;
end