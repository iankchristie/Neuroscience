function Ndimstandards=add_dimension(standards)
   
    for i=1:length(standards)
        for j=1:length(standards(i).data)
            seconddim=zeros(size(standards(i).data{j}(2,:)));
            Ndimstandards(i).data{j}=[standards(i).data{j};seconddim];
        end
    end
