load allvariables_division_breakdown.mat
%  load('allvariables_division_breakdown.mat') %DEPRACATE

%  load('driving_crimes_by_division.mat'); %DEPRACATE

divNames = {'Central','Rampart','Southwest','Hollenbeck','Harbor','Hollywood','Wilshire','West_LA','Van_Nuys','West_Valley','Northeast','77th_Street','Newton','Pacific','N_Hollywood','Foothill','Devonshire','Southeast','Mission','Olympic','Topanga'};



[binlats,binlons]=find(binLabels);

binClarity = cell(length(binlats),6);

numCrimesTotal = bins(find(binLabels));

for i = 1:length(binlats)
    binClarity{i,1}=binLabels(binlats(i),binlons(i));
    binClarity{i,2}=gridlats(binlats(i));
    binClarity{i,3}=gridlons(binlons(i));
    binClarity{i,4} = divNames{binDivisions(binlats(i),binlons(i))};
    binClarity{i,5} = binDivisions(binlats(i),binlons(i));
    binClarity{i,6} = regexprep(binPlaceNames{binlats(i),binlons(i)},' +',' ');
    binClarity{i,7}=numCrimesTotal(i);
end


% csvwrite('bin_coordinates_withDivision.csv',binClarity);

%MANUALLY ADD HEADER:
%Bin Number, Latitude (SW corner), Longitude (SW corner), Total Reports
%2012-2015

% binClarityCell = num2cell(binClarity);
% divisions = binClarity(:,4);
%
% divisions = cellfun(@(x)divNames{x},divisions,'UniformOutput',0);
% binClarityCell(:,4)=divisions;

formatspec = '%d,%d,%d,%s,%d,%s,%d\n';

formatspecHead = '%s,%s,%s,%s,%s,%s,%s\n';
header = {'Bin Number','Latitude (SW corner)','Longitude (SW corner)','Division Name','Division Number','Address','Total Reports 2012-2015'};
filename = 'bin_coordinates_withAddress.csv';

binClarity = binClarity';

fid = fopen(filename,'w');

fprintf(fid,formatspecHead,header{1,1:end});
fprintf(fid,formatspec,binClarity{:,:});

fclose(fid);

save('binClarity.mat','binClarity');