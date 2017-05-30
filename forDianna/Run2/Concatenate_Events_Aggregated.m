% load('driving_crimes_by_division.mat');
% load('binClarity.mat');
% binClarity = binClarity';

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
aggregateBy=7;
divNames = {'Central','Rampart','Southwest','Hollenbeck','Harbor','Hollywood','Wilshire','West_LA','Van_Nuys','West_Valley','Northeast','77th_Street','Newton','Pacific','N_Hollywood','Foothill','Devonshire','Southeast','Mission','Olympic','Topanga'};
output_filename = ['all_events_aggregated_',num2str(aggregateBy),'days.csv'];

%% Opening output file
filenameOUT = ['forDianna/DataForDianna/Run2/',output_filename];
fOUT = fopen(filenameOUT,'w');

for i = 1:21

    %% Reading Events
    filename = ['forDianna/DataForDianna/Run2/event_list/aggregated/events_',divNames{i},'.csv'];
    formatspec = '%s%f%f%f%f%[^\n\r]';
    fid = fopen(filename,'r');
    divisionEvents = textscan(fid,formatspec,'Delimiter',',','HeaderLines',1);
    fclose(fid);
    %Organizing into proper cell array
    divisionEvents = [divisionEvents{1},num2cell(divisionEvents{2}),num2cell(divisionEvents{3}),num2cell(divisionEvents{4}),num2cell(divisionEvents{5})];
    %Adding division labels
    divNum = num2cell(repmat(i,size(divisionEvents,1),1));
    divName = cellstr(repmat(divNames{i},size(divisionEvents,1),1));
    divisionEvents = [divisionEvents,divNum,divName];
    %% Reading and Writing Header on first pass
    if i ==1
        fid = fopen(filename,'r');
        headspec = '%s%s%s%s%s\n';
        header = textscan(fid,headspec,1,'Delimiter',',');
        %Removing header elements from cells
        header = cellfun(@(x) x{:},header,'UniformOutput',0);
        fclose(fid);
        %Write to file
        headspec = '%s,%s,%s,%s,%s,%s,%s\n';
        header = [header,{'Division Number','Division Name'}];
        fprintf(fOUT,headspec,header{:});
    end
    %% Writing Events
    bodyspec = '%s,%f,%f,%f,%f,%f,%s\n'; %Date, Bin_Number, Rankking, Latitude, Longitude, division number, division name
    divisionEvents = divisionEvents';
    fprintf(fOUT,bodyspec,divisionEvents{:});
%     

end

fclose(fOUT);