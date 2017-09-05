function [LUe, LDe, RUe, RDe, LDI, RDI, SS, LUi, LDi, RUi, RDi, LSI, RSI, notNumber, blowsUp, Oscillates, CoVVector] = analyzeISNOutput(r,dt)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

MeanThresh = .01;
CoVThresh = .05;

notNumber = any(isnan(r(:)));

blowsUp = any(r(:) > 500);

t1Start = round(.7 / dt);
t1End = round(.8 / dt);
t2Start = round(1.7 / dt);
t2End = round(1.8 / dt);

targets = [r(1,t1Start:t1End);r(1,t2Start:t2End);r(3,t1Start:t1End);r(3,t2Start:t2End)];
targetsSTD = nanstd(targets');
targetsMean = nanmean(targets');
CoVVector = targetsSTD ./ targetsMean;

Oscillates = any(targetsMean >= MeanThresh & CoVVector >= CoVThresh);

if Oscillates,
    t1Start = round(.5 / dt);
    t1End = round(.8 / dt);
    t2Start = round(1.5 / dt);
    t2End = round(1.8 / dt);
    
    LUe = mean(r(1, t1Start:t1End));

    LDe = mean(r(1, t2Start:t2End));

    RUe = mean(r(3, t1Start:t1End));

    RDe = mean(r(3, t2Start:t2End));

    LUi = mean(r(2, t1Start:t1End));

    LDi = mean(r(2, t2Start:t2End));

    RUi = mean(r(4, t1Start:t1End));

    RDi = mean(r(4, t2Start:t2End));
else
    LUe = r(1,.79/dt);

    LDe = r(1,1.79/dt);

    RUe = r(3,.79/dt);

    RDe = r(3,1.79/dt);

    LUi = r(2,.79/dt);

    LDi = r(2,1.79/dt);

    RUi = r(4,.79/dt);

    RDi = r(4,1.79/dt);
end

LDI = (LUe - LDe) / (LUe + LDe);

RDI = (RDe - RUe) / (RUe + RDe);

LSI = (LUi - LDi) / (LUi + LDi);

RSI = (RDi - RUi) / (RDi + RUi); 

if(all(r(:,1/dt)<20) && all(r(:,end)<20)), %this makes sure that it's going back to 0 with no input
    SS = 1;
else
    SS = 0;
end

end