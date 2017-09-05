x = -1:.001:1;
alphaPos =  0.0000055 * ones(size(x));
alphaNeg  = 0.000005 * ones(size(x));

y = arrayfun(@stdp_kernelISN, x, alphaPos, alphaNeg);

figure;
plot(x, y);
hold on
plot([-1 1], [0 0], 'r');
title('Plasticity Kernel');
xlabel('Delta Time (sec)');
ylabel('Change in Weight');