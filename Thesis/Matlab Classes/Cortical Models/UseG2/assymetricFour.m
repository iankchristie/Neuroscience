inputStrong = 10;
inputWeak = 5;

% Create our neurons
n1 = CorticalNeuron('name','n1');
n2 = CorticalNeuron('name','n2');

%Connect them
n1.input{1,2} = n2;
n2.input{1,2} = n1;

% follows pattern
% 
%           neuron1     neuron2
% neuron1   W11         W12
% neuron2   W21         W22

%Creating increment vectors
W11 = [-1:.2:1];
W12 = [-1:.2:1];
W21 = [-1:.2:1];
W22 = [-1:.2:1];

%Matrices to hold response data
UP = zeros(length(W11),length(W12),length(W21),length(W22));
DOWN = zeros(length(W11),length(W12),length(W21),length(W22));

%%%%%%%%%%%%%%%%%%%Let's do UP first%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n1.A = inputStrong;
n2.A = inputWeak;

for i=1:length(W11),
    for j=1:length(W12),
        for k=1:length(W21),
            for l=1:length(W22),
                %reset neurons
                n1.reset();
                n2.reset();

                %create connection matrix
                connection_matrix = [W11(i) W12(j); W21(k) W22(l)];

                model = createTwoCorticalModel(connection_matrix,n1,n2);

                UP(i,j,k,l) = max(runModel(model));
            end
            disp(['W21: ']);
            disp(k);
        end
    end
    disp(['W11: ']);
    disp(i);
end

%%%%%%%%%%%%%%%%%%%Let's do DOWN next%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n1.A = inputWeak;
n2.A = inputStrong;

for i=1:length(W11),
    for j=1:length(W12),
        for k=1:length(W21),
            for l=1:length(W22),
                %reset neurons
                n1.reset();
                n2.reset();

                %create connection matrix
                connection_matrix = [W11(i) W12(j); W21(k) W22(l)];

                model = createTwoCorticalModel(connection_matrix,n1,n2);

                DOWN(i,j,k,l) = max(runModel(model));
            end
            disp(['W21: ']);
            disp(k);
        end
    end
    disp(['W11: ']);
    disp(i);
end