function plot_boxwhisker(data, x_location, boxwidth,color) 
% PLOT_BOXWHISKER - Creates a BOXWHISKER plot 
% PLOT_BOXWHISKER(MYDATA, X_LOCATION, BOXWIDTH,COLORSTRING) 
% Makes a box whisker plot of MYDATA at the location 
% X_LOCATION on the X axis with width BOXWIDTH with color equal 
% to COLORSTRING (see 'help plot' for color strings) 

boxdata = prctile(data, [5 25 50 75 95]); 
hold on; 
plot(x_location+boxwidth*[-1 1]/4,boxdata(1)*[1 1],['-' color]); % plot low bar 
plot(x_location+boxwidth*[-1 1 1 -1 -1],boxdata([2 2 4 4 2]),['-' color]); % box 
plot(x_location+boxwidth*[-1 1]/4,boxdata(5)*[1 1],['-' color]); % high bar 
plot(x_location+boxwidth*[-1 1],boxdata(3)*[1 1],['-' color]); % median bar
plot(x_location*[1 1],boxdata([1 5]),['-' color]); % vertical bar 
end