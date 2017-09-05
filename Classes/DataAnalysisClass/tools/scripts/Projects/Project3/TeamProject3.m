base = '/Users/ianchristie/Dropbox/cortical_model_direction_selectivity/Neuroscience/DataAnalysisClass/tools/scripts/Projects/Project3/Team2_1mM_ACh';

d = dir([base filesep 'fly*']);
bins = -0.5:1:256;
alpha  = .05;

controlPeaks = [];
experimentalPeaks = [];

for i = 1: length(d),
    [c, e, cp, ep] = analyzeDatFly([base filesep d(i).name]);
    
    controlPeaks = [controlPeaks cp];
    experimentalPeaks = [experimentalPeaks ep];
end

[h, p] = ttest2(controlPeaks, experimentalPeaks)

if p < alpha,
    disp('Because the p-value is less than our alpha value of, 0.05, we can reject the null hypothesis that the differences in peaks come from the same distribution');
else
    disp('Because the p-value is greater than our alpha value of, 0.05, we cannot reject the null hypothesis that the differences in peaks come from the same distribution');
end