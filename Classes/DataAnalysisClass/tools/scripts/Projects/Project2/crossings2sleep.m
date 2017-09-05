function [ times, time_sleeping ] = crossings2sleep( times, crossings )
time_sleeping = [];
[binnedTimes, binnedCrossings] = bindata(times, crossings);
[m,n] = size(binnedCrossings);
for i = 1: m,
  time_sleeping = [time_sleeping gettimesleeping(binnedCrossings(i, :))];
end
times = mean(binnedTimes');

plotit = 0;
if plotit,
    switches = [0, 12, 24, 36, 48, 60, 72, 96];
    figure;
    plot(times, time_sleeping);
    for i = 1: length(switches),
        hold on
        plot([switches(i), switches(i)], [0 30], 'r');
    end
    hold off
    title('Sleeping Recordings');
    xlabel('Time (hr)');
    ylabel('Time Sleeping (min)');
end

end