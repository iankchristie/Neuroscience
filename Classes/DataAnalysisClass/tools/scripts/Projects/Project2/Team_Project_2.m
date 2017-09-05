base = '/Users/ianchristie/Dropbox/cortical_model_direction_selectivity/Neuroscience/DataAnalysisClass/tools/scripts/Projects/Project2/tp2_team2';
kod = [base filesep 'knockout'];
wtd = [base filesep 'wildtype'];

disp('working on KO');
[l_KO, sd_KO, sn_KO, ts_KO, sr_KO, ff_KO] = analyzeflies(kod);
disp('working on WT');
[l_WT, sd_WT, sn_WT, ts_WT, sr_WT, ff_WT] = analyzeflies(wtd);

mean_KO = mean(sr_KO);
mean_WT = mean(sr_WT);

figure;
plot(ts_KO, mean_KO);
hold on
plot(ts_WT, mean_WT, 'r');
title('Averaged Sleeping Recordings');
xlabel('Time (hr)');
ylabel('Time Sleeping (min)');
legend('Knock Out', 'WildType');

[h_l, p_l] = ttest2(l_KO, l_WT)

[h_sd, p_sd] = ttest2(sd_KO, sd_WT)

[h_sn, p_sn] = ttest2(sn_KO, sn_WT)