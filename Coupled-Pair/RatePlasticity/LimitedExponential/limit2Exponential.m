function [final] = limit2Exponential(init, delta)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here

final = 0;

if init > 0,
    if init + delta > init*2,
        final = init*2;
    elseif init + delta < init/2,
        final = init/2;
    else
        final = init + delta;
    end
else
    if init + delta > init/2,
        final = init / 2;
    elseif init + delta < init*2
        final = init * 2;
    else
        final = init + delta;
end

end

