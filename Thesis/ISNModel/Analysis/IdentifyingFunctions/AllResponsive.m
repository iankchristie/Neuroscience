function [out] = AllResponsive(r,dT)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here

out = 0;

HZThresh = 60;
DIThresh = .3;

[LUe, LDe, RUe, RDe, LDI, RDI, SS] = analyzeISNOutput(r,dT);

if (LUe > HZThresh && LDe > HZThresh && RUe > HZThresh && RDe > HZThresh && LDI < DIThresh && RDI < DIThresh && SS == 1),
    out = 1;
end

end

