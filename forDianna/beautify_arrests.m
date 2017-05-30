% load('loaded_arrests.mat');
% removeCols = [2,3,6,15,16,17];
% betterDates = cellfun(@(x) x(1:10),arrests(:,1),'UniformOutput',0);
% arrests(:,1)=betterDates;
% arrests(:,removeCols)=[];
% colNames(:,removeCols)=[];
% colNames=[colNames,{'Latitude','Longitude'}];
% arrests = [arrests,num2cell(coords)];
% divNames = {'Central','Rampart','Southwest','Hollenbeck','Harbor','Hollywood','Wilshire','West_LA','Van_Nuys','West_Valley','Northeast','77th_Street','Newton','Pacific','N_Hollywood','Foothill','Devonshire','Southeast','Mission','Olympic','Topanga'};
% 
% prefix = 'forDianna/DataForDianna/Arrest_List/'
% 
% filenameALL = [prefix, 'all_events.csv'];


headspec= repmat('%s,',1,length(colNames));
headspec(end)=[];
headspec = [headspec,'\n'];
bodyspec = '%s,%d,%s,%d,%s,%s,%d,%s,%s,%s,%s,%f,%f\n';
fALL = fopen(filenameALL,'w');


arrests_by_division = cell(21,1);
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
    inds = (cell2mat(arrests(:,2))==i); %Column 2 holds the division number
    arrests_by_division{i} =arrests(inds,:);

    
    filename = [prefix,'by_division/',num2str(i),divNames{i},'_arrests.csv'];
    fid = fopen(filename,'w');
    fprintf(fid,headspec,colNames{:});
    if i ==1
        fprintf(fALL,headspec,colNames{:});
    end
    
    body = arrests_by_division{i};
    body = body';
    fprintf(fid,bodyspec,body{:,:});
    fprintf(fALL,bodyspec,body{:,:});
    
    fclose(fid);
end

fclose(fALL);