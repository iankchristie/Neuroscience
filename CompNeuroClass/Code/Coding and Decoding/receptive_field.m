% receptive_field.m
% Plots a receptive field for a simple cell, with separable time and space
% components.

dx = 0.01;
dt = 0.001;
x = -1:dx:1;
t = 0:dt:0.1;

cs = cos(2*pi*x).*exp(-x.*x/(0.5));     % Spatial variation
tm = exp(-20*t).*sin(2*pi*10*t);        % Temporal variation

field = zeros(length(cs),length(tm));
for i = 1:length(cs)
    for j = 1:length(tm)
        field(i,j) = cs(i)*tm(j);       % 
    end
end

imagesc(field')
set(gca,'YDir','normal')
set(gca,'FontSize',16)
ylabel('Time from Stimulus (ms)')
xlabel('Position of stimulus')
