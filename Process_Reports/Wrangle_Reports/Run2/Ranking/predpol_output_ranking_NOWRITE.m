%  load('Process_Reports/Mat_Files/Run2/driving_crimes_by_division.mat');
%  load('Process_Reports/Mat_Files/Run2/binClarity.mat');

%% Creating "coordinate_info.mat"
%  load('driving_crimes_by_division.mat');
%  load('binClarity.mat');
%  clear driving_crimes_by_division;
%  save('Process_Reports/Mat_Files/Run2/coordinate_info.mat');
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
rankingsByDivision = cell(size(divNames));
for i = 1:21
    disp([num2str(i),': ', divNames{i}])
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
    preds = [usedBins,full(preds)];

    
    %% Ranking top bins on each day
    rankings = zeros(size(preds,1),size(preds,2)-1);
    for j = 2:size(preds,2)
        [~,ranking] = sort(preds(:,j));
        ranking = ranking(end:-1:1);
        ranking = ranking(find(ismember(ranking,find(preds(:,j)))));
        ranking = usedBins(ranking);
        rankings(1:length(ranking),j-1)=ranking;
    end
    rankings((sum(abs(rankings),2)==0),:)=[];
    
    rankingsByDivision{i} = rankings;

end
% rankingsByDivision{1}(:,1) = []; %For some reason, Central's dates include 7/01/2012, but all others do not. 
binClarity = binClarity';
save('Process_Reports/Mat_Files/Run2/ranking_spacetime_guide.mat','binClarity','binLabels','dates','divNames','drivers','gridlats','gridlons','rankingsByDivision');