function [out] = HalfUniDirectional(LUe, LDe, RUe, RDe, LUi, LDi, RUi, RDi, SS)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

out = 0;
thresh = 60;

if(SS == 1),
    if (LUe > thresh && LDe > thresh && RUe > thresh && RDe < thresh),
        if (LUi > thresh && LDi > thresh && RUi > thresh && RDi < thresh)
            out = 2;
        else
            out = 1;
        end
    end

    if (LUe > thresh && LDe > thresh && RUe < thresh && RDe > thresh),
        if (LUi > thresh && LDi > thresh && RUi < thresh && RDi > thresh),
            out = 2;
        else
            out = 1;
        end
    end

    if (LUe > thresh && LDe < thresh && RUe > thresh && RDe > thresh),
        if (LUi > thresh && LDi < thresh && RUi > thresh && RDi > thresh),
            out = 2;
        else
            out = 1;
        end
    end

    if (LUe < thresh && LDe > thresh && RUe > thresh && RDe > thresh),
        if (LUi < thresh && LDi > thresh && RUi > thresh && RDi > thresh),
            out = 2;
        else
            out = 1;
        end
    end
end

end

