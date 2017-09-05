function r = rectify(x)

% RECTIFY - Rectify around 0
%
%  R = RECTIFY(X)
%
%  Returns X except where X is less than 0,
%  in which case 0 is returned.
%
r = x; r(find(r<0)) = 0; 

