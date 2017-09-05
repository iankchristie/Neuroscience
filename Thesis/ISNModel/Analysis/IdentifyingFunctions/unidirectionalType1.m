function [out] = unidirectionalType1(r, dT)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

out = 0;
threshDI = .4;
threshRate = 40;

[LUe, LDe, RUe, RDe, LDI, RDI, SS] = analyzeISNOutput(r,dT);

if (SS == 1), %%makes sure it returns to steady state
    if (LDI > threshDI && RDI < -threshDI), %%Left Firing
        if (LUe > threshRate) && (RUe > threshRate),
            out = 1;
        end
    end
    if (LDI < -threshDI && RDI > threshDI), %%Right firing
        if (LDe > threshRate) && (RDe > threshRate),
            out = 1;
        end
    end
end

end

