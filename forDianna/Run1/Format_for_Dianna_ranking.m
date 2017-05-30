
divNames = {'Central','Rampart','Southwest','Hollenbeck','Harbor','Hollywood','Wilshire','West_LA','Van_Nuys','West_Valley','Northeast','77th_Street','Newton','Pacific','N_Hollywood','Foothill','Devonshire','Southeast','Mission','Olympic','Topanga'};

for i = 1:21
    disp(['Division: ',num2str(i)]);
    load('/Users/Zach/Drive/Stop LAPD Spying/Predpol Project/Code/Process_Reports/Mat_Files/binClarity.mat')
    binClarity = binClarity';
    
    %% Reading predictions
    filename = ['predpol_predicted_LACITY_',divNames{i},'_reportedbins.csv'];
    preds = sparse(csvread(filename,1,0)); %Skip 1 row
    numCols = size(preds,2);
    
    
    %% Wrangling BinClarity
    
    formatspecBinClarity = '%d,%d,%d,%s,%d,%s,%d,';
    
    formatspecBinClarityHead = '%s,%s,%s,%s,%s,%s,%s,';
    BinClarityheader = {'Bin Number','Latitude (SW corner)','Longitude (SW corner)','Division Name','Division Number','Address','Total Reports 2012-2015'};
    
    %     binClarity = binClarity';
    
    
    
    
    
    %% Reading header ('bin' and dates)
    fid = fopen(filename);
    dates = textscan(fid,'%s',numCols,'Delimiter',',');
    fclose(fid);
    dates = dates{1}(2:end);
    dates = dates';
    binNums = preds(:,1);
    preds = preds(:,2:end);
    
    
    formatspec1 = repmat('%d,',1,numCols-1);
    formatspec1 = formatspec1(1:(end-1));
    formatspec1 = [formatspec1,'\n'];
    %     formatspecHead = repmat('%{yyyy-mm-dd}D,',1,length(dates));
    %     formatspecHead = ['%s,',formatspecHead(1:(end-1))];
    %     dates = [{'bin'},dates];
    formatspecHead = repmat('%s,',1,numCols);
    formatspecHead = formatspecHead(1:end-1);
    formatspecHead = [formatspecHead,'\n'];
    
    
    
    
    %% Turning heat scores into rankings
    %Sparse data structure makes this very efficient
    
    numBinsUsed = size(preds,1);
    for l = 1:size(preds,2)
        [~,ranks] = sort(preds(:,l),'descend');
        preds(ranks(1:nnz(preds(:,l))),l) = 1:nnz(preds(:,l));
    end
    
    
    %% Prepping monster matrix
    binClarity = binClarity(binNums,:);
    preds = full(preds);
    preds = num2cell(preds);
%     preds = num2str(preds);
     preds = [binClarity,preds];
%       preds = [binClarity,num2cell(preds)];
    
    head = [BinClarityheader(1,1:end),dates(1,1:end)];
    preds = [head;preds];
    
    
    
    preds = preds';
    % Need?
    
    %% Writing
    
    
    
    filename2 = ['DataForDianna_rankings_andBinGuide/predictionsWithBinInfo_rank_',divNames{i},'.csv'];
    
    
    
    
%     headspec = [formatspecBinClarityHead,formatspecHead,'\n'];
    spec = [formatspecBinClarity,formatspec1];
    
    
    fid = fopen(filename2,'w');
    
%     fprintf(fid,headspec,head{1,:});
    fprintf(fid,headspec,preds{:,1});
    a = {};
    fprintf(fid,'\n',a{:});
    fprintf(fid,spec,preds{:,2:end});
    %     for j = 1:size(preds,1)
    %         fprintf(fid,spec,preds{j,:});
    %     end
    fclose(fid);
    
    
    
%     head = [BinClarityheader(1,1:end),dates(1,1:end)];
%     
%     headspec = [formatspecBinClarityHead,formatspecHead,'\n'];
%     spec = [formatspecBinClarity,formatspec1];
%     
%     
%     fid = fopen(filename2,'w');
%     
%     fprintf(fid,headspec,head{1,:});
%     fprintf(fid,spec,preds{:,:});
%     %     for j = 1:size(preds,1)
%     %         fprintf(fid,spec,preds{j,:});
%     %     end
%     fclose(fid);
    
    
    
    
    
    
    
    
    
    
end