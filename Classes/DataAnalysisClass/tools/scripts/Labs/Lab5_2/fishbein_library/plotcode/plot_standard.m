function h = plot_standard(standards, mode, colors, standard_number, standard_replicate_number)

% PLOT_STANDARD - Plot standards
%
%  H=PLOT_STANDARD(STANDARDS, MODE, [COLORS, STANDARD_NUMBER, STANDARD_REPLICATE_NUMBER])
%  
%  Plots melt curves from the standard structure STANDARDS. Plots are constructed according to
%  the number provided in MODE (see below).  If COLORS is provided and is
%  not empty, then that set of colors are used in the plots (see format below).
%  If STANDARD_NUMBER is provided and is not empty, then only the STANDARD_NUMBER
%  is plotted.  If STANDARD_REPLICATE_NUMBER is provided and is not empty, then only that
%  replicate number is plotted.
%
%  If MODE is 1, then only individual examples are plotted.
%  If MODE is 2, then means values are plotted in a thicker line
%  If MODE is 3, then both individual examples AND means are plotted
%  
%  COLORS should be a string list of standard matlab plot colors (see HELP PLOT).
%  The default is 'bgrcmyk' (blue green red cyan magenta yellow black).  If there are more
%  than 7 standards, then the colors are repeated.

 % first, we need to handle setting variables properly based on either "default behavior"
 % or user-specified inputs

 % set the colors; we'll use the variable name 'colorlist' here to distinguish it from
 % the variable name 'colors' that the user specifies; we'll actually use 'colorlist'
 % in the function


colorlist = 'bgrcmyk'; % these are the defaults
if nargin>=3 % if there are at least 3 inputs to the function`
	if ~isempty(colors) % and if the 'colors' argument is not empty
		colorlist = colors;  % we'll use the user's choice
	end;
end;

stand_nums = 1:length(standards); % these are standards to loop over
if nargin>=4
	if ~isempty(standard_number)
		stand_nums = standard_number;
	end;
end;

  % 
stand_repls = [];
if nargin>=5
	if ~isempty(standard_replicate_number),
		stand_repls = standard_replicate_number;
	end;
end;

h = [];

for k=stand_nums

    col_number = 1+mod(k,length(colorlist));  % this line should output a number between 1 and length(colors)

    if isempty(stand_repls)
        stand_repl_loop = 1:length(standards(k).data); 
    else
        stand_repl_loop = stand_repls;
    end;

    if mode==2||mode==3
	% we need to calculate the mean  --
        %%  lets add this next week, because there's a trick; we'll make calculating the mean its own function
	[T,mnf] = mean_standard(standards(k));
	h(end+1) = plot(T,mnf,colorlist(col_number),'linewidth',3);  % this will do the wrong thing for multiple dimensions
    end;

    for m=stand_repl_loop
	hold on;
	if mode==1||mode==3
	        h(end+1) = plot(standards(k).data{m}(1,:),standards(k).data{m}(2,:),colorlist(col_number)); % this will only plot 1st dimension
	end;
        xlabel('Temperature');
        ylabel('Fluorescence');
    end

end


