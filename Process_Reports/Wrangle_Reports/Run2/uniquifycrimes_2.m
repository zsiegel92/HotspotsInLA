%uniquifycrimes
%load('reported_load.mat');

% mincrimecode = min(cell2mat(reps(:,8)));
% maxcrimecode = max(cell2mat(reps(:,8)));

[crimecodes,indexOfFirsts,translation] = unique(cell2mat(reps(:,8)));
[crimecodes,indices] = sort(crimecodes);
indexOfFirsts = indexOfFirsts(indices);
translation = arrayfun(@(x)indices(x),translation);

%{
  Note:
crimecodes(translation) == cell2mat(reps(:,8))
%and
crimecodes == reps(indexOfFirsts,8)
%}

% crimeNames = reps(indexOfFirsts,9);
crimeNames = cell(length(crimecodes),1);

for i = 1:length(crimecodes)
    crimeNames{i}=unique(reps(find(translation==i),9));
end
maxMultipleDefinitions = max(cellfun(@length,crimeNames));

for i = find(cellfun(@length,crimeNames)>1)'
        crimeNames{i,2} = crimeNames{i}(2);
        crimeNames{i,1} = crimeNames{i}(1);
end

numOccurrences = arrayfun(@(i) nnz(translation==i),1:length(crimecodes))';
[~,indices] = sort(numOccurrences);
indices = flip(indices);
numOccurrences_prevalence = numOccurrences(indices);
crimecodes_prevalence = crimecodes(indices);


for i = 1:size(crimeNames,1)
    crimeNames(i,1)=crimeNames{i,1};
    if (length(crimeNames{i,2})>0)
        crimeNames(i,2)=crimeNames{i,2};
    else
        crimeNames{i,2} = '';
    end
end
crimeNames_prevalence = crimeNames(indices',:);


code_desc_prevalence_byPrevalence = [num2cell(crimecodes_prevalence),crimeNames_prevalence,num2cell(numOccurrences_prevalence)];
code_desc_prevalance_byCode = [num2cell(crimecodes),crimeNames,num2cell(numOccurrences)];


filename = 'reported_info_by_Code.csv';
filename2 = 'reported_info_by_Prevalence.csv';
firstrow = {'Crime_Code', 'Crime_Name_1','Crime_Name_2','Number_Occurrences'};

fid = fopen(filename,'w');
fprintf(fid,'%s, %s,%s, %s\n',firstrow{1,:});
for i = 1:size(code_desc_prevalance_byCode,1)
    fprintf(fid,'%d,%s,%s,%d\n',code_desc_prevalance_byCode{i,:});
end
fclose(fid);

fid = fopen(filename2,'w');
fprintf(fid,'%s, %s,%s, %s\n',firstrow{1,:});
for i = 1:size(code_desc_prevalence_byPrevalence,1)
    fprintf(fid,'%d,%s,%s,%d\n',code_desc_prevalence_byPrevalence{i,:});
end
fclose(fid);



clear a
clear ans

clear code_desc_prevalence
clear coordi
clear coordstrings
clear fid
clear filename
clear filename2
clear firstrow
clear i
clear indexOfFirsts
clear indices
clear maxMultipleDefinitions

save('Uniquified_Definitions.mat')
