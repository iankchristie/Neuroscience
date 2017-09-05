% STA.m
% Spike-triggered-average 
% requires arrays and variables as follows:
% dt , time step
% t =0:dt:tmax , time array
% Iapp(Ncells,length(t)) noisy applied current to each cell to base response on
% spikes(Ncells,length(t)) spike array for each cell
%%%%%%%%%%%%%%%%%%%%%%%%%%%%Code Added Below%%%%%%%%%%%%%%%%%%%%%%%%%%
Ncells = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%Code Added Above%%%%%%%%%%%%%%%%%%%%%%%%%%
tminus = 0.20; % How long before spike time to begin
tplus = 0.050;  % How long after spike time to continue
nminus = tminus/dt; % Number of time points before zero
nplus = tplus/dt;   % Number of time points after zero
nt = length(t);     % length of original data set
sum_I = zeros(Ncells,nminus+nplus+1);  % STA will accumulate here
tcorr = -tminus:dt:tplus;   % Vector of time points for STA   
Iapp(1,:) = Iapp(1,:) - mean(Iapp(1,:)); % Removes mean applied current
for cell = 1:Ncells
    spikeposition = find(spikes(cell,:));  % Time bins for each spike
    totalspikes = length(spikeposition)    % Total number of spikes
    for spike = 1:totalspikes
        ispike = spikeposition(spike);     % ispike is the bin containing a spike
        imin = max(1,ispike-nminus);       % Bin to start measuring stimulus
        imax = min(nt,ispike+nplus);       % Bin to finish measuring
        % The following lines put the stimulus, Iapp, into bins shifted 
        % by the spike time (ispike)
        for i = imin:imax                  
            sum_I(cell,i-ispike+nminus+1) = sum_I(cell,i-ispike+nminus+1) ...
                                            + Iapp(1,i)/totalspikes;
        end
    end
    
    
end

figure;
plot(tcorr,sum_I)
title('Spike Triggered Average')
legend('cell1 ', 'cell2', 'cell3')
xlabel('tstim - tspike (sec)')
ylabel('Mean Stimulus Current')
