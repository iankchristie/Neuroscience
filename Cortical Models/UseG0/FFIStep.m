function [ current ] = FFIStep( time )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

current = 0;
on = 1.15;

startTime = .01;
endTime = .290;

if(time>startTime && time <endTime),
    current = on;
end

end

