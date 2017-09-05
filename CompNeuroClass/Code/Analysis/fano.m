% fano.m plots Fano factor as a function of time
% assumes an array called spikes exists with a number of trials
% and the time step is given already as dt
% Fano factor takes the number of spikes in a given time window on each
% trial and caclulated the variance in that number, divided by the mean.
% Published version follows multi_poisson_ramp.m

% dt=0.0001;                      % timestep if not provided already
[rows cols] = size(spikes)      % rows = no.of trials, cols = no. of time steps    
ntrials=rows                    % no. of trials    
tmax = (cols-1)*dt;             % maximum time
t = 0:dt:tmax;                  % time vector

figure()
cumspikes=cumsum(spikes,2);     %cumulative sum

plot(t,cumspikes)               % plot cumulative sums of spikes 

sqrcumspikes=cumspikes.*cumspikes;  % Square of number of spikes up to that time

meanN=sum(cumspikes)/ntrials;       % Mean number of spikes as a function of time
sqrN=sum(sqrcumspikes)/ntrials;     % Mean of squared number of spikes as function of time

figure()                            % New figure
subplot(3,1,1)                      % Make 3 subplots
plot(t,meanN)                       % In first subplot, give mean no. of spikes up to each time
ylabel('Mean of N, no. of spikes')
subplot(3,1,2)
plot(t,sqrN-meanN.*meanN)           % In next subplot, the variance of spike no. with time
ylabel('Var(N)')
subplot(3,1,3)
ff = (sqrN-meanN.*meanN)./(max(meanN,0.001));  % In final subplot, the Fano factor
plot(t,ff)
xlabel('Time (sec)')
ylabel('Fano factor')

