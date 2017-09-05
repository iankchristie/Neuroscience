function r = correct_ISN_classification(resp, ISN_stats)
% CORRECT_ISN_CLASSIFICATION - apply a corrected ISN label

r = resp;

apply_correction = 0;

values = [ 4 5 ; 6 7 ; 8 9 ; 10 11; ];

[i,j] = find(resp==values);

if ~isempty(i),
	r = values(i,1);
	if ISN_stats(1,1) || ISN_stats(2,2),
		r = r+1;
	end;
end;

