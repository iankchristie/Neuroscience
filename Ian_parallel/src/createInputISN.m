function [Itotal] = createInputISN(strong, weak, dt)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

z = zeros(2,.2/dt);
os = (1.15)*strong*ones(1,ceil(.6/dt));
ow = (1.15)*weak*ones(1,ceil(.6/dt));
ou = [os;ow];
od = [ow;os];

inputu = [z ou z [0;0]];
inputd = [z od z];

Itotal = [inputu inputd];

end

