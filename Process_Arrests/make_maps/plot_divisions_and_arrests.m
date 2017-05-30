 load('minDistFromTopK_remBadgeocode_descentCompress.mat')
 load('ranking_spacetime_guide.mat');

%% OUTLINE
%{
1. Filter the hotspot rankings by date, to only observe 2015 hotspots
2. Plot each day's hotspots on map with a slider
3. Plot each day's arrests on map.
4. Plot something to do with race on map.

%}



divNames = cellfun(@(x) strrep(x,'_',' '),divNames,'UniformOutput',0); %UNDO at end of code

% scatter(cell2mat(binClarity(:,3)),cell2mat(binClarity(:,2)),[],cell2mat(binClarity(:,5)),'filled'); %scatter(x,y,sz,c) <- division number is color
% legend(divNames)

%% Trace Division Boundaries

for l = 1:21
    divCells = find(cell2mat(binClarity(:,5))==l);
    points = cell2mat(binClarity(divCells,[3,2]));
    centroids = mean(cell2mat(binClarity(divCells,[3,2])),1);
    displacements = ((points(:,1) - centroids(1)).^2+(points(:,2)-centroids(2)).^2).^.5;
    [displacements,id] = sort(displacements);
    points = points(id,:);
    
    s = std(displacements(1:floor(0.9*length(displacements))));
    
    
    points = points(find(displacements<4.5*s),:);
    
    
    outline = boundary(points);
    plot(points(outline,1),points(outline,2),'DisplayName',divNames{l});
% plot(points(outline,1),points(outline,2));
    hold on
end
% Plot Division Name Text
for l = 1:21
    divCells = find(cell2mat(binClarity(:,5))==l);
    centroids = mean(cell2mat(binClarity(divCells,[3,2])),1);
    text(centroids(1),centroids(2),divNames{l})
end
% legend('show')



%% Scatter Arrests color-coded by race

descent_code_translations = struct();
descent_code_translations.O = 'Other';
descent_code_translations.B = 'Black';
descent_code_translations.W = 'White';
descent_code_translations.H = 'Hispanic';

colors = rand(length(relevantDescents),3);
rankDateNums = datenum(dates);

uniqueDates = [];
divArrDates=cell(21,1);
for l=1:21
    divArrDates{l} = specified_arrests_by_division_race{l}(:,1);
    divArrDates{l} = cellfun(@(x) x(1:10),divArrDates{l},'UniformOutput',0);
    divArrDates{l} = datenum(divArrDates{l});
    uniqueDates = sort(unique([uniqueDates;unique(divArrDates{l})]));
end

scats = cell(size(relevantDescents));
j = 50;%day 50   - there are 335 arrest dates!
for l = 1:21
    races = cell2mat(specified_arrests_by_division_race{l}(:,9));
    races = arrayfun(@(x) find(relevantDescents == x,1),races);
    raceInds = cellfun(@(x) races==x,{1,2,3,4},'UniformOutput',0);
    

    indsOfDate = (divArrDates{l}==uniqueDates(j));
    
    coords = coordsByDiv{l}(:,[2,1]); %[lon,lat] for plotting
    
    for k = 1:length(relevantDescents)
        inds = find(raceInds{k}.*indsOfDate);
        scats{k} = scatter (coords(inds,1),coords(inds,2),[],'MarkerEdgeColor', colors(k,:),'DisplayName',relevantDescents(k));
    end
end
legend([scats{:}],arrayfun(@(x) getfield(descent_code_translations,x),relevantDescents,'UniformOutput',0));
title(['Arrests on: ', datestr(uniqueDates(j))])
hold off

%
%
% % Print Borders
fig = gcf;
fig.Units = 'inches';
fig.Position = [0,0,50,50];
fig.PaperUnits = 'inches';
fig.PaperPosition = [0,0,40,40];
fig.PaperSize = [50,50];
print(['Divisions_Outlined_withArrests_day_',datestr(uniqueDates(j))],'-dpdf','-r0');


divNames = cellfun(@(x) strrep(x,' ','_'),divNames,'UniformOutput',0);