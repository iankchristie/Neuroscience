%%Plots asymmetric 4 up


[x y m n] = size(UP);

plotLength = ceil(sqrt(n));
plotWidth = floor(sqrt(n));

for i=1: m,
    temp = num2str(W22(i));
    titleString = ['W22 set to ' temp];
    figure('name',titleString);
    
    for j=1: n,
        subplot(plotLength,plotWidth,j);
        temp2 = num2str(W21(j));
        plotImagesc(W12, W11, UP(:,:,j,i), ['W21 set to' temp2],'W12','W11');
        caxis([0 100]);
    end
end