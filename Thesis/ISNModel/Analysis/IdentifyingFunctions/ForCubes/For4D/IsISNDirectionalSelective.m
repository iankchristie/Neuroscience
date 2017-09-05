function [out] = IsISNDirectionalSelective(respstruct, varargin)
% IsDirectionalSelective: is ISN model response directionally selective?
%
%  OUT = ISISNDIRECTIONALSELECTIVE(RESPONSESTRUCT, ...)
%
%  Examines whether responses from the model excitatory neurons from
%  each column exhibit 1) substantial responses above a threshold, and
%  2) selectivity for opposite directions.
%
%  If this is true, OUT is 1. If this ALSO true for the interneurons in the
%  model, then OUT is 2. The selectivity of the interneurons must match the
%  selectivity of excitatory neurons in the same column.
%
%  RESPONSESTRUCT is a structure that contains the results of running the
%  model. It includes several fields:
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
%  resp_thresh (50)               | Minimal response that must be exceeded
%                                 |   for responses to be considered substantial
%  dir_thresh (0.8)               | Minimal selectivity required for model to be
%                                 |   considered strongly bi-directional
%  inhibitory_dir_thresh (0.2)    | Minimal selectivity required for model inhibitory
%                                 |   neurons to be considered bi-directional


resp_thresh = 50;
dir_thresh = 0.5;
inhibitory_dir_thresh = 0.2;


assign(varargin{:});

struct2var(respstruct); % assign structure fields to local variables

out = 0;

LDI = (LUe - LDe) / (LUe + LDe);
RDI = (RDe - RUe) / (RUe + RDe);
LSI = (LUi - LDi) / (LUi + LDi);
RSI = (RDi - RUi) / (RDi + RUi);

if (SS == 1), %%Makes sure that we reach steady state
    if (LDI >= dir_thresh && RDI >= dir_thresh),    %%Cells are directional selective. Left is firing to up and Right is firing to DOwn
        if ((LUe > resp_thresh) && (RDe > resp_thresh))   %%Makes sure that they are responsive
            if ((LSI > inhibitory_dir_thresh) && (RSI >= inhibitory_dir_thresh)),     %%Tests suppression
                out = 2;    %%Return 2 if suppression of inhibition exists
            else
                out = 1;    %%Return 1 is suppression of inhibition doesn't exist yet is still direction selective
            end
        end
    elseif (LDI <= -dir_thresh && RDI <= -dir_thresh),
        if ((RUe > resp_thresh) && (LDe > resp_thresh))
            if ((LSI <= -inhibitory_dir_thresh) && (RSI <= -inhibitory_dir_thresh)),
                out = 2;
            else
                out = 1;
            end
        end
    end
end

end

