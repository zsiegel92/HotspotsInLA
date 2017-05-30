% load('minDistFromTopK_remBadgeocode_descentCompress.mat')
% load('Crime_stats_by_Division.mat'); %in 'Process_Reports/create_stats_to_compare/processDump'
% load('binClarity.mat');
for D = [.25,.5,1,1.5]
    %% Finding percentage of arrests made within .5km of a hotspot by race
    descent_codes = 'BWHO';
    percentWithinD = cell(21,1);
    totPercentWithinD = cell(21,1);
    % D = .5;
    for l = 1:21
        totPercentWithinD{l} = sum((closestRealDist{l}<D),1)/size(closestRealDist{l},1);
        percentWithinD{l} = zeros(length(descent_codes),length(kValues));
        descents = specified_arrests_by_division_race{l}(:,9);
        descents = [descents{:}]';
        for j = 1:length(descent_codes)
            arrests_by_race = find(descents==descent_codes(j));
            percentWithinD{l}(j,:) = sum((closestRealDist{l}(arrests_by_race,:)<D),1)/sum((closestRealDist{l}<D),1);
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
    
    printKValues = 8:17;
    linespec = ['%s',repmat(',%d',1,length(printKValues)),'\n'];
    
    filename = ['externalStats/2015_percent_ofrace_within_',num2str(D),'km_distPredicated.csv'];
    fid = fopen(filename,'w');
    
    fprintf(fid,'%s\n',['Percent Arrests Within ', num2str(D),'km from Nearest "Hotspot" vs Race']);
    fprintf(fid,'%s\n',['Year: 2015; Units: % arrests within ',num2str(D), 'km of a HS that are of a given race']);
    fprintf(fid,'%s\n','');
    for l = 1:21
        totNumArrests = size(specified_arrests_by_division_race{l},1);
        
        divInfo = {[divNames{l}, ': Division ', num2str(l)],['Total 2015 Arrests: ', num2str(totNumArrests)],['Total 2015 Reports: ',num2str(tot2015Reports_byDivision(l))],['Total 2015 Predpol-Driving Reports: ',num2str(tot2015PredpolReports_byDivision(l))]};
        fprintf(fid,'%s\n',divInfo{1,:});
        line = ['Number of "hotspots":',num2cell(printKValues)];
        fprintf(fid,linespec,line{1,:});
        for j = 1:length(descent_codes)
            lineFront = [getfield(descent_code_translations,descent_codes(j)),' (',num2str(descent_codes_counter_by_division(l,j)),' arrests - ', num2str(descent_codes_counter_by_division(l,j)/totNumArrests), '% of tot)']; %e.g. 'Black (8650 arrests)'
            line =[lineFront,num2cell(percentWithinD{l}(j,printKValues))];
            fprintf(fid,linespec,line{1,:});
        end
        lineFront = ['Percent Total (', num2str(totNumArrests),') Within ',num2str(D),'km'];
        line =[lineFront,num2cell(totPercentWithinD{l}(printKValues))];
        fprintf(fid,linespec,line{1,:});
        fprintf(fid,'%s\n','');
    end
    fclose(fid);
    
end