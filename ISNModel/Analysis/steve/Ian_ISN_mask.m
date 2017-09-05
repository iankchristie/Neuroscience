function b = Ian_ISN_mask(ISN_values)
% IAN_ISN_MASK - return a mask as to whether major columns are ISN
%
%  

 % assume 3D input

for i=1:size(ISN_values,1), 
	for j=1:size(ISN_values,2),
		for k=1:size(ISN_values,3),
			if ~isempty(ISN_values{i,j,k}),
				b(i,j,k) = ISN_values{i,j,k}(1,1) || ISN_values{i,j,k}(2,2);
			end;
		end;
	end;
end;
	
