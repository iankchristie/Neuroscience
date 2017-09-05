%%Time parameters
t0 = 0;
dt = .001;
tend = 1;
tau = .004;

time = t0:dt:tend;
tempVector = zeros(4,length(time));

%%Columns
Wee = 0:.05:1;
Wii = 0;
Wei = 0:.05:.4;
Wie = -0.01:-.05:-.41;

%%input
inputMatrix = [1 0;
               1 0;
               0 1;
               0 1];
           
currents = 0.5:400;

SteadyStates = zeros(2, length(Wee), length(Wei), length(Wie), length(currents));


for i = 1: length(Wee),
    fprintf('Wee %d \n', Wee(i));
    for j = 1: length(Wei),
        fprintf('\tWei %d\n', Wei(j));
        for k = 1: length(Wie),
            fprintf('\t\tWie %d\n', Wie(k));
            for q = 1: length(currents),
                column = getConnectionMatrix2('Wee', Wee(i),'Wii', Wii, 'Wei', Wei(j), 'Wie', Wie(k));
                
                inputCurrentTemp = createInputISN(currents(q), currents(q), dt);
                %%Temporary
                [~, b] = size(inputCurrentTemp);
                pivot = round(b / 2);
                inputCurrent = inputCurrentTemp(:, 1 : pivot);

                r = runISNTime(time, dt, tau, column, inputCurrent, inputMatrix, tempVector, 'rectified115');
                
                SteadyStates(1, i, j, k, q) = r(1, round(.75/dt));
                SteadyStates(2, i, j, k, q) = r(2, round(.75/dt));
            end
        end
    end
end