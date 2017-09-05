function [ out ] = IsISNUniDirectional(respstruct,varargin)
% IsISNUniDirectional: is ISN model response half uni-directionally selective?
%
%  OUT = ISISNUNIDIRECTIONAL(RESPONSESTRUCT, ...)
%
%  Examines whether responses from the model excitatory neurons from
%  both columns exhibit substantial responses above a threshold for
%  the same upward or downward directions.
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
%  resp_thresh (40)               | Minimal response that must be exceeded
%                                 |   for responses to be considered substantial
%  dir_thresh (0.4)               | Minimal direction index for both E1 and E2 to
%                                 |   exhibit to upward (or downward) stimulation
%                                 |   in order to be considered unidirectional
%  interneuron_dir_thresh (0.2)   | Minimal direction index for both I1 and I2 to
%                                 |   exhibit to upward (or downward) stimulation in
%                                 |   order to be considered unidirectional
%


resp_thresh = 50;
dir_thresh = 0.4;
interneuron_dir_thresh = 0.2;

struct2var(respstruct);
assign(varargin{:});

out = 0;

threshDI = .4;
threshSI = .2;
threshRate = 40;

LDI = (LUe - LDe) / (LUe + LDe);
RDI = (RDe - RUe) / (RUe + RDe);
LSI = (LUi - LDi) / (LUi + LDi);
RSI = (RDi - RUi) / (RDi + RUi);

if (SS == 1), %%makes sure it returns to steady state
    if (LDI > dir_thresh && RDI < -dir_thresh), %% both responding to up
        if (LUe > resp_thresh) && (RUe > resp_thresh), %%Makes sure that they're responsive
            if (LSI > interneuron_dir_thresh && RSI < -interneuron_dir_thresh)
                out = 2;
            else
                out = 1;
            end
        end
    end
    if (LDI < -dir_thresh && RDI > dir_thresh), %% both responding to down
        if (LDe > resp_thresh) && (RDe > resp_thresh),
            if (LSI < -interneuron_dir_thresh && RSI > interneuron_dir_thresh),
                out = 2;
            else
                out = 1;
            end
        end
    end
end

