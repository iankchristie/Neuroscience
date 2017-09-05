function [average_response, individual_responses] = calculate_responses(voltage, stim_times)
% compute responses during stimulus presentations
%
%  [AVG_RESPONSE, INDIVID_RESPONSES] = CALCULATE_RESPONSES(SPIKE_TIMES, STIM_TIMES)
%
%   This function calculates the mean number of spikes
%   per second fired during presentations of a 
%   repeated stimulus. VOLTAGE should contain the
%   Voltage trace.  STIM_TIMES should be a matrix;
%   each row of STIM_TIMES should have the onset (column
%   1) and offset (column 2) time of the stimulus
%   presentation.  AVG_RESPONSE is the average response
%  (in spikes per second) that was observed during the
%   stimulus presentation, and INDIVID_RESPONSES is a
%   vector that contains the responses to the individual 
%   stimulus presentations.    

Vt = -0.0001;
sampling_rate = 10000;

individual_responses = zeros(1, size(stim_times, 1));

for i=1:size(stim_times,1),

  individual_responses(i) = getNumSpikes(voltage, stim_times(i,1), stim_times(i,2), Vt, sampling_rate) / (stim_times(i,2) - stim_times(i,1));

end;

average_response = mean(individual_responses);