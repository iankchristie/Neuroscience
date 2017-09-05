clear %clear all variables
% 
% This code is for problem number 2a on homework 1. It is a simulation on a
% leaky integrate and fire neuron responding to a constant applied current.
% It saves the voltage of each time step in the output vector.
% It then plots Voltave vs. Time
% 
% Note: To make dimensional analysis easier I converted all variables to 
% standard SI units.

El = -.070;         %Leak Potential (-.070 V)
Rm = 12E6;          %Membrane Resistance (12e6 ohms)
taum = .015;        %Membrane Time Constant (.015 sec)

Vth = -.050;        %Threshold potential (-0.50 V)
Vreset = -.065;     %Reset potential (-0.065 V)
Vspike = .030;      %Spike potential (0.030 V)

Vm = El;            %Initially set membrane potential to leak potential

Iapp = 1.67E-9;     %Input current (1.67E-9 amps)

T = 0;              %Start time (0 sec)
dT = .001;          %Time increment (.001 sec)
endTime = 2;        %End Time (2 sec)

time = T:dT:endTime;%Creating of time vector
output = zeros(1,length(time)); %Allocating memory for output voltages

for i = 1:length(time)  %For the length of time
    if Vm == Vspike     %Check to see if just spiked
        Vm = Vreset;    %Reset to reset potential if true
    end
    %Calculate next voltage
    Vm = Vm + (((El-Vm)+Iapp*Rm)/taum)*dT;
    if Vm >= Vth            %Check to see if spiking
        Vm = Vspike;        %We're Spiking!!! Set to Spike Potential
    end
    output(1,i) = Vm;       %Update ouput with current Voltage
end

%Plotting
str = num2str(Iapp);
plot(time,output);
xlabel('Time (sec)')
ylabel('Voltage (V)')
title(['Time vs. Voltage Current = ' str])