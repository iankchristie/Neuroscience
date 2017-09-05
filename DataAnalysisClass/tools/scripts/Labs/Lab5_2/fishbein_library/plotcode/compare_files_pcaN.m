function [ns1,ns2,pc,themean] = compare_files_pcaN(filename1,filename2, N)


[ns1, pc, themean] = read_shift_interp_normalize_2deriv(filename1);
close(gcf);
[ns2] = read_shift_interp_normalize_2deriv(filename2);
close(gcf);

figure;
h1 = plot_standard_projectionN(ns1, N, pc, themean);
h2 = plot_standard_projectionN(ns2, N, pc, themean);



