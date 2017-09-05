numTrials = 100;

Wrecorder = zeros(2,numTrials+1);
DIrecorder = zeros(2,numTrials);

strong = 10;
weak = 5;

Wxx = .34;
wxy_initial = .1;
W12 = wxy_initial;
W21 = wxy_initial;

Wrecorder(:,1) = wxy_initial;

M = [Wxx W12;
    W21 Wxx]

T = 0;  
dT = .001;         
endTime = 1;        
time = T:dT:endTime;
tau = 0.004;

zeros1 = zeros(1,.1/dT);
zeros2 = zeros(1,.2/dT);
zeros3 = zeros(1,.3/dT);
zeros4 = zeros(1,.4/dT);
zeros5 = zeros(1,.5/dT);

strongArray = strong*(1.15*ones(1,.5/dT));
weakArray = weak*(1.15*ones(1,.5/dT));

IAUp = [zeros1 strongArray zeros4 0];
IBUp = [zeros2 weakArray zeros3 0];

IUp = [IAUp; IBUp];

IADown = [zeros2 weakArray zeros3 0];
IBDown = [zeros1 strongArray zeros4 0];

IDown = [IADown; IBDown];

W = eye(2);

for i = 1: numTrials,
    i
    I = randomUpDownInput(length(time), strong, weak);
    [randomV] = runModelTime(time, dT, tau, M, I, W);
    [upV] = runModelTime(time, dT, tau, M, IUp, W);
    [downV] = runModelTime(time, dT, tau, M, IDown, W);
        
    dW12 = ratePlasticity2(randomV(1,:), randomV(2,:), dT);
    dW21 = ratePlasticity2(randomV(2,:), randomV(1,:), dT);
    W12 = rectify(W12 + dW12);
    W21 = rectify(W21 + dW21);
    
    Wrecorder(1,i+1) = W12;
    Wrecorder(2,i+1) = W21;
    
    A_Up_response = max(upV(1,:));
    A_Down_response = max(downV(1,:));

    B_Up_response = max(upV(2,:));
    B_Down_response = max(downV(2,:));
    
    A_DI = (A_Up_response - A_Down_response) / (A_Up_response + A_Down_response);
    B_DI = (B_Down_response - B_Up_response) / (B_Up_response + B_Down_response);
    
    DIrecorder(1,i) = A_DI;
    DIrecorder(2,i) = B_DI;
    
    M = [Wxx W12;
        W21 Wxx]
    
end

figure;
subplot(2,1,1);
plot(Wrecorder(1,:));
hold on
plot(Wrecorder(2,:),'r');
title('Bidirectional Training');
xlabel('Trial Number');
ylabel('Strength');
legend('W12','W21');

subplot(2,1,2);
plot(DIrecorder(1,:));
hold on
plot(DIrecorder(2,:),'r');
title('Bidirectional Training');
xlabel('Trial Number');
ylabel('Index');
legend('Neuron A','Neuron B');