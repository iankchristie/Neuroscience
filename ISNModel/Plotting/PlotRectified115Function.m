x = 0:.001:75;

y = arrayfun(@rectified115, x);

figure;
plot(x, y);
xlim([0 75]);
box off