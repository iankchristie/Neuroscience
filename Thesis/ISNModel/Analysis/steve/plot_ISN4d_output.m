function h = plot_ISN4d_output(respstruct,varargin)
% PLOT_ISN4D_OUTPUT - Plot the output of the 4d network simulation
%
%  H = PLOT_ISN4D_OUTPUT(RESPSTRUCT)
%
%  Given a RESPSTRUCT, plots a summary of the model output in the current
%  axes.
%    
%  RESPSSTRUCT is a structure that contains the results of running the
%  model. It includes several fields:
%  fieldname                      | Description
%  -----------------------------------------------------------------------
%  'm'                            | Connection matrix
%  'LUe'                          | Response of E1 ('left excitatory neuron')
%                                 |   to upward motion.
%  'LDe'                          | Response of E1 ('left excitatory neuron')
%                                 |   to downward motion.
%  'RUe'                          | Response of E2 ('right excitatory neuron')
%                                 |   to upward motion.
%  'RDe'                          | Response of E2 ('right excitatory neuron')
%                                 |   to downward motion.
%  'LUi'                          | Response of I1 ('left inhibitory neuron')
%                                 |   to upward motion.
%  'LDi'                          | Response of I1 ('left inhibitory neuron')
%                                 |   to downward motion.
%  'RUi'                          | Response of I2 ('right inhibitory neuron')
%                                 |   to upward motion.
%  'RDi'                          | Response of I2 ('right inhibitory neuron')
%                                 |   to downward motion.
%  'SS'                           | Whether or not the model settles to a steady
%                                 |   state when input is removed (0/1). If it does
%                                 |   not it probably "explodes" with input.
%
% This function also takes name/value pairs to modify functionality:
% Parameter (default value)       | Description
% ---------------------------------------------------------------------------
% ResponseLabel ({''})            | Labels describing the response types (cell list)
% FindResponseLabel (1)           | Find the response label
% labelcolorstruct                | Structure list of labels, colors, and labeling functions
%  (IanISNlabelscolors)           |   (see HELP IANISNLABELSCOLORS)

struct2var(respstruct);

ResponseLabel = {''};
FindResponseLabel = 1;
labelcolorstruct = IanISNlabelscolors;

assign(varargin{:});

if FindResponseLabel,
	[c,ind,label]=get_ISN_labelcolor(respstruct,labelcolorstruct),
	ResponseLabel = label;
	if ~iscell(ResponseLabel), ResponseLabel = {ResponseLabel}; end;
end;

printConnectionMatrixLabels

m,

LDI = (LUe - LDe) / (LUe + LDe);
RDI = (RDe - RUe) / (RUe + RDe);
LSI = (LUi - LDi) / (LUi + LDi);
RSI = (RDi - RUi) / (RDi + RUi);

figure;

hold off;
h1=bar([1 2 3 4],[LUe LUi RUe RUi]);
set(h1,'facecolor',[0 0 1]);
hold on;
h2=bar([6 7 8 9],[LDe LDi RDe RDi]);
set(h2,'facecolor',[1 0 0]);

title_string = ['SS=' int2str(SS) ', Strong=' num2str(Strong) ', Weak=' num2str(Weak) ', LDI=' num2str(LDI,2) ...
		', RDI=' num2str(RDI,2) ];
title_string2 = [];

for i=1:length(ResponseLabel),
	title_string2 = [title_string2 ResponseLabel{i} ', '];
end;
if length(ResponseLabel)>0,
	title_string2 = title_string2(1:end-2);
end;

title({title_string,title_string2},'interp','none');

set(gca,'xtick',[1 2 3 4 6 7 8 9],'xticklabel',{'LUe','LUi','RUe','RUi','LDe','LDi','RDe','RDi'});

box off;
axis([0 10 0 100]);

set(gca,'userdata',respstruct);

plot_ISN_timeseries(respstruct);
