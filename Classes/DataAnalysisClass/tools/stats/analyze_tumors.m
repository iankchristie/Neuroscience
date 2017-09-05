function [change,rate,a,b,c,d] = analyze_tumors(folder)
% ANALYZE_TUMORS - Analyze folder of data
%  [change,rate,a,b,c,d] = ANALYZE_TUMORS(FOLDERNAME)
%
%  Steps through all subdirectories of the folder
%  FOLDERNAME and looks for files called
%  'tumor_data.txt'
%
%  If it finds one, then it performs a fit
%  using TUMORFIT.m.  The CHANGE, RATE, and A, B, C, D
%  of that function are returned.
%
%

subdirs = dir(folder);
change = []; rate = [];
a = []; b = []; c = []; d = [];

for i=1:length(subdirs),
    if subdirs(i).isdir&~strcmp(subdirs(i).name,'.')&~strcmp(subdirs(i).name,'..'),
        filename = [folder filesep subdirs(i).name filesep 'tumor_data.txt'];
        if exist(filename),
            disp(['Analyzing file ' filename '.']);
            data = load(filename,'-ascii');
            [change_,rate_,a_,b_,c_,d_] = tumorfit(data,5);
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