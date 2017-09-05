
strong = 5:10;
weak = 1:5;

cd /Users/ianchristie/Documents/MATLAB/Coupled-Pair/Data/ParFinderData

for s = 1:length(strong),
    for w = 1: length(weak), 
        openfig(sprintf('S%dW%d/Space.fig', strong(s), weak(w)));
    end
end