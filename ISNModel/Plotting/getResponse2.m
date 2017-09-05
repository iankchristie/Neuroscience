function [ resp ] = getResponse2(respstruct)
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here

resp = 1;

if strcmp(respstruct.Response, 'Unresponsive'),
    resp = 2;
elseif strcmp(respstruct.Response, 'Unselective'),
    resp = 3;
elseif strcmp(respstruct.Response, 'DSSupress'),
    resp = 4;
elseif strcmp(respstruct.Response, 'DS'),
    resp = 5;
elseif strcmp(respstruct.Response, 'UniSupress'),
    resp = 6;
elseif strcmp(respstruct.Response, 'Uni'),
    resp = 7;
elseif strcmp(respstruct.Response, 'HalfUniSupress'),
    resp = 8;
elseif strcmp(respstruct.Response, 'HalfUni'),
    resp = 9;
elseif strcmp(respstruct.Response, 'Half2UniSupress'),
    resp = 10;
elseif strcmp(respstruct.Response, 'HalfUni2'),
    resp = 11;
else
    resp = 1;
end

end