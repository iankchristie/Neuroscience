function [c,label_indexes_that_work, label,unique_label] = get_ISN_labelcolor(x, labelcolorstruct, varargin)
% GET_ISN_LABELCOLOR - Return the color and label for ISN model responses
%
% [C, INDEX, LABEL, UNIQUE_LABEL] = GET_ISN_LABELCOLOR(X, LABELCOLORSTRUCT, ...)
%
% Inputs:
%    X - The model ISN response structure
%    LABELCOLORSTRUCT - The types of labels we can apply (see HELP IanISNlabelscolors)
%    
% Outputs:
%    C - An RGB color value; if no match was found, is [NaN NaN NaN]
%    INDEX - The index(es) of the LABELCOLORSTRUCT that matches
%    LABEL - The text label that corresponds to the label that was found to match
%            If no match, then NaN
%    UNIQUE_LABEL - 0/1 Was there a unique label?  If not found, is 1
%
% This function can take additional name/value pairs:
% Parameter (default value)    |  Description
% -------------------------------------------------------------------------
% 'ErrorIfNotUnique' (0)       |  Trigger an error if there is more than one label
%

ErrorIfNotUnique = 0;

assign(varargin{:});

foundIt = 0;
unique_label = 1;
c = [NaN NaN NaN];
label = NaN;

label_indexes_that_work = [];

for i=1:length(labelcolorstruct),
	compare = eval(labelcolorstruct(i).function);
	if compare,
		label_indexes_that_work(end+1) = i;
		if foundIt,
			unique_label = 0;
		end;
		foundIt = 1;
		label = labelcolorstruct(i).ResponseLabel;
		if labelcolorstruct(i).PlotIt,
			c = labelcolorstruct(i).PlotColor;
			if compare==1,
				c = c/2;
			end;
		end;
	end;
end;

if ErrorIfNotUnique & ~unique_label,
	labellist = [];
	for i=1:length(label_indexes_that_work),
		labellist = [labellist labelcolorstruct(label_indexes_that_work(i)).ResponseLabel ', '];
	end;
	labellist = labellist(1:end-2); % guaranteed to have at least 2 entries
	error(['Label not unique: ' labellist '.']);
end;

