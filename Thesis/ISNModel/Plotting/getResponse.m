function [ resp ] = getResponse(respstruct)
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here

resp = 9;

if strcmp(respstruct.Response, 'NaN'),
    resp = 1;
elseif strcmp(respstruct.Response, 'BlowsUp'),
    resp = 2;
elseif strcmp(respstruct.Response, 'Oscillates'),
    resp = 3;
elseif strcmp(respstruct.Response, 'BlowsUpOscillates'),
    resp = 4;
elseif strcmp(respstruct.Response, 'DS'),
    resp = 5;
elseif strcmp(respstruct.Response, 'DSSupress'),
    resp = 6;
elseif strcmp(respstruct.Response, 'Uni'),
    resp = 7;
elseif strcmp(respstruct.Response, 'UniSupr'),
    resp = 8;
else
    resp = 9;
end

end