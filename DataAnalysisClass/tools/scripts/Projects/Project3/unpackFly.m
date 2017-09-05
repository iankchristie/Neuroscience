function [control, experiment, controlHist, experimentHist] = unpackFly(fileName, plotit)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

controlFile = [fileName filesep 'control.tif'];
experimentalFile = [fileName filesep 'experimental.tif'];
timeRate = .001;

fileinfo = imfinfo(controlFile);
num_frames = length(fileinfo);

tempRawControl = double(imread(controlFile,1));
tempDispControl = rescale(tempRawControl, [min(tempRawControl(:)) max(tempRawControl(:))],[0 255]);

[a1, b1] = size(tempDispControl);

control = zeros(a1, b1, num_frames);

tempRawExperimental = double(imread(experimentalFile,1));
tempDispExperimental = rescale(tempRawExperimental, [min(tempRawExperimental(:)) max(tempRawExperimental(:))],[0 255]);

[a2, b2] = size(tempDispExperimental);

experiment = zeros(a2, b2, num_frames);

bins = -0.5+[0:256];

controlHist = zeros(length(bins), num_frames);
experimentHist = zeros(length(bins), num_frames);

if plotit,
    figure;
    colormap(gray(256));
end
for i = 1: num_frames,
    tempRawControl = double(imread(controlFile,i));
    tempDispControl = rescale(tempRawControl, [min(tempRawControl(:)) max(tempRawControl(:))],[0 255]);
    
    tempRawExperimental = double(imread(experimentalFile,i));
    tempDispExperimental = rescale(tempRawExperimental, [min(tempRawExperimental(:)) max(tempRawExperimental(:))],[0 255]);
    
    tempControlHist = histc(tempDispControl(:), bins);
    tempExperimentalHist = histc(tempDispExperimental(:), bins);
    
    if plotit,
        subplot(2,2,1);
        image(tempDispControl);
        if i < 60,
            title('Baseline');
        elseif i > 120,
            title('Recording');
        else
            title('Perfusion');
        end
        
        subplot(2,2,2);
        image(tempDispExperimental);
        if i < 60,
            title('Baseline');
        elseif i > 120,
            title('Recording');
        else
            title('Perfusion');
        end
        
        subplot(2,2,3);
        bar(bins+0.5,tempControlHist);
        axis([0 256 0 8000]);
        
        subplot(2,2,4);
        bar(bins+0.5,tempExperimentalHist);
        axis([0 256 0 8000]);
        pause(timeRate);
    end
    control(:,:,i) = tempDispControl;
    experiment(:,:,i) = tempDispExperimental;
    controlHist(:,i) = tempControlHist;
    experimentHist(:,i) = tempExperimentalHist;
end

end

