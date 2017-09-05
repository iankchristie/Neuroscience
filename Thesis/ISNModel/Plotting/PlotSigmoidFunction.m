x = 0:.001:75;

y = arrayfun(@sigmoidFunction, x);

figure;
plot(x, y);
axis([0 75 0 100]);
title('Sigmoid Function');
xlabel('Input');
ylabel('Response');
box off