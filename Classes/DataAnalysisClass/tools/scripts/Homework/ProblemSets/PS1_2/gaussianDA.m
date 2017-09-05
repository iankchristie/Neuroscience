function g = gaussianDA(x, p)
% GAUSSIAN - Gaussian function
%
%   G = GAUSSIAN(X,P)
%
% Returns the Gaussian function:
%   G = P(1)+P(2)*EXP(-((X-P(3)).^2)/(2*P(4)^2))
%
% P(1) corresponds to the constant offset.
% P(2) corresponds to the height.
% P(3) corresponds to the peak location.
% P(4) corresponds to the peak width.
%

g = p(1)+p(2)*exp(-((x-p(3)).^2)/(2*p(4)^2));
end