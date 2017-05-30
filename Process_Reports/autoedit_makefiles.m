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
divNames = {'Central','Rampart','Southwest','Hollenbeck','Harbor','Hollywood','Wilshire','West_LA','Van_Nuys','West_Valley','Northeast','77th_Street','Newton','Pacific','N_Hollywood','Foothill','Devonshire','Southeast','Mission','Olympic','Topanga'};

dumname = 'Makefile_dummy';
dumtext = fileread(dumname);

for i = 1:21
    actualtext = strrep(dumtext,'DIVNAME',divNames{i});
    actualtext = strrep(actualtext,'DIVNUMBER',num2str(i));
    filename = ['Makefile_',num2str(i)];
    fid = fopen(filename,'w');
    fprintf(fid,'%s',actualtext);
    fclose(fid);
end