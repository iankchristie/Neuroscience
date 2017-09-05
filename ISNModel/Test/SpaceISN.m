strong = 14;
weak = 6;

Wee = .5;
Wii = 0;
Wei = .25;
Wie = -.25;

Wxe1 = .03;
Wxe2 = 0.0;
Wxi1 = .0;
Wxi2 = .0;

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

zeros1 = zeros(1,.1/dt);
zeros2 = zeros(1,.2/dt);
zeros3 = zeros(1,.3/dt);
zeros4 = zeros(1,.4/dt);
zeros5 = zeros(1,.5/dt);

strongArray = strong*(1.15*ones(1,.5/dt));
weakArray = weak*(1.15*ones(1,.5/dt));

IAUp = [zeros1 strongArray zeros4 0];
IBUp = [zeros2 weakArray zeros3 0];

IUp = [IAUp; IBUp];

IADown = [zeros2 weakArray zeros3];
IBDown = [zeros1 strongArray zeros4];

IDown = [IADown; IBDown];

Itotal = [IUp IDown];

v = zeros(4,length(time));

r = runISNTime(time, dt, tau, m, Itotal, w, v);

 PlotISN(timeVect, Itotal, r);
 PlotISNAll(timeVect, Itotal, r);

LUe = r(1,.6/dt)
LUi = r(2,.6/dt)

LDe = r(1,1.6/dt)
LDi = r(2,1.6/dt)

RUe = r(3,.6/dt)
RUi = r(4,.6/dt)

RDe = r(3,1.6/dt)
RDi = r(4,1.6/dt)

LDI = (LUe - LDe) / (LUe + LDe)

Ldeltai = LDi / LUi

RDI = (RDe - RUe) / (RUe + RDe)

Rdeltai = RUi / RDi


