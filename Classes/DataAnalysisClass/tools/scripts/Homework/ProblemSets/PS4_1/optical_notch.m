function [result] = optical_notch(wavelengths, pass_wavelength, bandwidth)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

interval = bandwidth / 2;

high = pass_wavelength + interval;
low = pass_wavelength - interval;

result = (wavelengths > low & wavelengths < high);

end

