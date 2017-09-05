function [out] = IsISNUnselectiveB(respstruct,varargin)
% IsISNUnselective - Is ISN model response unselective?
%
%  OUT = ISISNUNSELECTIVE(RESPONSESTRUCT, ...)
%
%  Examines whether responses from the model excitatory neuron from
%  one column fail to exhibit substantial responses above a direction selective index
%  threshold.
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
%  If this is true, OUT is 1. If this ALSO true for the interneurons in the
%  model, then OUT is 2. The selectivity of the interneurons must match the
%  selectivity of excitatory neurons in the same column.
%
%  The user can also specify additional parameters as name/value pairs:
%  Parameter (default value)      | Description
%  ----------------------------------------------------------------------
%  resp_thresh (50)               | Minimal response that must be exceeded for
%                                 |   responses to be considered substantial
%  dir_thresh (0.3)               | Minimal direction index that must be exceeded
%                                 |   for responses to be considered selective
%


out = 0;

struct2var(respstruct);

resp_thresh = 50;
dir_thresh = 0.3;

assign(varargin{:});

%LDI = (LUe - LDe) / (LUe + LDe);

%RDI = (RDe - RUe) / (RUe + RDe);

if SS == 1,
    if (LUe > resp_thresh && LDe > resp_thresh && LDI <  dir_thresh && RUe < resp_thresh && RDe < resp_thresh),
        out = 1;
    else
        if (RUe > resp_thresh && RDe > resp_thresh && RDI <  dir_thresh && LUe < resp_thresh && LDe < resp_thresh),
            out = 1;
        end
    end
end

end

