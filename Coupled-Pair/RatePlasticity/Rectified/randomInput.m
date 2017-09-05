numTrials = 200;
Wrecorder = zeros(2,numTrials+1);
DIrecorder = zeros(2,numTrials);

Strongmax = 10;
Weakmin = 5;

Wxx = .3;
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

Ts = [zeros1 Strongmax*ones(1,.3/dT) zeros1];
Tw = [zeros1 Weakmin*ones(1,.3/dT) zeros1];
Ttime = 0:dT:(length(Ts)-1)*dT;

TUp = [Ts; Tw];
TDown = [Tw; Ts];

W = eye(2,2);

for i = 1: numTrials,
    
    a = (Strongmax - Weakmin)*rand(1)+Weakmin;
    b = (Strongmax - Weakmin)*rand(1)+Weakmin;
    
    if a > b,
        strong = a;
        weak = b;
    else
        strong = b;
        weak = a;
    end
    
    strongArray = strong*(1.15*ones(1,.5/dT));
    weakArray = weak*(1.15*ones(1,.5/dT));

    IAUp = [zeros1 strongArray zeros4 0];
    IBUp = [zeros2 weakArray zeros3 0];

    IUp = [IAUp; IBUp];

    IADown = [zeros2 weakArray zeros3 0];
    IBDown = [zeros1 strongArray zeros4 0];

    IDown = [IADown; IBDown];

    temp = round(rand);
    if temp,
        disp('UP');
        [v1] = runModelTime(time, dT, tau, M, IUp, W);
    else
        disp('Down');
        [v1] = runModelTime(time, dT, tau, M, IDown, W);
    end
    dW12 = ratePlasticity2(v1(1,:), v1(2,:), dT);
    dW21 = ratePlasticity2(v1(2,:), v1(1,:), dT);
    W12 = rectify(W12 + dW12);
    W21 = rectify(W21 + dW21);
    Wrecorder(1,i+1) = W12;
    Wrecorder(2,i+1) = W21;
    
    [Tup] = runModelTime(Ttime, dT, tau, M, TUp, W);
    [Tdown] = runModelTime(Ttime, dT, tau, M, TDown, W);
    
    A_Up_response = max(Tup(1,:));
    A_Down_response = max(Tdown(1,:));

    B_Up_response = max(Tup(2,:));
    B_Down_response = max(Tdown(2,:));
    
    A_DI = (A_Up_response - A_Down_response) / (A_Up_response + A_Down_response);
    B_DI = (B_Down_response - B_Up_response) / (B_Up_response + B_Down_response);
    
    DIrecorder(1,i) = A_DI;
    DIrecorder(2,i) = B_DI;
    
    M = [Wxx W12;
        W21 Wxx]
    
%     if mod(i,25)==0,
%         figure;
%         plot(time, v1(1,:));
%         hold on
%         plot(time,v1(2,:),'r');
%         if temp,
%             title('Repsonse in Up Direction');
%         else
%             title('Repsonse in Down Direction');
%         end
%         xlabel('Time (sec)');
%         ylabel('Response (Hz)');
%         legend('Neuron A','Neuron B');
%     end
    
end

figure;
subplot(2,1,1);
plot(Wrecorder(1,:));
hold on
plot(Wrecorder(2,:),'r');
title('Random Training');
xlabel('Trial Number');
ylabel('Strength');
legend('W12','W21');

subplot(2,1,2);
plot(DIrecorder(1,:));
hold on
plot(DIrecorder(2,:),'r');
title('Random Training');
xlabel('Trial Number');
ylabel('Index');
legend('Neuron A','Neuron B');