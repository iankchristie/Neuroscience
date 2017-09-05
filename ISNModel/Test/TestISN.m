strong = 12;
weak = 4;

Wee = .8;
Wii = 0;
Wei = .4;
Wie = -.41;

Wxe1 = 0.09;
Wxe2 = 0.00;
Wxi1 = 0.05;
Wxi2 = 0.0;

m = [Wee     Wei      Wxe1      Wxi1;
     Wie     Wii      0         0;
     Wxe2    Wxi2     Wee       Wei;
     0       0        Wie       Wii];

w = [1 0; 1 0; 0 1; 0 1];

t0 = 0;
dt = .001;
tend = 2;
timeVect = t0:dt:tend;
tau = .004;

v = zeros(4,length(timeVect));

Itotal = createInputISN(strong, weak, dt);

r = runISNTime(timeVect, dt, tau, m, Itotal, w, v, 'rectified115');


 PlotISN(timeVect, Itotal, r);
 PlotISNAll(timeVect, Itotal, r);

[LUe, LDe, RUe, RDe, LDI, RDI, SS, LUi, LDi, RUi, RDi, LSI, RSI] = analyzeISNOutput(r,dt)

if any(any(isnan(r))),
    disp('NaN');
else
    blowsUp = any(any(r > 1000));
    osc = oscillates(r);
    if(blowsUp || osc),
        if(blowsUp && ~ osc),
            disp('BlowsUp');
        end
        if(osc && ~blowsUp),
            disp('Oscillates');
        end
        if(blowsUp && osc),
            disp('BlowsUpOscillates');
        end                        
    end
end

var(r(1,.6/dt:.8/dt))
var(r(1,.2/dt:.4/dt))