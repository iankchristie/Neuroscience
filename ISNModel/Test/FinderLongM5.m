strong = 9:16;
weak = 6:13;

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

Wxe = 0:1:1;
Wxi1 = 0:1:1;
Wxi2 = 0:1:1;

ds = {};
uni = {};
halfuni = {};
unsel = {};

if ~exist('ParFinderM5Data', 'dir')
    mkdir('ParFinderM5Data');
end

for s = 1:length(strong),
    for w = 1: length(weak), 
        if (strong(s) > weak(w))
            if ~exist(sprintf('ParFinderM5Data/S%dW%d', strong(s), weak(w)), 'dir')
                mkdir(sprintf('ParFinderM5Data/S%dW%d', strong(s), weak(w)))
            end
        end
    end
end

for s = 1: length(strong),
    for w = 1: length(weak),
        if strong(s) > weak(w),
            Itotal = createInputISN(strong(s), weak(w), dt);
            for i = 1: length(Wxe),
                for j = 1: length(Wxi1),
                    for k = 1: length(Wxi2),
                        
                        m = getConnectionMatrix('Wxe',Wxe(i),'Wxi1',Wxi1(j),'Wxi2',Wxi2(k));
                        
                        r = runISNTime(time,dt,tau,m,Itotal,inputMatrix,tempVector);
                        
                        if DirectionalType1(r,dt) == 1,
                            ds{end+1} = struct('m',m,'Wxe',Wxe(i),'Wxi1',Wxi1(j),'Wxi2',Wxi2(k),'Strong',strong(s),'Weak',weak(w));
                        end
                        if unidirectionalType1(r,dt) == 1,
                            uni{end+1} = struct('m',m,'Wxe',Wxe(i),'Wxi1',Wxi1(j),'Wxi2',Wxi2(k),'Strong',strong(s),'Weak',weak(w));
                        end
                        if unidirectionalType2(r,dt) == 1,
                            halfuni{end+1} = struct('m',m,'Wxe',Wxe(i),'Wxi1',Wxi1(j),'Wxi2',Wxi2(k),'Strong',strong(s),'Weak',weak(w));
                        end
                        if UnSelective(r,dt) == 1,
                            unsel{end+1} = struct('m',m,'Wxe',Wxe(i),'Wxi1',Wxi1(j),'Wxi2',Wxi2(k),'Strong',strong(s),'Weak',weak(w));
                        end
                        
                    end
                end
            end
            disp(['          Done with weak: ' num2str(weak(w))]);
            save(sprintf('ParFinderM5Data/S%dW%d/AllDS.mat', strong(s),weak(w)), 'ds');
            save(sprintf('ParFinderM5Data/S%dW%d/AllUni.mat', strong(s),weak(w)), 'uni');
            save(sprintf('ParFinderM5Data/S%dW%d/AllHalfUni.mat', strong(s),weak(w)), 'halfuni');
            save(sprintf('ParFinderM5Data/S%dW%d/AllUnSel.mat', strong(s),weak(w)), 'unsel');
            ds = {};
            uni = {};
            halfuni = {};
            unsel = {};
        end
    end
    disp(['Done with Strong: ' num2str(strong(s))]);
end








