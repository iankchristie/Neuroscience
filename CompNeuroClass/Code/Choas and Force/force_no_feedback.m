% FORCE.m
%
% This function generates the sum of 4 sine waves in figure 2D using the architecture of figure 1A with the RLS
% learning rule.
%
% written by David Sussillo

disp('Clearing workspace.');
clear;

linewidth = 3;
fontsize = 14;
fontweight = 'bold';

N = 2500;
p = 0.1;
g = 1.6;				% g greater than 1 leads to chaotic networks.
%g = 3.0;
alpha = 1.0;
nsecs = 1440;
dt = 0.1;
learn_every = 2;

offset = 0.0*g;

scale = 1.0/sqrt(p*N);
M = sprandn(N,N,p)*g*scale;
M = full(M);

M(find(M)) = M(find(M)) + offset;

nRec2Out = N;
wo = zeros(nRec2Out,1);
dw = zeros(nRec2Out,1);
wf = 2.0*(rand(N,1)-0.5);

disp(['   N: ', num2str(N)]);
disp(['   g: ', num2str(g)]);
disp(['   p: ', num2str(p)]);
disp(['   nRec2Out: ', num2str(nRec2Out)]);
disp(['   alpha: ', num2str(alpha,3)]);
disp(['   nsecs: ', num2str(nsecs)]);
disp(['   learn_every: ', num2str(learn_every)]);


simtime = 0:dt:nsecs-dt;
simtime_len = length(simtime);
simtime2 = 1*nsecs:dt:2*nsecs-dt;

amp = 1.3;
freq = 1/60;
ft = (amp/1.0)*sin(1.0*pi*freq*simtime) + ...
     (amp/2.0)*sin(2.0*pi*freq*simtime) + ...
     (amp/6.0)*sin(3.0*pi*freq*simtime) + ...
     (amp/3.0)*sin(4.0*pi*freq*simtime);
ft = ft/1.5;

ft2 = (amp/1.0)*sin(1.0*pi*freq*simtime2) + ...
      (amp/2.0)*sin(2.0*pi*freq*simtime2) + ...
      (amp/6.0)*sin(3.0*pi*freq*simtime2) + ...
      (amp/3.0)*sin(4.0*pi*freq*simtime2);
ft2 = ft2/1.5;


wo_len = zeros(1,simtime_len);    
zt = zeros(1,simtime_len);
zpt = zeros(1,simtime_len);
x0 = 0.5*randn(N,1);
z0 = 0.5*randn(1,1);

x = x0; 
r = tanh(x)+1;
z = z0; 

ti = 0;
P = (1.0/alpha)*eye(nRec2Out);
rstore = zeros(10,length(simtime));
xstore = zeros(10,length(simtime));
for t = simtime
    ti = ti+1;	
    
    
    % sim, so x(t) and r(t) are created.
    x = (1.0-dt)*x + M*(r*dt);
    % + wf*(z*dt);
    r = tanh(x)+0.1;
%    r = max(tanh(x),0);    
%    r = tanh(x);
    z = wo'*r;
 
    rstore(:,ti) = r(1:10);
     xstore(:,ti) = x(1:10);

    
end
error_avg = sum(abs(zt-ft))/simtime_len;
disp(['Training MAE: ' num2str(error_avg,3)]);    
figure();
plot(simtime,rstore)

