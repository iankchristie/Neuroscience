function [output, averages] = simIntFireLeaky(varargin)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

El = -.070;
Rm = 12E6;
taum = .015;

Vth = -.050;
Vreset = -.065;
Vspike = .030;

Iapp = 1.6E-9;
endIapp = 2E-9;
totesIapp = 9;

T = 0;
dT = .001;
endTime = 2;

whiteNoise = 1;
sigma = .005;

assign(varargin{:});

Vm = El;

time = T:dT:endTime;
output = zeros(totesIapp,length(time));

IappVector = Iapp:(endIapp-Iapp)/totesIapp:endIapp;
averages = zeros(2,totesIapp+1);

spikeCounter = 0;

for j = 1:length(IappVector)
    for i = 1:length(time)
        if Vm == Vspike
            Vm = Vreset;
        end
        Vm = Vm + (((El-Vm)+IappVector(j)*Rm)/taum)*dT;
        if whiteNoise == 1
            Vm = Vm + randn(1)*sigma*sqrt(dT);
        end
        if Vm >= Vth
            Vm = Vspike;
            spikeCounter = spikeCounter + 1;
        end
        output(j,i) = Vm;
    end
    Vm = El;
    averages(1,j) = IappVector(j);
    averages(2,j) = spikeCounter / (endTime - T);
    spikeCounter = 0;
end

[m, ~] = size(output);

for k = 1:m
    figure;
    plot(time,output(k,:));
end

figure;
plot(averages(1,:),averages(2,:));

f = firingFrequencyCurve(IappVector,'taum',taum,'Rm',Rm,'El',El,'Vreset',Vreset,'Vth',Vth);

figure;
plot(IappVector, f);

end

