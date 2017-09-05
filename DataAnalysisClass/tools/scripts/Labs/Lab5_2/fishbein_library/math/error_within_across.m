 function [error_within, error_across, error_matrix, W, B, grand_mean] = error_within_across(standards)
 % CHECKCLASSIFIER- compares standards to themselves, tests the strength of
 % each classification algorithm
 % [performance, [actualvsclassified],[error_matrix]]=check_classifier(standards standards classifier)
 % 
 % The three inputs are the standards twice and the classifying function to
 % be tested. The output is a numerical performance value, a matrix with
 % the results of the classification of the standards against themselves,
 % and the error matrix, which shows the error in classifying each
 % standard. Loops through the standards, comparing them against each other.
 % this is setup to only handle case where standards_base == standards_tocheck
 % 
 % error_matrix is an NUMBER_OF_REPLICANTS(in standards_to_check) X NUM_STANDARDS (in standards)
 % array, where errormatrix(i,j) is the error of replicant i on standard number j.

error_matrix = []; %declares the two output matrices

error_within = zeros(length(standards),1);

error_across = zeros(length(standards),length(standards));

W = [];

B = [];

grand_mean = [];

X_diff = {};

m=1;  % m refers to the replicant number
for i=1:length(standards)
	X_diff{i} = [];
	[dummyT,mymean]=mean_standard(standards(i)); % we needed the 2nd output argument; the first output argument is the time
	grand_mean = [grand_mean; mymean*size(standards(i).data,2)];
        for j=1:size(standards(i).data,2)  % I changed t to i
		errorw =sum((standards(i).data{j}(2,:)-mymean).^2);
		X_diff{i} = [X_diff{i} ; standards(i).data{j}(2,:) - mymean];
		error_matrix(m,i)= errorw;
            m=m+1;
        end
    %end
end


for i=1:length(standards),
	if isempty(W),
		W = X_diff{i}' * X_diff{i};
	else, W = W + X_diff{i}' * X_diff{i};
	end;
end;

size(W),

grand_mean = mean(grand_mean,1);

for i=1:length(standards),
	% calculate mean of the standard here
	[dummyT,mymean] = mean_standard(standards(i));% we needed the 2nd output argument; the first output argument is the time
	N_replicants = size(standards(i).data,2);
	if isempty(B),
		B = N_replicants*(mymean-grand_mean)'*(mymean-grand_mean);
	else,
		B = B+N_replicants*(mymean-grand_mean)'*(mymean-grand_mean);
	end;
	for j=1:size(standards(i).data,2), 
		myreplicant = standards(i).data{j};
		errorw =sum((myreplicant(2,:)-mymean).^2);
		error_within(i) = error_within(i) + (errorw/N_replicants);
	end;

	for k=1:length(standards),
		[dummyT,myothermean] = mean_standard(standards(k));% we needed the 2nd output argument; the first output argument is the time
		error_across(i,k) =  sum((mymean-myothermean).^2);
	end;
end;

