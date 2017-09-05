
 % this code reads in the standards and plots them
standards = read_standard_data(['datasets' filesep 'rawsequences.txt']);

figure;
plot_standard(standards, 3);  % this will plot the standards

 % this is some code that checks the performance of the basic classifier

[bestmatch,errors] = classify_melt_curve_T(standards, standards(1).data{1});

disp(['Best match is ' int2str(bestmatch) '.']);

 % plot the best match in green dash, plot example curve in green dash thin

figure;
plot_standard(standards,2,['k']);

h = plot_standard(standards, 2, [], bestmatch);
set(h,'color',[0 1 0],'linestyle','--');

h = plot_standard(standards,3, [], 1);
set(h,'color',[1 0 0],'linestyle','--');

h = plot_standard(standards, 1, [], 1, 1);
set(h,'color',[0 0 1],'linestyle','--');

box off;
error_within_across(standards);


 % do a systematic test of the classifier performance
<<<<<<< TREE
% 
% <<<<<<< TREE
% [performance,actualvsclassified] = check_classifier(standards,standards,'classify_melt_curve');
% 
% size(error_matrix);
% 
% 
% =======
% [performance,actualvsclassified,errormatrix] = check_classifier(standards,standards,'classify_melt_curve');
% 
% normalizestandards = modify_standards(standards,'normalize_by_firstvalue');
% 
% figure;
% plot_standard(normalizestandards,3);
% >>>>>>> MERGE-SOURCE
=======

[performance,actualvsclassified,errormatrix] = check_classifier(standards,standards,'classify_melt_curve');

normalizestandards = modify_standards(standards,'normalize_by_firstvalue');

figure;
plot_standard(normalizestandards,3);



[error_within, error_across, error_matrix] = error_within_across(standards);


% standard deviation analysis -- look at standard devs

clear A
for i=1:length(normalizestandards), A(i) = std(normalizestandards(i).data{1}(2,:)); end;
plot(A)
hist(A);
>>>>>>> MERGE-SOURCE

set(findobj('type','line'),'color','black')
