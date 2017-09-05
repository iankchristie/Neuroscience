function [out] = clusterSimulation(strong, weak)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

out = 0;

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

Wxe1 = 0:.05:1;
Wxe2 = 0:.05:1;
Wxi1 = 0:.05:1;
Wxi2 = 0:.025:1;

Itotal = createInputISN(strong, weak, dt);

cube = cell(length(Wxe1),length(Wxe2),length(Wxi1),length(Wxi2));

for i = 1: length(Wxe1),
    for j = 1: length(Wxe2),
        for k = 1: length(Wxi1),
            for l = 1: length(Wxi2),

                m = getConnectionMatrix2('Wxe1',Wxe1(i),'Wxe2',Wxe2(j),'Wxi1',Wxi1(k),'Wxi2',Wxi2(l));

                r = runISNTime(time,dt,tau,m,Itotal,inputMatrix,tempVector);

                [LUe, LDe, RUe, RDe, ~, ~, SS, LUi, LDi, RUi, RDi, ~, ~] = analyzeISNOutput(r,dt);

                cube{i,j,k,l} = struct('m',m,'Wxe1',Wxe1(i),'Wxe2',Wxe2(j),'Wxi1',Wxi1(k),'Wxi2',Wxi2(l),...
                                     'LUe', LUe, 'LDe', LDe, 'RUe', RUe, 'RDe', RDe,'LUi', LUi,...
                                     'LDi', LDi, 'RUi', RUi, 'RDi', RDi,'SS', SS,...
                                     'Strong',strong,'Weak',weak,'Response','None');

%                 if DirectionalType1(r,dt) == 1,
%                     if SuppressionOfInhibition(r,dt),
%                         cube{i,j,k}.tag = 'DSSup';
%                     else
%                         cube{i,j,k}.tag = 'DS';
%                     end
%                 end
%                 if unidirectionalType1(r,dt) == 1,
%                     if UniSuppressionofInhibition(r,dt) == 1,
%                         cube{i,j,k}.tag = 'UniSup';
%                     else
%                         cube{i,j,k}.tag = 'Uni';
%                     end
%                 end
%                 if unidirectionalType2(r,dt) == 1,
%                     cube{i,j,k}.tag = 'HalfUni';
%                 end
%                 if UnSelective(r,dt) == 1,
%                     cube{i,j,k}.tag = 'UnSel';
%                 end
%                 if NoneResponsive(r,dt) == 1,
%                     cube{i,j,k}.tag = 'NoneRes';
%                 end
            end
        end
    end
end
save(sprintf('WholeCubesData/S%dW%d/Cube.mat', strong,weak), 'cube');

out = out + 1;

end

