inputStrong = 25;
inputWeak = 1;

u1 = [inputStrong; inputWeak];
u2 = [inputWeak; inputStrong];
% follows pattern
% 
%           neuron1     neuron2
% neuron1   W11         W12
% neuron2   W21         W22

W = eye(2);

%Creating increment vectors
Wxx = -.5:.02:.5;
Wxy = -1:.04:1;

%Matrices to hold response data
UPA = zeros(length(Wxx),length(Wxy));
UPB = zeros(length(Wxx),length(Wxy));
DOWNA = zeros(length(Wxx),length(Wxy));
DOWNB = zeros(length(Wxx),length(Wxy));

%%%%%%%%%%%%%%%%%%%Let's do UP first%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:length(Wxx),
    disp(['Wxx: ']);
    disp(i);
    for j=1:length(Wxy),
        %create connection matrix M
        M = [Wxx(i) Wxy(j); Wxy(j) Wxx(i)];
        %Run the model and store in v
        v = RunModelMatrix(M, u1, W);

        UPA(i,j) = max(v(1,:));
        UPB(i,j) = max(v(2,:));
    end
end

%%%%%%%%%%%%%%%%%%%Let's do DOWN Next%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('DOWN');

for i=1:length(Wxx),
    disp(['Wxx: ']);
    disp(i);
    for j=1:length(Wxy),
        %create connection matrix M
        M = [Wxx(i) Wxy(j); Wxy(j) Wxx(i)];
        %Run the model and store in v
        v = RunModelMatrix(M, u2, W);

        DOWNA(i,j) = max(v(1,:));
        DOWNB(i,j) = max(v(2,:));
    end
end

%%%%%%Determine Directional Selectivity Index%%%%%%%%
DIA = (UPA-DOWNA)./(UPA+DOWNA);
DIB = (DOWNB-UPB)./(UPB+DOWNB);

%%%%%%Plot DI index%%%%%%%%%%
figure;
plotImagesc(Wxy,Wxx, DIA, 'Response of Neuron A', 'Cross Connection Strength', 'Recurrent Connection Strength');
figure;
plotImagesc(Wxy,Wxx, DIB, 'Response of Neuron B', 'Cross Connection Strength', 'Recurrent Connection Strength');

%%%%%%Plot Color Based on response of Both neurons%%%%%%
%StatePlot
[statemap, map] = StateMap2D(UPA, UPB, DOWNA, DOWNB);
plot4Color(Wxy, Wxx, statemap, 'States of Parameter Space', 'Cross Connection Strength','Recurrent Connection Strength');
colormap(map);


