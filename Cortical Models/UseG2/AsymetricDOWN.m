%%Plots asymmetric 4 DOWN


[x y m n] = size(DOWN);

plotLength = ceil(sqrt(n));
plotWidth = floor(sqrt(n));

for i=1: m,
    temp = num2str(W22(i));
    titleString = ['W22 set to ' temp];
    figure('name',titleString);
    
    for j=1: n,
        subplot(plotLength,plotWidth,j);
        temp2 = num2str(W21(j));
        plotImagesc(W12, W11, DOWN(:,:,j,i), ['W21 set to' temp2],'W12','W11');
        caxis([-1 1]);
    end
end