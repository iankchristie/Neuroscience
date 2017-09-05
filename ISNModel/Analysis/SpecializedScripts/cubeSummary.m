S = 2:20;
W = 1:19;

cubesSummary = cell(length(S), length(W));

for a = 1: length(S),
    for o = 1: length(W),
        if S(a) > W(o),
            summary = struct('S', S(a), 'W', W(o), 'DS',0,'DSSupress',0,'Uni',0,...
                             'UniSupr',0,'BlowsUp', 0,'Oscillates',0, 'BlowsUpOscillates', 0);
            clear cube;
            disp('Working On');
            load(sprintf('/home/iankc/data115/S%dW%d/Cube.mat', S(a), W(o)));
            [n, m, l] = size(cube);
            for i = 1: n
                for j = 1: m
                    for k = 1:l
                        if strcmp(cube{i,j,k}.Response, 'DS'),
                            summary.DS = 1;
                        elseif strcmp(cube{i,j,k}.Response, 'DSSupress'),
                            summary.DSSupress = 1;
                        elseif strcmp(cube{i,j,k}.Response, 'Uni'),
                            summary.Uni = 1;
                        elseif strcmp(cube{i,j,k}.Response, 'UniSupr'),
                            summary.UniSupr = 1;
                        elseif strcmp(cube{i,j,k}.Response, 'BlowsUp'),
                            summary.BlowsUp = 1;
                        elseif strcmp(cube{i,j,k}.Response, 'Oscillates'),
                            summary.Oscillates = 1;
                        elseif strcmp(cube{i,j,k}.Response, 'BlowsUpOscillates'),
                            summary.BlowsUpOscillates = 1;
                        end
                    end
                end
            end
            cubesSummary{S(a), W(o)} = summary;
        end
    end
end
save('/home/iankc/data115/cubesSummary.mat', 'cubesSummary');