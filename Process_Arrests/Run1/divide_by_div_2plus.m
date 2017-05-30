function [arrests_by_division,coordsByDiv,arrDatesByDiv] = divide_by_div(arrests,coords,arrDates)
arrests_by_division = cell(21,1);
coordsByDiv= cell(21,1);
arrDatesByDiv=cell(21,1);
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
    inds = (cell2mat(arrests(:,4))==i);
    
    coordsByDiv{i}=coords(inds,:);
    arrDatesByDiv{i} = arrDates(inds,:);
    arrests_by_division{i} =arrests(inds,:);
end

save('arrests_by_division_from_divide_by_div.mat');

end