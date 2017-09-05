
strong = 9:16;
weak = 6:13;

Wee = .5;
Wii = 0;
Wei = .25;
Wie = -.25;

Wxe = 0:.4:.4;
Wxi1 = 0:1:1;
Wxi2 = 0:1:1;

W = [1 0; 1 0; 0 1; 0 1];

t0 = 0;
dt = .001;
tend = 2;
timeVect = t0:dt:tend;
tau = .004;

v = zeros(4,length(timeVect));

if ~exist('ParFinderM2Data', 'dir')
    mkdir('ParFinderM2Data');
end

for s = 1:length(strong),
    for w = 1: length(weak), 
        if (strong(s) > weak(w))
            if ~exist(sprintf('ParFinderM2Data/S%dW%d', strong(s), weak(w)), 'dir')
                mkdir(sprintf('ParFinderM2Data/S%dW%d', strong(s), weak(w)))
            end
        end
    end
end

parfor s = 1:length(strong),
    for w = 1: length(weak), 
        if (strong(s) > weak(w))
            z = zeros(2,.2/dt);
            os = (1.15)*strong(s)*ones(1,.6/dt);
            ow = (1.15)*weak(w)*ones(1,.6/dt);
            ou = [os;ow];
            od = [ow;os];

            inputu = [z ou z [0;0]];
            inputd = [z od z];

            Itotal = [inputu inputd];

            for i = 1: length(Wxe),
                uniType1 = {};
                uniType2 = {};
                DSType1 = {};
                for j = 1: length(Wxi1),
                    for k = 1: length(Wxi2),
                        m = [Wee    Wei     Wxe(i)     Wxi1(j);
                            Wie     Wii     0       0;
                            Wxe(i)      Wxi2(k)    Wee     Wei;
                            0     0       Wie     Wii];

                        r = runISNTime(timeVect, dt, tau, m, Itotal, W,v);

                        if unidirectionalType1(r, dt) == 1,
                            uniType1{end+1} = struct('Wr',Wxe(i),'W12',Wxi1(j),'W21',Wxi2(k),'S',strong(s),'W',weak(w));
                        end
                        if unidirectionalType2(r, dt) == 1,
                            uniType2{end+1} = struct('Wr',Wxe(i),'W12',Wxi1(j),'W21',Wxi2(k),'S',strong(s),'W',weak(w));
                        end
                        if DirectionalType1(r, dt) == 1,
                            DSType1{end+1} = struct('Wr',Wxe(i),'W12',Wxi1(j),'W21',Wxi2(k),'S',strong(s),'W',weak(w));
                        end
                    end
                end
                parsave(sprintf('ParFinderM2Data/S%dW%d/uniType1%d.mat', strong(s),weak(w), i), uniType1);
                parsave(sprintf('ParFinderM2Data/S%dW%d/uniType2%d.mat', strong(s),weak(w), i), uniType2);
                parsave(sprintf('ParFinderM2Data/S%dW%d/DS%d.mat', strong(s),weak(w), i), DSType1);
            end
        end
    end
    disp(['Done with ' num2str(s)]);
end



