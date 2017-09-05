function Ian_singlecompartment
% IAN_SINGLECOMPARTMENT - Examine responses of a single neural element with biased input, with self-excitation varying

x.m = zeros(4,4); 
x.Strong = 8;
x.Weak = 7;

Strong = {6,6,6};
Weak = {5,5,1.1};

Waa_range = 0:0.01:1;

Di = {};

myfig = figure;

for i=1:3,

	x.Strong = Strong{i};
	x.Weak = Weak{i};

	Di{i} = [];
	LUe{i} = [];
	LDe{i} = [];

	for Waa=Waa_range;
		x.m(1,1) = Waa;
		x_out = plot_ISN_timeseries(x,'rectified115');
		close;
		close;
		if x_out.SS,
			Di{i}(end+1) = (x_out.LUe-x_out.LDe)/sum([x_out.LUe x_out.LDe]);
			LUe{i}(end+1) = x_out.LUe;
			LDe{i}(end+1) = x_out.LDe;
		else,
			Di{i}(end+1) = NaN;
			LUe{i}(end+1) = NaN;
			LDe{i}(end+1) = NaN;
		end;
		if ~x_out.SS, break; end;
	end;

	subplot(3,3,i);
	plot(Waa_range(1:length(Di{i})), Di{i},'b-');
	xlabel('Waa');
	ylabel('DI');
	title(['Strong=' num2str(x.Strong) ', Weak= ' num2str(x.Weak) '.']);
	axis([0 1 0 1]);
	box off;

	subplot(3,3,i+3);
	plot(Waa_range(1:length(LUe{i})), LUe{i},'b-');
	hold on;
	plot(Waa_range(1:length(LDe{i})), LDe{i},'r-');
	xlabel('Waa');
	ylabel('Resp');
	title(['Strong=' num2str(x.Strong) ', Weak= ' num2str(x.Weak) '.']);

	axis([0 1 0 100]);
	box off;

end;

