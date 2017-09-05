function [ out ] = UniDirectional(LUe, LDe, RUe, RDe, LUi, LDi, RUi, RDi, SS)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

out = 0;
threshDI = .4;
threshSI = .2;
threshRate = 40;

LDI = (LUe - LDe) / (LUe + LDe);

RDI = (RDe - RUe) / (RUe + RDe);

LSI = (LUi - LDi) / (LUi + LDi);

RSI = (RDi - RUi) / (RDi + RUi);

if (SS == 1), %%makes sure it returns to steady state
    if (LDI > threshDI && RDI < -threshDI), %%Responding to up
        if (LUe > threshRate) && (RUe > threshRate), %%Makes sure that they're responsive
            if (LSI > threshSI && RSI < -threshSI)
                out = 2;
            else
                out = 1;
            end
        end
    end
    if (LDI < -threshDI && RDI > threshDI), %%Responding to down
        if (LDe > threshRate) && (RDe > threshRate),
            if (LSI < -threshSI && RSI > threshSI),
                out = 2;
            else
                out = 1;
            end
        end
    end
end

