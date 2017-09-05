function [ISN_stats] = Ian_ISN_detect(cubestruct, kick, duration)
% Ian_ISN_detect - Detect whether network simulation is operating as an ISN
%
%  ISN_STATS = IAN_ISN_DETECT(CUBESTRUCT [, KICK, DURATION])
%
%  Tests the network described by CUBESTRUCT to see whether it operates in 
%  ISN mode. It performs a 'kick' of 1Hz to each interneuron (or KICK, if
%  the argument is provided) and examines whether the interneuron increases
%  or decreases its firing rate after 0.1 seconds (DURATION).
%
%  Inputs:
%   CUBESTRUCT - the output of a simulation with fields:
%     'm' - connection matrix
%     'LUe' - response of E_A to up
%     'LDe' - response of E_A to down
%     'LUi' - response of I_A to up
%     'LDi' - response of I_A to down
%     'RUe' - response of E_B to up
%     'RDe' - response of E_B to down
%     'RUi' - response of I_B to up
%     'RDi' - response of I_B to down
%     'Oscillates' - does it oscillate?
%     'BlowsUp' - does it blow up?
%     'SS' - does it hit a steady state
%     'Strong' - the strong input
%     'Weak' - the weak input
% 
%  Outputs:
%    ISN_STATS = [ ISN_A_UP ISN_B_UP ; ...  % are I_A, I_B performing ISN-behavior to UP?
%                  ISN_A_DOWN ISN_B_DOWN ]  % are I_A, I_B performing ISN-behavior to DOWN?
%
%   
%  

if nargin<2, kick = 1; end;
if nargin<3, duration = 0.1; end;

plotit = 0;
dt = 1e-3;
tau = 0.004;

ISN_stats = [0 0 ; 0 0];

time = 0:dt:duration;

I_neurons = [2 4];
Input =	[cubestruct.Strong cubestruct.Weak ;
	 cubestruct.Weak cubestruct.Strong ];

strs = {'LUe','LUi','RUe','RUi','LDe','LDi','RDe','RDi'};
for i=1:length(strs),
	eval([ strs{i} '=getfield(cubestruct,strs{i});']);
end;

initial_rates = [  [LUe;LUi;RUe;RUi] [LDe;LDi;RDe;RDi] ];

for i=1:length(I_neurons),
	for j = 1:size(Input,1),
		W = [ 1 0 0 ; 1 0 1; 0 1 0; 0 1 0];
		W(I_neurons(i),3) = 1;
		I_current = 1.15*repmat([Input(j,1) ; Input(j,2) ; kick/1.15],1,length(time));

		r = runISNTime(time, dt, tau, cubestruct.m, I_current, W, initial_rates(:,j), 'rectified115'); 
		ISN_stats(i,j) = r(I_neurons(i),end) < (initial_rates(I_neurons(i),j)-kick*0.5);

		if plotit,
			PlotISN(time,I_current,r);
		end;
	end;
end;

