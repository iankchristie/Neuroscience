function [Itotal] = createInputISN(strong, weak, dt)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

z1 = zeros(2,.1/dt); % 0.1
z2 = zeros(2,0.2/dt); %0.2 seconds
z = zeros(2,.2/dt); % 0.2
os2 = (1.15)*strong*ones(1,ceil(.4/dt)); %0.6
ow2 = (1.15)*weak*ones(1,ceil(.4/dt)); % 0.6
os = (1.15)*strong*ones(1,ceil(.6/dt)); %0.6
ow = (1.15)*weak*ones(1,ceil(.6/dt)); % 0.6
ou = [os;ow];
od = [ow;os];

if 1,
    inputu = [z ou z [0;0]];
    inputd = [z od z];
else,
    inputu = [z1 ou z2 [0;0]];
    inputd = [z1 od z2];    
end;

Itotal = [inputu inputd];

end

