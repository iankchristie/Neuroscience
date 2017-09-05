% isi.m calculates distribution of inter-spike intervals
% assumes a vector of spiketimes "spikes" and the 
% time bin width, "dt" are already defined
sptimes = dt*find(spikes);
nspikes = length(sptimes)
isis = diff(sptimes);

hist(isis,100)

