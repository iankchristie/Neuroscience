strong = 15:18;
weak = 14:17;

t0 = 0;
dt = .005;
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

Wxe = 0:.2:1;
Wxi1 = 0:.2:1;
Wxi2 = 0:.2:1;

if ~exist('WholeCubesData', 'dir')
    mkdir('WholeCubesData');
end

for s = 1:length(strong),
    for w = 1: length(weak), 
        if (strong(s) > weak(w))
            if ~exist(sprintf('WholeCubesData/S%dW%d', strong(s), weak(w)), 'dir')
                mkdir(sprintf('WholeCubesData/S%dW%d', strong(s), weak(w)))
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

            cube = cell(length(Wxe),length(Wxi1),length(Wxi2));
            
            for i = 1: length(Wxe),
                for j = 1: length(Wxi1),
                    for k = 1: length(Wxi2),
                        
                        m = getConnectionMatrix2('Wxe1',Wxe(i),'Wxe2',Wxe(i),'Wxi1',Wxi1(j),'Wxi2',Wxi2(k));
                        
                        r = runISNTime(time,dt,tau,m,Itotal,inputMatrix,tempVector);
                        
                        [LUe, LDe, RUe, RDe, ~, ~, SS, LUi, LDi, RUi, RDi, ~, ~] = analyzeISNOutput(r,dt);
                        
                        cube{i,j,k} = struct('m',m,'Wxe',Wxe(i),'Wxi1',Wxi1(j),'Wxi2',Wxi2(k),...
                                             'LUe', LUe, 'LDe', LDe, 'RUe', RUe, 'RDe', RDe,...
                                             'SS', SS, 'LUi', LUi, 'LDi', LDi, 'RUi', RUi, 'RDi', RDi,...
                                             'Strong',strong(s),'Weak',weak(w),'tag','None');
                        
                        if DirectionalType1(r,dt) == 1,
                            if SuppressionOfInhibition(r,dt),
                                cube{i,j,k}.tag = 'DSSup';
                            else
                                cube{i,j,k}.tag = 'DS';
                            end
                        end
                        if unidirectionalType1(r,dt) == 1,
                            if UniSuppressionofInhibition(r,dt) == 1,
                                cube{i,j,k}.tag = 'UniSup';
                            else
                                cube{i,j,k}.tag = 'Uni';
                            end
                        end
                        if unidirectionalType2(r,dt) == 1,
                            cube{i,j,k}.tag = 'HalfUni';
                        end
                        if UnSelective(r,dt) == 1,
                            cube{i,j,k}.tag = 'UnSel';
                        end
                        if NoneResponsive(r,dt) == 1,
                            cube{i,j,k}.tag = 'NoneRes';
                        end
                    end
                end
            end
            parsave(sprintf('WholeCubesData/S%dW%d/Cube.mat', strong(s),weak(w)), cube);
            disp(['          Done with weak: ' num2str(weak(w))]);
        end
    end
    disp(['Done with Strong: ' num2str(strong(s))]);
end




