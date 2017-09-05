
strong = 9:16;
weak = 6:13;

Wee = .5;
Wii = 0;
Wei = .25;
Wie = -.25;
Wxbase = .2;

Wx = -.2:.02:.2;
Wxi1 = 0:.02:1;
Wxi2 = 0:.02:1;

W = [1 0; 1 0; 0 1; 0 1];

t0 = 0;
dt = .001;
tend = 2;
timeVect = t0:dt:tend;
tau = .004;

v = zeros(4,length(timeVect));

if ~exist('ParFinderM3Data', 'dir')
    mkdir('ParFinderM3Data');
end

for s = 1:length(strong),
    for w = 1: length(weak), 
        if (strong(s) > weak(w))
            if ~exist(sprintf('ParFinderM3Data/S%dW%d', strong(s), weak(w)), 'dir')
                mkdir(sprintf('ParFinderM3Data/S%dW%d', strong(s), weak(w)))
            end
        end
    end
end

parfor s = 1:length(strong),
    for w = 1: length(weak), 
        if (strong(s) > weak(w))

            Itotal = createInputISN(strong(s), weak(w), dt);

            for i = 1: length(Wx),
                uniType1 = {};
                uniType2 = {};
                DSType1 = {};
                for j = 1: length(Wxi1),
                    for k = 1: length(Wxi2),
                            %E1             %I1         %E2             %I2
                        m = [Wee            Wei         Wxbase+Wx(i)    Wxi1(j);    %E1
                            Wie             Wii         0               0;          %I1
                            Wxbase-Wx(i)    Wxi2(k)     Wee             Wei;        %E2
                            0               0           Wie             Wii];       %I2

                        r = runISNTime(timeVect, dt, tau, m, Itotal, W,v);
                        
                        [LUe, LDe, RUe, RDe, LDI, RDI, SS] = analyzeISNOutput(r,dt);

                        if unidirectionalType1(LDI, RDI, SS) == 1,
                            uniType1{end+1} = struct('Wr',Wx(i),'W12',Wxi1(j),'W21',Wxi2(k),'S',strong(s),'W',weak(w));
                        end
                        if unidirectionalType2(LUe, LDe, RUe, RDe, SS) == 1,
                            uniType2{end+1} = struct('Wr',Wx(i),'W12',Wxi1(j),'W21',Wxi2(k),'S',strong(s),'W',weak(w));
                        end
                        if DirectionalType1(LDI, RDI, SS) == 1,
                            DSType1{end+1} = struct('Wr',Wx(i),'W12',Wxi1(j),'W21',Wxi2(k),'S',strong(s),'W',weak(w));
                        end
                    end
                end
                parsave(sprintf('ParFinderM3Data/S%dW%d/uniType1%d.mat', strong(s),weak(w), i), uniType1);
                parsave(sprintf('ParFinderM3Data/S%dW%d/uniType2%d.mat', strong(s),weak(w), i), uniType2);
                parsave(sprintf('ParFinderM3Data/S%dW%d/DS%d.mat', strong(s),weak(w), i), DSType1);
            end
        end
    end
    disp(['Done with ' num2str(s)]);
end



