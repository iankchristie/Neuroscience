function [samplemeans, true_mean] = simulate_random_sampling(true_d, N, M)
% SIMULATE_EXPERIMENTAL_TRIAL - Simulate a random sampling experiment
%  [SAMPLEMEANS, TRUEMEAN]=SIMULATE_RANDOM_SAMPLING(TRUE_D, N, M, PLOTIT)
%
%   Inputs: TRUE_D: the "true distribution"
%           N : the number of samples in each experiment
%           M : the number of experiments to simulate
%           PLOTIT: 0 or 1, if we should plot the distribution of M sample means
%   Outputs: 
%          SAMPLEMEANS : The distribution of M sample means (1 for each experiment)
%          TRUEMEAN : The true mean; that is, the mean of the true distribution
true_mean = mean(true_d); % we know the answer!
i = 1;
samplemeans = []; % begin with the sample means empty
while (i<=M),
    randompermutation = randperm(length(true_d));
    sample = true_d(randompermutation(1:N));
    samplemeans(i) = mean(sample);
    i = i+1;
end;

figure;
[N,bin_centers] = autohistogram(samplemeans);
bar(bin_centers,100*N/sum(N));
xlabel('X variable');
ylabel('Percent of data');
hold on;
[X,Y] = cumhist(samplemeans,[bin_centers(1) bin_centers(end)],0.1);
plot(X,Y,'r-'); % red line for cumulative histogram
% plot the true mean as a vertical bar
plot([true_mean true_mean], [0 100],'k--','linewidth',2);
end