function [out] = UnSelective2(LUe, LDe, RUe, RDe, ~, ~, ~, ~, SS)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

out = 0;

HZThresh = 60;
DIThresh = .3;

LDI = (LUe - LDe) / (LUe + LDe);

RDI = (RDe - RUe) / (RUe + RDe);

if (LUe > HZThresh && LDe > HZThresh && RUe > HZThresh && RDe > HZThresh && LDI <  DIThresh && RDI < DIThresh && SS == 1),
    out = 1;
end

end

