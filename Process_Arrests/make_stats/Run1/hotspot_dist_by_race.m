load('minDistFromTopK_remBadgeocode_descentCompress.mat')
load('Crime_stats_by_Division.mat'); %in 'Process_Reports/create_stats_to_compare/processDump'
% descent_codes = unique(cell2mat(arrayfun(@(l) cell2mat(unique(specified_arrests_by_division_race{l}(:,9))'),(1:21),'UniformOutput',0)));
descent_codes = 'BWHO';
avgDists = cell(21,1);

for l = 1:21
    avgDists{l} = zeros(length(descent_codes),length(kValues));
    descents = specified_arrests_by_division_race{l}(:,9);
    descents = [descents{:}]';
    for j = 1:length(descent_codes)
        arrests_by_race = find(descents==descent_codes(j));
        avgDists{l}(j,:) = mean(closestRealDist{l}(arrests_by_race,:));
    end
end
clear descents arrests_by_race;


%% Count Number of Arrests with Each Descent Code
%Count number of arrests with each descent code

descent_codes_counter_by_division = zeros(21,length(descent_codes));

for l = 1:21
    descs = cell2mat(specified_arrests_by_division_race{l}(:,9));
    descent_codes_counter_by_division(l,:) = arrayfun(@(j) nnz(descs == descent_codes(j)),(1:length(descent_codes)));
end
clear descs;

%% Printing (with only realistic K values)
descent_code_translations = struct();
descent_code_translations.O = 'Other';
descent_code_translations.B = 'Black';
descent_code_translations.W = 'White';
descent_code_translations.H = 'Hispanic';
% getfield(descent_code_translations,descent_codes(j)

printKValues = 4:25;
linespec = ['%s',repmat(',%d',1,length(printKValues)),'\n'];

filename = '2015_Distance_from_Hotspots_byRace_withStats.csv';
fid = fopen(filename,'w');

fprintf(fid,'%s\n','Average Distance from Nearest "Hotspot" vs Race');
fprintf(fid,'%s\n','Year: 2015; Units: kilometers');
fprintf(fid,'%s\n','');
for l = 1:21
    disp(l)
    totNumArrests = num2str(size(specified_arrests_by_division_race{l},1));
    
    divInfo = {[divNames{l}, ': Division ', num2str(l)],['Total 2015 Arrests: ', totNumArrests],['Total 2015 Reports: ',num2str(tot2015Reports_byDivision(l))],['Total 2015 Predpol-Driving Reports: ',num2str(tot2015PredpolReports_byDivision(l))]};
    fprintf(fid,'%s\n',divInfo{1,:});
    line = ['Number of "hotspots":',num2cell(printKValues)];
    fprintf(fid,linespec,line{1,:});
    for j = 1:length(descent_codes)
        lineFront = [getfield(descent_code_translations,descent_codes(j)),' (',num2str(descent_codes_counter_by_division(l,j)),' arrests)']; %e.g. 'Black (8650 arrests)'
        line =[lineFront,num2cell(avgDists{l}(j,printKValues))];
        fprintf(fid,linespec,line{1,:}); 
    end 
    fprintf(fid,'%s\n','');
end
fclose(fid);