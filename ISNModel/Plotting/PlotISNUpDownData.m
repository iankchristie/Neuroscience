function [ output ] = PlotISNUpDownData(time,inputUp, inputDown, updata, downdata)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

output = 0;

figure;
subplot(3,2,1);
plot(time,inputUp(1,:));
hold on
plot(time,inputDown(1,:),'r');
title('T1');
xlabel('Time (sec)');
ylabel('Current');
legend('Up','Down');

subplot(3,2,2);
plot(time,inputUp(2,:));
hold on
plot(time,inputDown(2,:),'r');
title('T2');
xlabel('Time (sec)');
ylabel('Current');
legend('Up','Down');

subplot(3,2,3);
plot(time, updata(1,:));
hold on
plot(time, downdata(1,:),'r');
title('E1');
xlabel('Time (sec)');
ylabel('Firing Rate (Hz)');
legend('Up','Down');

subplot(3,2,5);
plot(time, updata(2,:));
hold on
plot(time, downdata(2,:),'r');
title('I2');
xlabel('Time (sec)');
ylabel('Firing Rate (Hz)');
legend('Up','Down');

subplot(3,2,4);
plot(time, updata(3,:));
hold on
plot(time, downdata(3,:),'r');
title('E2');
xlabel('Time (sec)');
ylabel('Firing Rate (Hz)');
legend('Up','Down');

subplot(3,2,6);
plot(time, updata(4,:));
hold on
plot(time, downdata(4,:),'r');
title('I2');
xlabel('Time (sec)');
ylabel('Firing Rate (Hz)');
legend('Up','Down');

output = output + 1;

end

