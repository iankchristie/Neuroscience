clear       % good to start by clearing out all old values
dt=0.001    % dt is the time step
t=0:dt:100;  % t is a vector of numbers from 0 to 100 in steps of dt
rate=10.1+10*cos(10*pi*t);   % rates oscillate in time
spikes=zeros(size(t));
for i=1:length(t)   % beginning of a loop that starts with i=1 and steps i up by 1 until it i=length(t)
    if rand < rate(i)*dt
        spikes(i) = 1;
    end
end             % this end marks the end of the for loop, so go back to line 7 and increase i unless i=length(t) already
subplot(2,1,1); % plot a figure with 2 rows and one column of graphs: start at position 1.
plot(t,rate);      % plot rate against t
axis([0 5 0 max(rate)])
subplot(2,1,2); % go to graph in the second position of the 2x1 set of graphs
plot(t,spikes);      % plot spikes against t
axis([0 5 -0.1 1.1])
