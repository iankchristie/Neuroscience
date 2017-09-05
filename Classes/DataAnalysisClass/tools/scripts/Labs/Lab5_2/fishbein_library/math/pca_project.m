function signals = pca_project(data, pc, themean)

data = data - themean;
signals =  pc' * data; %for my weighted pca, something about the inner matrix dimensions is disagreeing; 
                        %i've checked that the data matrix is 44x1 and the pc matrix is 44x44

