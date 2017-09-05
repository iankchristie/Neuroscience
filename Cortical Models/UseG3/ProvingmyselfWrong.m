
strong = 5;
weak = 2;

M = [.3 1;
    0.1 .3];


u_up = [strong; weak];
u_down = [weak; strong];

W = eye(2,2);

[v1, t1] = RunModelMatrix(M, u_up, W);
[v2, t2] = RunModelMatrix(M, u_down, W);

max_upA = max(v1(1,:))
max_downA = max(v2(1,:))

max_upB = max(v1(2,:))
max_downB = max(v2(2,:))

DIA = (max_upA - max_downA)/(max_upA + max_downA)
DIB = (max_downB - max_upB)/(max_upB + max_downB)

result = zeros(1,length(t1));

for i=1:length(t1),
    result(i) = FFIStep(t1(i));
end

figure;
subplot(3,1,1);
plot(t1, v1(1,:));
hold on
plot(t2,v2(1,:),'r');
title('Repsonse in Up Direction');
xlabel('Time (sec)');
ylabel('Response (Hz)');
legend('Neuron A','Neuron B');
axis([0 .4 0 100]);
subplot(3,1,2);
plot(t1, v1(2,:));
hold on
plot(t2, v2(2,:),'r');
title('Repsonse in Down Direction');
xlabel('Time (sec)');
ylabel('Response (Hz)');
legend('Neuron A','Neuron B');
axis([0 .4 0 100]);
subplot(3,1,3);
plot(t1,strong*result,'g');
hold on
plot(t1,weak*result,'m');
title('Input');
xlabel('Time (sec)');
ylabel('Input Units (amps)');
legend('Strong','Weak');
axis([0 .4 0 15]);

