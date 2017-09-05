function [out] = IsISNUnresponsive(respstruct, varargin)
% IsISNUnresponsive: is ISN model response half uni-directionally selective?
%
%  OUT = ISISNUNRESPONSIVE(RESPONSESTRUCT, ...)
%
%  Examines whether responses from any model excitatory neuron 
%  exhibits substantial responses above a threshold or above a direction
%  selectivity threshold.
%
%  RESPONSESTRUCT is a structure that contains the results of running the
%  model. It includes several fields:
%
%  fieldname                      | Description
%  -----------------------------------------------------------------------
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
%  The user can also specify additional parameters as name/value pairs:
%  Parameter (default value)      | Description
%  ----------------------------------------------------------------------
%  resp_thresh (40)               | Minimal response that must be exceeded
%                                 |   for responses to be considered substantial
%  dir_thresh (0.3)               | Minimal direction selectivity that must be 
%                                 |   exceeded for responses to be considered 
%                                 |   substantial
%


resp_thresh = 50;
dir_thresh = 0.3;

assign(varargin{:});
struct2var(respstruct);

out = 0;

LDI = (LUe - LDe) / (LUe + LDe);

RDI = (RDe - RUe) / (RUe + RDe);

if ((LUe<resp_thresh)&&(LDe<resp_thresh)&&(RUe<resp_thresh)&&(RDe<resp_thresh) && (LDI<dir_thresh) && (RDI<dir_thresh) && (SS==1)),
    out = 1;
end

end

