% PCA_example.m
% Generate multi-neuron data with only two degrees of freedom and analyze
% using PCA.

clear

rng(3);                 % Initialize random number generator to a controled value

Ncells = 50;            % Data from 50 cells so 50-dimensional data set.

dt = 0.001;             % dt in sec
tmax = 10;              % tmax in sec
t = 0:dt:tmax;          % time vector
Nt = length(t);

rate = zeros(Ncells,Nt); % firing rates of all cells is the main matrix

%% The following section generates dummy data from particular inputs
period = 2;             
omega = 2*pi/period;

ton1 = period;
toff1 = period+period/2;
non1 = round(ton1/dt);
noff1 = round(toff1/dt);

A0 = 50;
A1 = 20;
A2 = 10;

noise = 20;

% Input1 is a sine wave for a short period in the "trial"
Input1 = [zeros(1,non1) A1*sin(2*omega*t(non1+1:noff1)) zeros(1,Nt-noff1)];

% Input 2 is a ramp of constant gradient
Input2 = A2*t;

% The following weights make each neuron have some random content of each
% input
W0 = 2+randn(Ncells,1);
W1 = randn(Ncells,1);
W2 = randn(Ncells,1);

% The rate matrix has a row for each cell with time in columns
% This set of firing rates with added noise really only has two major
% signals in it, "Input1" and "Input2"
rate = W0*A0*ones(1,Nt) + W1*Input1 + W2*Input2 + noise*randn(size(rate));

%%
% Do PCA next. Each column should be a variable (i.e. a different cell) and
% each row an observation (here a time point). Need transpose of rate to do
% this correctly as rate stores the neurons as rows.
[COEFF, SCORE, LATENT, TSQUARED, EXPLAINED, MU] = pca(rate');

%% In this example, less connection between weights and Principal Components
% figure(1)
% plot(W1,COEFF(:,1),'x')
% 
% figure(2)
% plot(W2,COEFF(:,2),'x')

% SCORE tells how much of each principal component is present at each point
% in time. If we simply multiplied COEFF*SCORE' we would recover the
% original data offset by the means. By only taking the first two columns of COEFF (the first
% two principal components) and multiplying out the first two columns of
% SCORE (the first two rows of SCORE') we reduce the original 50-dimensions
% of data into a 2D data set. 
SCORET = SCORE';
newrates = COEFF(:,1:2)*SCORET(1:2,:) + MU'*ones(1,Nt);;

% Now we compare plots of the original rates and the 2D reduced rates.
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

% Explained is % variance explained by successive components
figure(5)
plot(EXPLAINED,'--o')

