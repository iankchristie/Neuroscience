function [out] = NoneResponsive(r, dT)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here

out = 0;
HZThresh = 40;
DIThresh = .3;

[LUe, LDe, RUe, RDe, LDI, RDI, SS] = analyzeISNOutput(r,dT);

if (LUe < HZThresh && LDe < HZThresh && RUe < HZThresh && RDe < HZThresh && LDI < DIThresh && RDI < DIThresh && SS == 1),
    out = 1;
end


end

