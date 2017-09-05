function [ control, experiment, peakDeltaControl, peakDeltaExperiment ] = analyzeDatFly(fileName)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

out = 0;
plotit = 1;

[control, experiment, controlHist, experimentHist] = unpackFly(fileName, plotit);

meanC = mean(control, 3);
meanE = mean(experiment, 3);

controlBaseline = control(:,:,1:60);
controlProfusion = control(:,:,61:120);
controlRecording = control(:,:,121:240);

meanControlBaseline = mean(controlBaseline, 3);
meanControlProfusion = mean(controlProfusion, 3);
meanControlRecording = mean(controlRecording, 3);

histControlBaseline = controlHist(:,1:60);
histControlProfusion = controlHist(:,61:120);
histControlRecording = controlHist(:,121:240);

meanHistControlBaseline = mean(histControlBaseline, 2);
meanHistControlProfusion = mean(histControlProfusion, 2);
meanHistControlRecording = mean(histControlRecording, 2);

experimentalBaseline = experiment(:,:,1:60);
experimentalProfusion = experiment(:,:,61:120);
experimentalRecording = experiment(:,:,121:240);

meanExperimentalBaseline = mean(experimentalBaseline, 3);
meanExperimentalProfusion = mean(experimentalProfusion, 3);
meanExperimentalRecording = mean(experimentalRecording, 3);

histExperimentBaseline = experimentHist(:,1:60);
histExperimentProfusion = experimentHist(:,61:120);
histExperimentRecording = experimentHist(:,121:240);

meanHistExperimentBaseline = mean(histExperimentBaseline, 2);
meanHistExperimentProfusion = mean(histExperimentProfusion, 2);
meanHistExperimentRecording = mean(histExperimentRecording, 2);

bins = -0.5+[0:256];

[peakControlBaselineValue] = getSmallestMeanPeak(histControlBaseline);
[peakControlProfusionValue] = getSmallestMeanPeak(histControlProfusion);
[peakControlRecordingValue] = getSmallestMeanPeak(histControlRecording);

peakDeltaControl = peakControlBaselineValue - peakControlRecordingValue;

[peakExperimentBaselineValue] = getSmallestMeanPeak(histExperimentBaseline);
[peakExperimentProfusionValue] = getSmallestMeanPeak(histExperimentProfusion);
[peakExperimentRecordingValue] = getSmallestMeanPeak(histExperimentRecording);

peakDeltaExperiment = peakExperimentBaselineValue - peakExperimentRecordingValue;

if plotit,
    %%control
    figure;
    colormap(gray(256));
    
    %%mean Images
    subplot(3,3,1);
    image(meanControlBaseline);
    title('Control Baseline');
    ylabel('Average Image');

    subplot(3,3,2);
    image(meanControlProfusion);
    title('Control Profusion');

    subplot(3,3,3);
    image(meanControlRecording);
    title('Control Recording');
    
    %%meanHist
    subplot(3,3,4);
    bar(bins+0.5,meanHistControlBaseline);
    axis([0 256 0 8000]);
    ylabel('Average Histogram');

    subplot(3,3,5);
    bar(bins+0.5,meanHistControlProfusion);
    axis([0 256 0 8000]);
    

    subplot(3,3,6);
    bar(bins+0.5,meanHistControlRecording);
    axis([0 256 0 8000]);

    %%meanCumHist
    subplot(3,3,7);
    [X1,Y1] = cumhist(meanHistControlBaseline, [0 256],1);
    plot(X1,Y1);
    ylabel('Average Cumulative Histogram');

    subplot(3,3,8);
    [X2,Y2] = cumhist(meanHistControlProfusion, [0 256],1);
    plot(X2,Y2);

    subplot(3,3,9);
    [X3,Y3] = cumhist(meanHistControlRecording, [0 256],1);
    plot(X3,Y3);

    %%experimentImages
    figure;
    colormap(gray(256));

    subplot(3,3,1);
    image(meanExperimentalBaseline);
    title('Experiment Baseline');
    ylabel('Average Image');

    subplot(3,3,2);
    image(meanExperimentalProfusion);
    title('Experiment Profusion');

    subplot(3,3,3);
    image(meanExperimentalRecording);
    title('Experiment Recording');

    %%experimentHist
    subplot(3,3,4);
    bar(bins+0.5, meanHistExperimentBaseline);
    axis([0 256 0 8000]);
    ylabel('Average Histogram');

    subplot(3,3,5);
    bar(bins+0.5,meanHistExperimentProfusion);
    axis([0 256 0 8000]);

    subplot(3,3,6);
    bar(bins+0.5,meanHistExperimentRecording);
    axis([0 256 0 8000]);

    %%experimentCumHist
    subplot(3,3,7);
    [X1,Y1] = cumhist(meanHistExperimentBaseline, [0 256],1);
    plot(X1,Y1);
    ylabel('Average Cumulative Histogram');

    subplot(3,3,8);
    [X2,Y2] = cumhist(meanHistExperimentProfusion, [0 256],1);
    plot(X2,Y2);

    subplot(3,3,9);
    [X3,Y3] = cumhist(meanHistExperimentRecording, [0 256],1);
    plot(X3,Y3);
end

out = 1;

end

