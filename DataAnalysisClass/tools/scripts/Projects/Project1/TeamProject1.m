
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Analysis and Notes:
%
% All paths are relative to the base, which is hard coded for my directory
% structure. You need to change the base so that it matches yours. To do
% this open the finder and navigate to the directory that you contain your
% 'mouse_data' folder in. Right click and choose 'get info'. Then copy and
% paste where it says 'where'
%
% The most important thing is that I changed the gaussian curve
% function. It wasn't working that great for a lot of the functions and I
% played around with it enough to know that I could have used a better fit.
% If you want to see why then you can uncomment the code that I commented
% out in fit_arm_nerve, and make sure that you also comment out the 
% following lines of code:
%    gaussLine = fit(locations', mn_resps', 'gauss1'); %a1*exp(-((x-b1)/c1)^2)
%    a = gaussLine.a1;
%    b = gaussLine.b1;
%    c = gaussLine.c1;
%
% Next note is that I'm excluding one file above that I called 'excluding',
% and the reason is that even though it passed the anova test, it clearly
% doesn't fit a gaussian distribution. You can test that too by
% uncommenting the line at the end of the script
% fit_arm_nerve(excluding{:}).
% 
% I'm saving all of the data that didn't pass the anova1 test in the cell
% array called failedFiles. 
% 
% I think those are all of the weird things that I did. The basic structure
% of this is that the script TeamProject will 
% create directories, paths, and shit we need to store things in
% Then loop through the directories of wildtype and knockout collecting the
% parameters for the gaussian curve
% Fit_arm_nerves will get the file name, then perform anova1 to make sure
% that it's not too noisey. Then it will do the gaussian fit.
% Once we have the parameters for the gaussian curve we perform 3 ttest's
% to see if three parameters that describe the gaussian curve are different.
%
% We can see that the distributions have the same means, which signifies
% that the gene doesn't create an offset of response. However, there is a
% significant difference between the standard deviations, which signifies
% that the knockout has a larger response radius. This could be due to a
% lot of things, my personal favorite might be a decrease in lateral
% inhibition, but that's just a theory that sprouts from the observations.
% Lastly, there is a significant difference between the amplitudes of the
% distributions with .03. I'm nervous to draw any conclusions from this
% because I believe that my new gaussian equation normalized that data, and
% the difference in amplitude is probably an artifact of a narrowing
% standard deviation.
% 
% If you have any questions please ask.


base = '/Users/ianchristie/Dropbox/cortical_model_direction_selectivity/Neuroscience/DataAnalysisClass/tools/scripts/Projects/mouse_data';
cd(base)
knockoutPath = [base filesep 'knockout'];
knockoutDir = dir(knockoutPath);
wildtypePath = [base filesep 'wildtype'];
wildtypeDir = dir(wildtypePath);

excluding = {[base filesep 'wildtype' filesep 'exp032' filesep 'mouse_arm_data.txt']};
failedFiles = {};

knockoutFits = [];
wildtypeFits = [];

disp('Working on knockout');
for i = 4 : length(knockoutDir),
    path = [knockoutPath filesep knockoutDir(i).name filesep 'mouse_arm_data.txt'];
    if ~strcmp(path, excluding),
        [a, b, c, failed] = fit_arm_nerve(path, 0);
        if ~failed,
            knockoutFits = [knockoutFits; a, b, c];
        else
            failedFiles{end+1} = path; 
        end
    end
end

disp('Working on wildtype');
for i = 4 : length(wildtypeDir),
    path = [wildtypePath filesep wildtypeDir(i).name filesep 'mouse_arm_data.txt'];
    if ~strcmp(path, excluding),
        [a, b, c, failed] = fit_arm_nerve(path, 0);
        if ~failed,
            wildtypeFits = [wildtypeFits; a, b, c];
        else
            failedFiles{end+1} = path; 
        end
    end
end


%fit for amplitudes
[h_a,p_a,ci_a,stats_a] = ttest2(knockoutFits(:,1), wildtypeFits(:,1));
disp('Probability that mean amplitudes of response are the same between knockout and wildtype');
p_a,

%fit for means
[h_b,p_b,ci_b,stats_b] = ttest2(knockoutFits(:,2), wildtypeFits(:,2));
disp('Probability that mean locations of response are the same between knockout and wildtype');
p_b,

%fit for standard deviations
[h_c,p_c,ci_c,stats_c] = ttest2(knockoutFits(:,3), wildtypeFits(:,3));
disp('Probability that mean standard deviations of response are the same between knockout and wildtype');
p_c,

ko_stats = mean(knockoutFits);
wt_stats = mean(wildtypeFits);

x = -15:.01:25;

ko_curve = normpdf(x,ko_stats(2), ko_stats(3));
wt_curve = normpdf(x,wt_stats(2), wt_stats(3));
figure;
plot(x, (ko_stats(1)./max(ko_curve))*ko_curve)
hold on
plot(x, (wt_stats(1)./max(wt_curve))*wt_curve, 'r')
title('Comparison of Sample Distributions');
xlabel('Locations (mm)'); 
ylabel('Mean response (spikes/sec)');
legend('Knockout', 'Wildtype');


%fit_arm_nerve(excluding{:}, 0);
