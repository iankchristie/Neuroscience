function [storers] = adjustFFI(varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

allTp = [];
allA1 = [];
allA2 = [];
allB = [];

time = 0:.01:.31;

assign(varargin{:});

i = 1;
for k = 0:.029:.290
    for t = 1 : length(time)
        allTp(i,t) = FFI(time(t),'Tp',k);
    end
    i = i+1;
end

i = 1;
for k = 0:-.2:-2
    for t = 1 : length(time)
        allA1(i,t) = FFI(time(t),'A1',k);
    end
    i = i + 1; 
end

i = 1;
for k = 0:.2:2
    for t = 1 : length(time)
        allA2(i,t) = FFI(time(t),'A2',k);
    end
    i = i + 1; 
end

i = 1;
for k = 0:-.2:-2
    for t = 1 : length(time)
        allB(i,t) = FFI(time(t),'B',k);
    end
    i = i + 1; 
end

figure;
subplot(4,1,1);
[m n] = size(allTp);
for k=1:m
    plot(time,allTp(k,:));
    hold on;
end
xlabel('Time(s)');
ylabel('output');
title(['Adjusting Tp from 0 to .29 in incriments of .029']);
box off;

subplot(4,1,2);
[m n] = size(allA1);
for k=1:m
    plot(time,allA1(k,:));
    hold on;
end
xlabel('Time(s)');
ylabel('output');
title(['Adjusting A1 from 0 to -2 in incriments of -.2']);
box off;

subplot(4,1,3);
[m n] = size(allA2);
for k=1:m
    plot(time,allA2(k,:));
    hold on;
end
xlabel('Time(s)');
ylabel('output');
title(['Adjusting A2 from 0 to 2 in incriments of .2']);
box off;

subplot(4,1,4);
[m n] = size(allB);
for k=1:m
    plot(time,allB(k,:));
    hold on;
end
xlabel('Time(s)');
ylabel('output');
title(['Adjusting B from 0 to -2 in incriments of -.2']);
box off;
end

