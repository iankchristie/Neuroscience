 

map = [1 0 0; %red
        1 1 0; %yellow
        0 1 0; %green
        0 0 1; %blue
        .5 .5 .5]; %grey

    
threshUP = 70;
threshDown = 40;

statemap = zeros(length(W11),length(W12),length(W21),length(W22));

for i=1:length(W11),
    for j=1:length(W12),
        for k=1:length(W21),
            for l=1:length(W22),
                if ((UPA(i,j,k,l) > threshUP && DOWNA(i,j,k,l) > threshUP) && (UPB(i,j,k,l) > threshUP && DOWNB(i,j,k,l) > threshUP)) %%%All firing
                    statemap(i,j,k,l) = 3;
                elseif ((UPA(i,j,k,l) > threshUP && DOWNA(i,j,k,l) > threshUP) || (UPB(i,j,k,l) > threshUP && DOWNB(i,j,k,l) > threshUP)) %%%one nueron is continiously firing
                    statemap(i,j,k,l) = 2;
                elseif ((UPA(i,j,k,l) > threshUP && DOWNB(i,j,k,l) > threshUP) || (DOWNA(i,j,k,l) > threshUP && UPB(i,j,k,l) > threshUP)) %%%opposite firing
                    statemap(i,j,k,l) = 1;
                elseif ((UPA(i,j,k,l) > threshUP && UPB(i,j,k,l) > threshUP) || (DOWNA(i,j,k,l) > threshUP && DOWNB(i,j,k,l) > threshUP)) %%%similar firing
                    statemap(i,j,k,l) = 4;
                else
                    statemap(i,j,k,l) = 5;
                end
            end
        end
    end
end

[m, ~, ~, n] = size(statemap);

plotLength = floor(sqrt(n));
plotWidth = ceil(sqrt(n));

while(plotLength*plotWidth < n),
    plotLength = plotLength + 1;
end

for i=1: m,
    temp = num2str(W11(i));
    titleString = ['W11 set to ' temp];
    figure('name', titleString);
    
    for j=1: n,
        subplot(plotLength,plotWidth,j);
        temp2 = num2str(W22(j));
        plot4Color(W12, W21, permute(statemap(i,:,:,j), [2 3 1 4]), ['W22 set to' temp2],'W12','W21');
        %caxis([-1 1]);
    end
end


