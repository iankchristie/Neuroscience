clear all
%%%%%%%%%%%%%%%%%%Orientaton Selectivity Model%%%%%%%%%%%%%%%%%%%%%%%%%
% The following code is the creation a multi-neuron model for orientaion selectivity. 
% Each neuron receives biases thalamic input, which is then strengthened
% or weakened by cross connections of every cortical neuron. These cross 
% connections vary between excitatory and inhibitory based on the similarity
% of preferred-orientation of the two neurons following a cosine function 
% with J0 mean and J2 amplitude
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

T = 0;              %Start time (0 sec)
dT = .001;          %Time increment (.001 sec)
endTime = 2;        %End Time (2 sec)

t = T:dT:endTime;   %Creating of time vector

%thalmic input
A = 40;             %Maximum amplitude of thalamic input current
c = [.1 .2 .4 .8];  %Contrast vector
%c = .4;            %Used for problem 4
eps = 0.1;            %How much the input modulates with orientation
Ocue = 0;           %Angle of stimulation
sigma = 5;          %Coefficient of randomness

%Model Necessities
tau = .010;         %Time constant of rate
numNeurons = 50;    %Number of neurons in the model
r = zeros(length(c),numNeurons,length(t));  %Rate vector: [x y z] x = contrast identifier, y = rate of each neuron, z = time step

%prefered orientation vector. each index corresponds to same index in
%r(x,:,y)
prefered_orientation = -pi/2:pi/(numNeurons-1):pi/2; %between -pi/2 to pi/2

%neighboring inputs
J0 = -.5;                %J0 mean of input from neighbor rates
J2 = 1;               %J2 amplitude of input from neighbor rates
dTheta = pi/numNeurons; %size of bins when "integrating"

r(:,:,1) = rand(length(c),numNeurons,1)*10; %fill initial rates with randomness

%%%%%%%%%%%%%%%Simulation%%%%%%%%%%%%%%%%%%%%%%
for k = 1: length(c), %For each contrast
    for i = 2: length(t), %For each time step
        %get thalmic input
        h = A*c(k)*(1-eps+eps*cos(2*(prefered_orientation - Ocue)));% + sigma*randn(1,numNeurons);  %use for noise
        for j = 1:numNeurons, %for each neuron get the next time step
            %rectify the total input to the cell. 
            %total input = thalmic input + cross connections
            %cross connections = j0 plus j2 times the cosine of 2 times the sum of neighbor strengths by their respective rates, and normalize
            I = max(h(j)+(J0 + J2*cos(2*(prefered_orientation-prefered_orientation(j)))*r(k,:,i-1)'*dTheta)/numNeurons,0);
            r(k,j,i) = r(k,j,i-1)+dT*(-r(k,j,i-1)+I)/tau; %update the rate for this neuron
        end
    end
end

%For subplotting
plotLength = ceil(sqrt(length(c)));
plotWidth = floor(sqrt(length(c)));

%%ALL
figure;
for k = 1:length(c),
    str = num2str(c(k));
    subplot(plotLength,plotWidth,k);
    plot(prefered_orientation,r(k,:,end));
    xlabel('Prefered-Orientation of Cells (radians)')
    ylabel('Firing rate (Hz)')
    title(['Prefered-Orientation vs. Final Firing rate Contrast = ' str])
end

%%Comparative
figure;
for k = 1:length(c),
    str = num2str(c);
    plot(prefered_orientation,r(k,:,end));
    xlabel('Prefered-Orientation of Cells (radians)')
    ylabel('Firing rate (Hz)')
    title(['Prefered-Orientation vs. Final Firing rate Contrast = ' str])
    hold on
end

%%Data
for i = 1:length(c),
    disp(['J2 = ' num2str(J2)]);
    disp(['Mean = ' num2str(mean(r(i,:,end)))]);
    disp(['Standard Deviation = ' num2str(std(r(i,:,end)))]);
    disp(['Range = ' num2str(range(r(i,:,end)))]);
    fprintf('\n');
    
end
