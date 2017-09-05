function new_standards = modify_standards(standards, functionname)

% MODIFY_STANDARDS - Apply an operator to a set of melt curve standards
%
%   NEW_STANDARDS = MODIFY_STANDARDS(STANDARDS, FUNCTIONNAME)
%
%   Applies the function FUNCTION name to the individual melt curve examples
%   in standards.
%
%   The form of the function defined by FUNCTIONNAME should be
%       my_new_curve = FUNCTIONNAME(a_single_melt_curve)
%     where a_single_melt_curve is a 2 x N matrix with the
%     first row being the temperature values and the second row being the
%     fluorescent values.
%

new_standards = standards;

for i=1:length(new_standards),
	for j=1:size(new_standards(i).data,2),
		eval(['new_standards(i).data{j} = ' functionname '(new_standards(i).data{j});']);
	end;
end;

