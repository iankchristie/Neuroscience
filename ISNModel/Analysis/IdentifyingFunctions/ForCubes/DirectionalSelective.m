function [out] = DirectionalSelective(LUe, LDe, RUe, RDe, LUi, LDi, RUi, RDi, SS)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


out = 0;
thresh = 50;

LDI = (LUe - LDe) / (LUe + LDe);

RDI = (RDe - RUe) / (RUe + RDe);

LSI = (LUi - LDi) / (LUi + LDi);

RSI = (RDi - RUi) / (RDi + RUi);

if (SS == 1), %%Makes sure that we reach steady state
    if (LDI >= .8 && RDI >= .8),    %%Cells are directional selective. Left is firing to up and Right is firing to DOwn
        if ((LUe > thresh) && (RDe > thresh))   %%Makes sure that they are responsive
            if ((LSI > .2) && (RSI >= .2)),     %%Tests suppression
                out = 2;    %%Return 2 if suppression of inhibition exists
            else
                out = 1;    %%Return 1 is suppression of inhibition doesn't exist yet is still direction selective
            end
        end
    elseif (LDI <= -.8 && RDI <= -.8),
        if ((RUe > thresh) && (LDe > thresh))
            if ((LSI <= -.2) && (RSI <= -.2)),
                out = 2;
            else
                out = 1;
            end
        end
    end
end

end

