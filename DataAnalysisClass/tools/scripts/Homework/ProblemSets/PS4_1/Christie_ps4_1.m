%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ian Christie
% Data Analysis
% Problem Set 4.1
% December 2, 2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all

%%%% Q1
%%Q1.1
im_raw = double(imread('cell_image.tiff'));
im_disp = rescale(im_raw, [min(im_raw(:)) max(im_raw(:))],[0 255]);
size(im_disp) %= 512   512

%%Q1.2
% It is an intensity image, you can tell because it is a two dimensional
% array and the values don't correspond to a colormap

%%Q1.3
myimage2 = imread('miro68.JPG');
size(myimage2) %= 561   747     3

%%Q1.4
%This is an RBG image. You can tell because it is a three dimensional
%matrix with three elements (RGB) in it's third dimension

%%%% Q2
f1 = figure(1);
subplot(2,2,1);
colormap(gray(256));
image(im_disp);
title('Cell Image');

subplot(2,2,2);
image(myimage2);
title('Tasteful Juan Miro Blue II');

subplot(2,2,3);
bins = -0.5:1:256;
N = histc(im_disp(:),bins);
bar(bins+0.5,N);
title('Intensity distribution');
xlabel('Pixel Intensity');
ylabel('Number');
axis([0 256 0 5000]);

subplot(2,2,4);
bins2 = -0.5:1:3*256;
colorLinearization = sum(myimage2, 3);
N = histc(colorLinearization(:),bins2);
bar(bins2+0.5,N);
title('Intensity distribution');
xlabel('Pixel Intensity');
ylabel('Number');
axis([0 3*256 0 14000]);

% I chose to just use the sum of RGB. Color Linearization is a pretty 
% studied topic, but I just went with the easiest

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Q2
%%Q2.1
x = -10:0.1:10;
y = x;
[X,Y] = meshgrid(x,y);
sig = 3;
Z = (1/sqrt(2*pi*sig^2))*exp(-(X.^2+Y.^2)/(2*sig^2));
figure;
colormap(jet(256));
image(x,y,255*Z);
title('Yes I see the exponential distribution!');
% Yes I see the exponential distribution!

%%Q2.2
centerX = 0;
centerY = 0;
radius = 3;

circlePixels = (Y - centerY).^2 + (X - centerX).^2 <= radius.^2;

figure;
image(x, y, 255*circlePixels) ;
colormap([0 0 0; 1 1 1]);
title('Binary image of a circle');

%%Q2.3
majorRadius = 3;
minorRadius = 2;

ellipse = (((Y - centerY).^2) / majorRadius^2) + (((X - centerX).^2) / minorRadius ^ 2) <= 1;

figure;
image(x, y, 255*ellipse) ;
colormap([0 0 0; 1 1 1]);
title('Binary image of a Ellipse');

%%Q2.4
thetaDegrees = 30;
theta = thetaDegrees * pi / 180;

rotatedEllipse = ((X*cos(theta)+X*sin(theta)).^2)/majorRadius^2+((X*sin(theta)-Y*cos(theta)).^2)/minorRadius^2 <= 1;

figure;
image(x, y, 255*rotatedEllipse) ;
colormap([0 0 0; 1 1 1]);
title('Binary image of a Ellipse Rotated');

%%Q2.5
rotatedEllipseFunctioned = makeRotatedEllipse(200, 120, 50, 45);

figure;
image(255*rotatedEllipseFunctioned) ;
colormap([0 0 0; 1 1 1]);
title('Binary image of a Ellipse Rotated via Function');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Q3
%%Q3.1

blurrer1 = 0:.001:.05;
blurrer2 = [0:.001:.01;
           0:.002:.02;
           0:.003:.03;
           0:.004:.04;
           0:.008:.08;
           0:.01:.1];
C1 = imfilter(myimage2,blurrer1, 'symmetric');
C2 = imfilter(myimage2,blurrer2, 'symmetric');
figure;
subplot(3,1,1);
image(myimage2);
title('Tasteful Juan Miro Blue II');
subplot(3,1,2);
imagesc(C1);
colormap(gray(256));
title('Artistically Tasteful Juan Miro Blue II');
subplot(3,1,3);
imagesc(C2);
colormap(gray(256));
title('Another Artistically Tasteful Juan Miro Blue II');

%%Q3.2
hl = fspecial('gaussian', 60, 5);
hh = fspecial('gaussian', 8, 1);
lowpass_cell_image = imfilter(im_disp, hl,'symmetric');
highpass_cell_image = im_disp - lowpass_cell_image;
filtered_cell_image = imfilter(highpass_cell_image, hh, 'symmetric');
figure;
imagesc(lowpass_cell_image);
title('Low Pass Cell Image');
colormap(gray(256));
figure;
imagesc(highpass_cell_image);
title('High Pass Cell Image');
colormap(gray(256));
figure;
imagesc(filtered_cell_image);
title('Filtered Cell Image');
colormap(gray(256));

%'symmetric'  Input array values outside the bounds of the array
%                     are computed by mirror-reflecting the array across
%                    the array border.
% basically it just makes sure that you don't get that black edge effect
% when you do maxtrix convolutions because of the edge artifact

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Q4
%%Q4.1
% Done, code below and attached

% function [result] = optical_notch(wavelengths, pass_wavelength, bandwidth)
% %UNTITLED5 Summary of this function goes here
% %   Detailed explanation goes here
% 
% interval = bandwidth / 2;
% 
% high = pass_wavelength + interval;
% low = pass_wavelength - interval;
% 
% result = (wavelengths > low & wavelengths < high);
% 
% end

%%Q4.2
load('PS4_1.mat');

excitation_pass_wavelength = 480;
excitation_bandwith = 30;

emission_pass_wavelength = 535;
emission_bandwidth = 40;

excitationFilter = optical_notch(wavelengths, excitation_pass_wavelength, excitation_bandwith);
emissionFilter = optical_notch(wavelengths, emission_pass_wavelength, emission_bandwidth);

figure;
plot(wavelengths, excitationFilter);
hold on
plot(wavelengths, Q505LP, 'r');
hold on
plot(wavelengths, emissionFilter, 'g');
hold off
legend('Excitation Filter','Q505LP','Emission FIlter');

%%Q4.3
figure;
currentLight = Xcite120';

subplot(7,1,1);
plot(wavelengths, currentLight);
title('Light at stages');

subplot(7,1,2);
currentLight = currentLight .* optical_notch(wavelengths, excitation_pass_wavelength, excitation_bandwith);
plot(wavelengths, currentLight);

subplot(7,1,3);
reflecting_dichronic = 1 - Q505LP;
currentLight = currentLight .* reflecting_dichronic;
plot(wavelengths, currentLight);
ylabel('Response (intensity)');

subplot(7,1,4);
temp = currentLight;
response = sum(currentLight .* GFPexcite);
currentLight = response * GFPemit;
currentLigt = currentLight + (.25 * temp);
plot(wavelengths, currentLight);

subplot(7,1,5);
currentLight = currentLight .* Q505LP;
plot(wavelengths, currentLight);

subplot(7,1,6);
currentLight = currentLight .* optical_notch(wavelengths, emission_pass_wavelength, emission_bandwidth);
plot(wavelengths, currentLight);

subplot(7,1,7);
currentLight = currentLight .* Dalsa1M60;
plot(wavelengths, currentLight);
xlabel('Wavelength (nm)');

%%Q4.4
% The answer is C. Largely what we care about, if we want to see more 
% AlexaFluor 594 than GFP, is the light that we are sending into the space,
% adn the light that we will collect. Both have to be more appropriate for 
% AlexaFluor 594 than for GFP. The excitation light that we put in should
% be greater than GFP (peak around 500) and around AlexaFlour 594 (peak
% around 575). Furthermore, we want to collect light around AlexaFlour 594
% (peak around 594) rather than GFP (also around 500). C allows for both 
% of these options.








