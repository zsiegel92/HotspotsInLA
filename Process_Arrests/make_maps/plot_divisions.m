% load('ranking_spacetime_guide.mat');
divNames = cellfun(@(x) strrep(x,'_',' '),divNames,'UniformOutput',0); %UNDO at end of code

% scatter(cell2mat(binClarity(:,3)),cell2mat(binClarity(:,2)),[],cell2mat(binClarity(:,5)),'filled'); %scatter(x,y,sz,c) <- division number is color
% legend(divNames)


%% Scatter Bins as Points
colors = rand(21,3);
for l = 1:21
    divCells = find(cell2mat(binClarity(:,5))==l);
    scatter(cell2mat(binClarity(divCells,3)),cell2mat(binClarity(divCells,2)),'DisplayName',divNames{l}, 'MarkerEdgeColor', colors(l,:)); %scatter(x,y,sz,c) <- division number is color
    hold on
end
% Plot Division Name Text
for l = 1:21
    divCells = find(cell2mat(binClarity(:,5))==l);
    centroids = mean(cell2mat(binClarity(divCells,[3,2])),1);
    text(centroids(1),centroids(2),divNames{l})
end
% Print Scatter
fig = gcf;
fig.Units = 'inches';
fig.Position = [0,0,50,50];
fig.PaperUnits = 'inches';
fig.PaperPosition = [0,0,40,40];
fig.PaperSize = [50,50];
print('BinsWithDivisionsMap','-dpdf','-r0');
% print('BinsWithDivisionsMap','-dbmp','-r0');
hold off
clf

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
    hold on
end
% Plot Division Name Text
for l = 1:21
    divCells = find(cell2mat(binClarity(:,5))==l);
    centroids = mean(cell2mat(binClarity(divCells,[3,2])),1);
    text(centroids(1),centroids(2),divNames{l})
end
legend('show')
% Print Borders
fig = gcf;
fig.Units = 'inches';
fig.Position = [0,0,50,50];
fig.PaperUnits = 'inches';
fig.PaperPosition = [0,0,40,40];
fig.PaperSize = [50,50];
print('Divisions_Outlined','-dpdf','-r0');
% print('BinsWithDivisionsMap','-dbmp','-r0');
hold off

divNames = cellfun(@(x) strrep(x,' ','_'),divNames,'UniformOutput',0);