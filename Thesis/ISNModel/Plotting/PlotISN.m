function [ output ] = PlotISN(time, input, data)
%PLOTISN Summary of this function goes here
%   Detailed explanation goes here

output = 0;

figure;
subplot(3,1,1);
plot(time,data(1,:),'b-');
hold on
plot(time,data(2,:),'g--');
title('Left Data');
xlabel('Time (sec)');
ylabel('Response');
legend('Excitatory','Inhibitory');
%ylim([0 100]);
box off;

subplot(3,1,2);
plot(time,data(3,:),'r-');
hold on
plot(time,data(4,:),'y--');
title('Right Data');
xlabel('Time (sec)');
ylabel('Response');
legend('Excitatory','Inhibitory');
%ylim([0 100]);
box off;

subplot(3,1,3);
plot(time,input(1,:),'b-');
hold on
plot(time,input(2,:),'r-');
title('Left Data');
xlabel('Time (sec)');
ylabel('Input');
legend('Left','Right');
box off;

output = output + 1;

end

