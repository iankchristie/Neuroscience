%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ian Christie
% Data Analysis
% Problem Set 1.3
% October 12, 2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


A = [15 16 17; 18 19 20; 21 22 23; 24 25 26];

if isequal([15; 18; 21; 24], A(:,1)),
    disp('Test 1: Correct');
else 
    disp('Test 1: Incorrect');
    disp('Correct Answer');
    A(:,1),
end

if isequal([15 16 17], A(1,:)),
    disp('Test 2: Correct');
else 
    disp('Test 2: Incorrect');
    disp('Correct Answer');
    A(1,:),
end

if isequal([15 16;18 19;21 22;24 25], A(:,[1 2])),
    disp('Test 3: Correct');
else 
    disp('Test 3: Incorrect');
    disp('Correct Answer');
    A(:,[1 2]),
end

if isequal([17 16 15;20 19 18;23 22 21;26 25 24], A(:,[3 2 1])),
    disp('Test 4: Correct');
else 
    disp('Test 4: Incorrect');
    disp('Correct Answer');
    A(:,[3 2 1]),
end

if isequal([31;37;43;49], A(:,1) + A(:,2)),
    disp('Test 5: Correct');
else 
    disp('Test 5: Incorrect');
    disp('Correct Answer');
    A(:,1) + A(:,2),
end

if isequal([16;19;22;25], A(:,[1+1])),
    disp('Test 6: Correct');
else 
    disp('Test 6: Incorrect');
    disp('Correct Answer');
    A(:,[1+1]),
end

if isequal([17 16;20 19;23 22;26 25], A(:,[1+2 1+1])),
    disp('Test 8a: Correct');
else 
    disp('Test 8a: Incorrect');
    disp('Correct Answer');
    A(:,[1+2 1+1]),
end

if isequal(15, A(1)),
    disp('Test 8b: Correct');
else 
    disp('Test 8b: Incorrect');
    disp('Correct Answer');
    A(1),
end

if isequal(18, A(2)),
    disp('Test 8c: Correct');
else 
    disp('Test 8c: Incorrect');
    disp('Correct Answer');
    A(2),
end

if isequal(21, A(3)),
    disp('Test 8d: Correct');
else 
    disp('Test 8d: Incorrect');
    disp('Correct Answer');
    A(3),
end

if isequal(24, A(4)),
    disp('Test 8e: Correct');
else 
    disp('Test 8e: Incorrect');
    disp('Correct Answer');
    A(4),
end

if isequal([21 24 16 19 22], A(3:7)),
    disp('Test 8f: Correct');
else 
    disp('Test 8f: Incorrect');
    disp('Correct Answer');
    A(3:7),
end

% Does it surprise you that you can address the elements of a 2-d matrix with a single index value?
% It did at first, but the conversion from n to the ith and jth position is really
% easy. Just i = ceil(n/mat.rows) and j = (n%mat.rows). Or matlab stores
% matrices linearly and performs appropriate operations when needing to

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Q2.1
% 
% i     j     k
%
% 2     6     5
% 
% 3     7     5
% 
% 4    13     5
% 
% 5    14     5
% 
% 6    15     5

% Q2.2
normPlate = 10;
normGrowth = 3;
mutPlate = 10;
mutGrowth = normGrowth / 2;

hour = 1;
numHours = 12;
while(hour <= numHours),
    normPlate = normPlate * normGrowth;
    mutPlate = mutPlate * mutGrowth;
    hour = hour + 1;
end
disp(sprintf('Normal Plate:    %d' ,normPlate)); % = 5314410
disp(sprintf('Mutation Plate:  %d' ,mutPlate));  % = 1297

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Q3.1
load('rat_ink.txt', '-ascii')
load('rat_noink.txt', '-ascii')

rat_ink_before = rat_ink(:,1);
rat_ink_after = rat_ink(:,2);

rat_noink_before = rat_noink(:,1);
rat_noink_after = rat_noink(:,2);

rat_ink_before_mean = mean(rat_ink_before);
rat_ink_after_mean = mean(rat_ink_after);

rat_noink_before_mean = mean(rat_noink_before);
rat_noink_after_mean = mean(rat_noink_after);

rat_ink_before_SE = std(rat_ink_before)/sqrt(length(rat_ink_before));
rat_ink_after_SE = std(rat_ink_after)/sqrt(length(rat_ink_after));

rat_noink_before_SE = std(rat_noink_before)/sqrt(length(rat_noink_before));
rat_noink_after_SE = std(rat_noink_after)/sqrt(length(rat_noink_after));

f1 = figure(1);
subplot(2,1,1);
bar(1,rat_ink_before_mean,'r');
hold on
bar(2,rat_ink_after_mean,'k');
plot([1 1],[rat_ink_before_mean-rat_ink_before_SE rat_ink_before_mean+rat_ink_before_SE],'k-');
plot([2 2],[rat_ink_after_mean-rat_ink_after_SE rat_ink_after_mean+rat_ink_after_SE],'k-');
ylabel('Weight (units)');
title('Rats with Ink');
legend('before Mean', 'after Mean', 'before SE', 'after SE');

subplot(2,1,2);
bar(1,rat_noink_before_mean,'y');
hold on;
bar(2,rat_noink_after_mean,'m');
plot([1 1],[rat_noink_before_mean-rat_noink_before_SE rat_noink_before_mean+rat_noink_before_SE],'k-');
plot([2 2],[rat_noink_after_mean-rat_noink_after_SE rat_noink_after_mean+rat_noink_after_SE],'k-');
ylabel('Weight (units)');
title('Control without Ink');
legend('before Mean', 'after Mean', 'before SE', 'after SE');

% Q3.2
[h,p] = ttest2(rat_ink_before, rat_ink_after);       %= 3.3090e-17
[h,p] = ttest2(rat_noink_before, rat_noink_after);   %= 4.2422e-17

% With an alpha value of .05 and a p-value of less than .5e-17, we can
% reject the null hypothesis that the samples of weights from before and
% after for each experiment came from the same distribution.

%Q3.3
rat_ink_change = rat_ink_after - rat_ink_before;
rat_noink_change = rat_noink_after - rat_noink_before;

[h,p] = ttest2(rat_ink_change, rat_noink_change);    %= 0.0026

% With an alpha value of .05 and a p-value of 0.0026, we can reject the
% null hypothesis that the presence of ink had no effect on the change in
% weight of the rat

%Q3.4
rat_ink_change_mean = mean(rat_ink_change);                     %= 73.9000
rat_noink_change_mean = mean(rat_noink_change);                 %= 85.3200

total_changes = cat(1,rat_ink_change, rat_noink_change);
total_changes_mean = mean(total_changes);                       %= 79.6100
total_changes_var = length(total_changes)*var(total_changes, 1);%= 1.6103e+03

ink_var = length(rat_ink_change)*var(rat_ink_change, 1);        %= 428.7000
noink_var = length(rat_noink_change)*var(rat_noink_change, 1);  %= 529.4960

within_var = ink_var + noink_var;                               %= 958.1960

between_var=length(rat_ink_change)*(rat_ink_change_mean-total_changes_mean)^2+length(rat_noink_change)*(rat_noink_change_mean-total_changes_mean)^2;
                                                                %= 652.0820
total_var = within_var + between_var;                           %= 1.6103e+03

total_changes_var - total_var;                                  %1.1369e-12 Rounds to 0, We didn't mess up!

explained_var = 100* between_var / total_var;                   %= 40.4950%

% We can explain around 40.5% of the total variation among change in
% weight by whether or not the animal had ink treatment.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q4.1
load('healing_times.txt', '-ascii');
f2 = figure(2);
for i = 1: 5,
    m = healing_times(:,i);
    se = std(healing_times(:,i))/sqrt(length(healing_times(:,i)));
    bar(i,mean(healing_times(:,i)), 'FaceColor', [0 0 .2*i]);
    hold on
end
legend('Placebo', 'Low Arnica','High Arnica','Low Staphisagria','High Staphisagria','Standard Errors');

for i = 1: 5,
    m = healing_times(:,i);
    se = std(healing_times(:,i))/sqrt(length(healing_times(:,i)));
    plot([i i], [m-se m+se], '-r');
end

xlabel('Substance Given');
ylabel('Healing Times (units)');
title('Healing times vs. medicine');

%Q4
[p_a,table]=anova1(healing_times);
% p_a =
% 
%    9.9681e-45
% 
% 
% table = 
% 
%     'Source'     'SS'          'df'    'MS'          'F'           'Prob>F'    
%     'Columns'    [420.5333]    [ 4]    [105.1333]    [332.5000]    [9.9681e-45]
%     'Error'      [ 22.1333]    [70]    [  0.3162]            []              []
%     'Total'      [442.6667]    [74]            []            []              []

% With the anova we can reject null hypothesis that these samples have a
% distribution of with a similar mean with an alpha value of .05 and a
% p-value of 9.9681e-45. There is a significant difference between the
% means, which suggests that healing time is dependent on substance given.



