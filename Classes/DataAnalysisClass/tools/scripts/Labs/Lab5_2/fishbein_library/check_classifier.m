function [performance, actualvsclassified, error_matrix] = check_classifier(standards_base, standards_tocheck, classifier_function)
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
actualvsclassified = [];

for i=1:length(standards_tocheck),
	for j=1:size(standards_tocheck(i).data,2), %??this line says there is an improper index matrix reference
                                                   % It didn't give me an error; did you run it using the exact arguments in test_code.m?
		myreplicant = standards_tocheck(i).data{j};% sets each standard as variable data set to be compared to all the other standards
		actual_standard = i; %documents the standard number
		eval([ '[bestmatch,errors] = ' classifier_function '(standards_base,myreplicant);']);%?? Essentially maintains a structure of output for classifier
                                                                                             % functions that we will use in all classifiers; translates from string to function?
		actualvsclassified(end+1,[1 2]) = [actual_standard bestmatch]; % make a vertical list with 1st column containing the standard number 
                                                       %and 2nd column containing the standard number that the classifier generated                                                          
        	error_matrix(end+1,[1:size(errors)])= [errors'];             %??I forgot what was supposed to be in this error matrix.
	end;
end;
		
performance = sum(actualvsclassified(:,1)==actualvsclassified(:,2))/length(actualvsclassified);
		%??could you explain what the '==' does in this statement
		% the == means 'is equal to?'; the '=' operator assigns 'A=B', whereas 'A==B' is 1 if A is equal to B, and is 0 otherwise; '==' asks a question, '=' assigns; make sense?

