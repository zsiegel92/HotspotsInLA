%Distance between
%(34.05079,-118.4684) & (34.05215,-118.4684)
%is 151.2m
%
%Distance between
%(34.05079,-118.4684) & (34.05079,-118.470029)
%is 150.1m
%distance(34.0508,-118.4701,34.05079,-118.4684) = .0014 (degrees of arc)
%
%USE:
%[latout,lonout] = reckon(lat,lon,arclen,az)
%[latout,lonout]=reckon(34.05079,-118.4684,.0013705,270) =
%[34.0508,-118.4701]


%[arclen,az] = distance(lat1,lon1,lat2,lon2)
%az
%Moving clockwise on a 360 degree circle,
%east has azimuth 90°, south 180°, and west 270°.
%
%0.0013705 is the number of degrees on the sphere corresponding to 500ft
%
%arclength (in meters) = (degrees/360)*2*pi*(3959*(1600))
%150.3563 (meters) = (.00136/360)*2*pi*(3959*(1600))

%% Loading Report Data
%   load('Uniquified_Definitions.mat')

% minlat = 33.3427;
% minlon =-118.8551;
% maxlat = 34.8087;
% maxlon = -117.6596;

%% Produce Grid Mesh
gridmesh = (150*360)/(2*pi*(3959*1600)); %.0014 arc-lengths ~ 150 m

gridlats = [];
gridlons = [];

lat = minlat;
while (lat <= maxlat)
    gridlats = [gridlats,lat];
    [lat,~] = reckon(lat,minlon,gridmesh,0);
end

lon = minlon;
while (lon <= maxlon)
    gridlons = [gridlons,lon];
    [~,lon] = reckon(minlat,lon,gridmesh,90);
end

%% Assigning Indices to Bins

bins = zeros(length(gridlats),length(gridlons));
binDivisions = zeros(size(bins));
binPlaceNames = cell(size(bins));
binYesCrossStreet = zeros(size(bins));
binAlreadyCrossStreet = zeros(size(bins));

badcoords = [badcoords,0];
binYesCrossStreet = cellfun(@isempty,reps(:,13));
binYesCrossStreet = (binYesCrossStreet==0);

badcoordIndex = 1;
for i = 1:size(coords,1)
    if (i ~= badcoords(badcoordIndex))
        latbin = nnz(gridlats<=coords(i,1));
        lonbin = nnz(gridlons<=coords(i,2));
        bins(latbin,lonbin)=bins(latbin,lonbin)+1;
        binDivisions(latbin,lonbin)= reps{i,5};
        
        if (binYesCrossStreet(i) && (binAlreadyCrossStreet(latbin,lonbin)==0))
            binAlreadyCrossStreet(latbin,lonbin) = 1;
            binPlaceNames{latbin,lonbin} = [reps{i,12},' & ', reps{i,13}];
        elseif (binAlreadyCrossStreet(latbin,lonbin) == 0)
            binPlaceNames{latbin,lonbin} = reps{i,12};%if any of the crimes
            %in the bin has a cross street, that is the preferred location specification.
        end
    else
        badcoordIndex = badcoordIndex+1;
    end
end

badcoords = badcoords(1:end-1);

[usedLats,usedLons]=find(bins);
usedBins = [usedLats,usedLons,bins(find(bins))]; %i'th row is i'th latitudinal bin index, i'th longitudinal bin index, total historical number of reports in that bin
usedBins = [usedBins,(1:size(usedBins,1))']; %Assign bin indices to used bins

%binLabels is a grid whose entries correspond to bins and are the indices of the bins.
binLabels = zeros(length(gridlats),length(gridlons));
for i = 1:size(usedBins,1)
    binLabels(usedBins(i,1),usedBins(i,2))=usedBins(i,4); %Insert bin indices into grid
end

%% Labeling Crimes with Bin Numbers
%crimeBins labels EACH crime with a bin number
crimeBins = zeros(size(coords,1),1);

badcoords = [badcoords,0];
badcoordIndex = 1;

for i = 1:size(coords,1)
    if (i ~= badcoords(badcoordIndex))
        latbin = nnz(gridlats<=coords(i,1));
        lonbin = nnz(gridlons<=coords(i,2));
        crimeBins(i) = binLabels(latbin,lonbin);
    else
        crimeBins(i) = 0;
        badcoordIndex = badcoordIndex+1;
    end
end
badcoords = badcoords(1:end-1);

reps = cat(2,reps,mat2cell(crimeBins,ones(size(crimeBins,1),1),1));

%% Divisions
reps(badcoords,:)=[];

reports_by_division = cell(21,1);
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
for i = 1:21
    reports_by_division{i} =reps(cellfun(@(x) (x==i),reps(:,5)),:);
end

save('division_breakdown.mat','reports_by_division','gridlats','gridlons','coords','binLabels','badcoords')
save('allvariables_division_breakdown.mat')