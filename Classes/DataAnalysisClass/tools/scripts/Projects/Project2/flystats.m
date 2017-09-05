function [ l, sd, sn, latency,sleepDay,sleepNight ] = flystats(times, sleeprec )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

latency = [];
sleepDay = [];
sleepNight = [];

switchLength = 23;

switches = [0, 12, 24, 36, 48, 60, 72, 96];

day = 1;

for i = 1: length(switches) - 1,
    startingIndex = 2*switches(i) + 1;
    window = sleeprec(startingIndex:startingIndex + switchLength);
    if day,
        sleepDay = [sleepDay; sum(window)];
        day = 0;
    else
        sleepNight = [sleepNight; sum(window)];
        
        sleeping = find(window);
        latency = [latency; sleeping(1) / 2];
   
        day = 1;
    end
end

l = mean(latency);
sd = mean(sleepDay);
sn = mean(sleepNight);

end

