function [something] = Plot4D(varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

out = 0;

constants = [];
variables = [];

inc = 0:.05:1;

assign(varargin{:});

cvars = {constants{1:2:end}};
cvals = {constants{2:2:end}};

Strong = cell2mat(cvals(find(ismember(cvars,'Strong'))));
Weak = cell2mat(cvals(find(ismember(cvars,'Weak'))));


disp([sprintf(['Loading ' pwd '/data/S%dW%d/Cube.mat'], Strong, Weak)])
load(sprintf([pwd '/data/S%dW%d/Cube.mat'], Strong, Weak));

x = [];

if (any(ismember(cvars, 'Wxe1'))),
    ind = getClosestIndex(cell2mat(cvals(ismember(cvars,'Wxe1'))), inc);
    disp(ind);
    x = squeeze(cube(ind,:,:,:));
    disp('Plotting')
    analyzeCube(x, Strong, Weak, 'xlab','Wxe2','ylab','Wxi1','zlab','Wxi2');
elseif (any(ismember(cvars, 'Wxe2'))),
    disp('Oops')
elseif (any(ismember(cvars, 'Wxi1'))),
    disp('Oops')
elseif (any(ismember(cvars, 'Wxi2'))),
    disp('Oops')
else
    error('You Must Input a valid dimensional constant: Wxe1, Wxe2, Wxi1, Wxi2');
end

out = out + 1;

end

