function [ latencies, sleepduringday, sleepduringnight, time_sleep, sleep_recs, failedFiles ] = analyzeflies( dirname )
%ANALYZEFLIES Analyze fly sleep data from crossings
%  [LAT, DAYSLEEP, NIGHTSLEEP, TIME_SLEEP,
%  SLEEP_RECS]=ANALYZEFLIES(DIRNAME)
%
%  Takes as input a directory name (e.g.,
%  '/Users/vanhoosr/MATLAB/data/team1_tp2/wildtype') and calculates the
%  sleep onset latency (LAT), the amount of DAYSLEEP, and the amount of
%  NIGHTSLEEP for all flies in the directory.
%  

d = dir([dirname filesep 'fly_*.txt']);

latencies = [];
sleepduringday = [];
sleepduringnight = [];
failedFiles = [];

sleep_recs = [];
time_sleep = [];

for i=1:length(d),
    path = [dirname filesep d(i).name];
    g = load(path,'-ascii');
    times = g(:,1);
    crossings = g(:,2);
      if ~isbadfly(times,crossings),
        [time_sleep,mysleeprec] = crossings2sleep(times',crossings');
        sleep_recs = [sleep_recs; mysleeprec(:)'];
        [l,sd,sn] = flystats(time_sleep,mysleeprec);
        latencies(end+1) = l;
        sleepduringday(end+1) = sd;
        sleepduringnight(end+1) = sn;
      else
          failedFiles = [failedFiles; path];
      end
end
end

