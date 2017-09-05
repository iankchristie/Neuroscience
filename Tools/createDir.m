strong = 2:20;
weak = 1:19;

if ~exist('data', 'dir')
    mkdir('data');
end

for s = 1:length(strong),
    for w = 1: length(weak), 
        if (strong(s) > weak(w))
            if ~exist(sprintf('data/S%dW%d', strong(s), weak(w)), 'dir')
                mkdir(sprintf('data/S%dW%d', strong(s), weak(w)))
            end
        end
    end
end