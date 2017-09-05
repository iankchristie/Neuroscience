function [ FileList ] = getfiles( varargin )
%GETFILES Creates a list of files from optional file extensions and/or
%keywords in all folders and subfolders in current or supplied directory
%
%Author: Dan Nyren August 2014
%__________________________________________________________________________
% SYNTAX :
%
%   FileList=GETFILES(Input1,...,Input3)
%__________________________________________________________________________
% INPUTS :
%
% NOTE: Input order does not matter, however there can only be a maximum of
%       3 inputs.
%    
%    File Keyword/Extension : 
%                          -Any File Extension in '*.*' format. If no file
%                           extension input is provided, output will be all
%                           files within specified directory. 
%                          -Keywords can also be provided to narrow search
%                           where asterisk (*) is a wildcard(example:
%                           '*sample*.csv' will output all files ending in
%                           sample___.csv such as fastsample1.csv or
%                           sample0132.csv).
%                          -Multiple filenames can be provided, separated
%                           by spaces (in the form '*.ext1 *.ext2' where
%                           all of the files of all of the extensions
%                           listed will be output.
%                          -Any of the above can be combined to create
%                           large keyword/extension combinations.
%
%    Directory :           Location of folder to search within. If no
%                          directory is provided, the current working
%                          directory will be used. NOTE: Supplying a
%                          directory will add that directory to the current
%                          working directory. To return to old directory,
%                          use CD.
%
%    Specific Files:       Matrix used to select specific files from output
%                          list. If no matrix is provided entire list will
%                          be output.
%__________________________________________________________________________
% EXAMPLES :
%
%    FileList=GETFILES;
%        Outputs a list of all the files in the current working directory.
%
%    FileList=GETFILES('*.csv');
%        Outputs a list of all of the *.csv (comma separated value) files
%        in the current working directory.
%
%    FileList=GETFILES('*sample.csv');
%        Outputs a list of all of the files ending in  sample.csv in the
%        current working directory.
%
%    FileList=GETFILES('C:\Program Files\MATLAB\R2013a\licenses')
%        Outputs a list of all of the files in the licenses folder (and any
%        subfolders) of the licenses folder in the MATLAB program files.
%
%    FileList=GETFILES([1,3:5,18])
%        Outputs files 1, 3, 4, 5, and 18 from the sorted list of the files in
%        the current working directory.
%
%    FileList=GETFILES('*.txt','C:\Program Files\MATLAB\R2013a\',[4,18:20])
%        Ouputs *.txt files 4, 18, 19, and 20 from the R2013a folder (and
%        any subfolders) of the MATLAB program files.
%__________________________________________________________________________
% NOTES :
%
%  -Supplying a directory will add that directory to the current working
%  directory
%
%  -Filename endings can also be provided to narrow search example:
%  '*sample.csv' will output all files ending in sample.csv)
%
%  -Use UIGETDIR to interactively get directory path and pass it to
%  GETFILES
%
%  -The first files in the list will generally be the files from the main
%  folder selected
%
%
% See also DIR, UIGETDIR, CD,  TYPE
% source: http://www.mathworks.com/matlabcentral/fileexchange/47459-getfiles-m


switch nargin
    case{0}
        FileList=systemfiles('*.*');
    case{1}
        if cellfun(@(x) isempty(strfind(x,':\')),varargin) && ~cellfun(@isnumeric,varargin);
            % There is not a directory input or a numeric input (there is a file type)
            FileList=systemfiles(varargin{1});
        elseif cellfun(@isnumeric,varargin)
            % There is a matrix input
            FileList=systemfiles('*.*');
            if ~isempty(FileList)
                FileList=FileList(varargin{1}); % Keep only wanted files
            else
                disp('No Files Found')
            end
        else
            % There is a directory input
            cd(varargin{1})
            FileList=systemfiles('*.*');
        end
    case{2}
        if ~cellfun(@isnumeric, varargin)
            % No numeric input, therefore a directory and file type are
            % inputs
            idx=cellfun(@(x) ~isempty(strfind(x,':\')),varargin); % separate which cell is directory or file type
            cd(varargin{idx}); % change working directory to the one selected
            FileList=systemfiles(varargin{~idx}); % Find Files in Directory
            
        elseif nnz(cellfun(@(x) isempty(strfind(x,':\')),varargin))==2 && nnz(cellfun(@isnumeric,varargin))~=2
            % There is a file type and a matrix input
            idx=cellfun(@isnumeric,varargin); % separate which cell is matrix or file type
            FileList=systemfiles(varargin{~idx}); % Find Files in Directory
            if ~isempty(FileList)
                FileList=FileList(varargin{idx}); % Keep only wanted files
            else
                disp('No Files Found')
            end
        else
            % There is a directory and a matrix input
            idx=cellfun(@isnumeric,varargin); % separate which cell is directory or matrix type
            cd(varargin{~idx}) % change working directory to the one selected
            FileList=systemfiles('*.*'); % Find Files in Directory
            if ~isempty(FileList)
                FileList=FileList(varargin{idx}); % Keep only wanted files
            else
                disp('No Files Found')
            end
        end
    case{3}
        % There is a file type, directory, and matrix input
        idxm=cellfun(@isnumeric,varargin); % separate which cell is a matrix
        idxd=cellfun(@(x) ~isempty(strfind(x,':\')),varargin); % separate which cell is a directory
        
        cd(varargin{idxd}) % change working directory to the one selected
        FileList=systemfiles(varargin{~(idxm+idxd)}); % Find Files in Directory
        if ~isempty(FileList)
            FileList=FileList(varargin{idxm}); % Keep only wanted files
        else
            disp('No Files Found')
        end
end
end
function [ Files ]=systemfiles(ext)
% Perform a search through every layer of the folder to find all input files
[~, list]=system(['dir /S /B ', ext]);
% Parse list to separate files
Files=regexp(list,'.*','match','dotexceptnewline');
end

