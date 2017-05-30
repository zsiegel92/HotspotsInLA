% load('driving_crimes_by_division.mat');
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
divNames = {'Central','Rampart','Southwest','Hollenbeck','Harbor','Hollywood','Wilshire','West_LA','Van_Nuys','West_Valley','Northeast','77th Street','Newton','Pacific','N_Hollywood','Foothill','Devonshire','Southeast','Mission','Olympic','Topanga'};
firstrow = {'"rownum"','"bin"','"OCCURRED"','"LAG"'};


for i = 1:size(driving_crimes_by_division,1) %21, for all divisions

   dates = driving_crimes_by_division{i}(:,1);
   bins = driving_crimes_by_division{i}(:,15);
   rownums = (1:size(driving_crimes_by_division{i},1))';
   LAG = zeros(size(rownums,1),1);
   
   
   dates = cellfun(@(x) [x(1:end-4),x((end-1:end))],dates,'UniformOutput',0);
   datenums=datenum(dates,'mm/dd/yy');
   [~,reportOrder] = sort(datenums);
   
   
   rownums = cellfun(@num2str,num2cell(rownums),'UniformOutput',0);
   rownums = cellfun(@(x) ['"',x,'"'],rownums,'UniformOutput',0);
   input = [rownums,bins,dates,num2cell(LAG)];
   
   input = input(reportOrder,:);
   
   filename = ['predpol_inputs/',num2str(i),divNames{i},'.csv'];
   fid = fopen(filename,'w');
   fprintf(fid,'%s,%s,%s,%s\n',firstrow{1,:});
   for j = 1:size(input,1)
       fprintf(fid,'%s,%d,%s,%d\n',input{j,:});
   end
   fclose(fid);
end