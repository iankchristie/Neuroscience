% poisson.m basic Poisson spike train
clear
dt=0.001;
tmax = 1000;
t=0:dt:tmax;                  % run for 
rate = 10;                  % constant rate of 10Hz
spikes=zeros(size(t));
for i=1:length(t)
    if (rand < dt*rate) 
        spikes(i) = 1;
    end
end
