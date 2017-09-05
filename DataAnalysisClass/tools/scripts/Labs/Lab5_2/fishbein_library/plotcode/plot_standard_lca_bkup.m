function [signals,PC,V,themean] = lca1(data)
W=[];
m=1;
for i=1:length(standards)
    [dummyT,mymean]=mean_standard(standards(i));   
        for j=1:size(standards(i).data,2) 
            errorw =sum((standards(i).data{j}(2,:)-mymean).^2);
        	W(m)= errorw;
            m=m+1;
        end
B=[];

	for k=1:length(standards),
		[dummyT,myothermean] = mean_standard(standards(k));% we needed the 2nd output argument; the first output argument is the time
		error_across(i,k) =  sum((mymean-myothermean).^2);
	end;
end;


finalproduct=inv(W)*B;
[PC, V] = eig(finalproduct); 
% extract diagonal of matrix as vector 
V = diag(V); 
% sort the variances in decreasing order 
%[junk, rindices] = sort(-1*V); 
[junk, rindices] = sort(-abs(V)); 
V = V(rindices);
PC = PC(:,rindices); 
% project the original data set 
signals = PC' * data;
