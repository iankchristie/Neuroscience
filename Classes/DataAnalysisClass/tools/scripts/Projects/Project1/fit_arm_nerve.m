function [a,b,c, failed] = fit_arm_nerve(filename, display)
% FIT_ARM_NERVE Fit Gaussian to arm nerve data
%
%   [A,B,C,FAILED]=FIT_ARM_NERVE(FILENAME)
%
%  Loads in arm nerve data from FILENAME, and
%  examines if the responses across locations are 
%  significantly different via ANOVA analysis.
%  If so, then a gaussian fit is performed and 
%  A (amplitude) B (mean location) C (standard deviation)
%  are returned.  If the ANOVA is not significant with
%  alpha 0.05, then A,B,C are set to NaN, and failed set to 1.

data = load(filename,'-ascii');
locations = data(1,:); % first row
rawdata = data(2:end,:); % row 2 through N
mn_resps = mean(rawdata); % computes the mean at each location
std_resps = std(rawdata); % computes standard deviation
Num_reps = size(rawdata,1); % number of rows in rawdata
std_err_resps = std_resps/sqrt(Num_reps);
G = repmat(1:length(locations),Num_reps,1); % groups for anova

failed = 0;

% unpack data, perform ANOVA analysis here
anova_p = anova1(rawdata(:), G(:), 'off');

% suppose anova p value is in variable anova_p
if anova_p<.05,
   % write your own gaussfit function, where x and y
   % are your data point

%    gauss = fittype('a+b*exp(-((x-c).^2)/((2*d^2)))');
%                     
%    fo = fitoptions(gauss);
%    [maxvalue,location] = max(mn_resps); % maxvalue will be guess for b
%    position_guess = mn_resps(location); % guess parameter c
%    width_guess = 1; % arbitrarily pick a width guess, parameter d
%    fo.StartPoint = [0; .5; mean(mn_resps); .5];
%    fo.Lower = [-maxvalue; 0; min(mn_resps); -Inf];
%    fo.Upper = [maxvalue; Inf; max(mn_resps); Inf];
%    gauss = setoptions(gauss,fo);
%    [gaussLine, ~] = fit(locations', mn_resps', gauss);
%    a = gaussLine.a;
%    b = gaussLine.b;
%    c = gaussLine.c;
  
   gaussLine = fit(locations', mn_resps', 'gauss1'); %a1*exp(-((x-b1)/c1)^2)
    
   if display,
       figure;
       errorbar(locations,mn_resps,std_err_resps,std_err_resps);
       xlabel('Locations (mm)'); 
       ylabel('Mean response (spikes/sec)');
       title(filename);
       hold on
       plot(locations, gaussLine(locations),'m');
   end
   
   a = gaussLine.a1;
   b = gaussLine.b1;
   c = gaussLine.c1;
 
else,
    a = NaN;
    b = NaN;
    c = NaN;
    failed = 1;
end
end

