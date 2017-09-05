function ovi = orientation_vector_index( angles, responses )
% ORIENTATION_VECTOR_INDEX
%     OVI=ORIENTATION_VECTOR_INDEX(ANGLES, RESPONSES)
%     Takes ANGLES in degrees
%
% OVI = 1 - |R| where 
% R = (RESPONSES* EXP(2I*ANGLES)') / SUM(RESPONSES)
%
% See Rinach et al. J.Neurosci. 2002 22:5639-5651

angles = angles/360*2*pi;
r = (responses * exp(2*sqrt(-1)*angles)') / sum(abs(responses));
ovi = abs(r);
end