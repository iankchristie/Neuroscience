
strong = 14;
weak = 13;

% Wee = 0:.2:1;
% Wii = 0:.5:1;
% Wei = .0:.5:1;
% Wie = -1:.5:0;
% Wx1 = 0:.2:.4;
% Wx2 = 0:.2:.4;

% Wee = 0:.25:1;
% Wii = -.1:.1:0;
% Wei = .0:.125:.5;
% Wie = -.5:.125:0;
% Wx1 = 0:.05:.2;
% Wx2 = 0:.05:.2;

Wee = .5;
Wii = 0;
Wei = .25;
Wie = -.25;


Wxe1 = 0:.01:.2;
Wxe2 = 0:.01:.2;
Wxi1 = 0:.01:.2;
Wxi2 = 0:.01:.2;


w = [1 0; 1 0; 0 1; 0 1];

t0 = 0;
dt = .001;
tend = 2;
timeVect = t0:dt:tend;
tau = .004;

z = zeros(2,.2/dt);
os = (1.15)*strong*ones(1,.6/dt);
ow = (1.15)*weak*ones(1,.6/dt);
ou = [os;ow];
od = [ow;os];

inputu = [z ou z [0;0]];
inputd = [z od z];

Itotal = [inputu inputd];

v = zeros(4,length(timeVect));

% uniType1 = cell(length(Wee),length(Wii),length(Wei),length(Wie),length(Wx));
% uniType2 = cell(length(Wee),length(Wii),length(Wei),length(Wie),length(Wx));
% DSType1 = cell(length(Wee),length(Wii),length(Wei),length(Wie),length(Wx));

parfor i = 1: length(Wxe1),
    uniType1 = {};
    uniType2 = {};
    DSType1 = {};
    for j = 1: length(Wxe2),
        for k = 1: length(Wxi1),
            for l = 1: length(Wxi2),
                m = [Wee        Wei         Wxe1(i)      Wxi1(k);
                     Wie        Wii         0            0;
                     Wxe2(j)          Wxi2(l)     Wee          Wei;
                     0    0           Wie          Wii];

                 r = runISNTime(timeVect, dt, tau, m, Itotal, w, v);

                 if unidirectionalType1(r, dt) == 1,
                     uniType1{end+1} = struct('Wee',Wee,'Wii',Wii,'Wei',Wei,'Wie',Wie,'Wxe1',Wxe1(i), 'Wxe2', Wxe2(j), 'Wxi1', Wxi1(k), 'Wxi2', Wxi2(l));
                 end
                 if unidirectionalType2(r, dt) == 1,
                     uniType2{end+1} = struct('Wee',Wee,'Wii',Wii,'Wei',Wei,'Wie',Wie,'Wxe1',Wxe1(i), 'Wxe2', Wxe2(j), 'Wxi1', Wxi1(k), 'Wxi2', Wxi2(l));
                 end
                 if DirectionalType1(r, dt) == 1,
                     DSType1{end+1} = struct('Wee',Wee,'Wii',Wii,'Wei',Wei,'Wie',Wie,'Wxe1',Wxe1(i), 'Wxe2', Wxe2(j), 'Wxi1', Wxi1(k), 'Wxi2', Wxi2(l));
                 end
            end
        end
    end
        parsave(sprintf('uniType1%d.mat', i), uniType1);
        parsave(sprintf('uniType2%d.mat', i), uniType2);
        parsave(sprintf('DsType1%d.mat', i), DSType1);
        disp(['Done with ' num2str(i)]);
end



