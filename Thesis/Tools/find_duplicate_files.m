% find_duplicate_files.m
%
%   This script finds duplicate files constrained by 'filetype' within the directory 'parentDIR'.
%       'filetype' (set below) describes file extension.  ex:  '*.m';  '*.mat';  'bestfunc.m';  '*' (all files).
%       'parentDIR' is the directory (and sub dirs.) to search.  ex: 'C:\Users\adanz\Documents\MATLAB';  'C:\Program Files\MATLAB\R2013a\';  'C:\'.
%   These two parameters are set here at the beginning.  
%
%   I chose to run this as a script rather than function for simplicity.  Unwanted vars are cleared at the end
%   leaving you with the following outputs in your workspace:
%       dup_count:  the number of duplicate filenames found
%       DUPLICATES_names: an array of file names that have duplicates
%       DUPLICATES_paths: an array of paths segments by duplicate files (the portion of path defined in 'parentDIR' is removed'
%       filetype and parentDIR (the inputs) will also be in the workspace.
%
%   IMPORTANT:  This script uses a custom fuction, 'getfiles.m' by Dan Nyren found on mathworks.com
%               http://www.mathworks.com/matlabcentral/fileexchange/47459-getfiles-m
%
% 150322  Adam Danz


%% PPARAMETERS
%enter parent directory (will search all sub dirs, too).
    parentDIR = '/Users/ianchristie';    
%enter file extention or a specific or partial filename
    filetype = '*.m';                                   %'*.m' for mfiles    '*.mat' for mat files
        
%% This could take a while depending on your params

allPs = getfiles(filetype, parentDIR);              %this is a custom func, generates list of all paths to all 'm' files
allFs = cell(numel(allPs),1);                       %storage bin

%trim paths to get filenames
wb1 = waitbar(0);                                   %display a waitbar
for i = 1:numel(allPs)                              %for each file in allMs
    namestart = max(find(allPs{i}=='\'))+1;         %char idx for beginning of filename within path
    allFs{i} = allPs{i}(namestart:end);             %all filenames (trimmed from paths)
    allPs_trim{i} = allPs{i}(numel(parentDIR)+1:end);  %trims the parentDIR from all paths since it will always be the same (save display output)
    waitbar(i/numel(allPs), wb1, 'Preparing lists of all files in all subdirectories'); %update waitbar
end
    
DUPLICATES_paths = {};                              %create storage bin
DUPLICATES_names = {};                              %create storage bin
dup_count = 0;                                      %counts num of dups
wb2 = waitbar(0);                                   %display waitbar
%find matches in allFs
for i = 1:numel(allFs) 
    matches = find(strcmp(allFs, allFs(i)));                    %idx of matches (scalar mean no match, vector are matches)
    if length(matches)>1 && sum(strcmp(DUPLICATES_names, allFs(i))) < 1 %if there is a duplicate AND this dup hasn't already been listed
        clc, dup_count = dup_count + 1                          %display live count of duplicates        
        DUPLICATES_names(end+1) = allFs(i);                     %list of filenames of dups
        DUPLICATES_paths(end+1: end+length(matches)) = allPs_trim(matches);  %list of paths from dup files
        DUPLICATES_paths(end+1) = {' '};                        %add a blank line between matches
    end
    waitbar(i/numel(allFs), wb2, 'Preparing lists of all duplicate files'); %update waitbar
end

%clear unwanted vars from workspace
close ([wb1 wb2])
clearvars = {'allFs', 'allPs', 'allPs_trim', 'i', 'matches', 'namestart', 'wb1', 'wb2', 'clearvars'};
clear (clearvars{:});

%convert to column vectors
DUPLICATES_paths = DUPLICATES_paths';                         
DUPLICATES_names = DUPLICATES_names';

% % Display outputs
% clc
% disp(['There are ', num2str(dup_count), ' duplicate files'])
% disp('File names:')
% DUPLICATES_names'
% disp('Paths')
% DUPLICATES_path'

    