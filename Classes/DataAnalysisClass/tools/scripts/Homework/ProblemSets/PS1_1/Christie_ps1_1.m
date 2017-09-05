%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ian Christie
% Data Analysis
% Problem Set 1.1
% September 10, 2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Q1.1
% drugvsplacebo
% RUN   DIFFERENCE  DIFFERENT?      Was choice best for you?    Best for # out of 100?
% 1     3           1               Yes                         64
% 2     2           1               Yes                         55
% 3     5           1               Yes                         95
% 4     1           1               Yes                         52
% 5     5           1               Yes                         91
% 
% drugvsplacebo('mean')
% RUN   DIFFERENCE  DIFFERENT?      Was choice best for you?    Best for # out of 100?
% 1     2           1               No                          53
% 2     5           1               Yes                         94
% 3     1           1               Yes                         77
% 4     5           1               Yes                         100
% 5     4           1               Yes                         81
%
% drugvsplacebo('median')
% RUN   DIFFERENCE  DIFFERENT?      Was choice best for you?    Best for # out of 100?
% 1     3           1               Yes                         50
% 2     4           1               Yes                         55
% 3     1           0               Yes                         55
% 4     5           1               Yes                         74
% 5     4           1               Yes                         82
% 
% drugvsplacebo('percentilerange')
% RUN  DIFFERENCE   DIFFERENT?      Was choice best for you?    Best for # out of 100?
% 1     3           1               Yes                         63
% 2     3           1               Yes                         61
% 3     4           1               Yes                         77
% 4     5           1               Yes                         99
% 5     4           1               Yes                         73
% 
% drugvsplacebo('bargraphrange')
% RUN  DIFFERENCE   DIFFERENT?      Was choice best for you?    Best for # out of 100?
% 1     3           1               Yes                         93
% 2     3           1               Yes                         94
% 3     4           1               Yes                         89
% 4     5           1               Yes                         95
% 5     4           1               Yes                         73
% 
% drugvsplacebo('histogram')
% RUN  DIFFERENCE   DIFFERENT?      Was choice best for you?    Best for # out of 100?
% 1     4           1               Yes                         85
% 2     5           1               Yes                         89
% 3     4           1               Yes                         56
% 4     5           1               Yes                         100
% 5     2           1               Yes                         64
% 
% drugvsplacebo('cumulativehistogram')
% RUN   DIFFERENCE  DIFFERENT?      Was choice best for you?    Best for # out of 100?
% 1     5           1               Yes                         86
% 2     5           1               Yes                         89
% 3     5           1               Yes                         99
% 4     5           1               Yes                         91
% 5     5           1               Yes                         83
% 
% Q1.2 
% My scores improved for percentilerange and histogram. I feel like I have 
% a better understand of the underlying data.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% READ ME: I did most of this with my own functions, not knowing that we
% were going ot be given a lot of them. I didn't want to delete that code,
% so I re-did them with the given functions on subplots and other figures.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Q2.1

gdata = load('days_guineapig_survival.txt', '-ascii');
mean(gdata)         %= 141.8472
median(gdata)       %= 102.5000
prctile(gdata, 25)  %= 82.5000
prctile(gdata, 75)  %= 151.5000

% The median probably would be the best indicator since the mean is influenced 
% by outliers. Imagine there was data corruption or an immortal geniue pig,
% the mean would be very affected by it but the median would be the same.
% However, the mean stripped of outliers would probably be a better
% indicator than the median.

% Q2.2
%This is a histogram with an overlay of a cumulative histogram with my own
%functions. I use steves functions in the next figure.
f1 = figure(1);
set(f1, 'name','Q2_2 & Q2_3');
a1 = axes('Parent',f1);
hist(gdata,15)
ylabel('Frequency')

% Q2.3 I put it on the same plot to be able to compare the histogram and
% the cumulative histogram more easily
a2 = axes('Parent',f1);
cdfplot(gdata)
grid off
set(a2,'Color','none')
set(a2,'YAxisLocation','right')
title('Histogram and Cumulative Histogram of Geuineapig Survival Rate')
xlabel('Survival Times (units)')
ylabel('Proportion of Area Under the Curve')

% This is using given functions
% Alternative Q2_2
f2 = figure(2);
set(f2, 'name','Alternative Q2_2 & Q2_3');
subplot(2,1,1);
[N,bin_centers] = histbins(gdata, 0:25:600);
bar(bin_centers,N);
title('Histogram of Geuineapig Survival Rate');
xlabel('Survival Times (days)')
ylabel('Number of occurrences');

% Alternative Q2_3
subplot(2,1,2);
[X1,Y1] = cumhist(gdata, [0 600],1);
plot(X1,Y1);
title('Cumulative Histogram of Geuineapig Survival Rate')
xlabel('Survival Times (days)')
ylabel('Percent of Area Under the Curve')

% Answer to Q2_3
% I don't think that the regular or cumulative histogram gives you much more 
% information than the other. The cumuluative hist is just the integration 
% from infinity of each data point in the histogram. Therefore, the shape of
% the histogram can be found by taking the derivative of the cumulative plot.
% Cumulative plots are a little less intunitive for beginners. But I like 
% looking at the cumulative plot because it condenses information nicely into
% a single curve. Plus we can do more statistical analysis of cumulative
% histograms than regular histograms.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Q3.1
gdc = load('glucose_diabetic_class.txt', '-ascii');
gdcmean = mean(gdc) % = 163.2778
gdi = load('glucose_diabetic_individual.txt', '-ascii');
gdimean = mean(gdi) % = 190.0625

% Note: These are bar graphs, not histograms! I initially didn't understand
% what was meant by "bar graphs of the mean".
f3 = figure(3);
set(f3, 'name','Q3_1 with Alternatives');
subplot(2,2,1);
bar(gdc, 'g');
hold on
xlim = get(gca, 'XLim');
line(xlim, [gdcmean gdcmean], 'color','k');
title('Glucose Diabetic Class Bar Graph and Mean Data')
axis([0 20 0 400])
xlabel('Patient Number')
ylabel('Glucose Measurements (mg/dl)')
legend('datapoints', 'mean','Location', 'northwest');

subplot(2,2,2);
bar(gdi);
hold on
axis([0 20 0 400])
xlim = get(gca, 'XLim');
line(xlim, [gdimean gdimean], 'color','k');
title('Glucose Diabetic Individual Bar Graph and Mean Data')
xlabel('Patient Number')
legend('datapoints', 'mean','Location', 'northwest');

subplot(2,2,3);
bar(1,gdcmean,'w');
hold on
plot(1,gdc,'og')
axis([0 2 0 400])
xlabel('Cumulative Data')
ylabel('Glucose Measurements (mg/dl)')

subplot(2,2,4);
bar(1,gdimean,'w');
hold on
plot(1,gdi,'sb')
axis([0 2 0 400])
xlabel('Cumulative Data')

% Q3.2
% Note: These are histograms
f4 = figure(4);
set(f4, 'name','Q3_2');
subplot(2,1,1);
hist(gdc, 7);
axis([50 400 0 6]);
title('Glucose Diabetic Class Histogram')
xlabel('Glucose Measurements (units)')
ylabel('Frequency')
subplot(2,1,2);
hist(gdi, 7);
axis([50 400 0 6]);
title('Glucose Diabetic Indivudual Histogram')
xlabel('Glucose Measurements (units)')
ylabel('Frequency')

% Another way to do it... stole some code from the drugvsplacebodisplay
f5 = figure(5);
set(f5, 'name','Alternative Q3_2');
bin_min = min(min(gdc),min(gdi));
bin_max = max(max(gdc),max(gdi));
bin_width = 2*iqr([gdc(:);gdi(:)])/power(length(gdc)/2+length(gdi)/2,1/3);
bin_edges = (bin_min-bin_width):bin_width:(bin_max+bin_width);
bin_centers = bin_edges + bin_width/2;
N1 = histc(gdc,bin_edges);
N2 = histc(gdi,bin_edges);
subplot(2,1,1);
bar(bin_centers,N1,'b');
title('Glucose Diabetic Class Histogram')
ylabel('Frequency');
box off;
subplot(2,1,2);
bar(bin_centers,N2,'g');
title('Glucose Diabetic Indivudual Histogram')
ylabel('Frequency');
xlabel('Glucose Measurements');
box off;

% Q3.3
f6 = figure(6);
set(f6, 'name','Q3_3 with Alternative');
subplot(2,1,1);
cdfplot(gdc);
hold on
h = cdfplot(gdi);
hold off
set(h,'color','r')
title('Diabetes Cumulative Histogram')
xlabel('Glucose Measurements (units)')
ylabel('Proportion of Area under the distribution')
legend('Class', 'Individual');

% Using cumhist
subplot(2,1,2);
[X1,Y1] = cumhist(gdc, [50 400],1);
[X2,Y2] = cumhist(gdi, [50 400],1);
plot(X1,Y1);
hold on
plot(X2,Y2, 'r');
title('Diabetes Cumulative Histogram')
xlabel('Glucose Measurements (units)')
ylabel('Proportion of Area under the distribution')
legend('Class', 'Individual');

% Q3.4
% I would advise my friend to take the group classes. We want our friend to
% have the greatest probability of low blood-sugar. Therefore we want the
% distribution that is most leftwards. We can kind of see that in the
% histograms, but the difference really shows in the cumulative plot. Even
% the top percentile for group classes is worse than individual classes, I
% hope that my friend is more average and thus will proabably benefit more
% from group classes.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Q4.1
% drugvsplacebo('*mean')
% RUN       DIFFERENCE      DIFFERENT?      CODE
% 1         1               0               164
% 2         1               0               824
% 3         1               0               907
% 4         1               0               848
% 5         2               0               889
% 6         2               0               507
% 7         3               1               961
% 8         0               0               851
% 9         3               1               933
% 10        0               0               472

% drugvsplacebo('*median')
% RUN       DIFFERENCE      DIFFERENT?      CODE
% 1         0               0               631
% 2         5               1               230
% 3         1               0               191
% 4         0               0               907
% 5         2               0               499
% 6         1               0               152
% 7         3               1               679
% 8         4               1               540
% 9         0               0               801
% 10        1               0               094

% drugvsplacebo('*percentilerange')
% RUN       DIFFERENCE      DIFFERENT?      CODE
% 1         2               1               898
% 2         3               1               115
% 3         2               0               628
% 4         0               0               829
% 5         3               1               815
% 6         3               1               641
% 7         0               0               567
% 8         4               1               626
% 9         3               0               317
% 10        4               1               432

% drugvsplacebo('*bargraphrange')
% RUN       DIFFERENCE      DIFFERENT?      CODE
% 1         2               0               373
% 2         0               0               112   
% 3         1               0               719
% 4         1               0               306
% 5         2               1               841
% 6         3               1               054
% 7         1               0               996
% 8         1               0               466
% 9         2               0               403
% 10        2               0               011

% drugvsplacebo('*histogram')
% RUN       DIFFERENCE      DIFFERENT?      CODE
% 1         1               1               574
% 2         2               0               290
% 3         3               0               040
% 4         1               0               458
% 5         2               0               921
% 6         1               1               686
% 7         2               1               616
% 8         3               0               381
% 9         4               0               523
% 10        2               0               110

% drugvsplacebo('*cumulativehistogram')
% RUN       DIFFERENCE      DIFFERENT?      CODE
% 1         1               0               701
% 2         1               0               236
% 3         1               0               575
% 4         1               1               777
% 5         2               0               736
% 6         1               0               168
% 7         2               0               799
% 8         2               1               388
% 9         2               1               117
% 10        2               1               001
