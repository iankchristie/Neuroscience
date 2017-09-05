strong = 15:18;
weak = 14:17;

LongFinder10


ParFinder10

irregularities = {};

for s = 1: length(strong),
    for w = 1: length(weak),
        if(strong(s)>weak(w)),
            if exist('ParFinderM10Data', 'dir') && exist('LongFinderm10Data','dir'),
                
                load(sprintf('LongFinderM10Data/S%dW%d/AllDS.mat', strong(s),weak(w)));
                tempds = ds;
                load(sprintf('ParFinderM10Data/S%dW%d/AllDS.mat', strong(s),weak(w)));
                if ~isempty(tempds) || ~isempty(ds),
                    disp('Here DS')
                end
                if(~isequal(tempds,ds)),
                    disp(['Irregularity in DS with Strong: ' num2str(strong(s)) ' and Weak: ' num2str(weak(w))]);
                    irregularities{end+1} = struct('Strong',strong(s), 'Weak', weak(w), 'Type', 'ds');
                end
                
                load(sprintf('LongFinderM10Data/S%dW%d/AllDSSup.mat', strong(s),weak(w)));
                tempdssup = dssup;
                load(sprintf('ParFinderM10Data/S%dW%d/AllDSSup.mat', strong(s),weak(w)));
                if ~isempty(tempdssup) || ~isempty(ds),
                    disp('Here DSSup')
                end
                if(~isequal(tempdssup,dssup)),
                    disp(['Irregularity in DSSUP with Strong: ' num2str(strong(s)) ' and Weak: ' num2str(weak(w))]);
                    irregularities{end+1} = struct('Strong',strong(s), 'Weak', weak(w), 'Type', 'dssup');
                end
                
                load(sprintf('LongFinderM10Data/S%dW%d/AllUni.mat', strong(s),weak(w)));
                tempuni = uni;
                load(sprintf('ParFinderM10Data/S%dW%d/AllUni.mat', strong(s),weak(w)));
                if ~isempty(tempuni) || ~isempty(uni),
                    disp('Here UNI')
                end
                if(~isequal(tempuni,uni)),
                    disp(['Irregularity UNI with Strong: ' num2str(strong(s)) ' and Weak: ' num2str(weak(w))]);
                    irregularities{end+1} = struct('Strong',strong(s), 'Weak', weak(w), 'Type', 'uni');
                end
                
                load(sprintf('LongFinderM10Data/S%dW%d/AllHalfUni.mat', strong(s),weak(w)));
                temphalfuni = halfuni;
                load(sprintf('ParFinderM10Data/S%dW%d/AllHalfUni.mat', strong(s),weak(w)));
                if ~isempty(temphalfuni) || ~isempty(halfuni),
                    disp('Here HALFUNI')
                end
                if(~isequal(temphalfuni,halfuni)),
                    disp(['Irregularity HALFUNI with Strong: ' num2str(strong(s)) ' and Weak: ' num2str(weak(w))]);
                    irregularities{end+1} = struct('Strong',strong(s), 'Weak', weak(w), 'Type', 'halfuni');
                end
                
                load(sprintf('LongFinderM10Data/S%dW%d/AllUnSel.mat', strong(s),weak(w)));
                tempunsel = unsel;
                load(sprintf('ParFinderM10Data/S%dW%d/AllUnSel.mat', strong(s),weak(w)));
                if ~isempty(tempunsel) || ~isempty(unsel),
                    disp('Here UNSEL')
                end
                if(~isequal(tempunsel,unsel)),
                    disp(['Irregularity UNSEL with Strong: ' num2str(strong(s)) ' and Weak: ' num2str(weak(w))]);
                    irregularities{end+1} = struct('Strong',strong(s), 'Weak', weak(w), 'Type', 'unsel');
                end
                
            end
        end
    end
end