% SKYEINIT - Initialize skye's tools

skyeglobals;

myfile = which('skyeinit');

[pathname,filename] = fileparts(myfile);

addpath(pathname);
addpath([pathname filesep 'classifiers']);
addpath([pathname filesep 'modifiers']);
addpath([pathname filesep 'math']);
addpath([pathname filesep 'plotcode']);
addpath([pathname filesep 'qualitycontrol']);

skye_common_temp = 30:75;
skye_trough_temp = 88;
skye_ictheor = 78.5;
