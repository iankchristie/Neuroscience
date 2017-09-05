%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ian Christie
% Data Analysis
% Problem Set 2.1
% October 26, 2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Q1
% Q1.1

load lemonade_july.mat
load lemonade_august.mat

sorting = [T_july'; lemonade_demanded_july'];
[Y,I]=sort(sorting(1,:));
sorted=sorting(:,I); % use the column indices from sort() to sort all columns of A.

T_july = sorted(1, :)';
lemonade_demanded_july = sorted(2, :)';

linear = fittype('a+b*x');
fo = fitoptions(linear);
fo.StartPoint = [25; 1.5]; % guess a=15, b=0.5
linear = setoptions(linear,fo);
[linearLine, linearGof] = fit(T_july, lemonade_demanded_july, linear);

polynomial = fittype('a+b*x+c*x^2+d*x^3+e*x^4+f*x^5');
% messing around with starting points. Couldn't really do it better
% fo = fitoptions(polynomial);
% fo.StartPoint = [25; 1.5; 0; 0; 0; 0];
% polynomial = setoptions(polynomial,fo);
[polynomialLine, polynomialGof] = fit(T_july, lemonade_demanded_july, polynomial);


f1 = figure(1);
scatter(T_july, lemonade_demanded_july);
hold on
scatter(T_august, lemonade_demanded_august, 'g');
title('Lemonade Demand vs. Temperature in July');
xlabel('Temperature (Celcius)');
ylabel('Lemonade Demand (in thousands)');
hold on
plot(T_july, linearLine(T_july), 'k-');
hold on
plot(T_july, polynomialLine(T_july), 'r-');
hold off
legend('July Lemonade Demand', 'August Lemonade Demand', 'Linear Fit','Polynomial Fit', 'Location','northwest');

% Q1.2
% linearGof.rsquare         = 0.5612
% polynomialGof.rsquare     = 0.6609
% The polynomial fit has a higher rsquared value. Which one would I choose
% though, that's a different question. One has to really look into the
% meaning of the line and the data that is trying to be fit, and really
% examine if the added complexity adds to the value of the prediction.
%
% For instance (I know that extrapolation is bad, but it fits my point) if
% one were to ask what the demand for lemonade is when the temperature is
% 0, then we would just have to look at the y-intercepts which we represent
% with our a coefficient. a for linearLine is 8, while a for polynomial
% line is -1985. This is unrealistic.
%
% It seems as though the added complexity of the polynomial fit just serves
% the variation in this particular dataset, and won't be generalize well
% over others.

% Q1.3
% Note: this uses a function that I downloaded from the internet that I'm
% attaching to the file
r2Linear = rsquare(lemonade_demanded_august, linearLine(T_august))          %=0.4441
r2Polynomial = rsquare(lemonade_demanded_august, polynomialLine(T_august))  %=0.2085

% The linear fit has the higher rsquared value. This does not suprise me.
% The polynomial fit was too trained for July's particular data set and
% could not handle data from august. In Artificial Intelligence this is
% called Overfitting, when the statistical model describes random error or
% noise instead of the underlying relationship.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Q2
%Q2.1
s = 0:.01:100;

f2 = figure(2);
subplot(2,2,1);
vmax = 1;
km = 1;
v = (vmax.*s)./(km+s);
plot(s, v);
ylabel('vmax = 1');
title('Michaelis Menten');

subplot(2,2,2);
vmax = 1;
km = 5;
v = (vmax.*s)./(km+s);
plot(s, v);
title('Michaelis Menten');

subplot(2,2,3);
vmax = 3;
km = 1;
v = (vmax.*s)./(km+s);
plot(s, v);
ylabel('vmax = 3');
xlabel('km = 1');

subplot(2,2,4);
vmax = 3;
km = 5;
v = (vmax.*s)./(km+s);
plot(s, v);
xlabel('km = 5');


% The vmax provides an asymptotic ceiling for the function at vmax. It then
% rises in a first order exponential with a substrate constant (not time
% constant becasuse substrate is our x) that's determibed by km. This can
% be seen because the vertical subplots have the same km, and thus have the
% same rate of change. They also have differnt vmax, and thus have
% different ceilings. Likewise horizontal columns have the same vmax and
% thus the same ceiling, but different kms and thus different rate of
% changes.

% Q2.2

load Michaelis_Menten.mat
sAdjusted = 0:10:100;

figure
scatter(sAdjusted, V1)
hold on
scatter(sAdjusted, V2, 'g')
hold on
title('Concentration vs. Reaction Rate');
xlabel('Substrate Concentration (M)');
ylabel('Reaction Rate (M/s)');

% Q2.3
MMFit = fittype('(a.*x)./(b+x)');
fo = fitoptions(MMFit);
fo.StartPoint = [3.5; 6]; % guess vmax = 3.5, km=6
MMFit = setoptions(MMFit,fo);
[V1Line, V1Gof] = fit(sAdjusted', V1', MMFit)
[V2Line, V2Gof] = fit(sAdjusted', V2', MMFit)

plot(sAdjusted, V1Line(sAdjusted), 'b');
hold on
plot(sAdjusted, V2Line(sAdjusted), 'g');
hold off
legend('V1 Data','V2 Data','V1 Fit','V2 Fit','Location','southeast');

% V1Line has vmax to be set at 3.4, and km to be 4. It also has an rsquared
% value of 1, which means it's probably a damn good fit
%
% V1Line = 
% 
%      General model:
%      V1Line(x) = (a.*x)./(b+x)
%      Coefficients (with 95% confidence bounds):
%        a =         3.4  (3.4, 3.4)
%        b =           4  (4, 4)
% 
% V1Gof = 
% 
%            sse: 1.0457e-14
%        rsquare: 1.0000
%            dfe: 9
%     adjrsquare: 1.0000
%           rmse: 3.4086e-08
% 
% V2Line has vmax to be set at 3.4, and km to be 8. It also has an rsquared
% value of 1. This makes sense because it seems to have the same asymptotic
% ceiling as V1, but has a slower rate of change.
%
% V2Line = 
% 
%      General model:
%      V2Line(x) = (a.*x)./(b+x)
%      Coefficients (with 95% confidence bounds):
%        a =         3.4  (3.4, 3.4)
%        b =           8  (8, 8)
% 
% V2Gof = 
% 
%            sse: 5.9222e-15
%        rsquare: 1.0000
%            dfe: 9
%     adjrsquare: 1.0000
%           rmse: 2.5652e-08


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Q3
%Q3.1

% function out = lessthan05(num)
%     out = 0;
%     if num < .05,
%       out = 1;
%     end
% end

% a = lessthan05(0.5)
% b = lessthan05(0.04)
% c = lessthan05(100)
% d = lessthan05(0)

% I recieved this output, which suggests that my function works
% a =
% 
%      0
% 
% 
% b =
% 
%      1
% 
% 
% c =
% 
%      0
% 
% 
% d =
% 
%      1

% Q3.2
% str1 = 'Hello';
% str2 = 'people';
% str3 = 'there';
% mystring = [str1 str3 str2]

% I predicted the evaluation will be 'Hellotherepeople', and I was right

% Q3.3
% str1 = 'The answer is ';
% str2 = 5;
% mystring = [str1 str2]

% I was wrong, I thought that it would throw a type error. Turns out it
% just saw 'The answer is ', and doesn't include the str2

% Q3.4
% str1 = 'The answer is ';
% str2 = int2str(5);
% mystring = [str1 str2 '.'];

% I was right, the evaluation was 'The answer is 5.'

% Q3.4
% mystring = ['foldername' filesep 'filename.txt']

% I wasn't sure if filesep was a built in variable. I predicted it
% correctly as 'foldername/filename.txt'

%Q3.5
% str1 = 'Hello';
% mynumber = double(str1) % convert to double, what are numbers?
% number1 = [ 65 66 67 68 69 70]; % these correspond to text codes
% mystring = [str1 ' ' number1]

% I looked up the ascii values for the characters 'H', 'e', 'l', 'l', 'o' and
% this is what I got: 72, 101, 108, 108, 111. This is also what is stored
% in my number

% From the previous lab I knew that 65 is the ascii character for 'A', so I knew
% that the value stored in mystring would be 'Hello ABCDE'
