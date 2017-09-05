inputStrong = 4;
inputWeak = 2;

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


%Range of variations
W11 = [-1:.5:1];
W12 = [-1:.5:1];
W21 = [-1:.5:1];
W22 = [-1:.5:1];

%default connection
defaultConnection = .344;

%Matrices for all Up variations
mW11W12U = zeros(length(W11),length(W12));
mW11W21U = zeros(length(W11),length(W21));
mW11W22U = zeros(length(W11),length(W22));
mW12W21U = zeros(length(W12),length(W21));
mW12W22U = zeros(length(W12),length(W22));
mW21W22U = zeros(length(W21),length(W22));


%Matrices for all down variations
mW11W12D = zeros(length(W11),length(W12));
mW11W21D = zeros(length(W11),length(W21));
mW11W22D = zeros(length(W11),length(W22));
mW12W21D = zeros(length(W12),length(W21));
mW12W22D = zeros(length(W12),length(W22));
mW21W22D = zeros(length(W21),length(W22));

%Matrices of direction index. No need for pre-allocation
mW11W12I = [];
mW11W21I = [];
mW11W22I = [];
mW12W21I = [];
mW12W22I = [];
mW21W22I = [];

%%%%%%%%%%%%%%%%%%%Let's do All up first%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n1.A = inputStrong;
n2.A = inputWeak;

%Changing W11 W12
for i = 1: length(W11),
    for j = 1: length(W12),
        %reset neurons
        n1.reset();
        n2.reset();
        
        %create connection matrix
        connection_matrix = [W11(i) W12(j); defaultConnection defaultConnection];
        
        model = createTwoCorticalModel(connection_matrix,n1,n2);
        
        mW11W12U(i,j) = max(runModel(model));
        
    end
    disp(i);
end

% figure;
% plotImagesc(W11,W12,mW11W12U,'W11 & W12 Up');

%Changing W11 W21
for i = 1: length(W11),
    for j = 1: length(W21),
        %reset neurons 
        n1.reset();
        n2.reset();
        
        %create connection matrix
        connection_matrix = [W11(i) defaultConnection; W21(j) defaultConnection];
        
        model = createTwoCorticalModel(connection_matrix,n1,n2);
        
        mW11W21U(i,j) = max(runModel(model));
        
    end
    disp(i);
end

% figure;
% plotImagesc(W11,W21,mW11W21U,'W11 & W21 Up');

%Changing W11 W22
for i = 1: length(W11),
    for j = 1: length(W22),
        %reset neurons 
        n1.reset();
        n2.reset();
        
        %create connection matrix
        connection_matrix = [W11(i) defaultConnection; defaultConnection W22(j)];
        
        model = createTwoCorticalModel(connection_matrix,n1,n2);
        
        mW11W22U(i,j) = max(runModel(model));
        
    end
    disp(i);
end

% figure;
% plotImagesc(W11,W22,mW11W22U,'W11 & W22 Up');

%Changing W12 W21
for i = 1: length(W12),
    for j = 1: length(W21),
        %reset neurons 
        n1.reset();
        n2.reset();
        
        %create connection matrix
        connection_matrix = [defaultConnection W12(i); W21(j) defaultConnection];
        
        model = createTwoCorticalModel(connection_matrix,n1,n2);
        
        mW12W21U(i,j) = max(runModel(model));
        
    end
    disp(i);
end

% figure;
% plotImagesc(W12,W21,mW12W21U,'W12 & W21 Up');

%Changing W12 W22
for i = 1: length(W12),
    for j = 1: length(W22),
        %reset neurons 
        n1.reset();
        n2.reset();
        
        %create connection matrix
        connection_matrix = [defaultConnection W12(i); defaultConnection W22(j)];
        
        model = createTwoCorticalModel(connection_matrix,n1,n2);
        
        mW12W22U(i,j) = max(runModel(model));
        
    end
    disp(i);
end

% figure;
% plotImagesc(W12,W22,mW12W22U,'W12 & W22 Up');

%Changing W21 W22
for i = 1: length(W21),
    for j = 1: length(W22),
        %reset neurons 
        n1.reset();
        n2.reset();
        
        %create connection matrix
        connection_matrix = [defaultConnection defaultConnection; W21(i) W22(j)];
        
        model = createTwoCorticalModel(connection_matrix,n1,n2);
        
        mW21W22U(i,j) = max(runModel(model));
        
    end
    disp(i);
end

% figure;
% plotImagesc(W21,W22,mW21W22U,'W21 & W22 Up');



%%%%%%%%%%%%%%%%%%%Let's do Down  Next%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n1.A = inputWeak;
n2.A = inputStrong;

%Changing W11 W12
for i = 1: length(W11),
    for j = 1: length(W12),
        %reset neurons
        n1.reset();
        n2.reset();
        
        %create connection matrix
        connection_matrix = [W11(i) W12(j); defaultConnection defaultConnection];
        
        model = createTwoCorticalModel(connection_matrix,n1,n2);
        
        mW11W12D(i,j) = max(runModel(model));
        
    end
    disp(i);
end

% figure;
% plotImagesc(W11,W12,mW11W12D,'W11 & W12 Down');

%Changing W11 W21
for i = 1: length(W11),
    for j = 1: length(W21),
        %reset neurons 
        n1.reset();
        n2.reset();
        
        %create connection matrix
        connection_matrix = [W11(i) defaultConnection; W21(j) defaultConnection];
        
        model = createTwoCorticalModel(connection_matrix,n1,n2);
        
        mW11W21D(i,j) = max(runModel(model));
        
    end
    disp(i);
end

% figure;
% plotImagesc(W11,W21,mW11W21D,'W11 & W21 Down');

%Changing W11 W22
for i = 1: length(W11),
    for j = 1: length(W22),
        %reset neurons 
        n1.reset();
        n2.reset();
        
        %create connection matrix
        connection_matrix = [W11(i) defaultConnection; defaultConnection W22(j)];
        
        model = createTwoCorticalModel(connection_matrix,n1,n2);
        
        mW11W22D(i,j) = max(runModel(model));
        
    end
    disp(i);
end

% figure;
% plotImagesc(W11,W22,mW11W22D,'W11 & W22 Down');

%Changing W12 W21
for i = 1: length(W12),
    for j = 1: length(W21),
        %reset neurons 
        n1.reset();
        n2.reset();
        
        %create connection matrix
        connection_matrix = [defaultConnection W12(i); W21(j) defaultConnection];
        
        model = createTwoCorticalModel(connection_matrix,n1,n2);
        
        mW12W21D(i,j) = max(runModel(model));
        
    end
    disp(i);
end

% figure;
% plotImagesc(W12,W21,mW12W21D,'W12 & W21 Down');

%Changing W12 W22
for i = 1: length(W12),
    for j = 1: length(W22),
        %reset neurons 
        n1.reset();
        n2.reset();
        
        %create connection matrix
        connection_matrix = [defaultConnection W12(i); defaultConnection W22(j)];
        
        model = createTwoCorticalModel(connection_matrix,n1,n2);
        
        mW12W22D(i,j) = max(runModel(model));
        
    end
    disp(i);
end

% figure;
% plotImagesc(W12,W22,mW12W22D,'W12 & W22 Down');

%Changing W21 W22
for i = 1: length(W21),
    for j = 1: length(W22),
        %reset neurons 
        n1.reset();
        n2.reset();
        
        %create connection matrix
        connection_matrix = [defaultConnection defaultConnection; W21(i) W22(j)];
        
        model = createTwoCorticalModel(connection_matrix,n1,n2);
        
        mW21W22D(i,j) = max(runModel(model));
        
    end
    disp(i);
end

% figure;
% plotImagesc(W21,W22,mW21W22D,'W21 & W22 Down');

%%%%%%%%%%Now We do the Calculations for direction indexing%%%%%%%%%%%%%%%%
mW11W12I = (mW11W12U-mW11W12D)./(mW11W12U+mW11W12D);
mW11W21I = (mW11W21U-mW11W21D)./(mW11W21U+mW11W21D);
mW11W22I = (mW11W22U-mW11W22D)./(mW11W22U+mW11W22D);
mW12W21I = (mW12W21U-mW12W21D)./(mW12W21U+mW12W21D);
mW12W22I = (mW12W22U-mW12W22D)./(mW12W22U+mW12W22D);
mW21W22I = (mW21W22U-mW21W22D)./(mW21W22U+mW21W22D);

%%%%%%%%%%%%%%%%%%%%PLOT EVERYTHING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

%%%%%%%%%%%%%%%Plot Up%%%%%%%%%%%%%%%%%%%%%%%%
figure('name', 'Response of n1 to input from Up (strong n1) direction');
subplot(3,3,1);
plotImagesc(W11,W12,mW11W12U,'W11 & W12 Up','','');
subplot(3,3,4);
plotImagesc(W11,W21,mW11W21U,'W11 & W21 Up','','');
subplot(3,3,5);
plotImagesc(W12,W21,mW12W21U,'W12 & W21 Up','','');
subplot(3,3,7);
plotImagesc(W11,W22,mW11W22U,'W11 & W22 Up','','');
subplot(3,3,8);
plotImagesc(W12,W22,mW12W22U,'W12 & W22 Up','','');
subplot(3,3,9);
plotImagesc(W21,W22,mW21W22U,'W21 & W22 Up','','');

%%%%%%%%%%%%%%%Plot Down%%%%%%%%%%%%%%%%%%%%%%%%
figure('name', 'Response of n1 to input from down (weak n1) direction');
subplot(3,3,1);
plotImagesc(W11,W12,mW11W12D,'W11 & W12 Down','','');
subplot(3,3,4);
plotImagesc(W11,W21,mW11W21D,'W11 & W21 Down','','');
subplot(3,3,5);
plotImagesc(W12,W21,mW12W21D,'W12 & W21 Down','','');
subplot(3,3,7);
plotImagesc(W11,W22,mW11W22D,'W11 & W22 Down','','');
subplot(3,3,8);
plotImagesc(W12,W22,mW12W22D,'W12 & W22 Down','','');
subplot(3,3,9);
plotImagesc(W21,W22,mW21W22D,'W21 & W22 Down','','');

%%%%%%%%%%%%%%%Plot Direction Index%%%%%%%%%%%%%%%%%%%%%%%%
figure('name', 'Direction Index');
subplot(3,3,1);
plotImagesc(W11,W12,mW11W12I,'W11 & W12 Index','','');
subplot(3,3,4);
plotImagesc(W11,W21,mW11W21I,'W11 & W21 Index','','');
subplot(3,3,5);
plotImagesc(W12,W21,mW12W21I,'W12 & W21 Index','','');
subplot(3,3,7);
plotImagesc(W11,W22,mW11W22I,'W11 & W22 Index','','');
subplot(3,3,8);
plotImagesc(W12,W22,mW12W22I,'W12 & W22 Index','','');
subplot(3,3,9);
plotImagesc(W21,W22,mW21W22I,'W21 & W22 Index','','');



