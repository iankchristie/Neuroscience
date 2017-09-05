%%Time parameters
t0 = 0;
dt = .001;
tend = 1;
tau = .004;

time = t0:dt:tend;
tempVector = zeros(4,length(time));

%%Columns
column = createColumn();

%%input
inputMatrix = [1 0;
               1 0;
               0 1;
               0 1];
           
currents = 0.5:400;

%%Run
ExcitatorySteadyState = zeros(1, length(currents));

figure;
for i = 1: length(currents),
    inputCurrentTemp = createInputISN(currents(i), currents(i), dt);
    %%Temporary
    [~, b] = size(inputCurrentTemp);
    pivot = round(b / 2);
    inputCurrent = inputCurrentTemp(:, 1 : pivot);

    r = runISNTime(time, dt, tau, column, inputCurrent, inputMatrix, tempVector, 'rectified115');
    
    plot(time, r');
    axis([0 1 0 2000])
    pause(.001);
    ExcitatorySteadyState(i) = r(1, round(.7/dt));
end
figure;
plot(currents, ExcitatorySteadyState);


