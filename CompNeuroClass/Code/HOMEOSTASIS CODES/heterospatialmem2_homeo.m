% heterospatialmem.m
% Code runs a number of trials of the spatial memory network
% (essentially equivalent to the orientation tuning codes
%  with very strong recurrent connections).
% In this code some randomness (heterogeneity) is added to the
% connections to show that stable memory can be lost by small
% variations across the cells.

clear
%close all
figureson = 0;

homeostasis_on = 1;
dt=0.005;
tmax = 3.;
t=0:dt:tmax;

Ncells = 36;                    % Only 20 cells, so in the spatial task one cell per 10 degrees
dtheta = 2.0*pi/Ncells;         % change in angle between cells
r=zeros(length(t),Ncells);      % Array of time-varying firing rates for each cell
h=zeros(1,Ncells);              % Fixed input from the thalamus
Itot=zeros(1,Ncells);           % Total current to each cell (will be updated each timestep)


A = 100.;                        % Amplitude of afferent input
epsilon = 0.1;                  % How peaked is the thalamic input
J0 = -7;                        % Strong all-to-all inhibition
J2 =10;                         % Strong locally peaked excitation
Wran = 0.1*J2;

W = zeros(Ncells);
theta = 2*pi*[1:Ncells]/Ncells;
for cell = 1:Ncells
    for cell2 = 1:Ncells
        W(cell,cell2) = (J0+J2*cos(theta(cell2)-theta(cell)))*dtheta/(2*pi);
    end
end
W = W.*(1+Wran*randn(Ncells));
W0 = W;
figure(98)
imagesc(W)
tau = 0.010;                     % Time constant for rate model

Ith0 = 10;                      % Average threshold
Iwidth0 = 10;                   % Average width of sigmoid firing rate curve
rmax0 = 100;                    % Average maximum firing rate
sigmaIth = 0;                 % Standard deviation across cells of threshold
sigmaIwidth = 0.0;              % Standard deviation across cells of width
sigmarmax = 0.0;                % Standard deviation across cells of maximum rate

Ith = Ith0*ones(1,Ncells) + sigmaIth*randn(1,Ncells);           % Threshold for each cell
Iwidth = Iwidth0*ones(1,Ncells) + sigmaIwidth*randn(1,Ncells);  % Width for each cell
rmax = rmax0*ones(1,Ncells) + sigmarmax*randn(1,Ncells);        % Max. rate for each cell

rand_homeo = 0.1;               % variation across cells in goal rate
rgoal = rmax0/5*(1+rand_homeo*randn(1,Ncells));                 % goal rate for homeostasis
epsilon_homeo = 0.000002;          % slow rate for doing homeostasis

figure(99)                       % Figure to plot f-I curve
clf                             % Clear figure
Iin = -50:0.1:50;             % Plot a range of input currents
rout = zeros(Ncells,length(Iin));
for cell = 1:Ncells
    rout(cell,:) = rmax(cell)./(1+exp(-(Iin-Ith(cell))/Iwidth(cell))).^2;   % This is the firing rate curve used in the simulation
end
plot(Iin,rout)                  % Plot f-I curve
xlabel('Input current')         % Label x-axis
ylabel('Firing rate')           % Label y-axis
drawnow

hstart = 0;                   % Time to switch on afferent input
hend = 1.0;                     % Time to switch off afferent input

c = 1;                        % Fixed contrast scales all inputs

Nloops = 100;                    % number of times to show each position

for loop = 1:Nloops
    loop
    rmean = zeros(1,Ncells);
    
    Ntrials = Ncells;
    cellmax = zeros(1,Ntrials);
    trial = 0;
    for cuecell = 1:Ncells;       % Vary center of input on each trial from cell 1 to 5 to 9 ...
        trial = trial + 1;
        
        for cell = 1:Ncells         % Give slightly peaked afferent input to each cell
            h(cell) = A*c*(1-epsilon + epsilon*cos(2*pi*(cell-cuecell)/Ncells));
        end
        
        for i = 2:length(t)         % Begin time integration
            
            if ( t(i) >= hstart ) && (t(i) < hend ) % In a small time window
                Itot = h;                           % give the afferent input
            else                                    % otherwise
                Itot = zeros(size(h));              % no input
            end
            
            Itot = Itot + r(i-1,:)*W;
            rinf = rmax./(1+exp(-(Itot-Ith)./Iwidth)).^2;   % Use square-of-sigmoid as firing rate curve
            % (note the ./ and.^ since this is done for a
            % vector of all cells.
            
            r(i,:) = rinf + (r(i-1,:)-rinf)*exp(-dt/tau);   % Update firing rate of all cells
            
            
        end                                 % Finished time integration
        
        
        % Now find out which cell has the highest firing rate
        rmaxcell = r(length(t),1);              % Initialize as final rate of first cell
        cellmax = 1;                            % Initialize with first cell having highest firing rate
        for cell = 2:Ncells                     % Look at all other cells
            if r(length(t),cell) > rmaxcell     % See if their final firing rate if above the highest so far
                cellmax = cell;                 % If it is then set that cell as cellmax
                rmaxcell = r(length(t),cell);   % and update the highest firing rate so far.
            end
        end
        
        
        if ( figureson)
            figure(1)                                % New figure
            clf
            subplot(2,1,1)
            plot(r(floor(hstart/dt)+1,:))             % Plot rates before afferent input
            hold on
            
            plot(r(floor(hend/dt),:),'r')            % Plot rates at end of afferent input
            
            plot(r(length(t),:),'g')                % Plot rates at the end of the delay
            drawnow
            subplot(2,1,2)
            plot(t,r(:,cuecell))                    % Rate of cuecell
            hold on
            plot(t,r(:,mod(cuecell-1+round(Ncells/4),Ncells)+1),'r')    % Rate of cell with orientation 1/4 turn
            plot(t,r(:,mod(cuecell-1-round(Ncells/4),Ncells)+1),'g')    % in each direction from cucell.
            
            plot(t,r(:,cellmax),'c')                % Rate of cell that ends up with maximum rate
            figure(2)
            imagesc(r')
            drawnow
        end
        cuecell;                                 % Let us know the cuecell
        %    cellmax                                 % and which cell had highest firing rate (they should be the same)
        % calculate population vector:
        costhetapop = cos(theta)*r(end-1,:)';
        sinthetapop = sin(theta)*r(end-1,:)';
        thetapop = atan(sinthetapop/costhetapop) + pi*(costhetapop<0);
        thetapop = thetapop + 2*pi*(thetapop<0);
        [theta(cuecell) thetapop];
        
        thetaout(trial) = thetapop;
        cueout(trial) = theta(cuecell);
        
        rmean = rmean + mean(r);
    end                         % Move to the next cuecell
    figure(3)
    plot(cueout,thetaout,'o-')
    axis([0 2*pi 0 2*pi])
    
            %% Now add homeostasis

        rmean = rmean/Ntrials;
        factors = epsilon_homeo*(rgoal-rmean);
        for post_cell = 1:Ncells
            W(:,post_cell) = (W(:,post_cell)-J0)*(1+factors(post_cell)) + J0;
        end
        figure(4) 
        plot(mean(W))
        axis([0 Ncells (-J2+J0)/Ncells (J2+J0)/Ncells])
        sd = std(mean(W))
    
end