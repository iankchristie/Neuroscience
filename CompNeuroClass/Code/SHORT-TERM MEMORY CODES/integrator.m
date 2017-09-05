% integrator.m
% simple file to show the need for fine tuning of feedback to 
% obtain graded memory in the manner of an integrator.
tic
dt = 0.005;                     % time step
tmax = 25;                      % maximum time
t = 0:dt:tmax;                  % set up vector of time
r=zeros(size(t));               % set up vector of rates, initially zero

tau = 0.050;                    % time constant for the network
W = 0.99;                          % recurrent excitatory feedback strength
Ith = 0;                      % threshold current for firing

Iapp0 = 0.5;                    % value of applied current
Ion = 5;                        % time to start applied current
Ioff = 15;                       % time to stop applied current

sigma = 0.1;                   % level of noise in current

Iapp = zeros(size(t));          % initialize vector of applied currents as zero
for i = 1:length(t)                 % run through all the elements
    if t(i) > Ion && t(i) <= Ioff   % if the time is between the start as stop times for applied current
        Iapp(i) = Iapp0;            % make the applied current value non-zero
    end
end

for i = 2:length(t)                             % run through time steps for integration
    Itot = Iapp(i) + r(i-1)*W + ...             % total current is applied current + feedback
        sigma*randn(1)/sqrt(dt);                % + noise  
    rinf = (Itot - Ith)*heaviside(Itot-Ith);    % steady state firing rate depends on current
    if Itot == Ith                              % problem arises since heaviside(0) is Nan
        rinf = 0.0;                             % so reset this to be equal to zero
    end
    r(i) = rinf + (r(i-1)-rinf)*exp(-dt/tau);   % integrate the firing rate towards stedy state
end

xlabel('time,t');                   
ylabel('rate,r');
plot(t,r,'b')                        % plot firing rate against time
toc