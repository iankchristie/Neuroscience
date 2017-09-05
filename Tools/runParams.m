function [out] = runParams(Wee, Wii, Wei, Wie, Wxe1, Wxe2, Wxi1, Wxi2, strong, weak)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

out = 0;

m = [Wee     Wei      Wxe1         Wxi1;
     Wie     Wii      0         0;
     0       Wxi2       Wee       Wei;
     Wxe2       0        Wie       Wii];

w = [1 0; 1 0; 0 1; 0 1];

t0 = 0;
dt = .001;
tend = 2;
time = t0:dt:tend;
tau = .004;

z = zeros(2,.2/dt);
os = (1.15)*strong*ones(1,.6/dt);
ow = (1.15)*weak*ones(1,.6/dt);
ou = [os;ow];
od = [ow;os];

inputu = [z ou z [0;0]];
inputd = [z od z];

Itotal = [inputu inputd];

v = zeros(4,length(time));

r = runISNTime(time, dt, tau, m, Itotal, w, v);


%PlotISNUpDownData(timeVect, inputu, inputd, ru, rd);

 PlotISN(time, Itotal, r);


out = out + 1;

end

