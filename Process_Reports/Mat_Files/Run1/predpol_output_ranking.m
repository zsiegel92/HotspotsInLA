load('driving_crimes_by_division.mat');
load('binClarity.mat');

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

for i = 1:21
    
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
    preds = [usedBins,full(preds)];
    
    
    
    formatspec1 = repmat('%d,',1,numCols);
    formatspec1 = formatspec1(1:(end-1));
    formatspec1 = [formatspec1,'\n'];
    %     formatspecHead = repmat('%{yyyy-mm-dd}D,',1,length(dates));
    %     formatspecHead = ['%s,',formatspecHead(1:(end-1))];
    %     dates = [{'bin'},dates];
    formatspecHead = repmat('%s,',1,numCols);
    formatspecHead = formatspecHead(1:end-1);
    formatspecHead = [formatspecHead,'\n'];
    dates = [{'bin'},dates];
    
    
    %WRITING TO FILE
        filename3 = ['Predpol/output_310_320_330_331/reported_only/predpol_predicted_LACITY_',divNames{i},'_reportedbins.csv'];
        fid = fopen(filename3,'w');
    
        fprintf(fid,formatspecHead,dates{1,1:end});
    
        fprintf(fid,formatspec1,preds');
        fclose(fid);
    
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
    
    dates = dates(1,2:end); %remove 'bins'
    formatspecHead = repmat('%s,',1,length(dates));
    formatspecHead = [formatspecHead(1:end-1),'\n'];
    formatspecHead = ['%s,',formatspecHead];
    dates = [{'Daily_Rank'},dates];
    
    rankingsNames = cell(size(rankings));
    
    for j = 1:size(rankings,2)
        for k = 1:size(rankings,1)
            if (rankings(k,j)>0)
                rankingsNames{k,j}=strrep(binClarity{rankings(k,j),5},',',';');
            else
                rankingsNames{k,j}='xxxx';
            end
        end
    end
    binLabz = (1:size(rankings,1))';
    binLabz = num2cell(binLabz);
    binLabz = cellfun(@num2str,binLabz,'UniformOutput',0);
    rankingsNames = [binLabz,rankingsNames];
    
    rankingsNames=rankingsNames';
    
    rankings = [(1:size(rankings,1))',rankings]; %Include rank as a column
    
    %%WRITING RANKINGS WITH NAMES
    formatspec1 = repmat('%s,',1,size(rankings,2));
    formatspec1 = [formatspec1(1:end-1),'\n'];
    
%     filename4 = ['Predpol/output_310_320_330_331/rankings/ranked_with_names/predpol_predicted_LACITY_',divNames{i},'_rankedBins_locNames.csv'];
%     
%     fid = fopen(filename4,'w');
%     
%     fprintf(fid,formatspecHead,dates{1,1:end});
%     fprintf(fid,formatspec1,rankingsNames{:,:});
%     
%     fclose(fid);
    
    %WRITING RANKINGS WITHOUT NAMES
    formatspec1 = repmat('%d,',1,size(rankings,2));
    formatspec1 = [formatspec1(1:end-1),'\n'];
    
    filename4 = ['Predpol/output_310_320_330_331/rankings/rankedBIN_NUMBERS/predpol_predicted_LACITY_',divNames{i},'_rankedBins.csv'];
    
    fid = fopen(filename4,'w');
    
    fprintf(fid,formatspecHead,dates{1,1:end});
    fprintf(fid,formatspec1,rankings');
    
    fclose(fid);
end