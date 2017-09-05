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
Wei = 0:.05:.5;
Wie = -.41;

%%input
inputMatrix = [1 0;
               1 0;
               0 1;
               0 1];
           
currents = 0.5:400;

WeiSteadyState = zeros(length(Wei), length(currents));

for i = 1: length(Wei),
    fprintf('Wee %d \n', Wei(i));

    for q = 1: length(currents),
        column = getConnectionMatrix2('Wee', Wee,'Wii', Wii, 'Wei', Wei(i), 'Wie', Wie);

        inputCurrentTemp = createInputISN(currents(q), currents(q), dt);
        %%Temporary
        [~, b] = size(inputCurrentTemp);
        pivot = round(b / 2);
        inputCurrent = inputCurrentTemp(:, 1 : pivot);

        r = runISNTime(time, dt, tau, column, inputCurrent, inputMatrix, tempVector, 'rectified115');

        WeiSteadyState(i,q) = r(1, round(.75/dt));
    end
end
figure;
image(WeiSteadyState);
set(gca,'ydir','normal')
colobar