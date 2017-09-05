function standards = read_standard_data_Ndimensions(tabdelimitedtextname)


output = read_tab_delimited_file(tabdelimitedtextname);
 % first let's read in the temperatures from these plates

T = [];

t_end = [];

for i=4:length(output)
       T(end+1) = (output{i}{1});  % took out str2num, not necessary, data are already numbers
    %if ((output{i+1}{1})==T(1))&&(~(i==4))
    if i>4&(T(end)<T(end-1)),
        s=i-1; %second dimension index
        t_end = length(T)-1;
        break;
    end;
end
mystructarray = struct('strain','','plate','','mutation','','data','');

mystructarray = mystructarray([]);

 % loop over columns of the output matrix

for i=2:length(output{1})
   if isnumeric(output{1}{i}), output{1}{i} = num2str(output{1}{i}); end;
   if isnumeric(output{3}{i}), output{3}{i} = num2str(output{3}{i}); end;
   if isnumeric(output{2}{i}), output{2}{i} = num2str(output{2}{i}); end;

   if ~isempty(strtrim(output{1}{i})), %removes whitespace
               platevalue = strtrim(output{1}{i});
               strainvalue = strtrim(output{3}{i});
               mutationinfovalue = strtrim(output{2}{i});% QUESTION:do I need to change this to i+1, the first column is temperatures
                                                         % Nope, but you're right, there is a small problem here; the solution is
                                                         % that we need to start the for loop at i = 2 to avoid the first column
               mydatafirstdim = [];
               mydatasecdim=[];
               
               for j=4:s  % this should be length(output), my error I think
                       mydatafirstdim(end+1) = (output{j}{i});%QUESTION: do I need to additionally remove any white space with strtrim, or is this done for me with str2
               end;
               for k=(s+1):length(output)
                       mydatasecdim(end+1)=(output{k}{i});
               end
               % is this a replicate of a standard we already know about?
               % or, is it a new standard?

               foundIt = 0;
               for j=1:length(mystructarray)
                       if strcmp(mystructarray(j).mutation,mutationinfovalue)&&strcmp(mystructarray(j).plate,platevalue),
                       foundIt = j;
                       end;
               end;
               if foundIt>0,
                       mystructarray(foundIt).data{end+1} = [T(1:t_end) ; mydatafirstdim; mydatasecdim];
               else
                       mynewstructure.strain = strainvalue;
                       mynewstructure.plate = platevalue;
                       mynewstructure.mutation = mutationinfovalue;
                       mynewstructure.data = { [T(1:t_end) ; mydatafirstdim; mydatasecdim] };
                       mystructarray(end+1) = mynewstructure;
               end;
       end;
end;
% at the end of this , will the functions standars output mynewstructure
% yes, we'll need to set standards to mystructarray
standards = mystructarray;
