function [out] = UnResponsive(LUe, LDe, RUe, RDe, ~, ~, ~, ~, SS)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

out = 0;
HZThresh = 40;
DIThresh = .3;

LDI = (LUe - LDe) / (LUe + LDe);

RDI = (RDe - RUe) / (RUe + RDe);

if (LUe < HZThresh && LDe < HZThresh && RUe < HZThresh && RDe < HZThresh && LDI < DIThresh && RDI < DIThresh && SS == 1),
    out = 1;
end

end

