function [out] = unidirectionalType2(r, dT)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

out = 0;
thresh = 60;

[LUe, LDe, RUe, RDe, ~, ~, SS] = analyzeISNOutput(r,dT);

if(SS == 1),
    if (LUe > thresh && LDe > thresh && RUe > thresh && RDe < thresh),
        out = 1;
    end

    if (LUe > thresh && LDe > thresh && RUe < thresh && RDe > thresh),
        out = 1;
    end

    if (LUe > thresh && LDe < thresh && RUe > thresh && RDe > thresh),
        out = 1;
    end

    if (LUe < thresh && LDe > thresh && RUe > thresh && RDe > thresh),
        out = 1;
    end
end

end

