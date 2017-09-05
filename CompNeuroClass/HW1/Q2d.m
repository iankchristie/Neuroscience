clear %clear all variables
% 
% This code is for problem number 2d on homework 1. It is a simulation on a
% leaky integrate and fire neuron responding rate to varying levels in current.
% This current increases incrementally from Iapp to endIapp, and stores the 
% frequency in a two demensional array, averages[], with the corresponding 
% current. It then plots the points with the theoretical frequency from 
% the script, frequencyScript.
% 
% Note1: Because this simulation only cares about frequency, I am not storing
% the potential anywhere.
% Note2: To make dimensional analysis easier I converted all variables to 
% standard SI units.

El = -.070;         %Leak Potential (-.070 V)
Rm = 12E6;          %Membrane Resistance (12e6 ohms)
taum = .015;        %Membrane Time Constant (.015 sec)

Vth = -.050;        %Threshold potential (-0.50 V)
Vreset = -.065;     %Reset potential (-0.065 V)
Vspike = .030;      %Spike potential (0.030 V)

Vm = El;            %Initially set membrane potential to leak potential

Iapp = 1.6E-9;      %First input current (1.6E-9 amps)
endIapp = 2.1E-9;   %Last input current (2.1E-9 amps)
totesIapp = 9;      %Number of increments - 1 (minus one is for indexing purposes)

T = 0;              %Start time (0 sec)
dT = .001;          %Time increment (.001 ms)
endTime = 2;        %End Time (2 sec)

time = T:dT:endTime;%Creating of time vector

IappVector = Iapp:(endIapp-Iapp)/totesIapp:endIapp; %Creation of Current Vector
averages = zeros(2,totesIapp+1);  %Creation of two dimensional array for output
                                  %this array will store current on top and
                                  %then corresponding frequency on bottom
                                 
                             

spikeCounter = 0;   %Temporary variable to count spikes

for j = 1:length(IappVector)    %For the length of the Input Current Vector
    for i = 1:length(time)      %For the length of time
        if Vm == Vspike         %Check to see if just spiked
            Vm = Vreset;        %Reset to reset potential if true
        end
        %Calculate next voltage
        Vm = Vm + (((El-Vm)+IappVector(j)*Rm)/taum)*dT;
        if Vm >= Vth            %Check to see if spiking
            Vm = Vspike;        %We're Spiking!!! Set to Spike Potential
            spikeCounter = spikeCounter + 1;    %increment spike counter
        end
    end 
    %Time simulation over. We have now recorded information with
    %IappVector(j) current
    Vm = El;    %reset Vm
    averages(1,j) = IappVector(j);  %Add current to averages
    averages(2,j) = spikeCounter / (endTime - T); %calculate and store frequency
    spikeCounter = 0;   %reset spikeCounter
end

frequencyScript %Creates frequencyCurve based on IappVector

%Plotting
figure;
plot(averages(1,:),averages(2,:),'bs-');
hold on
plot(averages(1,:),frequencyCurve,'mx-');
legend('Simulation', 'Calculation');
xlabel('Current (amps)')
ylabel('Spike Frequency (Hz)')
title('Spike Frequency vs. Current')