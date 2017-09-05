function s = IanISNlabelscolors
% IanISNlabelscolors - Mapping between labels and plot color
%
%  Creates a default structure that describes the mapping between response label
%  types and plot color.
%
%  Fields are as follows:
%  Fieldname:                 | Description
%  --------------------------------------------------------------------
%  'ResponseLabel'            | The label to use (e.g., 'Directional')
%  'PlotIt'                   | 0/1 should we plot this label?
%  'PlotColor'                | [r g b]
%  'function'                 | Function to evaluate. The function should take a cube structure
%                             |   as an argument with variable 'x'. e.g., 'IsUNSDirectionalSelective(x);'
%
%

s =    struct('ResponseLabel','Unresponsive',  'PlotIt', 1,'PlotColor', [1 1 1],       'function','IsISNUnResponsive(x,''dir_thresh'',Inf);');
s(2) = struct('ResponseLabel','Unselective',   'PlotIt', 1,'PlotColor', [0.5 0.5 0.5], 'function','IsISNUnselective(x);');
s(3) = struct('ResponseLabel','HalfUni',       'PlotIt', 1,'PlotColor', [1 1 0],       'function','IsISNHalfUniDirectional(x);');
s(4) = struct('ResponseLabel','Unidirectional','PlotIt', 1,'PlotColor', [1 0 0],       'function','IsISNUniDirectional(x);');
s(5) = struct('ResponseLabel','Directional',   'PlotIt', 1,'PlotColor', [0 0 1],       'function','IsISNDirectionalSelective(x);');
s(6) = struct('ResponseLabel','HalfUni2',      'PlotIt', 1,'PlotColor', [0 1 0],       'function','IsISNHalfUni2Directional(x);');


