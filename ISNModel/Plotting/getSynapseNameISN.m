function [name] = getSynapseNameISN(x, y)
%RUNTRIALWITHPLASTICITY Summary of this function goes here
%   Detailed explanation goes here

nameMatrix = {'Wee',    'Wei',  'Wxe1',     'Wxi1'; 
              'Wie',    'Wii',  '0',        '0';
              'Wxe2',   'Wxi2', 'Wee',      'Wei';
              '0',      '0',    'Wie',      'Wii'};

name = nameMatrix{x,y};

end
