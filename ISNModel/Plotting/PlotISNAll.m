function [ output ] = PlotISNAll(time, input, data)
%PLOTISN Summary of this function goes here
%   Detailed explanation goes here

output = 0;

figure;
subplot(2,1,1);
plot(time,data(1,:),'b-');
hold on
plot(time,data(2,:),'g--');
hold on
plot(time,data(3,:),'r-');
hold on
plot(time,data(4,:),'y--');
title('Response (HZ)');
xlabel('Time (sec)');
ylabel('Response');
legend('Excitatory 1','Inhibitory 1', 'Excitatory 2','Inhibitory 2');
%ylim([0 100]);
box off;

subplot(2,1,2);
plot(time,input(1,:));
hold on
plot(time,input(2,:),'r');
title('Left Data');
xlabel('Time (sec)');
ylabel('Input (HZ)');
legend('Left','Right');
box off;

output = output + 1;

end

