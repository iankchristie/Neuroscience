function [normstandards, noisynormstandards, standards, noiseTB,noiseBovis,noiseAfricanum] = noise_analysis(filename,numrep)
standards=read_standard_data(filename);
% in speciesindex, cell 1=TB, cell 2=Bovis, cell 3=Africanum, Microti
% cell 4= NTM

speciesindex={};

for j=1:length(standards)
    if findstr('tuberculosis',lower(standards(j).strain))
        speciesindex{1}=[];
        speciesindex{1}=[speciesindex{1};j];
    elseif findstr('bovis', lower(standards(j).strain))
        speciesindex{2}=[];
        speciesindex{2}=[speciesindex{2};j];
    elseif findstr('africanum',lower(standards(j).strain))
        speciesindex{3}=[];
        speciesindex{3}=[speciesindex{3};j];
    elseif findstr('microti', lower(standards(j).strain))
        speciesindex{3}=[speciesindex{3};j];
    else
        speciesindex{4}=[];
        speciesindex{4}=[speciesindex{4};j];
    end
end
noisy_standards = struct('strain','','plate','','mutation','','data','');

noisy_standards = noisy_standards([]);

for k=1:length(speciesindex)
    if ~isempty(speciesindex{k})
        noisecluster=noise_cluster(standards(speciesindex{k}(1)),numrep);
        noisy_standards(end+1) = noisecluster;
    end
end
noisynormstandards=interp_normalize_deriv(noisy_standards);
normstandards=interp_normalize_deriv(standards);



[performance actvsclass errormatrix]=check_classifier(normstandards, noisynormstandards,'classify_melt_curve');
keyboard;
h=probability_classification(actvsclass,normstandards,noisynormstandards);
