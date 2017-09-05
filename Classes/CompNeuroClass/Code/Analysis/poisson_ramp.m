clear
dt=0.0001;
t=0:dt:200;
spikes=zeros(size(t));
for i=1:length(t)
    rate = 5+t(i);
    if (rand < dt*rate) 
        spikes(i) = 1;
    end
end
