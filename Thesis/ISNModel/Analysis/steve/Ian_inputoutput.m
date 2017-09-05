function Ian_inputoutput(x)
% IAN_INPUTOUTPUT - vary input and show output for a fixed ISN

Input_range = 0:5:200;

Di = {};

myfig = figure;

title_list = {'sigmoidFunction','rectified^2','rectified^1.15'};

for i=1:3,

	if i==3,
		x.m = zeros(4,4);
		x.m(1,1) = 0.8; x.m(2,1) = -0.41; x.m(1,2) = 0.4; 
	end;

	Di{i} = [];
	LUe{i} = [];
	LDe{i} = [];
	LUi{i} = [];
	LDi{i} = [];

    
    
	for input=Input_range;
		x.Strong = input;
		x.Weak = 0;
		if i==1,
			x_out = plot_ISN_timeseries(x,'sigmoidFunction');
		elseif i==2,
			x_out = plot_ISN_timeseries(x,'rectified2');
		elseif i==3,
			x_out = plot_ISN_timeseries(x,'rectified115');
		end;
		close;
		close;
		if x_out.SS,
			Di{i}(end+1) = (x_out.LUe-x_out.LDe)/sum([x_out.LUe x_out.LDe]);
			LUe{i}(end+1) = x_out.LUe;
			LUi{i}(end+1) = x_out.LUi;
			LDe{i}(end+1) = x_out.LDe;
			LDi{i}(end+1) = x_out.LDi;

		else,
			Di{i}(end+1) = NaN;
			LUe{i}(end+1) = NaN;
			LUi{i}(end+1) = NaN;
			LDe{i}(end+1) = NaN;
			LDi{i}(end+1) = NaN;
		end;
		if ~x_out.SS, break; end;
	end;

	subplot(3,3,i);
	plot(Input_range(1:length(Di{i})), Di{i},'b-');
	xlabel('Input');
	ylabel('DI');
	title([title_list{i}]);
	set(gca,'ylim',[0 1]);
	box off;

	subplot(3,3,i+3);
	plot(Input_range(1:length(LUe{i})), LUe{i},'b-');
	hold on;
	plot(Input_range(1:length(LUi{i})), LUi{i},'g-');
	xlabel('Input');
	ylabel('Resp');
	title([title_list{i}]);

	box off;

end;

