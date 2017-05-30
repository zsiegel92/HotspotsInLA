load('loaded_arrests.mat');
load('ranking_spacetime_guide.mat');

%% Clearing arrests without coordinates
arrests(badcoords,:)=[];
coords(badcoords,:)=[];
% clear badcoords;

%% Converting dates to date numbers
arrDates = arrests(:,1);
arrDates = cellfun(@(x) x(1:10),arrDates,'UniformOutput',0);
arrDates = datenum(arrDates,'mm/dd/yyyy');

rank_dates = datenum(dates,'yyyy-mm-dd');
clear dates;


%% Clearing hotspot rankings and arrests for dates on which BOTH are not available

firstArrest = min(arrDates);
lastArrest = max(arrDates);

firstRanked = min(rank_dates);
lastRanked = max(rank_dates);

rankTooEarly = find(rank_dates < max(firstRanked,firstArrest));
rankTooLate = find(rank_dates > min(lastRanked,lastArrest));

arrTooEarly = find(arrDates < max(firstRanked,firstArrest));
arrTooLate = find(arrDates > min(lastRanked,lastArrest));

for i = 1:21
    rankingsByDivision{i}(:,[rankTooEarly;rankTooLate])=[];
end

rank_dates([rankTooEarly;rankTooLate])=[];

arrests([arrTooEarly;arrTooLate],:)=[];
arrDates([arrTooEarly;arrTooLate])=[];
coords([arrTooEarly;arrTooLate],:) = [];

clear firstArrest lastArrest firstRanked lastRanked rankTooEarly rankTooLate arrTooEarly arrTooLate

%% Loading bin coordinates
binCoords = [binClarity{:,2};binClarity{:,3}]';




%% Only including certain crimes (commented out - looking at all crimes
%QOL_specCharges = {}; %FIGURE THIS OUT
%serious_specCharges = {}; %FIGURE THIS OUT
% specCharges = {'a123', '2345', 'cda346'};%eg
%specCharges = QOL_specCharges;
%speCharges = serious_specCharges;
% specified_arrests = divide_by_charge_2plus(arrests,specCharges);

specified_arrests = arrests;

clear arrests;


%% Dividing by division
%{
Divisions:
1 = Central
2 = Rampart
3 = Southwest
4 = Hollenbeck
5 = Harbor
6 = Hollywood
7 = Wilshire
8 = West LA
9 = Van Nuys
10 = West Valley
11 = Northeast
12 = 77th Street
13 = Newton
14 = Pacific
15 = N Hollywood
16 = Foothill
17 = Devonshire
18 = Southeast
19 = Mission
20 = Olympic
21 = Topanga
%}
[specified_arrests_by_division,coordsByDiv,arrDatesByDiv] = divide_by_div_2plus(specified_arrests,coords,arrDates);
clear specified_arrests arrDates coords;

%% Finding Closest Hotspot at various specificities
%Read "heat" CSVs, create copies with only 2015

%read those CSVs into an array with bin number

%re-generate or load bin gridlats and gridlons from Predpol

%for each crime, compare its lat-lon to each day's ranked crimes and
%generate the distance to each in an array within a for-loop iterating
%through all the arrests

%in same for loop, take the minimum distance hotspot of the first k% of the
%ranked hotspots for k = 1, 2, 3, 4, ..., 15, yielding, for each crime,
%fifteen bin distances, many of which will be the same.
%

%copy these closeness rankings into a separate .mat file with minimal
%information regarding each crime - otherwise it will take too long to
%load.
minK = 1;
maxK = 25;
kValues = minK:maxK;


closestRealDist = cell(21,1);
closestToWhich = cell(21,1);

for i = 1:21 %each division
    disp(i);
    arrDates =arrDatesByDiv{i};
    arrCoords = coordsByDiv{i};
    
    arrDates = arrayfun(@(x) find(rank_dates==x,1),arrDates); %turn arrDates into indices in rank_dates (and rankingsByDivision{i})
    
    
    closestRealDist{i}= zeros(size(specified_arrests_by_division{i},1),length(kValues));
    closestToWhich{i} = zeros(size(specified_arrests_by_division{i},1),length(kValues));
    
    rankings = rankingsByDivision{i}(1:maxK,:);
    
    
    %FIGURE OUT WHICH DATE ARREST WAS MADE AT AND WHAT RANKINGS WERE
    for j = 1:size(specified_arrests_by_division{i},1) %iterate through each arrest
        
        %For each arrest, find the coordinates of the top ranked cells on its given day
        topBinsAtArrest = rankings(:,arrDates(j));
        topBinsAtArrest(topBinsAtArrest==0)=[];
        
        rankedLats = cell2mat(binClarity(topBinsAtArrest,2));
        rankedLons = cell2mat(binClarity(topBinsAtArrest,3));
        
        [arcLens,~] = distance(rankedLats,rankedLons,repmat(arrCoords(j,1),length(topBinsAtArrest),1),repmat(arrCoords(j,2),length(topBinsAtArrest),1),'degrees');
        arcLens = arcLens* (2*pi*3959*1.6/360); %Distance in Kilometers from the nearest of the top kValues bins!
        closestRealDist{i}(j,:) = arrayfun(@(x)min(arcLens(1:min(x,length(arcLens)))),kValues)'; %the i'th entry (runs from 1:max(kValues) of closestRealDist{i}(j,:)
        %is the minimum of arcLens(1:min(i,length(arcLens)),
        %meaning if there are fewer than max(kValues) ranked/nonzero bins
        %on that day, the minimum-distanced among the first i of them is
        %taken unless i is greater than the number of ranked bins, in which
        %case the minimum distanced of them all is taken.
        
        [~,closestToWhich{i}(j,1:length(arcLens))] = sort(arcLens);
        
    end
end

clear binCoords arrCoords rank_dates arrDates ans arcLens closestDist coords dists f i j l maxK  minK rankedLats rankedLons rankings topBinsAtArrest;
% save('minDistFromTopK.mat');



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
