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
           
currents = 400*time;
inputCurrent = [currents; currents];

%%Run

r = runISNTime(time, dt, tau, column, inputCurrent, inputMatrix, tempVector, 'rectified115');

plot(time, r(1,:))