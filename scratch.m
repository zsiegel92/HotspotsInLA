
%% Remove Incorrectly Geocoded Points:
%{
Longest Distances (diameters) of districts:
Van Nuys: approx 9.334 km
West_LA: approx 19 mi
%}

numPoorlyGeocoded = zeros(21,1);
cutoffStds = 2.5;


for l = 1:21
    
    cutoffDist = mean(closestRealDist{l}(:,length(kValues))) + cutoffStds*std(closestRealDist{l}(:,length(kValues))); %cutoff distance is cutoffStds standard deviations from the mean distance from closest hotspot when there are max(kValues) hotspots!
    
    numPoorlyGeocoded(l) = length(find(closestRealDist{l}(:,length(kValues))>cutoffDist)); %If a crime is >cutoffDist km from ALL OF THE 25 TOP-RANKED CELLS, it is probably poorly geocoded.
    disp([num2str(numPoorlyGeocoded(l)),' POSSIBLY poorly geocoded in ', divNames{l}, ' Division, with cutoff ', num2str(cutoffDist), ' km'])
    
    badlyGeocoded = find(closestRealDist{l}(:,length(kValues))>cutoffDist);
    
    cutoffDist = 0.2; %0.2 km
    cutoffNeighbors = 5; %if there are cutoffNeighbords other arrests within cutoffDist of an arrest, it is NOT poorly geocoded, but is probably just on a boundary of a division!
    pardoned = [];
    for j = 1:length(badlyGeocoded)
        distances = (2*pi*3959*1.6/360)*distance(coordsByDiv{l}(:,1),coordsByDiv{l}(:,2),coordsByDiv{l}(badlyGeocoded(j),1),coordsByDiv{l}(badlyGeocoded(j),2),'degrees');%Distance 
        %in Kilometers from each of the other arrests in the division!
        if (length(find(distances<cutoffDist))>cutoffNeighbors)
            pardoned = [pardoned,j];
        end
  
    end
    badlyGeocoded(pardoned)=[];
    disp([num2str(length(badlyGeocoded)),' PROBABLY poorly geocoded in ', divNames{l}, ' Division, (<', num2str(cutoffNeighbors), ' neighbors within ', num2str(cutoffDist), ' km)'])
    
    coordsByDiv{l}(badlyGeocoded,:)=[];
    arrDatesByDiv{l}(badlyGeocoded,:)=[];
    specified_arrests_by_division{l}(badlyGeocoded,:)=[];
    closestRealDist{l}(badlyGeocoded,:)=[];
    closestToWhich{l}(badlyGeocoded,:)=[];
end

clear l; clear badlyGeocoded; clear cutoffDist cutoffNeighbors; clear distances pardoned;

save('minDistFromTopK_rem_badgeocode.mat')
