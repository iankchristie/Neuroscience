function [out] = SuppressionOfInhibition(r,dt)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

[~, ~, ~, ~, LDI, RDI, ~, ~, ~, ~, ~, Ldeltai, Rdeltai] = analyzeISNOutput(r,dt);

out = 0;

if LDI > 0,
    if Ldeltai > 1.1 && Rdeltai < .9,
        out = 1;
    end
else
    if Ldeltai < .9 && Rdeltai > 1.1,
        out = 1;
    end
end

end

