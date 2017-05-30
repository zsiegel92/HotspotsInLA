clear all
load('minDistFromTopK_remBadgeocode_descentCompress.mat');

datacleaned = 1;

%% Remove Incorrectly Geocoded Points:
%{
Longest Distances (diameters) of districts:
Van Nuys: approx 9.334 km
West_LA: approx 19 mi
%}
if (datacleaned == 0)
    numPoorlyGeocoded = zeros(21,1);
    cutoffStds = 2;
    for l = 1:21
        cutoffDist = mean(closestRealDist{l}(:,length(kValues))) + cutoffStds*std(closestRealDist{l}(:,length(kValues))); %cutoff distance is cutoffStds standard deviations from the mean distance from closest hotspot when there are max(kValues) hotspots!
        numPoorlyGeocoded(l) = length(find(closestRealDist{l}(:,length(kValues))>cutoffDist)); %If a crime is >cutoffDist km from ALL OF THE 25 TOP-RANKED CELLS, it is probably poorly geocoded.
        disp([num2str(numPoorlyGeocoded(l)),' poorly geocoded in ', divNames{l}, ' Division, with cutoff ', num2str(cutoffDist), ' km'])
    end
    
    for l = 1:21
        cutoffDist = mean(closestRealDist{l}(:,length(kValues))) + cutoffStds*std(closestRealDist{l}(:,length(kValues)));
        badlyGeocoded = find(closestRealDist{l}(:,1)>cutoffDist);
        
        coordsByDiv{l}(badlyGeocoded,:)=[];
        specified_arrests_by_division{l}(badlyGeocoded,:)=[];
        closestRealDist{l}(badlyGeocoded,:)=[];
        closestToWhich{l}(badlyGeocoded,:)=[];
    end
end


%% Plot weird curve
f = figure;
for l = 1:21
    subplot(3,7,l);
    %     plot(kValues,sum(closestRealDist{l},1)/size(closestRealDist{l},1))
    errorbar(kValues,mean(closestRealDist{l},1),std(closestRealDist{l},0,1));
    %     boxplot(closestRealDist{1},kValues,'OutlierSize',1); %good!
    %Just remove extreme outliers and don't show outliers either and control s.t. the x ticks are kValues
    title(divNames{l});
    xlabel('# Cells Flagged');
    ylabel('Avg Dist to Closest Flagged Cell');
end

