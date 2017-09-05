function printConnectionMatrixLabels
% PRINTCONNECTIONMATRIXLABELS - Print labels for the connection matrix
%
% Prints the following labels for the connection matrix M:
%        TO: E1      I1      E2      I2
%FROM E1     Wee     Wei     Wxe1    Wxi1
%FROM I1     Wie     Wii     0       0
%FROM E2     Wxe2    Wxi2    Wee     Wei
%FROM I2     0       0       Wie     Wii
%

str = ['        TO: E1      I1      E2      I2' sprintf('\n')  ...
	'FROM E1     Wee     Wei     Wxe1    Wxi1' sprintf('\n') ...
	'FROM I1     Wie     Wii     0       0' sprintf('\n') ...
	'FROM E2     Wxe2    Wxi2    Wee     Wei' sprintf('\n') ...
	'FROM I2     0       0       Wie     Wii' sprintf('\n') ...
	];

disp(str);

