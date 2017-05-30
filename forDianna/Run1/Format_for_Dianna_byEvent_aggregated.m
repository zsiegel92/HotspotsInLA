% load('driving_crimes_by_division.mat');
% load('binClarity.mat');
% binClarity = binClarity';

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
aggregateBy = 7; %Number of days over which to aggregate heat scores

eventsPerDay = 12; %Number of events per time-step considered

for i = 1:21
   disp(['Division ', num2str(i),': ',divNames{i}]);
   disp('Reading Raw Output')
    %% Reading predictions
    filename1 = ['Predpol/output_310_320_330_331/output_raw/predpol_predicted_LACITY_',divNames{i},'.csv'];
    
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
    filename2 = ['Predpol/input_310_320_330_331/',num2str(i),divNames{i},'.csv'];
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
    
    disp('Aggregating')
    %% Aggregating
    agPreds = zeros(size(preds,1),floor(size(preds,2)/aggregateBy));
    agDates = cell(1,floor(size(dates,2)/aggregateBy));
    
    for j = 1:size(agPreds,2)
        agDates{j} = [dates{(j-1)*aggregateBy+1},'--',dates{j*aggregateBy}];
        agPreds(:,j) = sum(preds(:,((j-1)*aggregateBy+1):j*aggregateBy),2);
    end
    preds = agPreds;
    dates = agDates;
    clear agPreds agDates;
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
    filename2 = ['DataForDianna/event_list_aggregated/events_',divNames{i},'_per',num2str(aggregateBy),'days.csv'];
    
    header = {'Date','Bin_Number','Ranking','Latitude','Longitude'};
    headspec = '%s,%s,%s,%s,%s\n';
    bodyspec = '%s,%d,%d,%d,%d\n';
    events = events';
    fid = fopen(filename2,'w');
    fprintf(fid,headspec,header{1,1:end});
    fprintf(fid,bodyspec,events{:,:});
    fclose(fid);
    

end