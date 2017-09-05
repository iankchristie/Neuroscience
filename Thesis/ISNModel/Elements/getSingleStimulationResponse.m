function [Le, Li, Re, Ri, SS, Oscillates] = getSingleStimulationResponse(r, dt)
%CREATEUPINPUT Summary of this function goes here
%   Detailed explanation goes here

MeanThresh = .01;
CoVThresh = .05;

tStart = round(.7 / dt);
tEnd = round(.8 / dt);

targets = [r(1,tStart:tEnd);r(2,tStart:tEnd);r(3,tStart:tEnd);r(4,tStart:tEnd)];
targetsSTD = nanstd(targets');
targetsMean = nanmean(targets');
CoVVector = targetsSTD ./ targetsMean;

Oscillates = any(targetsMean >= MeanThresh & CoVVector >= CoVThresh);

if Oscillates,
    t1Start = round(.5 / dt);
    t1End = round(.8 / dt);
    
    Le = mean(r(1, t1Start:t1End));
    
    Li = mean(r(2, t1Start:t1End));

    Re = mean(r(3, t1Start:t1End));

    Ri = mean(r(4, t1Start:t1End));
else
    Le = r(1,.79/dt);
    
    Li = r(2,.79/dt);

    Re = r(3,.79/dt);

    Ri = r(4,.79/dt);
end

if(all(r(:,end)<20)), %this makes sure that it's going back to 0 with no input
    SS = 1;
else
    SS = 0;
end

end