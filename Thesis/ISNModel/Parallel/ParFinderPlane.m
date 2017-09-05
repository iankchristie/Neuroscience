strong = 17;
weak = 12;

t0 = 0;
dt = .001;
tend = 2;
time = t0:dt:tend;
tau = .004;

inputMatrix = [1 0;
               1 0;
               0 1;
               0 1];
 
tempVector = zeros(4,length(time));

%%%%%The model%%%%%
%       E1      I1      E2      I2
%E1     Wee     Wei     Wxe1    Wxi1
%I1     Wie     Wii     0       0
%E2     Wxe2    Wxi2    Wee     Wei
%I2     0       0       Wie     Wii

Wee = .5;
Wei = .25;
Wie = -.25;
Wii = 0;

inc = 1:6;
slopes = 1.33.^inc;
Wxi1 = 0:.025:1;
Wxe1 = 0:.025:1;
Wxe2 = 0:.025:1;


if ~exist('ParFinderPlaneData', 'dir')
    mkdir('ParFinderPlaneData');
end

for s = 1:length(slopes)
    if ~exist(sprintf('ParFinderPlaneData/Slope%d', inc(s)), 'dir')
        mkdir(sprintf('ParFinderPlaneData/Slope%d', inc(s)))
    end
end

delete(gcp('nocreate'))
parpool(2)

Itotal = createInputISN(strong, weak, dt);

parfor s = 1: length(slopes),
    ds = {};
    dssup = {};
    uni = {};
    halfuni = {};
    unsel = {};
    for i = 1: length(Wxi1),
        for j = 1: length(Wxe1),
            for k = 1: length(Wxe2),

                m = getConnectionMatrix2('Wxe1',Wxe1(j),'Wxe2',Wxe2(k),'Wxi1',Wxi1(i),'Wxi2',(1/slopes(s))*Wxi1(i));

                r = runISNTime(time,dt,tau,m,Itotal,inputMatrix,tempVector);

                if DirectionalType1(r,dt) == 1,
                    if SuppressionOfInhibition(r,dt),
                        dssup{end+1} = struct('m',m,'Wxe1',Wxe1(j),'Wxe2',Wxe2(k),'Wxi1',Wxi1(i),'Wxi2',(1/slopes(s))*Wxi1(i),'Strong',strong,'Weak',weak,'Slope',slopes(s));
                    else
                        ds{end+1} = struct('m',m,'Wxe1',Wxe1(j),'Wxe2',Wxe2(k),'Wxi1',Wxi1(i),'Wxi2',(1/slopes(s))*Wxi1(i),'Strong',strong,'Weak',weak,'Slope',slopes(s));
                    end
                end
                if unidirectionalType1(r,dt) == 1,
                    uni{end+1} = struct('m',m,'Wxe1',Wxe1(j),'Wxe2',Wxe2(k),'Wxi1',Wxi1(i),'Wxi2',(1/slopes(s))*Wxi1(i),'Strong',strong,'Weak',weak,'Slope',slopes(s));
                end
                if unidirectionalType2(r,dt) == 1,
                    halfuni{end+1} = struct('m',m,'Wxe1',Wxe1(j),'Wxe2',Wxe2(k),'Wxi1',Wxi1(i),'Wxi2',(1/slopes(s))*Wxi1(i),'Strong',strong,'Weak',weak,'Slope',slopes(s));
                end
                if UnSelective(r,dt) == 1,
                    unsel{end+1} = struct('m',m,'Wxe1',Wxe1(j),'Wxe2',Wxe2(k),'Wxi1',Wxi1(i),'Wxi2',(1/slopes(s))*Wxi1(i),'Strong',strong,'Weak',weak,'Slope',slopes(s));
                end

            end
        end
    end
    parsave(sprintf('ParFinderPlaneData/Slope%d/AllDS.mat', inc(s)), ds);
    parsave(sprintf('ParFinderPlaneData/Slope%d/AllDSSup.mat', inc(s)), dssup);
    parsave(sprintf('ParFinderPlaneData/Slope%d/AllUni.mat', inc(s)), uni);
    parsave(sprintf('ParFinderPlaneData/Slope%d/AllHalfUni.mat', inc(s)), halfuni);
    parsave(sprintf('ParFinderPlaneData/Slope%d/AllUnSel.mat', inc(s)), unsel);
    disp(['          Done with slope: ' num2str(slopes(s))]);
end

