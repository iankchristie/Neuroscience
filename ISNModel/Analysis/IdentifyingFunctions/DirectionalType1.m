function [out] = DirectionalType1(r, dT)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

out = 0;
thresh = 50;

[LUe, LDe, RUe, RDe, LDI, RDI, SS] = analyzeISNOutput(r,dT);

if (LDI >= .8 && RDI >= .8),
    if ((LUe > thresh || RUe > thresh) && (LDe > thresh || RDe > thresh))
        if(SS == 1),
            out = 1;
        end
    end
end

end

