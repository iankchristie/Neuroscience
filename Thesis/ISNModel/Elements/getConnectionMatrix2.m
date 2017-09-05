function [m] = getConnectionMatrix2(varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%%%%%The model%%%%%
%       E1      I1      E2      I2
%E1     Wee     Wei     Wxe1    Wxi1
%I1     Wie     Wii     0       0
%E2     Wxe2    Wxi2    Wee     Wei
%I2     0       0       Wie     Wii

Wee = .5;
Wei = .25;
Wie = -.25;
Wii = 0;

Wxe1 = 0;
Wxe2 = 0;
Wxi1 = 0;
Wxi2 = 0;

assign(varargin{:});

m = [Wee    Wei     Wxe1     Wxi1;
     Wie    Wii     0       0;
     Wxe2    Wxi2    Wee     Wei;
     0      0       Wie     Wii];

end

