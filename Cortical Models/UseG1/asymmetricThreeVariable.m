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

%default connection
defaultConnection = -.344;

%Creating increment vectors
Outer = [-1:.3:1];
Middle = [-1:.3:1];
Inner = [-1:.3:1];

%Matrices for all UP variations
UP11_12_21 = zeros(length(Outer),length(Middle),length(Inner));
UP11_12_22 = zeros(length(Outer),length(Middle),length(Inner));
UP11_21_21 = zeros(length(Outer),length(Middle),length(Inner));
UP12_21_22 = zeros(length(Outer),length(Middle),length(Inner));

%Matrices for all DOWN variations
DOWN11_12_21 = zeros(length(Outer),length(Middle),length(Inner));
DOWN11_12_22 = zeros(length(Outer),length(Middle),length(Inner));
DOWN11_21_21 = zeros(length(Outer),length(Middle),length(Inner));
DOWN12_21_22 = zeros(length(Outer),length(Middle),length(Inner));

%Matrices of direction index. No need for pre-allocation
DI11_12_21 = [];
DI11_12_22 = [];
DI11_21_22 = [];
DI12_21_22 = [];

%%%%%%%%%%%%%%%%%%%Let's do All up first%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n1.A = inputStrong;
n2.A = inputWeak;

disp('UP11-12-21');
for i = 1: length(Outer),
    for j = 1: length(Middle),
        for k = 1: length(Inner),
            %reset neurons
            n1.reset();
            n2.reset();
        
            %create connection matrix
            connection_matrix = [Outer(i) Middle(j); Inner(k) defaultConnection];
        
            model = createTwoCorticalModel(connection_matrix,n1,n2);
            
            UP11_12_21(i,j,k) = max(runModel(model));
        end
    end
    disp(i);
end

disp('UP11-12-22');
for i = 1: length(Outer),
    for j = 1: length(Middle),
        for k = 1: length(Inner),
            %reset neurons
            n1.reset();
            n2.reset();
        
            %create connection matrix
            connection_matrix = [Outer(i) Middle(j); defaultConnection Inner(k)];
        
            model = createTwoCorticalModel(connection_matrix,n1,n2);
            
            UP11_12_22(i,j,k) = max(runModel(model));
        end
    end
    disp(i);
end

disp('UP11-21-22');
for i = 1: length(Outer),
    for j = 1: length(Middle),
        for k = 1: length(Inner),
            %reset neurons
            n1.reset();
            n2.reset();
        
            %create connection matrix
            connection_matrix = [Outer(i) defaultConnection ; Middle(j) Inner(k)];
        
            model = createTwoCorticalModel(connection_matrix,n1,n2);
            
            UP11_21_22(i,j,k) = max(runModel(model));
        end
    end
    disp(i);
end

disp('UP12-21-22');
for i = 1: length(Outer),
    for j = 1: length(Middle),
        for k = 1: length(Inner),
            %reset neurons
            n1.reset();
            n2.reset();
        
            %create connection matrix
            connection_matrix = [defaultConnection Outer(i); Middle(j) Inner(k) ];
        
            model = createTwoCorticalModel(connection_matrix,n1,n2);
            
            UP12_21_22(i,j,k) = max(runModel(model));
        end
    end
    disp(i);
end

%%%%%%%%%%%%%%%%%%%Next Let's do down%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n1.A = inputWeak;
n2.A = inputStrong;

disp('Down11-12-21');
for i = 1: length(Outer),
    for j = 1: length(Middle),
        for k = 1: length(Inner),
            %reset neurons
            n1.reset();
            n2.reset();
        
            %create connection matrix
            connection_matrix = [Outer(i) Middle(j); Inner(k) defaultConnection];
        
            model = createTwoCorticalModel(connection_matrix,n1,n2);
            
            DOWN11_12_21(i,j,k) = max(runModel(model));
        end
    end
    disp(i);
end

disp('Down11-12-22');
for i = 1: length(Outer),
    for j = 1: length(Middle),
        for k = 1: length(Inner),
            %reset neurons
            n1.reset();
            n2.reset();
        
            %create connection matrix
            connection_matrix = [Outer(i) Middle(j); defaultConnection Inner(k)];
        
            model = createTwoCorticalModel(connection_matrix,n1,n2);
            
            DOWN11_12_22(i,j,k) = max(runModel(model));
        end
    end
    disp(i);
end

disp('Down11-21-22');
for i = 1: length(Outer),
    for j = 1: length(Middle),
        for k = 1: length(Inner),
            %reset neurons
            n1.reset();
            n2.reset();
        
            %create connection matrix
            connection_matrix = [Outer(i) defaultConnection; Middle(j) Inner(k)];
        
            model = createTwoCorticalModel(connection_matrix,n1,n2);
            
            DOWN11_21_22(i,j,k) = max(runModel(model));
        end
    end
    disp(i);
end

disp('Down12-21-22');
for i = 1: length(Outer),
    for j = 1: length(Middle),
        for k = 1: length(Inner),
            %reset neurons
            n1.reset();
            n2.reset();
        
            %create connection matrix
            connection_matrix = [defaultConnection Outer(i); Middle(j) Inner(k)];
        
            model = createTwoCorticalModel(connection_matrix,n1,n2);
            
            DOWN12_21_22(i,j,k) = max(runModel(model));
        end
    end
    disp(i);
end

%%%%%%%%%%Now We do the Calculations for direction indexing%%%%%%%%%%%%%%%%
DI11_12_21 = (UP11_12_21-DOWN11_12_21)./(UP11_12_21+DOWN11_12_21);
DI11_12_22 = (UP11_12_22-DOWN11_12_22)./(UP11_12_22+DOWN11_12_22);
DI11_21_22 = (UP11_21_22-DOWN11_21_22)./(UP11_21_22+DOWN11_21_22);
DI12_21_22 = (UP12_21_22-DOWN12_21_22)./(UP12_21_22+DOWN12_21_22);

%%%%%%%%%%%%%%%%%%%%PLOT EVERYTHING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

newFolder = sprintf('Default%d',floor(defaultConnection*1000));
mkdir('/Users/ianchristie/Documents/MATLAB/Data/images/ThreeVariable',newFolder)

full = sprintf('/Users/ianchristie/Documents/MATLAB/Data/images/ThreeVariable/Default%d',floor(defaultConnection*1000));

m = ceil(sqrt(length(Inner)));
n = ceil(sqrt(length(Inner)));

%%%%%%%%%%%%%%%Plot Up%%%%%%%%%%%%%%%%%%%%%%%%

figure;
for i = 1: length(Inner),
    subplot(m,n,i);
    plotImagesc(Outer, Middle, UP11_12_21(:,:,i), 'UP11-12-21 with W21 increasing','W11','W12');
end

base = 'UP11_12_21';
QuickSaveFunction(base,full);

figure;
for i = 1: length(Inner),
    subplot(m,n,i);
    plotImagesc(Outer, Middle, UP11_12_22(:,:,i), 'UP11-12-22 with W22 increasing','W11','W12');
end

base = 'UP11_12_22';
QuickSaveFunction(base,full);

figure;
for i = 1: length(Inner),
    subplot(m,n,i);
    plotImagesc(Outer, Middle, UP11_21_22(:,:,i), 'UP11-21-22 with W22 increasing','W11','W21');
end

base = 'UP11_21_22';
QuickSaveFunction(base,full);

figure;
for i = 1: length(Inner),
    subplot(m,n,i);
    plotImagesc(Outer, Middle, UP12_21_22(:,:,i), 'UP12-21-22 with W22 increasing','W12','W21');
end

base = 'UP12_21_22';
QuickSaveFunction(base,full);

%%%%%%%%%%%%%%%Plot Down%%%%%%%%%%%%%%%%%%%%%%%%

figure;
for i = 1: length(Inner),
    subplot(m,n,i);
    plotImagesc(Outer, Middle, DOWN11_12_21(:,:,i), 'DOWN11-12-21 with W21 increasing','W11','W12');
end

base = 'DOWN11_12_21';
QuickSaveFunction(base,full);

figure;
for i = 1: length(Inner),
    subplot(m,n,i);
    plotImagesc(Outer, Middle, DOWN11_12_22(:,:,i), 'DOWN11-12-22 with W22 increasing','W11','W12');
end

base = 'DOWN11_12_22';
QuickSaveFunction(base,full);

figure;
for i = 1: length(Inner),
    subplot(m,n,i);
    plotImagesc(Outer, Middle, DOWN11_21_22(:,:,i), 'DOWN11-21-22 with W22 increasing','W11','W21');
end

base = 'DOWN11_21_22';
QuickSaveFunction(base,full);

figure;
for i = 1: length(Inner),
    subplot(m,n,i);
    plotImagesc(Outer, Middle, DOWN12_21_22(:,:,i), 'DOWN12-21-22 with W22 increasing','W12','W21');
end

base = 'DOWN12_21_22';
QuickSaveFunction(base,full);

%%%%%%%%%%%%%%%Plot Direction Index%%%%%%%%%%%%%%%%%%%%%%%%

figure;
for i = 1: length(Inner),
    subplot(m,n,i);
    plotImagesc(Outer, Middle, DI11_12_21(:,:,i), 'DI11-12-21 with W21 increasing','W11','W12');
    caxis([-1 1]);
end

base = 'DI11_12_21';
QuickSaveFunction(base,full);

figure;
for i = 1: length(Inner),
    subplot(m,n,i);
    plotImagesc(Outer, Middle, DI11_12_22(:,:,i), 'DI11_12_22 with W22 increasing','W11','W12');
    caxis([-1 1]);
end

base = 'DI11_12_22';
QuickSaveFunction(base,full);

figure;
for i = 1: length(Inner),
    subplot(m,n,i);
    plotImagesc(Outer, Middle, DI11_21_22(:,:,i), 'DI11-21-22 with W22 increasing','W11','W21');
    caxis([-1 1]);
end

base = 'DI11_21_22';
QuickSaveFunction(base,full);

figure;
for i = 1: length(Inner),
    subplot(m,n,i);
    plotImagesc(Outer, Middle, DI12_21_22(:,:,i), 'DI12-21-22 with W22 increasing','W12','W21');
    caxis([-1 1]);
end

base = 'DI12_21_22';
QuickSaveFunction(base,full);


