function [h,pc,v,themean] = plot_standard_pca(standards, colors, standard_number, standard_replicant)

 % first, interpret our inputs

colorlist = 'bgrcmyk'; % these are the defaults
pointlist = 'os^dos^';
if nargin>1 % if there are at least 2 inputs to the function`
        if ~isempty(colors) % and if the 'colors' argument is not empty
                colorlist = colors;  % we'll use the user's choice
        end;
end;

stand_nums = 1:length(standards); % these are standards to loop over
if nargin>2
        if ~isempty(standard_number)
                stand_nums = standard_number;
        end;
end;

  %
stand_repls = [];
if nargin>3
        if ~isempty(standard_replicate_number),
                stand_repls = standard_replicate_number;
        end;
end;

 % second, make a matrix of the mean values such that each column
 % is a mean vector of each standard

mn_list = [];

for k=1:length(standards),
	[T,mnf] = mean_standard(standards(k));
	mn_list = [mn_list mnf'];  % might need to be [mn_list; mnf];
end;

 % this calculates the principle components (the eigenvectors of covariance matrix)

global v;
[signals,pc,v,themean] = pca1(mn_list);

% third, now do actual plotting

h = [];
j=[];
for k=stand_nums

    col_number = 1+mod(k,length(colorlist));  % this line should output a number between 1 and length(colors)
    if isempty(stand_repls)
        stand_repl_loop = 1:length(standards(k).data);
    else
        stand_repl_loop = stand_repls;
    end;

    %if mode==2||mode==3  % maybe someday we'll plot the mean but not right now
    %    % we need to calculate the mean  --
    %    %%  lets add this next week, because there's a trick; we'll make calculating the mean its own function
    %    [T,mnf] = mean_standard(standards(k));
    %    h(end+1) = plot(T,mnf,colorlist(col_number),'linewidth',3);
    %end;

    for m=stand_repl_loop
        hold on;
	 % project onto the pca space
	pcaprojection= pca_project(standards(k).data{m}(2,:)', pc, themean);
	[pcaprojection(1) pcaprojection(2)];
        h(end+1) = plot(pcaprojection(1),pcaprojection(2),[ pointlist(col_number)  colorlist(col_number) ]);
        %text function added to analysis the clustering analysis
        j(end+1)=text(pcaprojection(1),pcaprojection(2),standards(k).strain);
        set(j, 'FontSize', 8);
        xlabel('PCA 1');
        ylabel('PCA 2');
    end

end
