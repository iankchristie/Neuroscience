function [ numSpikes ] = getNumSpikes(v, T0, T1, Vt, sampling_rate)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

numSpikes = 0;

indice0 = T0*sampling_rate;
indice1 = T1*sampling_rate;

interval = v(indice0:indice1);

numSpikes = length(find(findSpike(interval', Vt)));

end

