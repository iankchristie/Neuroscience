%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ian Christie
% Data Analysis
% Problem Set 1.2
% September 29, 2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Q1
% 
% mydata1 = 100*generate_random_data(10,'normal',1,1); 
% mydata2 = 100*generate_random_data(10,'normal',0,1);
%
%
% figure;
% mean = mean(mydata1);
% mean2 = mean(mydata2);
% bar([1 2],[mean mean2]);
% hold on;
% plot(1,mydata1,'go');
% plot(2,mydata2,'bs');
%
%%%%Q1.1
% The code above would not work. The reason is that matlab only reserves
% a set number of key words, while many functions can be overridden in
% memory by another variable. In this scenario, matlab has a function
% called 'mean' in memory. In the second line, 'mean = mean(mydata1);' we
% override that reference 'mean' from the function 'mean' to whatever the
% value of mean(mydata1) was. I would fix this by renaming the variable
% mean, to something else, like 'mean1':
%
%
% figure;
% mean1 = mean(mydata1);
% mean2 = mean(mydata2);
% bar([1 2],[mean1 mean2]);
% hold on;
% plot(1,mydata1,'go');
% plot(2,mydata2,'bs');
%
%%%%Q.2
% Q1.2.1
%
% a = 5;  % line 1
% x = 7;  % line 2
% b = f1(x); % line 3
%
% Only a, b, and x exist in the workspace. The corresponding values are 
% a = 5
% b = 250
% x = 7
%
% Q1.2.2
% clear all
% 
% c = 20; % line 1
% b = f1(c); % line 2
%
% Now only c and b exist in the workspace. The corresponding values are
% c = 20
% b = 2005
%
% The reason for seeing these results is because of the way that matlab
% handles functions. Whenever a statement is typed on the Read-Evaluate-Print-Loop
% (REPL or command line), it gets evaluated and the effect is on the global 
% workspace. However, when a function is called, matlab creates what is 
% known as an isolated scope. That means that the memory allocated towards
% that function call is separate from the global workspace & the global
% workspace is separated from it. That means that the only way get data
% into a function is to pass it in as a parameter, and the only way to get
% data back from the function is to pass it back as an argument. Therefore,
% 'a' in the global workspace will remain the same, because another 'a' was
% created in a different part of memory, but then tossed away when the
% function call ended. Likewise, b now exists in the global workspace
% because it is now storing whatever 'f1(x)' returned.
%
% Q1.2.3
% clear all
% 
% d = 10;
% b = f2(20);
%
% When I ran the above code I got this error
% Undefined function or variable 'd'.
% 
% Error in f2 (line 3)
% a = 5 * d * c;
% 
% Error in Christie_ps1_2 (line 78)
% b = f2(20);
%
% The reason for this error is explained above. Because of the isolated
% scope that was created for the function 'f2', the function no longer has
% access to the global workspace. This means that even though 'd' is
% defined in the global workspace, the function has no way of seeing it.
% The way to fix this problem is to pass d in as an argument, which means
% altering the .m file as well to:
%
% function a = f2(x, d)
% c = x^2 + 1;
% a = 5 * d * c;
% end
%
% and passing in d as a parameter like so
%
% d = 10;
% b = f2(20, d);
%
% I would take caution doing this, as it kind of makes it seems as though
% the 'd' in the global workspace is connected to the 'd' in the function,
% when they are not!
%
%%%%Q1.3
%Q1.3.1
x = -20:20; 
p1 = [ 0 1 0 3];
g1 = gaussianDA(x,p1);

figure(1)
subplot(4,1,1)
plot(x,g1);
axis([-20 20 0 2])
title('Standard Gaussian Curve');
ylabel('value (units)');
legend('Gaussian Curve');

p2 = [ 0 2 0 3];
g2 = gaussianDA(x,p2);
subplot(4,1,2)
plot(x,g1);
hold on
plot(x, g2, 'r');
axis([-20 20 0 2])
title('Height Multiplied by 2');
ylabel('value (units)');
legend('Original Curve', 'Altered Curve')

% It's height multiplied from 1 to 2, while mean and deviation stayed
% constant

p3 = [ 0 1 0 6];
g3 = gaussianDA(x,p3);
subplot(4,1,3)
plot(x,g1);
hold on
plot(x, g3, 'r');
axis([-20 20 0 2])
title('Width Multiplied by 2');
ylabel('value (units)');
legend('Original Curve', 'Altered Curve')

% It got broader, while height and mean stayed constant

p4 = [ 0 1 3 3];
g4 = gaussianDA(x, p4);
subplot(4,1,4)
plot(x,g1);
hold on
plot(x, g4, 'r');
axis([-20 20 0 2])
title('Mean shifted by +3');
ylabel('value (units)');
xlabel('value (units)');
legend('Original Curve', 'Altered Curve')

% It was shifted over by three x unites, while height and deviation stayed
% constant
%
%Q1.3.2
%
% Both codes will run and they will get the same answer... Student A just
% did a lot more work than student B. I guess that student A doesn't
% understand that the point of functions is to eliminate redudancy in code
% by performing the same operation on different input. Student B does
% understand that, and therefore did a lot less work with a lot less space.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Q2
%%%%Q2.1
box_coords = [ 1 1 ; 1 2; 2 2; 2 1];
box_coords(:,1);  % examine all X coordinates (in the first column)
box_coords(:,2);  % examine Y coordinates (in the second column)
figure(2);
box_coords([1:4 1], 1);
plot(box_coords([1:end 1],1),box_coords([1:end 1],2));
axis ([0 3 0 3]);

figure(3)
t = (1/16:1/8:1)'*2*pi;
x = cos(t);
y = sin(t);

fill(x,y,'r')
axis square
str1 = 'STOP';
t = text(-.53,0,str1, 'FontSize', 75, 'color', 'w');
title('Stopsign');

%%%%Q2.2
a = load('chickenweights_control_experimental.txt', '-ascii');
corn = a(:,1);
lysine = a(:,2);

figure(4)
plot_boxwhisker(corn, 1, .1, 'b');
hold on
plot_boxwhisker(lysine, 2, .1, 'r');
title('Weight of Chickens with Different Foods');
ylabel('Weight (grams)');
xlabel('Sample 1 is Corn, 2 is Lysine Enriched... Legend Not working');
legend('Corn', 'Lysine Enriched');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Q3
%%%%Q3.1
cornMean = mean(corn);
lysineMean = mean(lysine);

figure(5);
subplot(2,1,1);
bar(1,cornMean,'w');
hold on
plot(1,corn,'ob')
hold on
bar(2,lysineMean,'w');
hold on
plot(2,lysine,'sr')
axis([0 3 200 500])
title('Bar Graph of Corn vs. Lysine-Enriched');
xlabel('Sample')
ylabel('Weight (grams)')

subplot(2,1,2)
[X1,Y1] = cumhist(corn, [200 500],1);
[X2,Y2] = cumhist(lysine, [200 500],1);
plot(X1,Y1);
hold on
plot(X2,Y2, 'r');
title('Cumulative Histogram of Corn vs. Lysine-Enriched');
xlabel('Weight (grams)')
ylabel('Percent under curve')
legend('Corn','Lysine Enriched');

%%%% Q3.2
[h,pvalue] = kstest2(corn,lysine);
% h = 1
% pvalue = 0.0232
% We can reject the null hypothesis with a confidence of 95%. Because we
% want to be 95% accurate, our alpha value will be .05. Because the pvalue
% of the ktest is .0232 and less than .05, we reject the null hypothesis
% that these data came from the same distribution.

%%%% Q3.3
[h,pvalue] = ttest2(corn,lysine);
% h = 1
% p = 0.0182
% We can reject the null hypothesis with a confidence of 95%. Because we
% want to be 95% accurate, our alpha value will be .05. Because the pvalue
% of the ktest is .0182 and less than .05, we reject the null hypothesis
% that these data came from the same distribution.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Q4
%
%%%%Q4.1
boy = load('iqs_boys.txt','-ascii');
girl = load('iqs_girls.txt','-ascii');

boyMean = mean(boy);
girlMean = mean(girl);

figure(6);
subplot(2,1,1);
bar(1,boyMean,'w');
hold on
plot(1,boy,'ob')
hold on
bar(2,girlMean,'w');
hold on
plot(2,girl,'sr')
axis([0 3 50 150])
title('Bar Graph of boy IQ vs. girl IQ');
xlabel('Sample')
ylabel('Weight (grams)')

subplot(2,1,2)
[X1,Y1] = cumhist(boy, [50 150],1);
[X2,Y2] = cumhist(girl, [50 150],1);
plot(X1,Y1);
hold on
plot(X2,Y2, 'r');
title('Cumulative Histogram of boy IQ vs. girl IQ');
xlabel('Weight (grams)')
ylabel('Percent under curve')
legend('boy','girl Enriched');

%%%% Q4.2
[h,pvalue] = kstest2(boy,girl);
% h = 0
% pvalue = 0.2049
% We cannot reject the null hypothesis. Because our choosen alpha-value is
% .05, and our pvalue is .2049 and greater, we cannot say that there is any
% difference between boy and girl IQ.

%%%% Q4.3
[h,pvalue] = ttest2(boy,girl);
% h = 0
% p = 0.0932
% We cannot reject the null hypothesis. Because our choosen alpha-value is
% .05, and our pvalue is .0932 and greater, we cannot say that there is any
% difference between boy and girl IQ.


