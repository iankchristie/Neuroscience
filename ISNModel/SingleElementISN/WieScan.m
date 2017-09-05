%%Time parameters
t0 = 0;
dt = .001;
tend = 1;
tau = .004;

time = t0:dt:tend;
tempVector = zeros(4,length(time));

%%Columns
Wee = .8;
Wii = 0;
Wei = .4;
Wie = -.01:-.05:-.51;

%%input
inputMatrix = [1 0;
               1 0;
               0 1;
               0 1];
           
currents = 0.5:400;

WieSteadyState = zeros(length(Wie), length(currents));

for i = 1: length(Wie),
    fprintf('Wee %d \n', Wie(i));

    for q = 1: length(currents),
        column = getConnectionMatrix2('Wee', Wee,'Wii', Wii, 'Wei', Wei, 'Wie', Wie(i));

        inputCurrentTemp = createInputISN(currents(q), currents(q), dt);
        %%Temporary
        [~, b] = size(inputCurrentTemp);
        pivot = round(b / 2);
        inputCurrent = inputCurrentTemp(:, 1 : pivot);

        r = runISNTime(time, dt, tau, column, inputCurrent, inputMatrix, tempVector, 'rectified115');

        WieSteadyState(i,q) = r(1, round(.75/dt));
    end
end
figure;
image(WieSteadyState);
set(gca,'ydir','normal')
colorbar