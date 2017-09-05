function [output] = QuickSaveFunction(base,full)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

output = 0;

fullFileName = fullfile(full, base);  
saveas(gcf,fullFileName); % Using export_fig instead of saveas.

output = 1;

end

