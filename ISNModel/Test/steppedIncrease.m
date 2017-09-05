
input = 10;

M = [.5 .2;
    -.2 .1];

T = 0;        
endTime = 1; 
dT = .001;
time = T:dT:endTime;
tau = 0.004;

z = zeros(1,.1/dT);
step = (1.15)*input*ones(1,.8/dT);
is1 = (1.15)*8*ones(1,.2/dT);
is2 = (1.15)*input*ones(1,.2/dT);
is3 = (1.15)*12*ones(1,.2/dT);
is4 = (1.15)*14*ones(1,.2/dT);

Itotal = [z step z 0;
          z is1 is2 is3 is4 z 0];

W = eye(2);

r = zeros(2,length(time));

[v1] = runISNTime(time, dT, tau, M, Itotal, W,r);

figure;
subplot(2,1,1);
plot(time, v1(1,:));
hold on
plot(time,v1(2,:),'r');
title('Response to Different Directions');
xlabel('Time (sec)');
ylabel('Response (Hz)');
legend('Excitatory','Inhibitory');
axis([0 endTime 0 100]);


subplot(2,1,2);
plot(time,Itotal(1,:));
hold on
plot(time,Itotal(2,:),'r');
title('Input');
xlabel('Time (sec)');
ylabel('Input Units (amps)');
legend('Excitatory','Inhibitory');