function standards = read_standard_raw_data(tabdelimitedtextname)


output = read_tab_delimited_file(tabdelimitedtextname);
 % first let's read in the temperatures from these plates

T = [];

for i=3:length(output)
       T(end+1) = (output{i}{1});  % took out str2num, not necessary, data are already numbers
end;

mystructarray = struct('strain','','plate','','replicate','','data','');

mystructarray = mystructarray([]);

 % obtain number of dimensions
 
N = 0;
firstentry = output{1}{1};
[firstplate, firstrepl, firstspecies, dye ] = extractsampleinfo( firstentry );

for i=1:length(output{1}),
    if ~isempty(strtrim(output{1}{i})),
        [newplate, newrepl, newspecies, dye ] = extractsampleinfo( strtrim(output{1}{i} ) );
        if strcmp(newplate,firstplate)&firstrepl==newrepl&strcmp(firstspecies,newspecies),
            N = N + 1;
        end;
    end;
end;

 % loop over columns of the output matrix
 

for i=1:2*N:length(output{1})
   if isnumeric(output{1}{i}), output{1}{i} = num2str(output{1}{i}); end;
   if isnumeric(output{2}{i}), output{2}{i} = num2str(output{2}{i}); end;
   
   if ~isempty(strtrim(output{1}{i})), %removes whitespace
               platevalue = tabdelimitedtextname;
               [newplate,replicatevalue,strainvalue,dye]=extractsampleinfo( strtrim(output{1}{i} ) );
               mydata = [];
               
               % add a for loop here that loops from 1:N that gets each
               % column; change this so mydata is 2 columns   
               for n=1:N,
                   for j=3:length(output)
                           mydata(n,j-2) = (output{j}{i-1+2*n});
                   end;
               end;
               % is this a replicate of a standard we already know about?
               % or, is it a new standard?
               foundIt = 0;
               for j=1:length(mystructarray)
                       if strcmp(mystructarray(j).strain,strainvalue)&&strcmp(mystructarray(j).plate,platevalue),
                       foundIt = j;
                       end;
               end;
               if foundIt>0,
                       mystructarray(foundIt).data{end+1} = [T ; mydata(1,:); mydata(2,:)];
               else
                       mynewstructure.strain = strainvalue;
                       mynewstructure.plate = platevalue;
                       mynewstructure.replicate = replicatevalue;
                       mynewstructure.data = { [T ; mydata(1,:); mydata(2,:)] };
                       mystructarray(end+1) = mynewstructure;
               end;
       end;
end;
% at the end of this , will the functions standars output mynewstructure
% yes, we'll need to set standards to mystructarray
standards = mystructarray;
