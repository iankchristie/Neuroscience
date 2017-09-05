function [out]  = PlotSingleElementData(SteadyStates, varargin)

out = 0;
column = 1; %excitatory column is 1, inhibitory is 2

WeeVector = 0:.05:1;
WiiVector = 0;
WeiVector = 0:.05:.4;
WieVector = -0.01:-.05:-.41;

Wee = 1;
Wei = 1;
Wie = 1;
Wii = 'Unknown Wii';

assign(varargin{:});

if isnumeric(Wee),
    Wee = closest(Wee, WeeVector);
else
    axisYLabel = 'Wee';
end
if isnumeric(Wei),
    Wei = closest(Wei, WeiVector);
else
    axisYLabel = 'Wei';
end
if isnumeric(Wie),
    Wie = closest(Wie, WieVector);
else
    axisYLabel = 'Wie';
end

figure;
command = sprintf('imagesc(squeeze(SteadyStates(%s, %s, %s, %s, :)));', num2str(column), num2str(Wee), num2str(Wei), num2str(Wie));
disp(command);
eval(command);
colorbar
set(gca,'ydir','normal')
xlabel('Input');
ylabel(axisYLabel);
title(sprintf('Wii = %d',Wii));

out = 1;

end