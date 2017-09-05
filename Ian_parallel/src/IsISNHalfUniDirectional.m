function [out] = IsISNHalfUniDirectional(respstruct, varargin)
% IsISNHalfUniDirectional: is ISN model response half uni-directionally selective?
%
%  OUT = ISISNHALFUNIDIRECTIONAL(RESPONSESTRUCT, ...)
%
%  Examines whether responses from the model excitatory neuron from
%  one column exhibit substantial responses above a threshold for
%  upward and downward directions, AND whether responses of the opposite
%  neuron are only above threshold for upward OR downward directions but not
%  both.
%
%  If this is true, OUT is 1. If this ALSO true for the interneurons in the
%  model, then OUT is 2. The selectivity of the interneurons must match the
%  selectivity of excitatory neurons in the same column.
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
%  resp_thresh (60)               | Minimal response that must be exceeded
%                                 |   for responses to be considered substantial
%

resp_thresh = 50; % was set to 60 in Ian's code

assign(varargin{:});

struct2var(respstruct);

out = 0;

if(SS == 1),
    if (LUe > resp_thresh && LDe > resp_thresh && RUe > resp_thresh && RDe < resp_thresh),
        if (LUi > resp_thresh && LDi > resp_thresh && RUi > resp_thresh && RDi < resp_thresh)
            out = 2;
        else
            out = 1;
        end
    end

    if (LUe > resp_thresh && LDe > resp_thresh && RUe < resp_thresh && RDe > resp_thresh),
        if (LUi > resp_thresh && LDi > resp_thresh && RUi < resp_thresh && RDi > resp_thresh),
            out = 2;
        else
            out = 1;
        end
    end

    if (LUe > resp_thresh && LDe < resp_thresh && RUe > resp_thresh && RDe > resp_thresh),
        if (LUi > resp_thresh && LDi < resp_thresh && RUi > resp_thresh && RDi > resp_thresh),
            out = 2;
        else
            out = 1;
        end
    end

    if (LUe < resp_thresh && LDe > resp_thresh && RUe > resp_thresh && RDe > resp_thresh),
        if (LUi < resp_thresh && LDi > resp_thresh && RUi > resp_thresh && RDi > resp_thresh),
            out = 2;
        else
            out = 1;
        end
    end
end

end

