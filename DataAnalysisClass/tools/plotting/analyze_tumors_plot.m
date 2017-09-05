function [change,rate,a,b,c,d] = analyze_tumors_plot(folder, plotit)
% ANALYZE_TUMORS - Analyze folder of data
%  [change,rate,a,b,c,d] = ANALYZE_TUMORS(FOLDERNAME, PLOTIT)
%
%  Steps through all subdirectories of the folder
%  FOLDERNAME and looks for files called
%  'tumor_data.txt'
%
%  If it finds one, then it performs a fit
%  using TUMORFIT.m.  The CHANGE, RATE, and A, B, C, D
%  of that function are returned.
%
%  If PLOTIT is 1, then each individual fit is plotted.
%

subdirs = dir(folder);
change = []; rate = [];
a = []; b = []; c = []; d = [];
if plotit, fig = figure; else, fig = []; end;
plot_number = 1;


for i=1:length(subdirs),
    if subdirs(i).isdir&~strcmp(subdirs(i).name,'.')&~strcmp(subdirs(i).name,'..'),
        filename = [folder filesep subdirs(i).name filesep 'tumor_data.txt'];
        if exist(filename),
            disp(['Analyzing file ' filename '.']);
            data = load(filename,'-ascii');
            [change_,rate_,a_,b_,c_,d_] = tumorfit(data,5);
            if plotit,
                supersubplot(fig, 3, 3, plot_number);
                tumorplot(data, a_, b_, c_, d_);
                title([subdirs(i).name ', C%=' int2str(change_) ', R=' num2str(rate_,2)]);
                plot_number = plot_number + 1;
            end;
            change(end+1) = change_;
            rate(end+1) = rate_;
            a(end+1) = a_;
            b(end+1) = b_;
            c(end+1) = c_;
            d(end+1) = d_;
        end;
    end;
end;
end