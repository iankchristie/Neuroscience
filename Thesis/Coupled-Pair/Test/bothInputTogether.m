
strong = 10;
weak = 5;

Wr = 0.3;
W12 = 0.09;
W21 = 0.0001;

M = [Wr W12;
    W21 Wr];

dT = .001;   

zeros1 = zeros(1,.1/dT);
zeros2 = zeros(1,.2/dT);
zeros3 = zeros(1,.3/dT);
zeros4 = zeros(1,.4/dT);
zeros5 = zeros(1,.5/dT);

strongArray = strong*(1.15*ones(1,.6/dT));
weakArray = weak*(1.15*ones(1, .6/dT));

IAUp = [zeros2 strongArray zeros2 0];
IBUp = [zeros2 weakArray zeros2 0];

IUp = [IAUp; IBUp];

IADown = [zeros2 weakArray zeros2];
IBDown = [zeros2 strongArray zeros2];

IDown = [IADown; IBDown];

Itotal = [IUp IDown];

T = 0;        
endTime = dT*(length(Itotal)-1);        
time = T:dT:endTime;
tau = 0.004;

W = eye(2,2);
[v1] = runModelTime(time, dT, tau, M, Itotal, W);

% max_upA = max(v1(1,1:floor(end/2)))
% max_downA = max(v1(1,floor(end/2):end))
% 
% max_upB = max(v1(2,1:floor(end/2)))
% max_downB = max(v1(2,floor(end/2):end))

max_upA = v1(1,floor(end/4))
max_downA = v1(1,3*floor(end/4))

max_upB = v1(2,floor(end/4))
max_downB = v1(2,3*floor(end/4))

DIA = (max_upA - max_downA)/(max_upA + max_downA)
DIB = (max_downB - max_upB)/(max_upB + max_downB)

figure;
subplot(2,1,1);
plot(time, v1(1,:));
hold on
plot(time,v1(2,:),'r');
title('Response to Different Directions');
xlabel('Time (sec)');
ylabel('Response (Hz)');
legend('Neuron A','Neuron B');
axis([0 endTime 0 100]);


subplot(2,1,2);
plot(time,Itotal(1,:));
hold on
plot(time,Itotal(2,:),'r');
title('Input');
xlabel('Time (sec)');
ylabel('Input Units (amps)');
legend('Neuron A','Neuron B');
axis([0 endTime 0 15]);

