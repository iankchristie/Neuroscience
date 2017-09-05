inputStrong = 15;
inputWeak = 0;

% Create our neurons
n1 = CorticalNeuron('name','n1');
n2 = CorticalNeuron('name','n2');

%Connect them
n1.input{1,2} = n2;
n2.input{1,2} = n1;

W11 = .5;
W12 = .01;
W21 = .5;
W22 = .01;

n1.A = inputStrong;
n2.A = inputWeak;

connection_matrix = [W11 W12; W21 W22];

model = createTwoCorticalModel(connection_matrix,n1,n2);

rU = max(runModel(model));

n1.A = inputWeak;
n2.A = inputStrong;

n1.reset();
n2.reset();

connection_matrix = [W11 W12; W21 W22];

model = createTwoCorticalModel(connection_matrix,n1,n2);

rD = max(runModel(model));

wuDI = (rU - rD) / (rU + rD)