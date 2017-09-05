
%%Time parameters
t0 = 0;
dt = .001;
tend = 1;
tau = .004;

timeStruct = struct('t0', t0, 'dt',dt,'tend',tend,'tau',tau);

%%Input parameters
Strong = 16;
Weak = 11;

inputMatrix = [1 0;
               1 0;
               0 1;
               0 1];

inputStruct = struct('Strong',Strong, 'Weak', Weak, 'inputMatrix', inputMatrix);

%%Model parameters
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

Wxe = 0.04;
Wxi1 = 0.05;
Wxi2 = 0.05;

m = getConnectionMatrix2('Wee', Wee,'Wii', Wii, 'Wei', Wei, 'Wie', Wie, 'Wxe1',Wxe,'Wxe2',Wxe,'Wxi1',Wxi1,'Wxi2',Wxi2);

modelStruct = struct('Wee', Wee,'Wii', Wii, 'Wei', Wei, 'Wie', Wie, 'Wxe1',Wxe,'Wxe2',Wxe,'Wxi1',Wxi1,'Wxi2',Wxi2, 'm', m, 'initialM', m);

%%Plasticity Parameters
plasticityMatrix = getConnectionMatrix2('Wee', 0,'Wii', 0, 'Wei', 0, 'Wie', 0, 'Wxe1',0,'Wxe2',0,'Wxi1',1,'Wxi2',1);
alphaPos =  0.000005;
alphaNeg  = 0.0000052; 

plasticityStruct = struct('plasticityMatrix', plasticityMatrix, 'alphaPos', alphaPos, 'alphaNeg', alphaNeg);

%%Training parameters
numTrials = 200;
trainingType = 'unidirectionalTrainingISN';
resultStruct = struct('m', 0, 'Lue', 0, 'Lui', 0, 'Rue', 0, 'Rui', 0, ...
                        'Lde', 0, 'Ldi', 0, 'Rde', 0, 'Rdi', 0, ...
                        'LDI', 0, 'RDI', 0, 'LSI', 0, 'RSI', 0, 'dWMatrix', 0);
trialStruct = struct('numTrials', numTrials, 'trainingType', trainingType);

for i = 1: numTrials,
    disp(['Trial Number: ' num2str(i)]);
    resultStruct(i) = feval(trainingType, timeStruct, inputStruct, modelStruct, plasticityStruct);
    modelStruct.m = resultStruct(i).m;
end

PlotTrainingData(resultStruct);
PlotTrainingDataSmall(resultStruct);

savingStruct = struct('timeStruct', timeStruct, 'inputStruct', inputStruct,...
                      'modelStruct', modelStruct, 'plasticityStruct', plasticityStruct, ...
                       'trialStruct', trialStruct, 'resultStruct', resultStruct);
                   
savingBasePath = '/Users/ianchristie/Dropbox/cortical_model_direction_selectivity/Neuroscience/ISNModel/Plasticity/PlasticityData';
savingTypePath = [savingBasePath filesep trainingType];
metaData = dir(savingTypePath);
savingPath = [savingTypePath filesep 'Trial' num2str(length(metaData)/2)];
savingPathStruct = [savingPath '.mat'];
savingPathFig = [savingPath '.fig'];
save(savingPathStruct, 'savingStruct');
saveas(gcf, savingPathFig);
