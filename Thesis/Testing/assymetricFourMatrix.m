inputStrong = 10;
inputWeak = 5;

u1 = [inputStrong; inputWeak];
u2 = [inputWeak; inputStrong];
% follows pattern
% 
%           neuron1     neuron2
% neuron1   W11         W12
% neuron2   W21         W22

W = eye(2);

%Creating increment vectors
W11 = -.5:.1:.5;
W12 = -.2:.04:.2;
W21 = -.2:.04:.2;
W22 = -.5:.1:.5;

%Matrices to hold response data
UPA = zeros(length(W11),length(W12),length(W21),length(W22));
UPB = zeros(length(W11),length(W12),length(W21),length(W22));
DOWNA = zeros(length(W11),length(W12),length(W21),length(W22));
DOWNB = zeros(length(W11),length(W12),length(W21),length(W22));

%%%%%%%%%%%%%%%%%%%Let's do UP first%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:length(W11),
    for j=1:length(W12),
        for k=1:length(W21),
            for l=1:length(W22),
                %create connection matrix M
                M = [W11(i) W12(j); W21(k) W22(l)];
                %Run the model and store in v
                v = RunModelMatrix(M, u1, W);
                
                UPA(i,j,k,l) = max(v(1,:));
                UPB(i,j,k,l) = max(v(2,:));
            end
            disp(['W21: ']);
            disp(k);
        end
    end
    disp(['W11: ']);
    disp(i);
end

%%%%%%%%%%%%%%%%%%%Let's do DOWN Next%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:length(W11),
    for j=1:length(W12),
        for k=1:length(W21),
            for l=1:length(W22),
                %create connection matrix M
                M = [W11(i) W12(j); W21(k) W22(l)];
                %Run the model and store in v
                v = RunModelMatrix(M, u2, W);
                
                DOWNA(i,j,k,l) = max(v(1,:));
                DOWNB(i,j,k,l) = max(v(2,:));
            end
            disp(['W21: ']);
            disp(k);
        end
    end
    disp(['W11: ']);
    disp(i);
end

%%%%%%Determine Directional Selectivity Index%%%%%%%%
DIA = (UPA-DOWNA)./(UPA+DOWNA);
DIB = (DOWNB-UPB)./(UPB+DOWNB);

%%%%%%Plot DI index%%%%%%%%%%
PlotAssymetric4Function(DIA, W11,W12,W21,W22);
PlotAssymetric4Function(DIB, W11,W12,W21,W22);

%%%%%%Plot Color Based on response of Both neurons%%%%%%
StatePlot



