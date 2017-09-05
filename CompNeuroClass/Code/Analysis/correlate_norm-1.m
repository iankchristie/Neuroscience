% correlate.m calculates autocorrelation
% a vector "spikes" matching a time vector "t" with time bins 
% of width "dt" should already be created
bindt=0.01;             % size of bins for correlation calculations
nscale = bindt/dt       % change of scale from spikes vector to binspikes
nbins=t(end)/bindt      % number of bins in binspikes
binspikes=zeros(1,nbins);   

tcorrmax = 1;         % calculate correlations up to 1s

for i=1:nbins
    binspikes(i) = sum(spikes(nscale*(i-1)+1:nscale*i)); % binspikes is a vector of spikes but at 
                                                         % a coarser timescale
                                                         
end

tcorr=0:bindt:tcorrmax; % time-vector for the calculation of correlations

ncorr = length(tcorr); %number of points of time at which correlation is calculated

corr=zeros(size(tcorr)); % set up the vector that will contain the correlations

for j=1:ncorr % this will generate ncorr values 
    corr(j) = binspikes(j:nbins)*binspikes(1:nbins+1-j)'/(nbins-j) ... 
        - mean(binspikes(j:nbins))*mean(binspikes(1:nbins+1-j));
end

plot(tcorr,corr)


