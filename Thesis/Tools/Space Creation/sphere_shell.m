function [ox, oy, oz] = sphere_shell(radius, x, y, z)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

[ox, oy, oz] = sphere(10);

ox = ox*radius + x;
oy = oy*radius + y;
oz = oz*radius + z;
end

