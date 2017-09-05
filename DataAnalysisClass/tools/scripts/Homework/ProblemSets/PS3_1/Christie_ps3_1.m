%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ian Christie
% Data Analysis
% Problem Set 3.1
% November 11, 2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Q1
%%%Q1.1
% What are the components of a sampled time series?
% D. All of them. We need the value at each sample, the time of each sample
% and the index of each sample (generally that one is derived from the file)

%%%Q1.2
% Which of the following (possibly more than 1 choice) contain sufficient
% information to specify a time series?
% We need everything above, but some information can be inferred from
% others.
% b) A list of samples and the a list of the times the samples were measured
% This gives us our values, times, and indices can be inferred from the
% file
% c) A list of samples, the time of the first sample, and a fixed time that
% elapsed between samples.
% We have the values. The times can be inferred given the start time and
% the fixed elapsed time. Indices can be inferred from the file as well.

%%%Q1.3
% All answers will use this formula
% ((sample index (cycle)) / (sample rate (cycle / time)))  + time offset (time) = time of sample index (time)
%%Q1.3.1
% (500 / 10,000) + 0 = 0.05 seconds

%Q1.3.2
% Just algebraically rearrange formula above
% ((time of sample index (time)) - time offset (time)) * (sample rate (cycle / time )) = sample index (cycle) 
% (0.453 - 0) * 10,000 = 4530 cycle

%Q1.3.3
% Oh, I did that above. Here it is again.
% sample number = ((time of sample index (time)) - time offset (time)) * (sample rate (cycle / time ))

%Q1.3.4
% (x number of samples (cycles)) / (sampling rate (cycle / time)) = time between x number of samples
% Because we're being inclusive with 100 and 200 we actually have 101
% samples
% 101 / 10,0000 = 0.0101 seconds

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Q2
% I wrote the function cumprod2 that is attached It basically looks like
% this:

% [n, m] = size(mat);
% if n >= 1 && m >= 1,
%     result = ones(n, m);
%     result(:, 1) = mat(:, 1);
% 
%     for i = 2: m,
%         result(:, i) = result(:,i - 1) .* mat(:, i);
%     end
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Q3
load neuron.mat

sampling_rate = 10000;

%%Q3.1
interval_start = 17;
interval_end = 20;
time_interval = interval_start:(1/sampling_rate):interval_end;
interval17_20 = voltage(interval_start*sampling_rate : interval_end*sampling_rate);
f1 = figure;
plot(time_interval, interval17_20);
title('Voltage over 17 - 20 seconds');
xlabel('Time (sec)');
ylabel('Voltage (V)');
hold on

%%Q3.2
Vt = -.0001;
% belowThresh = interval17_20<=Vt;
% belowThresh(1) = 0;
% belowThreshIndices = find(belowThresh);
% spikes = interval17_20(belowThreshIndices-1)>Vt; 
% belowThreshIndices(spike);

% I could use the code above, and it makes a lot of intuitive sense and its
% more "matlab expression-y" whatever that means. I assume you didn't want me to
% write a function or use a for loop.
% But its kind of inefficient since I have to make multiple passes over data. I
% created a function, called findSpike, that will do a one pass loop over the data.
% The loop function code is here

% function [ result ] = findSpike(v, thresh)
% %FINDSPIKE returns bitmap of indices where v(i-1) is above threshold and
% %v(i) is below threshhold  
% 
% result = zeros(1, length(v));
% 
% for i = 2: length(v),
%     if v(i) <= thresh && v(i-1) > thresh,
%         result(i) = 1;
%     end
% end
% 
% end

% I think that the Vt above at -0.0001 is a good threshold for the spike
% data. It gives us 71 spikes, which is pretty biologically accurate. Not
% too many, and not too few

%%Q3.3

spikes = findSpike(interval17_20', Vt);

plot(time_interval, spikes.*interval17_20', 'ro');
hold off

%%Q3.4
% I'm not entirely sure what "write matlab expression" means. I'm taking it
% to mean just write a function. I wrote getNumSpikes a function that I
% have attached

% indice0 = T0*sampling_rate;
% indice1 = T1*sampling_rate;
% 
% interval = v(indice0:indice1);
% 
% numSpikes = length(find(findSpike(interval', Vt)));


getNumSpikes(voltage, interval_start, interval_end, Vt, sampling_rate)

%%Q3.5
interval_start = 17;
interval_end = 21;

stim = ones(1, (stim_times(2,3) - stim_times(2,2))*sampling_rate);
zeroA = zeros(1,ceil((stim_times(2,2)-interval_start)*sampling_rate));
zeroB = zeros(1,ceil((interval_end - stim_times(2,3))*sampling_rate));
stimulus = [zeroA stim zeroB];

time_interval = interval_start:(1/sampling_rate):interval_end;
interval17_21 = voltage(interval_start*sampling_rate : interval_end*sampling_rate);

f2 = figure;
plot(time_interval, interval17_21);
title('Voltage over 17 - 21 seconds');
xlabel('Time (sec)');
ylabel('Voltage (V)');
hold on
plot(time_interval, max(interval17_21)*stimulus, 'go');
hold on
spikes2 = findSpike(interval17_21', Vt);
plot(time_interval, spikes2.*interval17_21', 'ro');
hold off
legend('Voltage', 'Stimuls Duration', 'Spikes')

%%Q3.6
% I changed the input so that it accepts the whole voltage trace instead of
% just the spike times. This was done so that I could use the getNumSpikes
% function I wrote earlier

% Vt = -0.0001;
% sampling_rate = 10000;
% 
% individual_responses = zeros(1, size(stim_times, 1));
% 
% for i=1:size(stim_times,1),
% 
%   individual_responses(i) = getNumSpikes(voltage, stim_times(i,1), stim_times(i,2), Vt, sampling_rate) / (stim_times(i,2) - stim_times(i,1));
% 
% end;
% 
% average_response = mean(individual_responses);

[avg, ind] = calculate_responses(voltage, stim_times(:,2:3));

%%Q3.7
ind1 = [];
for i = 1: size(stim_times, 1),
    if abs(stim_times(i,1) - 1) < .01,
        ind1 = [ind1 ind(i)];
    end
end

ind1, %= 35.0000   11.5000   19.0000   47.5000   36.5000   spikes/sex
avg1 = mean(ind1) %= 29.9 spikes / sec
