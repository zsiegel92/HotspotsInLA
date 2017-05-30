%  load('minDistFromTopK_remBadgeocode_descentCompress.mat')
%  load('ranking_spacetime_guide.mat');

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
colors = rand(21,3);
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
    plot(points(outline,1),points(outline,2),'DisplayName',divNames{l},'Color', colors(l,:));
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

%% Sort arrest dates
rankDateNums = datenum(dates);

uniqueDates = [];
divArrDates=cell(21,1);
for l=1:21
    divArrDates{l} = specified_arrests_by_division_race{l}(:,1);
    divArrDates{l} = cellfun(@(x) x(1:10),divArrDates{l},'UniformOutput',0);
    divArrDates{l} = datenum(divArrDates{l});
    uniqueDates = sort(unique([uniqueDates;unique(divArrDates{l})]));
end

%% Scatter Hotspots

% descent_code_translations = struct();
% descent_code_translations.O = 'Other';
% descent_code_translations.B = 'Black';
% descent_code_translations.W = 'White';
% descent_code_translations.H = 'Hispanic';



scats = cell(21,1);
j = 50;%day 50   - there are 335 arrest dates!
numFlagged = 10;
for l = 1:21
    hotBins = rankingsByDivision{l}(:,find(rankDateNums==uniqueDates(j),1));
    hotBins = hotBins(hotBins~=0);
    hotCoords = cell2mat(binClarity(hotBins,[2,3]));
    
        scats{l} = scatter(hotCoords(1:numFlagged,2),hotCoords(1:numFlagged,1),linspace(100,10,numFlagged),'MarkerEdgeColor', colors(l,:),'DisplayName',divNames{l});

end
legend([scats{:}],divNames);
title(['Hotspots on: ', datestr(uniqueDates(j))])
hold off

%
%

% %% Print Borders
fig = gcf;
fig.Units = 'inches';
fig.Position = [0,0,50,50];
fig.PaperUnits = 'inches';
fig.PaperPosition = [0,0,40,40];
fig.PaperSize = [50,50];
 print(['Divisions_Outlined_withHotspots_day_',datestr(uniqueDates(j))],'-dpdf','-r0');


divNames = cellfun(@(x) strrep(x,' ','_'),divNames,'UniformOutput',0);