% load('driving_crimes_by_division.mat');
% load('binClarity.mat');
% binClarity = binClarity';
folderNames = {'forDianna','forDianna/DataForDianna','forDianna/DataForDianna/Run2','forDianna/DataForDianna/Run2/event_list'};
for i = 1:length(folderNames)
    if ~exist(folderNames{i},'dir')
        mkdir(folderNames{i});
        addpath(folderNames{i});
    end
end
writeDir ='forDianna/DataForDianna/Run2/event_list';
%% Creating "coordinate_info.mat"
%  load('driving_crimes_by_division.mat');
%  load('binClarity.mat');
%  clear driving_crimes_by_division;
%  save('coordinate_info.mat');
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
19 = Mission
20 = Olympic
21 = Topanga
%}
divNames = {'Central','Rampart','Southwest','Hollenbeck','Harbor','Hollywood','Wilshire','West_LA','Van_Nuys','West_Valley','Northeast','77th_Street','Newton','Pacific','N_Hollywood','Foothill','Devonshire','Southeast','Mission','Olympic','Topanga'};


eventsPerDay = 12;
for i = 1:21
   disp(['Division ', num2str(i),': ',divNames{i}]);
   disp('Reading Raw Output')
    %% Reading predictions
    filename1 = ['Predpol_UPDATED/output/predpol_predicted_LACITY_',divNames{i},'.csv'];
    
    preds = sparse(csvread(filename1,1,0)); %Skip 1 row
    numCols = size(preds,2);
    
    %% Reading header ('bin' and dates)
    fid = fopen(filename1);
    dates = textscan(fid,'%s',numCols,'Delimiter',',');
    fclose(fid);
    dates = dates{1}(2:end);
    dates = dates';
    
    binNums = preds(:,1);
    preds = preds(:,2:end);
    
    
    
    disp('Simplifying Output')
    %% Reading which bins are actually used in reports
    filename2 = ['Predpol_UPDATED/input/',num2str(i),divNames{i},'.csv'];
    fid = fopen(filename2);
    reps = textscan(fid,'%*s %d %*D %*d','Delimiter',',','headerLines', 1);
    fclose(fid);
    usedBins = sort(unique(reps{1}));
    clear reps;
    
    
    %% Only include bins that are used.
    preds = preds(usedBins,:);
    %binNums = binNums(usedBins);
    clear binNums
    
    usedBins = double(usedBins);
    
    disp('Building Events list')
    %% Capturing eventsPerDay events per day
    %Columns are DATE, BIN#, ranking on that day, Lat, Lon, 
    events = cell(eventsPerDay*size(preds,2),5);
    
    for j = 1:size(preds,2)
        [~,ranking] = sort(preds(:,j),'descend');
        ranking = usedBins(ranking(1:eventsPerDay));
        events(((j-1)*eventsPerDay+1):(j*(eventsPerDay)),:) = [repmat(dates(j),eventsPerDay,1),num2cell(ranking),num2cell((1:eventsPerDay)'),binClarity(ranking,2:3)];
    end
    
    disp('Writing to file')
    %% Writing Events
    filename2 = [writeDir, '/events_',divNames{i},'.csv'];
    
    header = {'Date','Bin_Number','Ranking','Latitude','Longitude'};
    headspec = '%s,%s,%s,%s,%s\n';
    bodyspec = '%s,%d,%d,%d,%d\n';
    events = events';
    fid = fopen(filename2,'w');
    fprintf(fid,headspec,header{1,1:end});
    fprintf(fid,bodyspec,events{:,:});
    fclose(fid);
    

end