% PCA_example.m
% Generate multi-neuron data with only two degrees of freedom and analyze
% using PCA.

clear

rng(3)

Ncells = 50;

dt = 0.001;             % dt in sec
tmax = 10;              % tmax in sec
t = 0:dt:tmax;          % time vector
Nt = length(t);

rate = zeros(Ncells,Nt); % firing rates of all cells is the main matrix

period = 2;
omega = 2*pi/period;


A0 = 50;
A1 = 20;
A2 = 10;

noise = 20;

Input1 = A1*sin(2*omega*t);

Input2 = A2*cos(omega*t);


W0 = 2+randn(Ncells,1);
W1 = randn(Ncells,1);
W2 = randn(Ncells,1);


rate = W0*A0*ones(1,Nt) + W1*Input1 + W2*Input2 + noise*randn(size(rate));


% Do PCA next. Each column should be a variable (i.e. a different cell) and
% each row an observation (here a time point). Need transpose of rate to do
% this correctly as rate stores the neurons as rows.
[COEFF, SCORE, LATENT, TSQUARED, EXPLAINED, MU] = pca(rate');

figure(1)
plot(W1,COEFF(:,1),'x')

figure(2)
plot(W2,COEFF(:,2),'x')


SCORET = SCORE';
newrates = COEFF(:,1:2)*SCORET(1:2,:);

figure(3) 
subplot(2,1,1)
plot(rate(1,:),rate(2,:),'o')
subplot(2,1,2)
plot(newrates(1,:),newrates(2,:),'o')

figure(4)
subplot(2,1,1)
plot(t,rate(2,:))
subplot(2,1,2)
plot(t,newrates(2,:))
