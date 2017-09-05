function [ output ] = plot4Color(vectorX, vectorY, matrix, t, xax, yax)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
 
output = 0;
map = [1 0 0; %red
        1 1 0; %yellow
        0 1 0; %green
        0 0 1; %blue
        .5 .5 .5]; %grey
    
 image(vectorX, vectorY, matrix);
 set(gca, 'ydir','normal');
 colormap(map);
 title(t);
xlabel(xax);
ylabel(yax);

output = output + 1;
end

