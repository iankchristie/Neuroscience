for k = 1: 12
    baseFileName = sprintf('figure_%d.jpg',k);
    % Specify some particular, specific folder:
    fullFileName = fullfile('/Users/ianchristie/Documents/MATLAB/Data/images/ThreeVariable', baseFileName);  
    saveas(figure(k),fullFileName); % Using export_fig instead of saveas.
end
