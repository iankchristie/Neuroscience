strong = 10;
weak = 5;

M = [.3 .05;
    .05 .3];

T = 0;  
dT = .001;         
endTime = 1;        
time = T:dT:endTime;
tau = 0.004;
aStart = .1;
bstart = .2;
aEnd = .6;
bEnd = .7;

zeros1 = zeros(1,.1/dT);
zeros2 = zeros(1,.2/dT);
zeros3 = zeros(1,.3/dT);
zeros4 = zeros(1,.4/dT);

strongArray = strong*(1.15*ones(1,.5/dT));
weakArray = weak*(1.15*ones(1,.5/dT));

IAUp = [zeros1 strongArray zeros4 0];
IBUp = [zeros2 weakArray zeros3 0];

IUp = [IAUp; IBUp];

IADown = [zeros2 weakArray zeros3 0];
IBDown = [zeros1 strongArray zeros4 0];

IDown = [IADown; IBDown];

W = eye(2,2);

[v1] = runModelTime(time, dT, tau, M, IUp, W);
[v2] = runModelTime(time, dT, tau, M, IDown, W);

max_upA = max(v1(1,:))
max_downA = max(v2(1,:))

max_upB = max(v1(2,:))
max_downB = max(v2(2,:))

DIA = (max_upA - max_downA)/(max_upA + max_downA)
DIB = (max_downB - max_upB)/(max_upB + max_downB)

figure;
subplot(2,2,1);
plot(time, v1(1,:));
hold on
plot(time,v1(2,:),'r');
title('Repsonse in Up Direction');
xlabel('Time (sec)');
ylabel('Response (Hz)');
legend('Neuron A','Neuron B');
subplot(2,2,2);
plot(time, v2(1,:));
hold on
plot(time, v2(2,:),'r');
title('Repsonse in Down Direction');
xlabel('Time (sec)');
ylabel('Response (Hz)');
legend('Neuron A','Neuron B');
subplot(2,2,3);
plot(time,IUp(1,:),'g');
hold on
plot(time,IUp(2,:),'m');
title('Input');
xlabel('Time (sec)');
ylabel('Input Units (amps)');
legend('Strong','Weak');
subplot(2,2,4);
plot(time,IUp(1,:),'g');
hold on
plot(time,IUp(2,:),'m');
title('Input');
xlabel('Time (sec)');
ylabel('Input Units (amps)');
legend('Strong','Weak');
hold off;
