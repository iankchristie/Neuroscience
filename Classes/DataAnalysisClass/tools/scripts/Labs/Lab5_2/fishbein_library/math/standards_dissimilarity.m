function D = standards_dissimilarity(standards)
% STANDARDS_DISSIMILARITY - Dissimilarity matrix for standards
%
%   D = STANDARDS_DISSIMILARITY(STANDARDS)
%
%   Returns an dissimilarity matrix D, where D(i,j) is the
%   squared error between the mean of standard(i) and standard(j).
%
%   See also: pdist
%
% 
% 

D = [];
for i=1:length(standards),
	[dummy,s1] = mean_standard(standards(i));
	for j=1:length(standards),
		[dummy,s2] = mean_standard(standards(j));
		D(i,j) = sum(  (s1(:)-s2(:)).^2 );
	end;
end;
