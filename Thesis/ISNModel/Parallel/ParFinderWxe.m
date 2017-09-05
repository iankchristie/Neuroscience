strong = 15:18;
weak = 14:17;

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

Wxi = 0:.05:.2;
Wxe1 = 0:.25:1;
Wxe2 = 0:.25:1;

if ~exist('ParFinderWxeData', 'dir')
    mkdir('ParFinderWxeData');
end

for s = 1:length(strong),
    for w = 1: length(weak), 
        if (strong(s) > weak(w))
            if ~exist(sprintf('ParFinderWxeData/S%dW%d', strong(s), weak(w)), 'dir')
                mkdir(sprintf('ParFinderWxeData/S%dW%d', strong(s), weak(w)))
            end
        end
    end
end

delete(gcp('nocreate'))
parpool(2)

parfor s = 1: length(strong),
    for w = 1: length(weak),
        if strong(s) > weak(w),
            Itotal = createInputISN(strong(s), weak(w), dt);
            ds = {};
            dssup = {};
            uni = {};
            halfuni = {};
            unsel = {};
            
            for i = 1: length(Wxi),
                for j = 1: length(Wxe1),
                    for k = 1: length(Wxe2),
                        
                        m = getConnectionMatrix2('Wxi1',Wxi(i),'Wxi2',Wxi(i),'Wxe1',Wxe1(j),'Wxe2',Wxe2(k));
                        
                        r = runISNTime(time,dt,tau,m,Itotal,inputMatrix,tempVector);
                        
                        if DirectionalType1(r,dt) == 1,
                            if SuppressionOfInhibition(r,dt),
                                dssup{end+1} = struct('m',m,'Wxi',Wxi(i),'Wxe1',Wxe1(j),'Wxe2',Wxe2(k),'Strong',strong(s),'Weak',weak(w));
                            else
                                ds{end+1} = struct('m',m,'Wxi',Wxi(i),'Wxe1',Wxe1(j),'Wxe2',Wxe2(k),'Strong',strong(s),'Weak',weak(w));
                            end
                        end
                        if unidirectionalType1(r,dt) == 1,
                            uni{end+1} = struct('m',m,'Wxi',Wxi(i),'Wxe1',Wxe1(j),'Wxe2',Wxe2(k),'Strong',strong(s),'Weak',weak(w));
                        end
                        if unidirectionalType2(r,dt) == 1,
                            halfuni{end+1} = struct('m',m,'Wxi',Wxi(i),'Wxe1',Wxe1(j),'Wxe2',Wxe2(k),'Strong',strong(s),'Weak',weak(w));
                        end
                        if UnSelective(r,dt) == 1,
                            unsel{end+1} = struct('m',m,'Wxi',Wxi(i),'Wxe1',Wxe1(j),'Wxe2',Wxe2(k),'Strong',strong(s),'Weak',weak(w));
                        end
                        
                    end
                end
            end
            parsave(sprintf('ParFinderWxeData/S%dW%d/AllDS.mat', strong(s),weak(w)), ds);
            parsave(sprintf('ParFinderWxeData/S%dW%d/AllDSSup.mat', strong(s),weak(w)), dssup);
            parsave(sprintf('ParFinderWxeData/S%dW%d/AllUni.mat', strong(s),weak(w)), uni);
            parsave(sprintf('ParFinderWxeData/S%dW%d/AllHalfUni.mat', strong(s),weak(w)), halfuni);
            parsave(sprintf('ParFinderWxeData/S%dW%d/AllUnSel.mat', strong(s),weak(w)), unsel);
            disp(['          Done with weak: ' num2str(weak(w))]);
        end
    end
    disp(['Done with Strong: ' num2str(strong(s))]);
end




