function [cube] = ISN3D115(strong, weak, varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

path = '/Users/ianchristie/Dropbox/cortical_model_direction_selectivity/Neuroscience/ISNModel/Data';
saveCoVData = 0;

out = 0;

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

Wee = .8;
Wii = 0;
Wei = .4;
Wie = -.41;

Wxe = 0:.02:.5;
Wxi1 = 0:.02:1;
Wxi2 = 0:.02:1;

assign(varargin{:});

Itotal = createInputISN(strong, weak, dt);

cube = cell(length(Wxe),length(Wxi1),length(Wxi2));

for i = 1: length(Wxe),
    disp('Working on');
    disp(Wxe(i));
    for k = 1: length(Wxi1),
        for l = 1: length(Wxi2),

            m = getConnectionMatrix2('Wee', Wee,'Wii', Wii, 'Wei', Wei, 'Wie', Wie, 'Wxe1',Wxe(i),'Wxe2',Wxe(i),'Wxi1',Wxi1(k),'Wxi2',Wxi2(l));

            r = runISNTime(time,dt,tau,m,Itotal,inputMatrix,tempVector, 'rectified115');

            [LUe, LDe, RUe, RDe, LDI, RDI, SS, LUi, LDi, RUi, RDi, LSI, RSI, notNumber, blowsUp, Oscillates, CoVVector] = analyzeISNOutput(r,dt);

            cube{i,k,l} = struct('m',m,'Wxe', Wxe(i),'Wxe1',Wxe(i),'Wxe2',Wxe(i),'Wxi1',Wxi1(k),'Wxi2',Wxi2(l),...
                                 'LUe', LUe, 'LDe', LDe, 'RUe', RUe, 'RDe', RDe,'LUi', LUi,...
                                 'LDi', LDi, 'RUi', RUi, 'RDi', RDi,'SS', SS, 'LDI', LDI, 'RDI', RDI, 'LSI', LSI, 'RSI', RSI,...
                                 'Strong',strong,'Weak',weak,'Response', 11, 'Nan', notNumber, 'BlowsUp', blowsUp, ...
                                 'CoV', CoVVector, 'Oscillates', Oscillates);

            cube{i,k,l}.Response = classifyISNResponse(cube{i,k,l});
            
            if saveCoVData,
                cube{i,k,l}.LUCoV = CoVVector(1);
                cube{i,k,l}.LDCoV = CoVVector(2);
                cube{i,k,l}.RUCoV = CoVVector(3);
                cube{i,k,l}.RDCoV = CoVVector(4);
            end
        end
    end
end
pathData115 = [path filesep 'data115'];
if ~exist(pathData115, 'dir'),
    mkdir(pathData115);
end
pathSW = [pathData115 filesep sprintf('S%dW%d', strong,weak)]
if ~exist(pathSW, 'dir'),
    mkdir(pathSW);
end
save([pathSW filesep 'Cube.mat'], 'cube');

out = out + 1;

end

