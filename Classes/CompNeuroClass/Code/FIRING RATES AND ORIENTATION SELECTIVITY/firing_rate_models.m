% firing_rate_models.m
% This code demonstrates three identical results from different methods of
% summing the synaptic input from other units.
% Model is a simple sigmoid function so that the firing rate of a "unit" is
% a sigmoid of the input current.
% The input current is proportional to the firing rate multiplied by the
% connection weights of all connected units.

Nunits = 3;                             % 3 units used
% Hence a 3x3 connection matrix.
% The default has element (i,j) (row i, column j) as the connection
% strength from unit j to unit i (this will be switched in the 3rd method).
gcoupling = [ 0.2   0    0.4; ...       % connections to unit 1 
              0.4  0.6    -1.5; ...     % connections to unit 2 
             -1    0.5    0.6];         % connections to unit 3 

% Now standard time vector with step dt
dt = 0.001;
tmax = 2;
tvector = 0:dt:tmax;
Nt = length(tvector);

tau = 0.01;                             % 10ms time constant for changes
exp_minus_dt_over_tau = exp(-dt/tau);   % this saves calculating it many times

% Now parameters for the sigmoid firing rate function, which will follow:
% rate = rmax / ( 1 + exp( -(inputs - threshold)/rate_sigma ) )
rmax = 100;                             % maximum rate
threshold = 20;                         % input needed to reach 1/2-max
rate_sigma = 10;                        % inverse steepness of the sigmoid

%% First of three methods 
rates = zeros(Nunits,Nt);               % initialize rates to zero              
for i = 2:Nt
    
    % slow way with for loops
    input = zeros(Nunits,1);
    for unit = 1:Nunits
        
        for pre_unit = 1:Nunits
            input(unit) = input(unit) + gcoupling(unit,pre_unit)*rates(pre_unit,i-1);
        end
    end
        
    rates_ss = rmax./(1+exp(-(input-threshold)/rate_sigma));    % steady state is a sigmoid of inputs
    
    rates(:,i) = rates_ss + ...
        ( rates(:,i-1) -rates_ss)*exp_minus_dt_over_tau;        % update rates of all units with exponential method
end

figure()
plot(tvector,rates)

%% Second of three methods
rates2 = zeros(Nunits,Nt);
for i = 2:Nt
    
    % The following single line is a matrix multuplication where
    % "rates(:,i-1)" is a column vector. This line reproduces the two
    % internal "for loops" in the first method.
    input2 = gcoupling*rates2(:,i-1);                   
    
    rates_ss2 = rmax./(1+exp(-(input2-threshold)/rate_sigma));  % steady state is a sigmoid of inputs
    
    rates2(:,i) = rates_ss2 + ...
        ( rates2(:,i-1) -rates_ss2)*exp_minus_dt_over_tau;      % update rates of all units with exponential method
end

figure()
plot(tvector,rates2)

%% Third of three methods
gcoupling3 = gcoupling';                        % Make the coupling matrix so that element (i,j) is strength from i to j.

rates3 = zeros(Nt,Nunits);
for i = 2:Nt
    
    % The following single line is a matrix multuplication where
    % "rates(i-1,:)" is a row vector. This line is equivalent to the two
    % internal "for loops" in the first method.
    input3 = rates3(i-1,:)*gcoupling3;    
    
    rates_ss3 = rmax./(1+exp(-(input3-threshold)/rate_sigma));  % steady state is a sigmoid of inputs
    
    rates3(i,:) = rates_ss3 + ...
        ( rates3(i-1,:) -rates_ss3)*exp_minus_dt_over_tau;      % update rates of all units with exponential method
end

figure()
plot(tvector,rates3)

