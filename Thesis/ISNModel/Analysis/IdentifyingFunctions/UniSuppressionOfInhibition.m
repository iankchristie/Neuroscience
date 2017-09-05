function [out] = UniSuppressionOfInhibition(r,dt)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

out = 0;
threshDI = .4;
threshRate = 40;

[LUe, LDe, RUe, RDe, LDI, RDI, SS, ~, ~, ~, ~, Ldeltai, Rdeltai] = analyzeISNOutput(r,dt);

if (SS == 1), %%makes sure it returns to steady state
    if (LDI > threshDI && RDI < -threshDI), %%Left Firing
        if (LUe > threshRate) && (RUe > threshRate),
            if (Ldeltai > 1.1 && Rdeltai > 1.1)
                out = 1;
            end
        end
    end
    if (LDI < -threshDI && RDI > threshDI), %%Right firing
        if (LDe > threshRate) && (RDe > threshRate),
            if (Ldeltai < .9 && Rdeltai < .9)
                out = 1;
            end
        end
    end
end

end