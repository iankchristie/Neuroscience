
strong = 5:10;
weak = 1:5;

Wr = 0:.01:.4;
W12 = 0:.01:1;
W21 = 0:.01:1;

w = eye(2);

t0 = 0;
dt = .001;
tend = 2;
timeVect = t0:dt:tend;
tau = .004;

if ~exist('ParFinderData', 'dir')
    mkdir('ParFinderData');
end

for s = 1:length(strong),
    for w = 1: length(weak), 
        if ~exist(sprintf('ParFinderData/S%dW%d', strong(s), weak(w)), 'dir')
            mkdir(sprintf('ParFinderData/S%dW%d', strong(s), weak(w)))
        end
    end
end

parfor s = 1:length(strong),
    for w = 1: length(weak), 
        z = zeros(2,.2/dt);
        os = (1.15)*strong(s)*ones(1,.6/dt);
        ow = (1.15)*weak(w)*ones(1,.6/dt);
        ou = [os;ow];
        od = [ow;os];

        inputu = [z ou z [0;0]];
        inputd = [z od z];

        Itotal = [inputu inputd];
        
        for i = 1: length(Wr),
            uniType1 = {};
            uniType2 = {};
            DSType1 = {};
            for j = 1: length(W12),
                for k = 1: length(W21),
                    m = [Wr(i) W12(j); 
                        W21(k) Wr(i)];

                    r = runModelTime(timeVect, dt, tau, m, Itotal, eye(2));

                    if unidirectionalType1(r, dt) == 1,
                        uniType1{end+1} = struct('Wr',Wr(i),'W12',W12(j),'W21',W21(k),'S',strong(s),'W',weak(w));
                    end
                    if unidirectionalType2(r, dt) == 1,
                        uniType2{end+1} = struct('Wr',Wr(i),'W12',W12(j),'W21',W21(k),'S',strong(s),'W',weak(w));
                    end
                    if DirectionalType1(r, dt) == 1,
                        DSType1{end+1} = struct('Wr',Wr(i),'W12',W12(j),'W21',W21(k),'S',strong(s),'W',weak(w));
                    end
                end
            end
            parsave(sprintf('ParFinderData/S%dW%d/uniType1%d.mat', strong(s),weak(w), i), uniType1);
            parsave(sprintf('ParFinderData/S%dW%d/uniType2%d.mat', strong(s),weak(w), i), uniType2);
            parsave(sprintf('ParFinderData/S%dW%d/DS%d.mat', strong(s),weak(w), i), DSType1);
        end
    end
    disp(['Done with ' num2str(s)]);
end



